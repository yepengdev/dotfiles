function emacsclient_editor
    if test (count $argv) -eq 0
        if not command -sq emacsclient
            echo "未找到 emacsclient，可安装 Emacs 或检查 PATH"
            return 1
        end

        emacsclient -nw -e '(progn (recentf-mode 1) (recentf-open-files) nil)'
        if test $status -ne 0
            echo "emacsclient 调用失败，确认 Emacs server 已运行 (M-x server-start)"
            return 1
        end
        return 0
    end

    emacsclient -nw $argv
end
