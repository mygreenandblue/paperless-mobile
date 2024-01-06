#!/usr/bin/env bash
set -Eeuo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__target_dir=$__script_dir/../assets/changelogs
readonly __script_dir
# Receives locale as first argument
function mergeChangelogs () {
    __target_file=$__target_dir/changelogs_$1.md
    rm -f $__target_file
    touch $__target_file
    ls -1v $__script_dir/../android/fastlane/metadata/android/$1/changelogs/[0-9]*.txt | tac | while read f; do
        __build_number="${f%.*}"
        echo "# $(basename -- $__build_number)" >> $__target_file
        cat $f >> $__target_file
        printf "\n\n" >> $__target_file
    done
}

mergeChangelogs 'en-US'
mergeChangelogs 'de-DE'

