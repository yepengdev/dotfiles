;;; init.el --- Doom module declaration -*- lexical-binding: t; -*-

;; This file answers exactly one question: which Doom modules are enabled, and
;; in what order they load. Per-module behaviour (fonts, keybinds, export
;; pipeline, input method, CJK handling, ...) lives in config.el and the
;; numbered fragments under lisp/. No setq, defun, hook or `after!' form
;; belongs here.
;;
;; ---------------------------------------------------------------------------
;; Scope and how changes take effect
;; ---------------------------------------------------------------------------
;;   init.el, packages.el    -> run `doom sync' (recomputes packages + autoloads)
;;   config.el, lisp/*.el    -> `M-x doom/reload' is enough
;;
;; ---------------------------------------------------------------------------
;; Where modules come from
;; ---------------------------------------------------------------------------
;;   native    ~/.config/emacs/sources/doom+/modules/   shipped with Doom
;;   custom    $DOOMDIR/modules/                        maintained in this repo
;;   packages  $DOOMDIR/packages.el `package!' forms    no module slot
;;
;; Custom modules are declared exactly like native ones: Doom resolves them
;; through `doom-module-load-path', where $DOOMDIR/modules/ comes first. To keep
;; the two sets apart at a glance, every custom module below carries a
;; `[custom]' marker together with its path. For the runtime picture - resolved
;; directory, origin and flags for every enabled module - run
;; `M-x my/describe-doom-modules' (implemented in lisp/80-tools.el).
;;
;; Custom modules declared in this file:
;;   :tools notes      $DOOMDIR/modules/tools/notes
;;   :tools novel      $DOOMDIR/modules/tools/novel
;;   :tools pomodoro   $DOOMDIR/modules/tools/pomodoro
;;   :tools cjk        $DOOMDIR/modules/tools/cjk
;;   :tools jieba      $DOOMDIR/modules/tools/jieba       (declared, disabled)
;;   :ffi   dyncall    $DOOMDIR/modules/ffi/dyncall
;;   :editor meow      $DOOMDIR/modules/editor/meow       (declared, disabled)
;;
;; ---------------------------------------------------------------------------
;; Reading this file
;; ---------------------------------------------------------------------------
;; Commented-out entries are a menu of options, not dead weight: they record
;; what was considered. Enabled modules with a dependency gap state the
;; criterion (which binary is missing, why it stays off) so the evaluation does
;; not have to be repeated. Press K (or C-c c k) on a module for its manual,
;; gd to open its source directory.

(doom! :input
       ;;bidi              ; right-to-left script support
       ;;chinese           ; pinyin first-letter search - handled by fcitx + evil-pinyin
       ;;japanese          ; Japanese input support
       ;;layout            ; auie,ctsrnm is the superior home row

       :completion
       ;;company           ; the ultimate code completion backend
       (corfu +orderless +dabbrev)   ; in-buffer completion: Capf + fuzzy + dabbrev
       ;;helm              ; *another* search engine for love and life
       ;;ido               ; the other *other* search engine...
       ;;ivy               ; a search engine for love and life
       (vertico +childframe +icons)  ; vertical completion UI (the search half)

       :ui
       deft              ; Notational Velocity for Emacs (notes depends on it)
       doom              ; what makes DOOM look like DOOM
       ;;dashboard         ; a splash screen with pretty pictures
       ;;doom-quit         ; DOOM quit prompt when quitting Emacs
       emoji             ; 🙂
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides     ; highlighted indent columns
       ;;(ligatures +extra) ; ligatures and symbols to make code pretty again
       ;;minimap           ; code minimap in the side margin
       modeline          ; snazzy Atom-style mode line, with an API
       nav-flash         ; blink the current line after big motions
       ;;neotree           ; a project tree, like vim's NERDTree
       ophints           ; highlight the region an operation acts on
       (popup +defaults) ; tame sudden temporary windows
       ;;smooth-scroll     ; so smooth you will not believe it is not butter
       ;;tabs              ; a tab bar for Emacs
       treemacs          ; a project tree, cooler than neotree
       ;;unicode           ; extended unicode support for various languages
       (vc-gutter +pretty) ; version control diff in the fringe
       ;;vi-tilde-fringe   ; tildes beyond the end of the buffer
       (window-select +numbers) ; visually switch windows
       workspaces        ; tab emulation, persistence and separate workspaces
       zen               ; distraction-free coding or writing

       :editor
       (evil +everywhere) ; come to the dark side, we have cookies
       ;;meow              ; [custom] alternative modal editing; parked in attic.el
       file-templates    ; auto-snippets for empty files
       fold              ; (nearly) universal code folding
       (format +onsave)  ; format on save via apheleia (SPC m f also works)
       ;;god               ; run Emacs commands without modifier keys
       ;;lispy             ; vim for lisp, for people who do not like vim
       multiple-cursors  ; editing in many places at once
       ;;objed             ; text object editing for the innocent
       ;;parinfer          ; turn lisp into python, sort of
       ;;rotate-text       ; cycle through the text at point
       snippets          ; my elves: they type, so I do not have to
       (whitespace +guess +trim) ; the whitespace butler
       word-wrap         ; soft wrapping with language-aware indent

       :emacs
       (dired +dirvish +icons) ; making dired pretty and useful
       electric          ; smarter, keyword-based electric-indent
       ;;eww               ; the internet is a terrible place
       (ibuffer +icons)  ; interactive buffer management
       tramp             ; remote files at your fingertips
       undo              ; persistent, smarter undo
       vc                ; version control, living in harmony with Emacs

       :term
       eshell            ; the elisp shell that works everywhere
       ;;shell             ; a simple shell REPL for Emacs
       ;;term              ; the basic terminal emulator for Emacs
       vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax            ; tsk tsk tsk, for every semicolon you missed (flymake)
       ;;(spell +flyspell) ; aspell/hunspell present but off: proofreading is manual
       ;;grammar           ; tsk tsk tsk, for every grammar mistake you made

       :tools
       ;;ansible           ; an IT automation tool
       ;;biblio            ; for your PhD (with citations)
       ;;collab            ; share buffers with friends
       ;;debugger          ; stepping through code, to help you add bugs
       ;;direnv            ; load environment variables automatically
       ;;docker            ; container management
       ;;editorconfig      ; let someone else argue about tabs vs spaces
       ;;ein               ; tame Jupyter notebooks with Emacs
       (eval +overlay)     ; run code (and REPLs) inline
       (lookup +dictionary +docsets) ; dict (wordnet) + docsets (none installed yet)
       ;;llm               ; when I said you needed friends, I did not mean this
       (lsp +eglot)        ; LSP client; clangd (llvm 21) serves :lang cc
       magit               ; a git porcelain for Emacs
       ;;make              ; run make tasks from Emacs
       ;; notes +film (film diary, modules/tools/notes/contrib/film.el) stays
       ;; off: the ~/org/denote/film/ silo exists but holds no notes yet; the
       ;; flag would add a SPC r d v prefix.
       notes               ; [custom] Denote + Deft notes (the knowledge backbone here)
       ;;pass              ; a password manager for neckbeards
       pdf                 ; pdf-tools enhancements
       pomodoro            ; [custom] pomodoro timer + notifications (C module cnotify)
       cjk                 ; [custom] CJK character counting (C module count-cjk.so)
       novel               ; [custom] Scrivener-style fiction workbench
       ;; jieba is declared but disabled: the [custom] module and
       ;; c-modules/jieba-module.so are both ready, yet the dictionary costs
       ;; 1-2s on first use and the note workflow does not need keyword
       ;; extraction. Enable when it does.
       ;;jieba             ; [custom] jieba segmentation + TF-IDF keywords
       ;;terraform         ; infrastructure as code
       ;;tmux              ; an API for interacting with tmux
       tree-sitter         ; syntax parsing, living in harmony...
       ;;upload            ; map a local project over ssh/ftp

       :lang
       ;;ada               ; types, we (blindly) trust
       ;;(agda +local)     ; types of types of types...
       ;;beancount         ; mind the accounting standards
       (cc +lsp)           ; C > C++ == 1
       ;;clojure           ; java with lisp
       ;;common-lisp       ; if you have seen one lisp, you have seen them all
       ;;coq               ; proofs-as-programs
       ;;crystal           ; ruby at the speed of c
       ;;csharp            ; unity, .NET and mono shenanigans
       ;;data              ; config/data formats
       ;;(dart +flutter)   ; paint ui and nothing else
       ;;dhall             ; a configuration language for the paranoid
       ;;elixir            ; erlang done right
       ;;elm               ; care for a cup of TEA?
       emacs-lisp          ; drowning in a sea of parentheses
       ;;erlang            ; an elegant language for a more civilized age
       ;;ess               ; emacs speaks statistics
       ;;factor            ; a stack language
       ;;faust             ; dsp, but keep your soul
       ;;fortran           ; in FORTRAN, GOD is REAL (unless declared INTEGER)
       ;;fsharp            ; ML stands for Microsoft's Language
       ;;fstar             ; (dependent) types and (monadic) effects and Z3
       ;;gdscript          ; the language you waited for
       ;;(go +lsp)         ; the hipster dialect
       ;;(graphql +lsp)    ; give queries a rest
       ;;(haskell +lsp)    ; a language that is lazier than I am
       ;;hy                ; readability of scheme, speed of python
       ;;idris             ; a language you can depend on
       ;;json              ; at least it is not XML
       ;;janet             ; fun fact: Janet is me!
       ;;(java +lsp)       ; the poster child for carpal tunnel syndrome
       ;;javascript        ; all hope abandon, ye who enter here
       ;;julia             ; a better, faster MATLAB
       ;;kotlin            ; a better, slicker Java(Script)
       (latex +cdlatex +fold) ; writing papers in Emacs has never been so fun
       ;;lean              ; for folks with too much to prove
       ;;ledger            ; be audit you can be
       ;;lua               ; one-based indices? one-based indices
       markdown          ; writing docs for people to ignore
       ;;nim               ; python + lisp at the speed of c
       ;;nix               ; I hereby declare "nix macht ja nichts"
       ;;ocaml             ; an objective camel
       ;;odin              ; c, but without the sharp edges
       ;; org flags, one criterion each:
       ;;   +journal org-journal / +noter org-noter PDF annotations /
       ;;   +pretty org-modern / +pandoc ox-pandoc export (pandoc present) /
       ;;   +present slides (centered-window, org-tree-slide installed) /
       ;;   +roam org-roam installed, but nothing here calls its API - knowledge
       ;;   management runs on Denote (see :tools notes)
       (org +journal +noter +pretty +pandoc +present +roam)
       ;;php               ; perl's insecure younger brother
       ;;plantuml          ; diagrams for confusing people more
       ;;graphviz          ; diagrams for confusing yourself more
       ;;purescript        ; javascript, but functional
       ;;python            ; beautiful is better than ugly
       ;;qt                ; the "cutest" gui framework ever
       ;;racket            ; a dsl for making dsls
       ;;raku              ; the artist formerly known as perl6
       ;;rest              ; emacs as a REST client
       ;;rst               ; ReST in peace
       ;;(ruby +rails)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       ;;(rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;scala             ; java, but good
       ;;(scheme +guile)   ; a fully conniving lisp family
       ;; sh +lsp needs bash-language-server, which is absent from exec-path
       ;; (only installed under ~/.local/share/vim-lsp-settings/). Add the flag
       ;; back once the binary is on PATH.
       (sh +fish)          ; she sells {ba,z,fi}sh shells on the C xor
       ;;sml               ; standard ML
       ;;solidity          ; do you need blockchain? no.
       ;;swift             ; who needs emoji variables?
       ;;terra             ; earth and moon aligned, for maximum performance
       ;;web               ; the tubes
       ;;yaml              ; json, but readable
       ;;zig               ; c, but simpler

       :ffi
       dyncall            ; [custom] libffi FFI: call any C function at runtime

       :os
       (:if (featurep :system 'macos) macos) ; macOS compatibility (no-op on Linux)
       tty                ; improve the terminal Emacs experience

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar          ; a calendar for Emacs
       ;;emms              ; the emacs multimedia system
       ;;everywhere        ; *leave* Emacs!? You must be joking
       ;;irc               ; how neckbeards socialise
       ;;(rss +org)        ; emacs as an RSS reader

       :config
       ;;literate          ; literate configuration
       (default +bindings +smartparens))
