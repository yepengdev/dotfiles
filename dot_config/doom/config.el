;;; config.el -*- lexical-binding: t; no-byte-compile: t; -*-
;;;
;;; Doom Emacs 个人配置 — 入口与运行时基线。
;;;
;;; 本文件只做两件事：设定启动期基线，然后按依赖顺序加载 lisp/ 下的分片。
;;; 具体配置请直接改对应的分片：M-x doom/reload 即可生效，无需 doom sync
;;;（除非改了 init.el 或 packages.el）。
;;;
;;; ─── 分片地图 ──────────────────────────────────────────────────────────
;;;
;;;   文件                 职责
;;;   ────────────────────────────────────────────────────────────────────
;;;   lisp/10-ui.el        外观：字体、CJK 回退、主题、行号、折行、内边距
;;;   lisp/20-editing.el   编辑行为：保存策略、Evil、写作辅助、Git、Shell、键位
;;;   lisp/30-system.el    系统交互：外部程序、浏览器、niri 焦点、lookup 源
;;;   lisp/40-org.el       Org 核心：目录、捕获、显示、标点、大文件降级
;;;   lisp/45-export.el    导出：Pandoc(docx/PDF)、ox-html、LaTeX/ctexbook
;;;   lisp/50-org-live.el  Org 实时预览子系统（HTTP+SSE）
;;;   lisp/60-reading.el   阅读：Dired、EPUB(nov)、PDF(pdf-tools/org-noter)
;;;   lisp/70-cjk.el       中文：fcitx5、拼音检索、中英混排间距
;;;   lisp/80-tools.el     工具：拼写、括号高亮、KDL、配置编译
;;;   lisp/90-session.el   服务器进程与会话退出
;;;   lisp/attic.el        未启用的备选方案（不加载，见文件头说明）
;;;
;;; ─── 三条约定 ──────────────────────────────────────────────────────────
;;;
;;; 1. 编号即依赖顺序。分片之间的耦合必须自上而下（如 45 定义
;;;    `my/org-export-assets-dir'，50 使用它），反向依赖一律通过
;;;    `with-eval-after-load'/`after!' 解耦。
;;; 2. 一个文件一个关注点。同一件事的实现只允许出现一次：平台差异集中在
;;;    30-system.el 的 `my/open-externally'，图形帧延迟初始化集中在
;;;    10-ui.el 的 `my--on-first-graphic-frame'，捕获模板集中在 40-org.el。
;;; 3. 死代码不留在活文件里。暂时不用的方案进 lisp/attic.el，
;;;    需要时再搬回对应分片。
;;;
;;; 功能级模块（notes、novel、pomodoro、cjk、jieba、dyncall、meow）不在此拆分，
;;; 它们仍是 modules/ 下的独立 Doom 模块，由 init.el 的 doom! 声明启用。

;; ─── 运行时基线 ──────────────────────────────────────────────────────────
;;
;; 编译与 GC 参数。Doom 默认值对大多数机器已经合适；以下仅为可调项，改动前
;; 请用 `M-x emacs-init-time' 实测，不要凭直觉开启。
;;
;; (setq native-comp-speed 2)             ; -O2 是甜点；-O3 膨胀 .eln 且差距极小
;; (setq native-comp-async-jobs-number    ; 并行编译任务数
;;       (min 4 (max 1 (/ (num-processors) 2))))
;; (setq package-native-compile t)        ; 安装包时自动编译
;; (setq native-comp-async-report-warnings-errors 'silent)
;;
;; gcmh：空闲时才做完整 GC，避免交互期间卡顿。
;; 100 MB 的高阈值对现代机器是安全上限。
;;
(after! gcmh
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold 100000000))

;; ─── 加载分片 ──────────────────────────────────────────────────────────
;;
;; `load!' 相对于本文件所在目录（$DOOMDIR）解析路径，因此无需绝对路径。
;; 顺序即文件名的字典序，新增分片请沿用两位数前缀。
;;
(load! "lisp/10-ui")
(load! "lisp/20-editing")
(load! "lisp/30-system")
(load! "lisp/40-org")
(load! "lisp/45-export")
(load! "lisp/50-org-live")
(load! "lisp/60-reading")
(load! "lisp/70-cjk")
(load! "lisp/80-tools")
(load! "lisp/90-session")
