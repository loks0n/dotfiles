function z -d "Open a project in Zed editor, cloning over SSH if missing"
    if test (count $argv) -ne 1
        echo "Usage: z owner/repo"
        return 1
    end

    set project $argv[1]
    set src_dir "$HOME/src"
    set full_path "$src_dir/$project"

    # Parse owner/repo
    set parts (string split "/" $project)
    if test (count $parts) -ne 2
        echo "Invalid format. Use: owner/repo"
        return 1
    end

    set owner $parts[1]
    set repo  $parts[2]

    # Clone if missing
    if not test -d $full_path
        set url "git@github.com:$owner/$repo.git"
        echo "Cloning $url ..."
        mkdir -p "$src_dir/$owner"
        git clone $url $full_path || return 1
    end

    echo "Opening $full_path..."
    zed $full_path
end
