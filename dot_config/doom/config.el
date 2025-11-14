(setq-default elisp-fontify-semantically t)

(setq user-full-name "Peng Ye"
      user-mail-address "yepeng230@gmail.com")

(setq doom-theme 'doom-one)

(setq display-line-numbers-type 't)

(setq org-directory "~/projects/org/"
    org-roam-directory "~/projects/org/roam"
    deft-directory "~/projects/")

(setq doom-font (font-spec :family "Monaspace Neon Medium" :size 17)
      doom-unicode-font (font-spec :family "Sarasa Gothic SC" :size 17)
      doom-variable-pitch-font (font-spec :family "Sarasa Gothic SC" :size 17))

(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

;; (defun my-cjk-font-setup ()
;;   (dolist (charset '(kana han cjk-misc bopomofo))
;;     (set-fontset-font t charset (font-spec :family "Noto Sans CJK SC"))))

;; (add-hook 'after-setting-font-hook #'my-cjk-font-setup)
;;(setq face-font-rescale-alist '(("Noto Sans CJK SC" . 1.2)))

(defvar fancy-splash-image-directory
  (expand-file-name "misc/splash-images/" doom-private-dir)
  "Directory in which to look for splash image templates.")

(defvar fancy-splash-image-template
  (expand-file-name "emacs-e-template.svg" fancy-splash-image-directory)
  "Default template svg used for the splash image.
Colours are substituted as per `fancy-splash-template-colours'.")

(defvar fancy-splash-template-colours
  '(("#111112" :face default   :attr :foreground)
    ("#8b8c8d" :face shadow)
    ("#eeeeef" :face default   :attr :background)
    ("#e66100" :face highlight :attr :background)
    ("#1c71d8" :face font-lock-keyword-face)
    ("#f5c211" :face font-lock-type-face)
    ("#813d9c" :face font-lock-constant-face)
    ("#865e3c" :face font-lock-function-name-face)
    ("#2ec27e" :face font-lock-string-face)
    ("#c01c28" :face error)
    ("#000001" :face ansi-color-black)
    ("#ff0000" :face ansi-color-red)
    ("#ff00ff" :face ansi-color-magenta)
    ("#00ff00" :face ansi-color-green)
    ("#ffff00" :face ansi-color-yellow)
    ("#0000ff" :face ansi-color-blue)
    ("#00ffff" :face ansi-color-cyan)
    ("#fffffe" :face ansi-color-white))
  "Alist of colour-replacement plists.
Each plist is of the form (\"$placeholder\" :doom-color 'key :face 'face).
If the current theme is a doom theme :doom-color will be used,
otherwise the colour will be face foreground.")
(defun fancy-splash-check-buffer ()
  "Check the current SVG buffer for bad colours."
  (interactive)
  (when (eq major-mode 'image-mode)
    (xml-mode))
  (when (and (featurep 'rainbow-mode)
             (not (bound-and-true-p rainbow-mode)))
    (rainbow-mode 1))
  (let* ((colours (mapcar #'car fancy-splash-template-colours))
         (colourise-hex
          (lambda (hex)
            (propertize
             hex
             'face `((:foreground
                      ,(if (< 0.5
                              (cl-destructuring-bind (r g b) (x-color-values hex)
                                ;; Values taken from `rainbow-color-luminance'
                                (/ (+ (* .2126 r) (* .7152 g) (* .0722 b))
                                   (* 256 255 1.0))))
                           "white" "black")
                      (:background ,hex))))))
         (cn 96)
         (colour-menu-entries
          (mapcar
           (lambda (colour)
             (cl-incf cn)
             (cons cn
                   (cons
                    (substring-no-properties colour)
                    (format " (%s) %s %s"
                            (propertize (char-to-string cn)
                                        'face 'font-lock-keyword-face)
                            (funcall colourise-hex colour)
                            (propertize
                             (symbol-name
                              (plist-get
                               (cdr (assoc colour fancy-splash-template-colours))
                               :face))
                             'face 'shadow)))))
           colours))
         (colour-menu-template
          (format
           "Colour %%s is unexpected! Should this be one of the following?\n
%s
 %s to ignore
 %s to quit"
           (mapconcat
            #'cddr
            colour-menu-entries
            "\n")
           (propertize "SPC" 'face 'font-lock-keyword-face)
           (propertize "ESC" 'face 'font-lock-keyword-face)))
         (colour-menu-choice-keys
          (append (mapcar #'car colour-menu-entries)
                  (list ?\s)))
         (buf (get-buffer-create "*fancy-splash-lint-colours-popup*"))
         (good-colour-p
          (lambda (colour)
            (or (assoc colour fancy-splash-template-colours)
                ;; Check if greyscale
                (or (and (= (length colour) 4)
                         (= (aref colour 1)   ; r
                            (aref colour 2)   ; g
                            (aref colour 3))) ; b
                    (and (= (length colour) 7)
                         (string= (substring colour 1 3)       ; rr =
                                  (substring colour 3 5))      ; gg
                         (string= (substring colour 3 5)       ; gg =
                                  (substring colour 5 7))))))) ; bb
         (prompt-to-replace
          (lambda (target)
            (with-current-buffer buf
              (erase-buffer)
              (insert (format colour-menu-template
                              (funcall colourise-hex target)))
              (setq-local cursor-type nil)
              (set-buffer-modified-p nil)
              (goto-char (point-min)))
            (save-window-excursion
              (pop-to-buffer buf)
              (fit-window-to-buffer (get-buffer-window buf))
              (car (alist-get
                    (read-char-choice
                     (format "Select replacement, %s-%s or SPC: "
                             (char-to-string (caar colour-menu-entries))
                             (char-to-string (caar (last colour-menu-entries))))
                     colour-menu-choice-keys)
                    colour-menu-entries))))))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "#[0-9A-Fa-f]\\{6\\}\\|#[0-9A-Fa-f]\\{3\\}" nil t)
        (recenter)
        (let* ((colour (match-string 0))
               (replacement (and (not (funcall good-colour-p colour))
                                 (funcall prompt-to-replace colour))))
          (when replacement
            (replace-match replacement t t))))
      (message "Done"))))
(defvar fancy-splash-cache-dir (expand-file-name "theme-splashes/" doom-cache-dir))

(defvar fancy-splash-sizes
  `((:height 300 :min-height 50 :padding (0 . 2))
    (:height 250 :min-height 42 :padding (2 . 4))
    (:height 200 :min-height 35 :padding (3 . 3))
    (:height 150 :min-height 28 :padding (3 . 3))
    (:height 100 :min-height 18 :padding (2 . 2))
    (:height 75  :min-height 15 :padding (2 . 1))
    (:height 50  :min-height 10 :padding (1 . 0))
    (:height 1   :min-height 0  :padding (0 . 0)))
  "List of plists specifying image sizing states.
Each plist should have the following properties:
- :height, the height of the image
- :min-height, the minimum `frame-height' for image
- :padding, a `+doom-dashboard-banner-padding' (top . bottom) padding
  specification to apply
Optionally, each plist may set the following two properties:
- :template, a non-default template file
- :file, a file to use instead of template")

(defun fancy-splash-filename (theme template height)
  "Get the file name for the splash image with THEME and of HEIGHT."
  (expand-file-name (format "%s-%s-%d.svg" theme (file-name-base template) height) fancy-splash-cache-dir))

(defun fancy-splash-generate-image (template height)
  "Create a themed image from TEMPLATE of HEIGHT.
The theming is performed using `fancy-splash-template-colours'
and the current theme."
  (with-temp-buffer
    (insert-file-contents template)
    (goto-char (point-min))
    (if (re-search-forward "$height" nil t)
        (replace-match (number-to-string height) t t)
      (if (re-search-forward "height=\"100\\(?:\\.0[0-9]*\\)?\"" nil t)
          (progn
            (replace-match (format "height=\"%s\"" height) t t)
            (goto-char (point-min))
            (when (re-search-forward "\\([ \t\n]\\)width=\"[\\.0-9]+\"[ \t\n]*" nil t)
              (replace-match "\\1")))
        (warn "Warning! fancy splash template: neither $height nor height=100 not found in %s" template)))
    (dolist (substitution fancy-splash-template-colours)
      (goto-char (point-min))
      (let* ((replacement-colour
              (face-attribute (plist-get (cdr substitution) :face)
                              (or (plist-get (cdr substitution) :attr) :foreground)
                              nil 'default))
             (replacement-hex
              (if (string-prefix-p "#" replacement-colour)
                  replacement-colour
                (apply 'format "#%02x%02x%02x"
                       (mapcar (lambda (c) (ash c -8))
                               (color-values replacement-colour))))))
        (while (search-forward (car substitution) nil t)
          (replace-match replacement-hex nil nil))))
    (unless (file-exists-p fancy-splash-cache-dir)
      (make-directory fancy-splash-cache-dir t))
    (let ((inhibit-message t))
      (write-region nil nil (fancy-splash-filename (car custom-enabled-themes) template height)))))
(defun fancy-splash-generate-all-images ()
  "Perform `fancy-splash-generate-image' in bulk."
  (dolist (size fancy-splash-sizes)
    (unless (plist-get size :file)
      (fancy-splash-generate-image
       (or (plist-get size :template)
           fancy-splash-image-template)
       (plist-get size :height)))))
(defun fancy-splash-ensure-theme-images-exist (&optional height)
  "Ensure that the relevant images exist.
Use the image of HEIGHT to check, defaulting to the height of the first
specification in `fancy-splash-sizes'. If that file does not exist for
the current theme, `fancy-splash-generate-all-images' is called. "
  (unless (file-exists-p
           (fancy-splash-filename
            (car custom-enabled-themes)
            fancy-splash-image-template
            (or height (plist-get (car fancy-splash-sizes) :height))))
    (fancy-splash-generate-all-images)))

(defun fancy-splash-clear-cache (&optional delete-files)
  "Clear all cached fancy splash images.
Optionally delete all cache files and regenerate the currently relevant set."
  (interactive (list t))
  (dolist (size fancy-splash-sizes)
    (unless (plist-get size :file)
      (let ((image-file
             (fancy-splash-filename
              (car custom-enabled-themes)
              (or (plist-get size :template)
                  fancy-splash-image-template)
              (plist-get size :height))))
        (image-flush (create-image image-file) t))))
  (message "Fancy splash image cache cleared!")
  (when delete-files
    (delete-directory fancy-splash-cache-dir t)
    (fancy-splash-generate-all-images)
    (message "Fancy splash images cache deleted!")))

(defun fancy-splash-switch-template ()
  "Switch the template used for the fancy splash image."
  (interactive)
  (let ((new (completing-read
              "Splash template: "
              (mapcar
               (lambda (template)
                 (replace-regexp-in-string "-template\\.svg$" "" template))
               (directory-files fancy-splash-image-directory nil "-template\\.svg\\'"))
              nil t)))
    (setq fancy-splash-image-template
          (expand-file-name (concat new "-template.svg") fancy-splash-image-directory))
    (fancy-splash-clear-cache)
    (message "") ; Clear message from `fancy-splash-clear-cache'.
    (setq fancy-splash--last-size nil)
    (fancy-splash-apply-appropriate-image)))

(defun fancy-splash-get-appropriate-size ()
  "Find the firt `fancy-splash-sizes' with min-height of at least frame height."
  (let ((height (frame-height)))
    (cl-some (lambda (size) (when (>= height (plist-get size :min-height)) size))
             fancy-splash-sizes)))

(setq fancy-splash--last-size nil)
(setq fancy-splash--last-theme nil)
(defun fancy-splash-apply-appropriate-image (&rest _)
  "Ensure the appropriate splash image is applied to the dashboard.
This function's signature is \"&rest _\" to allow it to be used
in hooks that call functions with arguments."
  (let ((appropriate-size (fancy-splash-get-appropriate-size)))
    (unless (and (equal appropriate-size fancy-splash--last-size)
                 (equal (car custom-enabled-themes) fancy-splash--last-theme))
      (unless (plist-get appropriate-size :file)
        (fancy-splash-ensure-theme-images-exist (plist-get appropriate-size :height)))
      (setq fancy-splash-image
            (or (plist-get appropriate-size :file)
                (fancy-splash-filename (car custom-enabled-themes)
                                       fancy-splash-image-template
                                       (plist-get appropriate-size :height)))
            +doom-dashboard-banner-padding (plist-get appropriate-size :padding)
            fancy-splash--last-size appropriate-size
            fancy-splash--last-theme (car custom-enabled-themes))
      (+doom-dashboard-reload))))
(defun doom-dashboard-draw-ascii-emacs-banner-fn ()
  (let* ((banner
          '(",---.,-.-.,---.,---.,---."
            "|---'| | |,---||    `---."
            "`---'` ' '`---^`---'`---'"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat
                 line (make-string (max 0 (- longest-line (length line)))
                                   32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(unless (display-graphic-p) ; for some reason this messes up the graphical splash screen atm
  (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn))

(defvar splash-phrase-source-folder
  (expand-file-name "misc/splash-phrases" doom-private-dir)
  "A folder of text files with a fun phrase on each line.")

(defvar splash-phrase-sources
  (let* ((files (directory-files splash-phrase-source-folder nil "\\.txt\\'"))
         (sets (delete-dups (mapcar
                             (lambda (file)
                               (replace-regexp-in-string "\\(?:-[0-9]+-\\w+\\)?\\.txt" "" file))
                             files))))
    (mapcar (lambda (sset)
              (cons sset
                    (delq nil (mapcar
                               (lambda (file)
                                 (when (string-match-p (regexp-quote sset) file)
                                   file))
                               files))))
            sets))
  "A list of cons giving the phrase set name, and a list of files which contain phrase components.")

(defvar splash-phrase-set
  (nth (random (length splash-phrase-sources)) (mapcar #'car splash-phrase-sources))
  "The default phrase set. See `splash-phrase-sources'.")

(defun splash-phrase-set-random-set ()
  "Set a new random splash phrase set."
  (interactive)
  (setq splash-phrase-set
        (nth (random (1- (length splash-phrase-sources)))
             (cl-set-difference (mapcar #'car splash-phrase-sources) (list splash-phrase-set))))
  (+doom-dashboard-reload t))

(defun splash-phrase-select-set ()
  "Select a specific splash phrase set."
  (interactive)
  (setq splash-phrase-set (completing-read "Phrase set: " (mapcar #'car splash-phrase-sources)))
  (+doom-dashboard-reload t))

(defvar splash-phrase--cached-lines nil)

(defun splash-phrase-get-from-file (file)
  "Fetch a random line from FILE."
  (let ((lines (or (cdr (assoc file splash-phrase--cached-lines))
                   (cdar (push (cons file
                                     (with-temp-buffer
                                       (insert-file-contents (expand-file-name file splash-phrase-source-folder))
                                       (split-string (string-trim (buffer-string)) "\n")))
                               splash-phrase--cached-lines)))))
    (nth (random (length lines)) lines)))

(defun splash-phrase (&optional set)
  "Construct a splash phrase from SET. See `splash-phrase-sources'."
  (mapconcat
   #'splash-phrase-get-from-file
   (cdr (assoc (or set splash-phrase-set) splash-phrase-sources))
   " "))

(defun splash-phrase-dashboard-formatted ()
  "Get a splash phrase, flow it over multiple lines as needed, and fontify it."
  (mapconcat
   (lambda (line)
     (+doom-dashboard--center
      +doom-dashboard--width
      (with-temp-buffer
        (insert-text-button
         line
         'action
         (lambda (_) (+doom-dashboard-reload t))
         'face 'doom-dashboard-menu-title
         'mouse-face 'doom-dashboard-menu-title
         'help-echo "Random phrase"
         'follow-link t)
        (buffer-string))))
   (split-string
    (with-temp-buffer
      (insert (splash-phrase))
      (setq fill-column (min 70 (/ (* 2 (window-width)) 3)))
      (fill-region (point-min) (point-max))
      (buffer-string))
    "\n")
   "\n"))

(defun splash-phrase-dashboard-insert ()
  "Insert the splash phrase surrounded by newlines."
  (insert "\n" (splash-phrase-dashboard-formatted) "\n"))

(defun +doom-dashboard-setup-modified-keymap ()
  (setq +doom-dashboard-mode-map (make-sparse-keymap))
  (map! :map +doom-dashboard-mode-map
        :desc "Find file" :ng "f" #'find-file
        :desc "Recent files" :ng "r" #'consult-recent-file
        :desc "Config dir" :ng "C" #'doom/open-private-config
        :desc "Open config.org" :ng "c" (cmd! (find-file (expand-file-name "config.org" doom-user-dir)))
        :desc "Open org-mode root" :ng "O" (cmd! (find-file (expand-file-name "lisp/org/" doom-user-dir)))
        :desc "Open dotfile" :ng "." (cmd! (doom-project-find-file "~/.config/"))
        :desc "Notes (roam)" :ng "n" #'org-roam-node-find
        :desc "Switch buffer" :ng "b" #'+vertico/switch-workspace-buffer
        :desc "Switch buffers (all)" :ng "B" #'consult-buffer
        :desc "IBuffer" :ng "i" #'ibuffer
        :desc "Previous buffer" :ng "p" #'previous-buffer
        :desc "Set theme" :ng "t" #'consult-theme
        :desc "Quit" :ng "Q" #'save-buffers-kill-terminal
        :desc "Search" :ng "o" #'eaf-open-browser-with-history
        :desc "Show keybindings" :ng "h" (cmd! (which-key-show-keymap '+doom-dashboard-mode-map))))

(add-transient-hook! #'+doom-dashboard-mode (+doom-dashboard-setup-modified-keymap))
(add-transient-hook! #'+doom-dashboard-mode :append (+doom-dashboard-setup-modified-keymap))
(add-hook! 'doom-init-ui-hook :append (+doom-dashboard-setup-modified-keymap))

(map! :leader :desc "Dashboard" "o s d" #'+doom-dashboard/open)

(defun +doom-dashboard-benchmark-line ()
  "Insert the load time line."
  (when doom-init-time
    (insert
     "\n\n"
     (propertize
      (+doom-dashboard--center
       +doom-dashboard--width
       (doom-display-benchmark-h 'return))
      'face 'doom-dashboard-loaded))))

(remove-hook 'doom-after-init-hook #'doom-display-benchmark-h)

(setq +doom-dashboard-functions
      (list #'doom-dashboard-widget-banner
            #'+doom-dashboard-benchmark-line
            #'splash-phrase-dashboard-insert))

(add-hook 'window-size-change-functions #'fancy-splash-apply-appropriate-image)
(add-hook 'doom-load-theme-hook #'fancy-splash-apply-appropriate-image)

(setq frame-title-format
      '(""
        (:eval
         (if (string-match-p (regexp-quote (or (bound-and-true-p org-roam-directory) "\u0000"))
                             (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?\s buffer-file-name))
           "%b"))
        (:eval
         (when-let ((project-name (and (featurep 'projectile) (projectile-project-name))))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(use-package! calctex
  :defer t
  :commands (calctex-mode calc)
  :init
  (add-hook 'calc-mode-hook #'calctex-mode)
  :config
  (setq calctex-additional-latex-packages "
\\usepackage[usenames]{xcolor}
\\usepackage{soul}
\\usepackage{adjustbox}
\\usepackage{amsmath,amsthm}
\\usepackage{cancel}
\\usepackage{mathtools}
\\usepackage{mathalpha}
\\usepackage{xparse}
\\usepackage{arevmath}"
        calctex-additional-latex-macros
        (concat calctex-additional-latex-macros
                "\n\\let\\evalto\\Rightarrow"))
  (defadvice! no-messaging-a (orig-fn &rest args)
    :around #'calctex-default-dispatching-render-process
    (let ((inhibit-message t) message-log-max)
      (apply orig-fn args)))
  ;; Fix hardcoded dvichop path (whyyyyyyy)
  (let ((vendor-folder (concat (file-truename doom-local-dir)
                               "straight/"
                               (format "build-%s" emacs-version)
                               "/calctex/vendor/")))
    (setq calctex-dvichop-sty (concat vendor-folder "texd/dvichop")
          calctex-dvichop-bin (concat vendor-folder "texd/dvichop")))
  (unless (file-exists-p calctex-dvichop-bin)
    (message "CalcTeX: Building dvichop binary")
    (let ((default-directory (file-name-directory calctex-dvichop-bin)))
      (call-process "make" nil nil nil))))

(setq calc-angle-mode 'rad  ; radians are rad
      calc-symbolic-mode t) ; keeps expressions like \sqrt{2} irrational for as long as possible

(after! text-mode
  (add-hook! 'text-mode-hook
    (unless (derived-mode-p 'org-mode)
      ;; Apply ANSI color codes
      (with-silent-modifications
        (ansi-color-apply-on-region (point-min) (point-max) t)))))

(after! org
  ;;(org-num-mode t)
  ;;(add-hook 'org-mode-hook 'org-num-mode)
  ;;(setq org-startup-numerated 't)
  (add-hook 'org-mode-hook 'org-display-inline-images)
;;  (require 'ox-extra)
  ;;(ox-extras-activate '(ignore-headlines))
  (setq-default org-startup-folded 'content)
  (setq-default org-log-done 'note)
  ;; 在你的 init.el 文件中添加
  (setq org-hide-emphasis-markers t)
  (setq org-export-default-options
        '(;;:section-numbers nil     ; 标题编号 (num:t)
          :with-toc 3            ; 生成3级目录 (toc:3)
          :H 3                   ; 标题级别 (H:3)
          :author nil            ; 默认不导出作者 (author:nil)
          :creator nil           ; 默认不导出创建者 (creator:nil)
          :timestamp nil         ; 默认不导出时间戳 (timestamp:nil)
          :with-sub-superscript "{}")) ; 启用 a^{b} 和 a_{b} 语法 (^:{})
  )

(use-package! org-contrib :config
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))

(use-package! org-transclusion
  :after org
  :commands org-transclusion-mode
  :init
  (map! :after org :map org-mode-map
        "<f12>" #'org-transclusion-mode))

(use-package! org-pandoc-import
  :after org)

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

(defadvice! org-edit-latex-emv-after-insert ()
  :after #'org-cdlatex-environment-indent
  (org-edit-latex-environment))

(setq org-re-reveal-theme "white"
      org-re-reveal-transition "slide"
      org-re-reveal-plugins '(markdown notes math search zoom))

(setq org-beamer-theme "[progressbar=foot]metropolis")

(after! ox-latex
  (setq org-latex-pdf-process '("latexmk -xelatex -quiet -shell-escape -f %f"))
  (setq org-latex-src-block-backend 'minted)
  (add-to-list 'org-latex-classes
               '("article"
                 "\\documentclass[12pt,a4paper]{report}
\\usepackage{graphicx}
\\usepackage{xcolor}
\\usepackage{xeCJK}
\\usepackage{enumitem}
\\usepackage{threeparttable}
\\usepackage{marginnote}
\\usepackage{cleveref}
\\usepackage[framemethod=TikZ]{mdframed}
\\usepackage{lmodern}
\\usepackage{verbatim}
\\usepackage{amsmath, amsthm}
\\usepackage{minted}
\\usepackage{fixltx2e}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{tikz}
\\usepackage{wrapfig}
\\usepackage{soul}
\\usepackage{textcomp}
\\usepackage{listings}
\\usepackage{geometry}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{latexsym}
\\usepackage{natbib}
\\usepackage{fancyhdr}
\\usepackage{cancel}
\\usepackage{microtype}
\\usepackage[xetex,colorlinks=true,CJKbookmarks=true, linkcolor=blue, urlcolor=blue, menucolor=blue]{hyperref}
\\usepackage{fontspec,xunicode,xltxtra}
\\newfontinstance\\MONO{\\fontnamemono}
\\newcommand{\\mono}[1]{{\\MONO #1}}
\\setmainfont{TeX Gyre Pagella}
\\setCJKmainfont{SimSun}
\\setCJKsansfont{WenQuanYi Micro Hei}
\\setCJKmonofont{Sarasa Gothic SC}
\\hypersetup{unicode=true}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,marginparsep=7pt, marginparwidth=.6in}
\\punctstyle{kaiming}

\\title{}
% 定义代码高亮风格
% \\usemintedstyle{manni} % 可以选择你喜欢的风格

% 设置代码背景色
\\setminted{bgcolor=white} % 对应于 listings 的 backgroundcolor

% 设置字体大小和样式，minted 没有直接的选项，但可以通过其他 LaTeX 命令来设置
\\setminted{fontsize=\\small, baselinestretch=1}

% 设置行号
\\setminted{linenos, numbersep=5pt, frame=lines, framesep=2mm}

% 设置页眉页脚的分隔线
\\renewcommand{\\headrulewidth}{0.4pt} % 页眉分隔线宽度
\\renewcommand{\\footrulewidth}{0pt} % 页脚分隔线宽度（0pt表示没有分隔线）
\\newtheorem{lemma}{Lemma}[chapter]
\\newtheorem{corollary}{Corollary}[chapter]
\\newtheorem{proposition}{Proposition}[chapter]

% 定义其他环境
\\newtheorem{ex}{Exercise}[chapter]
\\newtheorem{notation}{Notation}[chapter]
\\newtheorem{remark}{Remark}[chapter]

\\newtheorem{theorem}{Theorem}[chapter]
\\newtheorem{definition}{Definition}[chapter]
\\newtheorem{exm}{Example}[chapter]
\\pagestyle{fancy}
\\fancyhf{}
\\renewcommand{\\chaptermark}[1]{\\markboth{#1}{}} % 修改页眉的chaptermark
\\fancyfoot[R]{\\thepage}
\\fancyhead{} % 页眉清空
\\fancyhead[R]{%
   % The chapter number only if it's greater than 0
   \\ifnum\\value{chapter}>0 \\chaptername\ \\thechapter: \\fi
   % The chapter title
   \\leftmark}
\\fancypagestyle{plain}{
\\fancyhead{} % 页眉清空
\\renewcommand{\\headrulewidth}{0pt} % 去页眉线
\\fancyfoot{}
\\fancyfoot[R]{\\thepage}
}
\\tolerance=1000

[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
[EXTRA]"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; 使用Listings宏包格式化源代码(只是把代码框用listing环境框起来，还需要额外的设置)
(setq org-export-latex-listings t)
;; Options for \lset command（reference to listing Manual)
;; 导出Beamer的设置
;; allow for export=>beamer by placing #+LaTeX_CLASS: beamer in org files
;;-----------------------------------------------------------------------------
(add-to-list 'org-latex-classes
             ;; beamer class, for presentations
             '("beamer"
               "\\documentclass[11pt,professionalfonts]{beamer}
\\mode

\\setbeamertemplate{footline}[frame number]{}
\\setbeamertemplate{navigation symbols}{}

\\usecolortheme{lily}
\\setbeamercolor{block title}{bg=blue!20,fg=black}
\\setbeamercolor{block body}{bg = blue!10, fg = black}
\\setbeamertemplate{itemize item}[square]
\\setbeamercolor{itemize item}{fg = cyan}
\\setbeamercolor{enumerate item}{fg = cyan}

\\usetheme{default}
\\beamertemplatenavigationsymbolsempty
\\setbeamercolor{titlelike}{fg=cyan}
\\beamertemplateballitem
\\setbeameroption{show notes}
\\usepackage{graphicx}
\\usepackage{tikz}
\\usepackage{xcolor}
\\usepackage{xeCJK}
\\usepackage{amsmath}
\\usepackage{lmodern}
\\usepackage{fontspec,xunicode,xltxtra}
\\usepackage{polyglossia}
\\setmainfont{TeX Gyre Pagella}
\\setCJKmainfont{Source Han Serif SC}
\\setCJKsansfont{Source Han Sans SC}
\\setCJKmonofont{Sarasa Gothic SC}
\\usepackage{verbatim}
\\usepackage{listings}
% \\institute{{{{beamerinstitute}}}}
\\subject{{{{beamersubject}}}}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\begin{frame}[fragile]\\frametitle{%s}"
                "\\end{frame}"
                "\\begin{frame}[fragile]\\frametitle{%s}"
                "\\end{frame}")))
)

(setq deft-directory "~/projects/")
(setq org-noter-notes-search-path '("~/projects"))

(after! ox-pandoc
  (setq org-pandoc-options-for-latex-pdf '((pdf-engine . "xelatex")
                                           (template . "eppdev-doc")
                                           ))
  (setq org-pandoc-options-for-docx '((reference-doc . "/home/peng/Documents/templates/template.docx")))
  )

;; ============================================================================
;; Novel Writing Capture System — Fixed & Stable
;; ============================================================================
(after! org-capture
  ;; --------------------------------------------------------------------------
  ;; 1. File structure
  ;; --------------------------------------------------------------------------
  (defvar my/novel-org-path "~/projects/novel/org/"
    "Base path for all novel-related org files.")

  (defvar my/novel-files
    '(("inbox"      . "inbox.org")
      ("characters" . "characters.org")
      ("scenes"     . "scenes.org")
      ("world"      . "world.org")
      ("dialogue"   . "dialogue.org")
      ("research"   . "research.org")
      ("poem"       . "poem.org")
      ("tasks"      . "tasks.org"))
    "Assoc list of novel org files (name . filename).")

  (defun my/novel-file (key)
    "Return full path for novel file KEY, or signal error if missing."
    (let ((fname (alist-get key my/novel-files nil nil #'string=)))
      (unless fname
        (error "Unknown novel file key: %s" key))
      (expand-file-name fname my/novel-org-path)))

  ;; Ensure the directory exists
  (unless (file-directory-p my/novel-org-path)
    (make-directory my/novel-org-path t))

  ;; --------------------------------------------------------------------------
  ;; 2. Utility: generate UUID IDs for linking
  ;; --------------------------------------------------------------------------
  (defun my/uuid ()
    "Generate a new org ID for capture entries."
    (when (require 'org-id nil t)
      (org-id-new)))

  ;; --------------------------------------------------------------------------
  ;; 3. Add capture templates safely
  ;; --------------------------------------------------------------------------
  (add-to-list 'org-capture-templates
               '("w" "Novel Writing") t)  ;; <- prefix key, valid now

  (add-to-list 'org-capture-templates
               `("wi" "Idea / Inbox" entry
                 (file+headline ,(my/novel-file "inbox") "Fleeting Ideas")
                 "* %? :idea:\n:PROPERTIES:\n:Created: %U\n:ID: %(my/uuid)\n:END:\n\n%i\n%a"
                 :empty-lines 1))

  (add-to-list 'org-capture-templates
               `("wc" "Character" entry
                 (file ,(my/novel-file "characters"))
                 ,(string-join
                   '("* %? :character:"
                     ":PROPERTIES:"
                     ":Created: %U"
                     ":ID: %(my/uuid)"
                     ":Alias:"
                     ":Role:"
                     ":Arc:"
                     ":END:"
                     "\n** Overview\n- Role in story:\n- One-line summary:\n\n"
                     "** Appearance\n- Physical description:\n\n"
                     "** Personality & Background\n- Traits & backstory:\n\n"
                     "** Motivation & Conflict\n- Drives:\n- Obstacles:\n\n"
                     "** Relationships\n- Key connections:\n\n"
                     "** Arc Notes\n\n")
                   "\n")
                 :empty-lines 1))

  (add-to-list 'org-capture-templates
               `("ws" "Scene / Plot Point" entry
                 (file+headline ,(my/novel-file "scenes") "Scenes")
                 ,(string-join
                   '("* %? :scene:"
                     ":PROPERTIES:"
                     ":Created: %U"
                     ":ID: %(my/uuid)"
                     ":Location:"
                     ":Time:"
                     ":POV:"
                     ":Characters:"
                     ":WorldRefs:"
                     ":Status: idea"
                     ":END:"
                     "\n** Logline\nOne-sentence summary of the scene.\n\n"
                     "** Purpose\n- Function in story:\n- Stakes:\n\n"
                     "** Outline\n1. Setup\n2. Conflict\n3. Resolution\n\n"
                     "** Emotional Arc\n- POV emotional change:\n\n"
                     "** Sensory Details\nSight / Sound / Smell / Touch / Taste:\n\n"
                     "** Notes\n\n")
                   "\n")
                 :empty-lines 1))

  (add-to-list 'org-capture-templates
               `("ww" "Worldbuilding / Lore" entry
                 (file+headline ,(my/novel-file "world") "World Notes")
                 ,(string-join
                   '("* %? :world:"
                     ":PROPERTIES:"
                     ":Created: %U"
                     ":ID: %(my/uuid)"
                     ":Category:"
                     ":END:"
                     "\n** Description\n\n"
                     "** Connections\nLinks to: [[id:]]\n\n"
                     "** Story Relevance\n\n")
                   "\n")
                 :empty-lines 1))

  (add-to-list 'org-capture-templates
               `("wd" "Dialogue Snippet" entry
                 (file+headline ,(my/novel-file "dialogue") "Fragments")
                 "* %U :dialogue:\n%?\n"
                 :empty-lines 1))

  (add-to-list 'org-capture-templates
               `("wr" "Research Note" entry
                 (file+headline ,(my/novel-file "research") "Notes")
                 "* %? :research:\n:PROPERTIES:\n:Created: %U\n:Source: %a\n:END:\n\n%i\n"
                 :empty-lines 1))

  (add-to-list 'org-capture-templates
               `("wt" "Writing Task" entry
                 (file+headline ,(my/novel-file "tasks") "Writing Tasks")
                 "* TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n:PROPERTIES:\n:Created: %U\n:END:"
                 :empty-lines 1))
  (add-to-list 'org-capture-templates
               `("wp" "Poem / Verse" entry
                 (file+headline ,(my/novel-file "poem") "Poems")
                 ,(string-join
                   '("* %? :poem:"
                     ":PROPERTIES:"
                     ":Created: %U"
                     ":ID: %(my/uuid)"
                     ":Form:"          ;; e.g. haiku / free verse / sonnet
                     ":Theme:"         ;; main subject or inspiration
                     ":END:"
                     "\n** Draft\n\n"
                     "** Imagery & Emotion\n\n"
                     "** Notes / Revisions\n\n")
                   "\n")
                 :empty-lines 1))
  )

(use-package! org-ql :ensure t)

(setq org-columns-default-format
      "%25ITEM(Task) %10ID(ID) %10POV(POV) %20Goal(Goal) %15Status(Status) %6Words(Words) %TAGS")

(defun my/novel-collect-scenes-from-current-buffer ()
  "从当前 Org buffer 中收集所有带 :scene: 标签的条目，并返回一个 plists 列表。
该函数会收集 :title :id :pov :goal :tensionscore :outcome :status :words :next 这些属性。"
  (unless (derived-mode-p 'org-mode)
    (error "This function must be run in an Org mode buffer"))
  (org-with-wide-buffer
    (let (out)
      (org-map-entries
       (lambda ()
         (let* ((title (nth 4 (org-heading-components)))
                (id    (org-entry-get nil "ID"))
                (pov   (org-entry-get nil "POV"))
                (goal  (org-entry-get nil "Goal"))
                (tensionscore (org-entry-get nil "TensionScore"))
                (outcome (org-entry-get nil "Outcome"))
                (status  (org-entry-get nil "Status"))
                (words   (org-entry-get nil "Words"))
                (next    (org-entry-get nil "Next")))
           (push (list :title title :id id :pov pov :goal goal
                       :tensionscore tensionscore :outcome outcome :status status
                       :words (when words (string-to-number words))
                       :next next)
                 out)))
       ;; --- 这是关键的修改 ---
       ;; 仅匹配层级为 1 (一个星号) 且带有 "scene" 标签的标题
       "+scene+LEVEL=1")
      (nreverse out))))

(defun my/novel-scenes-to-table ()
  "为当前 Org 文件中的所有场景生成一个 Org 表格，并在新 buffer 中显示。
表格包含 Scene, ID, POV, Goal, TensionScore, Outcome, Status, Words 列。"
  (interactive)
  (let ((rows (my/novel-collect-scenes-from-current-buffer)))
    (with-current-buffer (get-buffer-create "*Novel Scenes Table*")
      (setq-local buffer-read-only nil)
      (erase-buffer)
      (insert "| Scene | ID | POV | Goal | TensionScore | Outcome | Status | Words |\n")
      (insert "|-\n")
      (dolist (s rows)
        (insert (format "| %s | %s | %s | %s | %s | %s | %s | %s |\n"
                        (or (plist-get s :title) "")
                        (or (plist-get s :id) "")
                        (or (plist-get s :pov) "")
                        (or (plist-get s :goal) "")
                        (or (plist-get s :tensionscore) "")
                        (or (plist-get s :outcome) "")
                        (or (plist-get s :status) "")
                        (or (plist-get s :words) ""))))
      (org-mode)
      (org-table-align)
      (goto-char (point-min))
      (display-buffer (current-buffer)))))

;; --- 增强版场景数据收集与 CSV 导出工具 ---

(defun my/org-get-text-under-subheading (subheading)
  "在当前 org-map-entries 的范围内，查找名为 SUBHEADING 的子标题并返回其下方的所有文本内容。
此版本使用更健壮的 org-element API。"
  (require 'org-element) ; 同样需要 require
  (save-excursion
    (let ((case-fold-search t)
          (re (format "^\\*\\* %s" (regexp-quote subheading))))
      (if (re-search-forward re nil t)
          ;; 使用 org-element API 解析当前标题
          (let* ((element (org-element-at-point))
                 (begin (org-element-property :contents-begin element))
                 (end (org-element-property :contents-end element)))
            (if (and begin end)
                (string-trim (buffer-substring-no-properties begin end))
              ""))
        ""))))

(defun my/novel-collect-rich-scene-data ()
  "从当前 Org buffer 中收集所有带 :scene: 标签的条目及其详细数据。
此版本会自动清理 ID 和 Next 属性中的 'id:' 前缀。"
  (unless (derived-mode-p 'org-mode)
    (error "This function must be run in an Org mode buffer"))
  (require 'org-element)
  (org-with-wide-buffer
    (let (out)
      (org-map-entries
       (lambda ()
         (let* (;; --- 这是关键的修改 ---
                (id-raw (org-entry-get nil "ID"))
                (next-raw (org-entry-get nil "Next"))
                (id (when id-raw (replace-regexp-in-string "^id:" "" id-raw)))
                ;; 对 Next 字段中的所有 "id:" 都进行替换
                (next (when next-raw (replace-regexp-in-string "id:" "" next-raw)))

                (plist (list
                        :title (nth 4 (org-heading-components))
                        :id id ; 使用清理后的 id
                        :pov (org-entry-get nil "POV")
                        :location (org-entry-get nil "Location")
                        :time (org-entry-get nil "Time")
                        :goal (org-entry-get nil "Goal")
                        :conflict (org-entry-get nil "Conflict")
                        :tensionscore (org-entry-get nil "TensionScore")
                        :outcome (org-entry-get nil "Outcome")
                        :status (org-entry-get nil "Status")
                        :words (let ((w (org-entry-get nil "Words")))
                                 (when w (string-to-number w)))
                        :arc (org-entry-get nil "Arc")
                        :characters (org-entry-get nil "Characters")
                        :next next ; 使用清理后的 next
                        :summary (my/org-get-text-under-subheading "概述 (Summary)")
                        :notes (my/org-get-text-under-subheading "笔记 (Notes)"))))
           (push plist out)))
       "+scene+LEVEL=1")
      (nreverse out))))

(defun my/csv-quote (str)
  "为 CSV 格式正确地引用字符串。
如果字符串包含逗号、双引号或换行符，则用双引号包裹它，
并将内部的双引号替换为两个双引号。"
  (let ((s (if (stringp str) str (format "%s" (or str "")))))
    (if (string-match "[\",\n]" s)
        (concat "\"" (string-replace "\"" "\"\"" s) "\"")
      s)))
(defun my/novel-export-scenes-to-csv (&optional file-path)
  "将当前 Org 文件中的所有场景数据导出为 CSV 文件。
如果 FILE-PATH 未提供，则会交互式地询问用户。
成功时返回导出的文件路径，否则返回 nil。"
  (interactive)
  (let* ((rows (my/novel-collect-rich-scene-data))
         (output-path (or file-path (read-file-name "Export CSV to file: " nil nil t "scenes.csv")))
         ;; --- 关键行 ---
         ;; 确保 headers 列表中包含小写的 :tensionscore
         (headers '(:id :title :status :pov :goal :conflict :outcome :tensionscore :arc :characters :location :time :words :summary :notes :next)))
    (when (and rows output-path)
      (with-temp-buffer
        (insert (mapconcat #'symbol-name headers ",") "\n")
        (dolist (s rows)
          (let ((line (mapconcat
                       (lambda (key) (my/csv-quote (plist-get s key)))
                       headers
                       ",")))
            (insert line "\n")))
        (write-region (point-min) (point-max) output-path nil))
      (message "Successfully exported %d scenes to %s" (length rows) output-path)
      output-path)))

;; --- 新增：可视化启动器 ---
(defvar my/novel-visualization-script
  (expand-file-name "scripts/visualize_novel.py" doom-private-dir)
  "指向用于可视化小说数据的 Python 脚本的路径。")

(defun my/novel-visualize-data-with-python ()
  "一键工作流：导出场景数据到 CSV，然后调用 Python 脚本生成可视化图表。"
  (interactive)
  (let* ((csv-dir (or buffer-file-name default-directory))
         (csv-file (expand-file-name "scenes_data.csv" (file-name-directory csv-dir)))
         (exported-path (my/novel-export-scenes-to-csv csv-file)))
    (if (and exported-path (file-exists-p my/novel-visualization-script))
        (progn
          (message "CSV exported. Now running Python visualization script...")
          ;; 异步执行脚本，避免冻结 Emacs
          (async-shell-command (format "python %s %s"
                                       (shell-quote-argument my/novel-visualization-script)
                                       (shell-quote-argument exported-path)))
          (message "Python script started asynchronously. A plot window should appear soon."))
      (unless exported-path
        (warn "CSV export was cancelled or failed."))
      (unless (file-exists-p my/novel-visualization-script)
        (warn "Visualization script not found at: %s" my/novel-visualization-script)))))



;; --- 新增：用于调用 Excel 转换脚本的变量和函数 ---

(defvar my/novel-excel-converter-script
  (expand-file-name "scripts/csv_to_styled_xlsx.py" doom-private-dir)
  "指向用于将 CSV 转换为格式化 Excel 文件的 Python 脚本的路径。")

(defun my/novel-export-to-excel ()
  "一键工作流：导出场景数据到 CSV，然后调用 Python 脚本将其转换为格式精美的 XLSX 文件。"
  (interactive)
  (let* ((csv-dir (or buffer-file-name default-directory))
         (csv-file (expand-file-name "scenes_data.csv" (file-name-directory csv-dir)))
         ;; 步骤 1: 调用我们已有的函数导出 CSV
         (exported-path (my/novel-export-scenes-to-csv csv-file)))
    ;; 步骤 2: 如果 CSV 导出成功，则调用新的 Python 脚本
    (if (and exported-path (file-exists-p my/novel-excel-converter-script))
        (progn
          (message "CSV exported. Now converting to styled XLSX...")
          (async-shell-command (format "python3 %s %s > /dev/null &"
                                       (shell-quote-argument my/novel-excel-converter-script)
                                       (shell-quote-argument exported-path)))
          (message "Python script started asynchronously. The .xlsx file will be created soon."))
      (unless exported-path
        (warn "CSV export was cancelled or failed."))
      (unless (file-exists-p my/novel-excel-converter-script)
        (warn "Excel converter script not found at: %s" my/novel-excel-converter-script)))))

(require 'org-id)
(setq org-id-link-to-org-use-id t)

(defun mcj/org-id-create ()
  "Create and store a human readable ID for the current heading."
  (let* ((title (or (nth 4 (org-heading-components)) ""))
         (san (replace-regexp-in-string "[^[[:alpha:]]]+" "_" (downcase title)))
         (san (replace-regexp-in-string "^_+\\|_+$" "" san))
         (new-id (format "L%s_%s" (format-time-string "%Y%m%d.%H%M%S") (if (string= san "") "untitled" san))))
    (org-entry-put nil "ID" new-id)
    ;; register to org-id locations
    (org-id-add-location new-id (or (buffer-file-name (buffer-base-buffer)) (buffer-file-name)))))

(defun mcj/org-id-get-or-create ()
  "Return the ID of the current entry, creating one if absent."
  (let ((old (org-entry-get nil "ID")))
    (if (and old (stringp old) (> (length old) 0))
        old
      (mcj/org-id-create)
      (org-entry-get nil "ID"))))
(defun mcj/org-id-create-if-needed ()
  "If the current node does not have a ID, create one."
  (interactive)
  (org-with-point-at nil
    (let ((old-id (org-entry-get nil "ID")))
      (if (and old-id (stringp old-id))
          (when (called-interactively-p 'any)
            (message "ID already exists. Not overwriting it."))
        (mcj/org-id-create)))))

;; Add mcj/org-id-create-if-needed as advice. For this we need a wrapper function that passes its argument to org-store-link
(defun mcj/org-id-advice (&rest _args)
  (when (org-before-first-heading-p)
    ;; nothing to do if not in heading - optional guard
    )
  (mcj/org-id-get-or-create)
  (org-id-update-id-locations))

(advice-add 'org-store-link :before #'mcj/org-id-advice)

(defun novel-auto-generate-id-after-snippet ()
  (when (looking-back "temp-id-placeholder" (line-beginning-position))
    (delete-region (line-beginning-position) (line-end-position))
    (mcj/org-id-get-or-create)))
(add-hook 'yas-after-exit-snippet-hook #'novel-auto-generate-id-after-snippet)

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(set-language-environment "UTF-8")

(after! pyim
  (require 'pyim-cregexp-utils)
  (require 'pyim-liberime)
  ;; 如果使用 popup page tooltip, 就需要加载 popup 包。
  ;; (require 'popup nil t)
  (setq pyim-page-tooltip 'posframe)

  ;; 如果使用 pyim-dregcache dcache 后端，就需要加载 pyim-dregcache 包。
  ;; (require 'pyim-dregcache)
  ;; (setq pyim-dcache-backend 'pyim-dregcache)

  ;; 加载 basedict 拼音词库。
  (pyim-basedict-enable)

  ;; 将 Emacs 默认输入法设置为 pyim.
  (setq default-input-method "pyim")

  ;; 显示 5 个候选词。
  (setq pyim-page-length 5)

  ;; 金手指设置，可以将光标处的编码（比如：拼音字符串）转换为中文。
  (global-set-key (kbd "M-j") 'pyim-convert-string-at-point)

  ;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp.
  (define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)

  ;; 设置 pyim 默认使用的输入法策略，我使用全拼。
  (pyim-default-scheme 'ziranma-shuangpin)
  ;; (pyim-default-scheme 'wubi)
  ;; (pyim-default-scheme 'cangjie)

  ;; 设置 pyim 是否使用云拼音。
  (setq pyim-cloudim 'baidu)

  ;; 设置 pyim 探针
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-org-structure-template))
  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; 开启代码搜索中文功能（比如拼音，五笔码等）
  (pyim-isearch-mode 1)
  )
(use-package! pyim-basedict
  :after pyim)

(after! dired
  (defun my/dired-xdg-open ()
    "Open the file at point in Dired using xdg-open."
    (interactive)
    (let ((file (dired-get-file-for-visit)))
      (if (file-directory-p file)
          (dired-find-file) ; Open directory in Dired
        (start-process "xdg-open" nil "xdg-open" file))))

  (define-key dired-mode-map (kbd "M-o") 'my/dired-xdg-open)
  )
