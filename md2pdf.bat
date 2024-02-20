@echo off
set filename=%1
set pdffilename=%~n1.pdf
SET "SCRIPT_DIR=%~dp0"


@REM 主题列表
@REM --highlight-style=tango, pygments, kate, monochrome, espresso, zenburn, haddock.

pandoc  -f markdown+tex_math_single_backslash  -V colorlinks --toc --number-sections --template=%SCRIPT_DIR%pandoc_template.tex %filename%   --pdf-engine=xelatex  --highlight-style=tango  -o %pdffilename% 

@REM 备份参数
@REM pandoc  -f markdown+tex_math_single_backslash  -V colorlinks --toc --number-sections --template=pandoc_template.tex %filename%   --pdf-engine=xelatex   --highlight-style=espresso  -o %pdffilename% 
