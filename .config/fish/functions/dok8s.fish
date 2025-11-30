function dok8s -d "Import & normalise DO K8s contexts across all doctl contexts"
    echo "Fetching DigitalOcean Kubernetes clusters across contexts..."

    set namespace_map cloud:cloud edge:edge dns:dns sandy:sandy assets:website

    set auth_lines (doctl auth list) || begin
        echo "Failed to list DigitalOcean auth contexts" >&2
        return 1
    end

    set original_context (string replace -r ' \(current\)$' '' (string match -r '.*\(current\)' $auth_lines))

    set target_contexts
    for line in $auth_lines
        set ctx (string replace -r ' \(current\)$' '' $line)
        if test $ctx != default
            set target_contexts $target_contexts $ctx
        end
    end

    if test (count $target_contexts) -eq 0
        echo "No DigitalOcean contexts to process"
        return 1
    end

    for ctx in $target_contexts
        printf "\n→ Switching to context: %s\n" $ctx
        doctl auth switch --context=$ctx || begin
            echo "Failed to switch to $ctx, skipping…" >&2
            continue
        end

        set clusters (doctl kubernetes cluster list --format Name --no-header)
        if test (count $clusters) -eq 0
            echo "No clusters found in context $ctx"
            continue
        end

        for cluster in $clusters
            echo "Processing cluster: $cluster"

            set new_context (string replace -r '^do-[^-]+-' '' $cluster)

            if kubectl config get-contexts -o name | grep -q "^$new_context\$"
                kubectl config delete-context $new_context
            end

            doctl kubernetes cluster kubeconfig save $cluster

            set saved (kubectl config current-context)
            kubectl config rename-context $saved $new_context

            set namespace ""
            for pair in $namespace_map
                set prefix (string split ":" $pair)[1]
                set mapped_ns (string split ":" $pair)[2]

                if string match -q "$prefix*" $new_context
                    set namespace $mapped_ns
                    break
                end
            end

            if test -n "$namespace"
                printf "✓ Added/refreshed %s as %s (ns: %s)\n" $cluster $new_context $namespace
            else
                printf "✓ Added/refreshed %s as %s\n" $cluster $new_context
            end
        end
    end

    if test -n "$original_context"
        printf "\nRestoring original context: %s\n" $original_context
        doctl auth switch --context=$original_context >/dev/null
    end

    printf "\nAll contexts processed!\n"
end
