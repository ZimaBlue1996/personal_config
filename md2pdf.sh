#!/bin/bash
# A script to convert markdown to pdf using pandoc, with Chinese font support and code block auto-wrapping

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 input.md"
  exit 1
fi

# Check if the input file is a markdown file
if [[ "$1" != *.md ]]; then
  echo "The input file must be a markdown file"
  exit 2
fi

# Get the input file name without extension
filename="${1%.*}"

# Create a temporary latex template file
# cat > template.tex << EOF



# Use pandoc to convert markdown to pdf using the template file
# pandoc -s "$1" --pdf-engine=xelatex  -V CJKmainfont="WenQuanYi Micro Hei Mono" -V geometry:"margin=1in" --listings -H listings.tex -o "$filename".pdf
# pandoc -f markdown+tex_math_single_backslash --toc --number-sections --template=pm-template.latex -s "$1" --pdf-engine=xelatex  -V CJKmainfont="WenQuanYi Micro Hei Mono" -V geometry:"margin=1in" --listings -H listings.tex -o "$filename".pdf   
pandoc -f markdown+tex_math_single_backslash  -V colorlinks --toc --number-sections --template=pm-template.tex   -s "$1" --pdf-engine=xelatex  --highlight-style=tango      -o "$filename".pdf   

# rm template.tex

# Print a success message
echo "Converted $1 to $filename.pdf successfully"
