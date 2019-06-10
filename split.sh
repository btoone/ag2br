#!/usr/bin/env bash
##
# Splits a project file exported from Agenda.app into several files based on
# the delimeter used by Agenda (---).
#
# Usage:
#
#     $ ./split.sh
# 
# Output files are stored in the same directory this script is ran from and
# are PREFIXed with the word "archive-". Each split file is also named for the 
# original project file so you can run this against multipe project files at
# once and keep all the files organized.
#
# Prompt: Pressing 'y' or 'enter' will process the file. Anything else will
# skip it.
# 
# Dir structure info
# 
# - agenda-export        - Project root (/)
# - /exported            - Temporary staging for project files yet to be split
# - /exported/is_split   - Storage of all project files that have been split
# - /output              - Temporary staging for all split files; The output 
#                          from the split program. Files need to be manually 
#                          moved here
# - /output/[collection] - Split files that have been grouped by collection for
#                          archive purposes
#

## Customizable vars
EXPORT_DIR="exported"
TAGS=" #notes"
PREFIX='collections'

exported_files=$(find $EXPORT_DIR -type f -name '*.md' -maxdepth 1)

for ef in $exported_files; do
  slug=$(basename "$ef" '.md')

  read -r -p "Split file?: $ef (y/n)? " answer
  case ${answer:0:1} in
    y|Y|"" )
      gcsplit -k -f "$PREFIX-$slug-" -b '%03d.md' "$ef" '/---/'+1 {*} |wc -l
    ;;
    * )
      echo 'Skipping ...'
    ;;
  esac
done

## Tag the output files
output_files=$(find . -type f -name '*.md' -maxdepth 1)

read -r -p "Would you like to apply the following tag(s) to all files?:$TAGS (y/n) " answer2
case ${answer2:0:1} in
  y|Y|"" )
    echo 'Applying tag(s) ...'
    for of in $output_files; do
      echo "$TAGS" >> "$of"
    done
  ;;
  * )
    echo 'No TAGS applied'
  ;;
esac

