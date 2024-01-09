@echo off
set filename=%1
set pdffilename=%~n1.pdf
rem 调用Pandoc程序并传递文件名参数
pandoc  -f markdown+tex_math_single_backslash --toc --number-sections --pdf-engine=xelatex --template=pm-template.tex %filename% -o %pdffilename% 
