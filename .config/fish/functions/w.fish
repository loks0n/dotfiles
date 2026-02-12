function w --description "Clone repo and create worktree for a branch"
    if test (count $argv) -ne 2
        echo "Usage: c <org/repo> <branch>"
        echo "Example: c appwrite/appwrite feat-improve-performance"
        return 1
    end

    set -l repo_path $argv[1]
    set -l branch $argv[2]
    set -l src_dir ~/src/$repo_path
    set -l worktree_dir ~/worktrees/$repo_path/$branch

    # Clone if source repo doesn't exist
    if not test -d $src_dir
        echo "Cloning $repo_path..."
        git clone "git@github.com:$repo_path.git" $src_dir
        or return 1
    end

    # Create worktree if it doesn't exist
    if not test -d $worktree_dir
        echo "Fetching origin..."
        git -C $src_dir fetch origin

        echo "Creating worktree $branch..."
        if git -C $src_dir rev-parse --verify origin/$branch &>/dev/null
            git -C $src_dir worktree add $worktree_dir $branch
        else
            git -C $src_dir worktree add $worktree_dir -b $branch
        end
        or return 1
    end

    cd $worktree_dir
end
