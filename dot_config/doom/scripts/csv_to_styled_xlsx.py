#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
import pandas as pd

def get_col_widths(df):
    """计算每列的最佳宽度。"""
    # 首先获取列名的宽度
    widths = {col: len(str(col)) for col in df.columns}
    # 遍历每一行，更新最大宽度
    for index, row in df.iterrows():
        for col, value in row.items():
            widths[col] = max(widths[col], len(str(value)))
    # 为宽度增加一点余量
    return {col: width + 2 for col, width in widths.items()}

def csv_to_excel(csv_path):
    """
    读取 CSV 文件并将其转换为一个带有高级格式的 XLSX 文件。
    """
    if not os.path.exists(csv_path):
        print(f"错误: 文件未找到 {csv_path}")
        return

    output_path = os.path.splitext(csv_path)[0] + '.xlsx'
    df = pd.read_csv(csv_path)

    # 创建一个 Pandas Excel writer 对象，使用 XlsxWriter 作为引擎
    writer = pd.ExcelWriter(output_path, engine='xlsxwriter')

    # 将 dataframe 写入 Excel，不包含 pandas 的 index
    df.to_excel(writer, sheet_name='Scenes', index=False)

    # 从 writer 中获取 workbook 和 worksheet 对象
    workbook = writer.book
    worksheet = writer.sheets['Scenes']

    # --- 定义格式 (Excel "设置") ---
    header_format = workbook.add_format({
        'bold': True,
        'text_wrap': True,
        'valign': 'top',
        'fg_color': '#D7E4BC', # 浅绿色背景
        'border': 1
    })

    # 为长文本列定义自动换行格式
    wrap_format = workbook.add_format({'valign': 'top', 'text_wrap': True})

    # 为居中的短文本列定义格式
    center_format = workbook.add_format({'align': 'center', 'valign': 'vcenter'})

    # --- 应用格式 ---
    # 1. 写入并格式化表头
    for col_num, value in enumerate(df.columns.values):
        worksheet.write(0, col_num, value, header_format)

    # 2. 设置列宽和特定列的格式
    col_widths = get_col_widths(df)
    long_text_cols = ['title', 'goal', 'conflict', 'outcome', 'summary', 'notes', 'characters']
    center_cols = ['status', 'arc', 'pov']

    for i, col_name in enumerate(df.columns):
        width = col_widths.get(col_name, 10) # 默认宽度为10
        if col_name in long_text_cols:
            # 对于长文本，限制最大宽度并应用换行
            worksheet.set_column(i, i, min(width, 50), wrap_format)
        elif col_name in center_cols:
            worksheet.set_column(i, i, width, center_format)
        else:
            worksheet.set_column(i, i, width)

    # 3. 启用筛选功能
    worksheet.autofilter(0, 0, len(df), len(df.columns) - 1)

    # 4. 冻结首行 (表头)
    worksheet.freeze_panes(1, 0)

    # 保存 Excel 文件
    writer.close()
    print(f"成功将数据导出到精美的 Excel 文件: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python csv_to_styled_xlsx.py <path_to_csv_file>")
    else:
        csv_file_path = sys.argv[1]
        csv_to_excel(csv_file_path)
