#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import pandas as pd
import matplotlib.pyplot as plt
import re
import os
import networkx as nx
from graphviz import Digraph # 需要安装 graphviz Python 库和系统程序

# --- Matplotlib 设置 (保持不变) ---
def set_chinese_font():
    """尝试设置一个可用的中文字体。"""
    supported_fonts = ['SimHei', 'Microsoft YaHei', 'WenQuanYi Zen Hei', 'KaiTi']
    for font in supported_fonts:
        try:
            plt.rcParams['font.sans-serif'] = [font]
            plt.rcParams['axes.unicode_minus'] = False
            print(f"成功设置字体: {font}")
            return
        except Exception:
            continue
    print("警告: 未找到支持的常用中文字体，统计图表中的中文可能显示为方块。")

# --- 数据处理函数 (保持不变) ---
def count_characters(character_string):
    if pd.isna(character_string) or not isinstance(character_string, str):
        return 0
    characters = re.split(r'[，,]\s*', character_string)
    non_empty_characters = [char for char in characters if char]
    return len(non_empty_characters)

# --- 新增：创建场景流程图的函数 ---
def create_scene_graph(df, output_dir):
    """
    使用 Graphviz 创建并渲染场景流程图。
    """
    print("正在创建场景流程图...")
    dot = Digraph('NovelSceneFlow', comment='Novel Scene Flow Graph')
    dot.attr(rankdir='TB', splines='ortho', nodesep='0.5', ranksep='1.0') # TB=Top to Bottom
    dot.attr('node', shape='box', style='rounded,filled', fontname='SimHei') # 确保节点字体也设置正确
    dot.attr('edge', fontname='SimHei')

    # 定义节点颜色
    status_colors = {
        'idea': '#E0E0E0',    # 灰色
        'draft': '#BBDEFB',   # 浅蓝
        'revise': '#FFF59D',  # 黄色
        'done': '#C8E6C9',    # 浅绿
    }

    # 1. 添加所有场景作为节点
    for _, scene in df.iterrows():
        scene_id = scene.get(':id', '')
        if not scene_id: continue # 跳过没有ID的行

        title = scene.get(':title', '无标题')
        status = scene.get(':status', 'idea')
        color = status_colors.get(status, '#FFFFFF') # 默认为白色

        # 节点标签可以包含多行信息
        label = f"{title}\n<{scene_id}>"

        dot.node(scene_id, label=label, fillcolor=color)

    # 2. 添加从 :Next: 属性定义的边
    for _, scene in df.iterrows():
        current_id = scene.get(':id', '')
        next_ids_str = scene.get(':next', '')
        if not current_id or pd.isna(next_ids_str):
            continue

        # 支持用逗号（中英文）分隔的多个 next 场景
        next_ids = re.split(r'[，,]\s*', str(next_ids_str))

        for next_id in next_ids:
            if next_id and next_id in df[':id'].values:
                dot.edge(current_id, next_id)

    # 3. 渲染并保存 SVG 文件
    output_filename_base = os.path.join(output_dir, 'scene_flow_graph')
    try:
        dot.render(output_filename_base, format='svg', cleanup=True)
        print(f"场景流程图已保存到: {output_filename_base}.svg")
    except Exception as e:
        print(f"错误: 无法渲染 Graphviz 图表。请确保 Graphviz 已正确安装并已添加到系统 PATH。")
        print(f"原始错误: {e}")


# --- 主分析函数 (保持不变) ---
def analyze_and_plot_stats(df, output_dir):
    """
    读取 DataFrame, 分析数据, 并生成统计图表。
    """
    # ... (这部分代码和之前完全一样) ...
    required_cols = ['title', 'tensionscore', 'words', 'character_count']
    for col in required_cols:
        if col not in df.columns:
            print(f"错误: CSV文件中缺少关键列 '{col}'。请检查 Emacs Lisp 导出脚本。")
            return # 提前退出，避免崩溃

    scene_labels = [str(title)[:10] + '...' if len(str(title)) > 10 else str(title) for title in df['title']]
    fig, axs = plt.subplots(3, 1, figsize=(12, 18), tight_layout=True)
    fig.suptitle('小说场景数据分析报告', fontsize=20)
    axs[0].plot(scene_labels, df['TensionScore'], marker='o', linestyle='-', color='r')
    axs[0].set_title('场景张力曲线 (Tension Score)')
    axs[0].set_ylabel('张力值 (1-10)')
    axs[0].grid(True, linestyle='--', alpha=0.6)
    axs[0].tick_params(axis='x', rotation=45)
    axs[1].bar(scene_labels, df['words'], color='b', alpha=0.7)
    axs[1].set_title('各场景预估字数')
    axs[1].set_ylabel('字数')
    axs[1].grid(True, axis='y', linestyle='--', alpha=0.6)
    axs[1].tick_params(axis='x', rotation=45)
    axs[2].bar(scene_labels, df['character_count'], color='g', alpha=0.7)
    axs[2].set_title('各场景出场角色数')
    axs[2].set_ylabel('角色数量')
    axs[2].grid(True, axis='y', linestyle='--', alpha=0.6)
    axs[2].tick_params(axis='x', rotation=45)
    output_filename = os.path.join(output_dir, 'novel_analysis_report.png')
    plt.savefig(output_filename)
    print(f"统计报告已保存到: {output_filename}")
    plt.show()

# --- 主执行入口 (修改后) ---
def main(csv_path):
    if not os.path.exists(csv_path):
        print(f"错误: 文件未找到 {csv_path}")
        return

    # 1. 读取和预处理数据
    df = pd.read_csv(csv_path)

    # --- 这是关键的修复和增强 ---
    # 将所有列名强制转换为小写，一劳永逸地解决大小写问题
    df.columns = df.columns.str.lower()

    # 现在可以安全地访问 'tensionscore'
    df['tensionscore'] = pd.to_numeric(df[':tensionscore'], errors='coerce').fillna(0)
    df['words'] = pd.to_numeric(df[':words'], errors='coerce').fillna(0)
    df['character_count'] = df[':characters'].apply(count_characters)

    output_dir = os.path.dirname(csv_path)

    # 2. 生成两种可视化
    create_scene_graph(df, output_dir)
    analyze_and_plot_stats(df, output_dir)


if __name__ == "__main__":
    set_chinese_font()
    if len(sys.argv) < 2:
        print("用法: python visualize_novel.py <path_to_csv_file>")
    else:
        csv_file_path = sys.argv[1]
        main(csv_file_path)
