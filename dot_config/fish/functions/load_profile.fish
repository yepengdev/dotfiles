function load_profile --description "按需载入 /etc/profile（仅一次）"
    if not set -q __profile_loaded
        bass source /etc/profile
        set -g __profile_loaded 1
    end
end
