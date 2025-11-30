function fish_k8s_prompt --description 'Display k8s context in the prompt'
    set -l fmt '%s'
    if test (count $argv) -gt 0
        set fmt $argv[1]
    end

    if command -q kubectl
        set -l k8s_context (kubectl config current-context 2>/dev/null)
        if test $status -eq 0
            set -l k8s_info (set_color cyan)"⎈ $k8s_context"(set_color normal)
            printf $fmt $k8s_info
        end
    end
end
