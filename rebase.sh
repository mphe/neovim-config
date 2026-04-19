#!/usr/bin/env bash
git stash && git fetch origin && git rebase origin/master && git stash apply

