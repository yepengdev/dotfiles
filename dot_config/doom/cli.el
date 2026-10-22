;;; $DOOMDIR/cli.el -*- lexical-binding: t; -*-
;;;
;;; 在 `doom sync' 等 CLI 操作中被 Doom 自动加载。
;;; 在普通 Emacs 会话中不加载。

;; ─── C 模块编译（doom sync 时编译 .so）────────────────────────────
;;
;; `doom-before-sync-hook' 由 bin/doom-sync 在同步前 `run-hooks'，随 :config
;; literate 模块之外的一切 CLI 一起生效；本文件只在 CLI 会话中被加载。

(add-hook 'doom-before-sync-hook
          (defun my/build-c-modules-on-sync ()
            (when (file-directory-p (expand-file-name "c-modules" doom-user-dir))
              (print! (start "Building C modules..."))
              (let ((default-directory (expand-file-name "c-modules" doom-user-dir)))
                (call-process "make" nil nil nil)
                (print! (success "C modules built"))))))

;; ─── 自定义 CLI 命令 ─────────────────────────────────────────────
;;
;; bin/doom 用 `(defcli-group! :prefix 'doom ...)' 包住整个 CLI 引导过程，
;; 因此本文件里的命令会自动带上 "doom" 前缀：写成 `(cbuild)' 即 `doom cbuild'。
;; 若写成 `(doom cbuild)'，命令键会变成 ("doom" "doom" "cbuild")，只有
;; `doom doom cbuild' 才调得到——这是本文件此前的写法，已修正。

(defcli! (cbuild)
         ()
         "在 $DOOMDIR/c-modules/ 中手动编译 C 模块。"
         (let ((default-directory (expand-file-name "c-modules" doom-user-dir)))
           (print! (start "Building C modules..."))
           (call-process "make" nil nil nil)
           (print! (success "C modules built"))))
