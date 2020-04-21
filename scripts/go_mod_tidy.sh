#!/bin/bash

cp go.mod mod_old
cp go.sum sum_old

go mod tidy
STATUS=$( git status --porcelain go.mod go.sum )
if [ ! -z "$STATUS" ]; then
    echo "Running go mod tidy modified go.mod and/or go.sum"
    echo "differences in go.mod"
    diff go.mod mod_old
    echo "differences in go.sum"
    diff go.sum sum_old
    exit 1
fi
echo "No modifications by go mod tidy"
exit 0
