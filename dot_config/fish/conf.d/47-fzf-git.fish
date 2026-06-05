if status is-interactive

    # Ctrl+G Ctrl+B — 模糊搜索 Git 分支并 checkout
    function __fzf_git_branch
        set -l branch (
            git branch --all --sort=-committerdate |
                string trim -c '* ' |
                fzf --preview 'git log --oneline --date=short --color=always --pretty="format:%C(auto)%h %C(green)%ai %Creset%s" {}' \
                    --preview-window=right:60%
        )
        if test -n "$branch"
            git checkout (string trim -- $branch) 2>/dev/null; or git switch (string trim -- $branch)
        end
        commandline -f repaint
    end

    # Ctrl+G Ctrl+F — 模糊搜索 Git 已修改文件，填入路径
    function __fzf_git_files
        set -l file (
            git -c color.status=always status --short |
                fzf --preview 'git diff --color=always (echo {} | string sub -s 4 | string trim)' \
                    --preview-window=right:60%
        )
        if test -n "$file"
            set -l filename (string sub -s 4 -- $file | string trim)
            commandline -a "$filename"
        end
        commandline -f repaint
    end

    # Ctrl+G Ctrl+L — 模糊搜索提交信息，填入 hash
    function __fzf_git_log
        set -l commit (
            git log --color=always --format="%C(auto)%h %C(green)%ai %Creset%s %C(bold blue)(%an)" |
                fzf --ansi --no-sort --reverse --multi \
                    --preview 'git show --color=always (echo {} | string split -n " " | string match -r "^[a-f0-9]{7,}" | head -1)' \
                    --preview-window=right:60% \
                    --bind 'ctrl-s:toggle-sort'
        )
        if test -n "$commit"
            set -l hash (echo $commit | string split -n " " | string match -r "^[a-f0-9]{7,}" | head -1)
            commandline -a $hash
        end
        commandline -f repaint
    end

    # 注册绑定：先按 Ctrl+G，再按 B / F / L
    bind \cg\cb __fzf_git_branch
    bind \cg\cf __fzf_git_files
    bind \cg\cl __fzf_git_log

end
