# Completions for c (clone + worktree helper)

# No file completions
complete -c w -f

# First arg: org/repo from ~/src
complete -c w -n "test (count (commandline -opc)) -eq 1" -a "(
    for org in ~/src/*/
        set -l org_name (basename \$org)
        for repo in \$org/*/
            echo \$org_name/(basename \$repo)
        end
    end
)"

# Second arg: remote branches from the repo
complete -c w -n "test (count (commandline -opc)) -eq 2" -a "(
    set -l repo_path (commandline -opc)[2]
    set -l src_dir ~/src/\$repo_path
    if test -d \$src_dir
        git -C \$src_dir branch -r 2>/dev/null | string replace -r '^\s*origin/' '' | string match -v 'HEAD *'
    end
)"
