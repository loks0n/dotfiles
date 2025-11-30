function __z_complete
    set src "$HOME/src"
    set token (commandline -ct)

    # Case 1: completing owner (no slash yet)
    if not string match -q "*/*" "$token"
        for owner in $src/*/
            echo (basename $owner)
        end
        return
    end

    # Case 2: completing repo (token is owner/…)
    set owner (string split "/" $token)[1]
    set owner_path "$src/$owner"

    if test -d $owner_path
        for repo in $owner_path/*/
            echo "$owner/"(basename $repo)
        end
    end
end

complete -c z -f -a "(__z_complete)"
