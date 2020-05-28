#!/bin/sh

# path:       /home/klassiker/.local/share/repos/vimwiki-pandoc/wiki2html.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/vimwiki-pandoc
# date:       2020-05-29T00:34:37+0200

# argument parsing
# do not overwrite (0) or overwrite (1)
# overwrite="$1"
# syntax chosen for the wiki
syntax="$2"
# file extension for the wiki
extension="$3"
# full path of the output directory
output_dir="$4"
# full path of the wiki page
input="$5"
# full path of the css file for this wiki
css_file=$(basename "$6")
# full path to the wiki's template
template_path="$7"
# the default template name
template_default="$8"
# the extension of template files
template_ext="$9"
# count of '../' for pages buried in subdirs
root_path="${10}"

# if file is in vimwiki base dir, the root path is '-'
[ "$root_path" = "-" ] && root_path=''

# example: index.md
file_name=$(basename "$input" ."$extension")
# example: /home/klassiker/Dokumente/Notes/index.md
output=$output_dir$file_name

# pandoc arguments
# if you have Mathjax locally use this:
mathjax="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
# mathjax="/usr/share/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"

# prepandoc processing and pandoc
pandoc_template="pandoc \
    --toc \
    --mathjax=$mathjax \
    --template=$template_path$template_default$template_ext \
    -f $syntax \
    -t html \
    -c $css_file \
    -M root_path:$root_path"

# searches for markdown links (without extension or .md) and appends a .html
regex1='s/(\[.+\])\(([^.)]+)(\.md)?\)/\1(\2.html)/g'
# removes placeholder title from vimwiki markdown file
regex2='s/^%title (.+)$/---\ntitle: \1\n---/'
# removes .html from links if # is set
regex3='/\#+[a-zA-Z0-9_.+-]*\.html/s/\.html//g'
# removes "file" from ![pic of sharks](file:../sharks.jpg)
regex4='s/file://g'

pandoc_input=$(< "$input" sed -r "$regex1;$regex2;$regex3;$regex4")
pandoc_output=$(printf "%s\n" "$pandoc_input" | $pandoc_template)

# postpandoc processing
printf "%s\n" "$pandoc_output" > "$output.html"
