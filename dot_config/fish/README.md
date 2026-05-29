# fish 配置 (Gentoo)

## 前置依赖

```bash
# Gentoo
emerge --ask app-shells/fish app-shells/fisher app-shells/bash-completion
emerge --ask sys-apps/bat app-text/eza sys-apps/fastfetch
```

```bash
# 安装 fisher 插件
fisher install jethrokuan/z
fisher install oh-my-fish/plugin-extract
fisher install oh-my-fish/plugin-sudope

# 安装 tide 主题
fisher install ilancosman/tide@v6
```

## 文件结构

```
~/.config/fish/
├── config.fish              # 入口：vi 键绑定 + Ctrl+@ 接受补全
├── fish_plugins             # fisher 插件清单
├── conf.d/
│   ├── 00-env.fish          # 环境变量 (EDITOR, LANG, MANPAGER 等)
│   ├── 10-path.fish         # PATH 管理
│   ├── 20-aliases.fish      # 别名 (eza, grep, ...)
│   ├── 30-abbr.fish         # 缩写 (ew → emerge --ask ... @world)
│   ├── 40-key-bindings.fish # 历史展开 (!!, !$)
│   ├── 50-editor.fish       # Emacs 客户端 (e, eg)
│   └── 70-cursor.fish       # 光标样式 (细线)
├── functions/
│   ├── rm.fish              # 安全删除 (-Iv)
│   ├── cp.fish              # 安全复制 (-i)
│   ├── mv.fish              # 安全移动 (-i)
│   ├── mkdir.fish           # 自动建父目录 (-pv)
│   ├── yazi.fish            # yazi 文件管理器 (y)
│   ├── emacsclient_editor.fish  # Emacs 客户端函数
│   ├── load_profile.fish    # 按需加载 /etc/profile
│   ├── fish_greeting.fish   # 启动问候 (fastfetch)
│   └── fish_command_not_found.fish  # 命令未找到提示
└── .gitignore
```

## 快速上手指南

有新机器时：

```bash
# 1. 克隆配置
git clone <your-repo> ~/.config/fish

# 2. 确保前置依赖已安装（见上方）

# 3. 安装 fisher 插件
fisher update

# 4. 配置 tide 主题
tide configure
```

## 日常使用

| 操作 | 按键 |
|------|------|
| 输入 `!` 再输入 `!` | 展开上一条命令 |
| 输入 `!` 再输入 `$` | 展开上一条命令的最后一个参数 |
| `Ctrl+@` (Ctrl+Space) | 接受自动补全建议 |
| `ew` (展开为 emerge ...) | Gentoo 全局升级 |
| `y` | 打开 yazi 文件管理器 |
| `e` | 打开 Emacs client（无参数显示 recentf） |
| `eg` | 打开 Emacs GUI frame |
| `load_profile` | 手动加载 /etc/profile（仅一次） |
