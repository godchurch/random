#!/bin/bash

declare -a REPOS=(
    "NULL"
    "testing"
    "dotfiles"
    "vm-browser"
)

for REPO in "${REPOS[@]}"; do
    git clone https://github.com/godchurch/${REPO}.git
done
