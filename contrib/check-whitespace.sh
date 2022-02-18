#!/bin/sh
# This file is a part of Julia. License is MIT: https://julialang.org/license

# Check for trailing white space in source files;
# report an error if so

# Files to check:
set -f # disable glob expansion in this script
file_patterns='
*.1
*.c
*.cpp
*.h
*.jl
*.lsp
*.scm
*.inc
*.make
*.mk
*.md
*.rst
*.sh
*.yml
*Makefile
'

if git --no-pager grep --color -n --full-name -P '[\s ]+$' -- $file_patterns; then
    echo "Error: trailing whitespace found in source file(s)"
    echo ""
    echo "This can often be fixed with:"
    echo "    git rebase --whitespace=fix HEAD~1"
    echo "or"
    echo "    git rebase --whitespace=fix master"
    echo "and then a forced push of the correct branch"
    exit 1
fi

for file in $(git --no-pager ls-files -- $file_patterns); do
    if test "$(tail -c 1 $file)" != "$(echo)"; then
        echo "Error: $file has no trailing newline"
        exit 1
    fi
    if test "$(tail -c 2 $file)" = "$(echo; echo)"; then
        echo "Error: $file has multiple trailing newlines"
        exit 1
    fi
done

echo "Whitespace check found no issues"
