#!/usr/bin/env bash
#
# Based on an answer by CodeWizard on Stack Overflow:
# https://stackoverflow.com/a/30590238
#
# Licensed under CC BY-SA 4.0:
# https://creativecommons.org/licenses/by-sa/4.0/
#
# Script name: rename_branch_local_remote.sh
# Description: Renames a git branch both locally and on remote.
# Usage: rename_branch_local_remote [old_branch_name] [new_branch_name] [remote]

# TODO: handle errors

# Names of things - allows you to copy/paste commands
old_name="$1"
new_name="$2"
remote="$3"

echo "Renaming branch [ $old_name ] to [ $new_name ] ..."

# Rename the local branch to the new name
echo -e "\t[>] Renaming local branch ..."
git branch -m $old_name $new_name
echo -e "\t[>] Local branch renamed."

# Delete the old branch on remote
echo -e "\t[>] Deleting old branch on remote ..."
git push $remote --delete $old_name
echo -e "\t[>] Old branch on remote deleted."

# Prevent git from using the old name when pushing in the next step.
# Otherwise, git will use the old upstream name instead of $new_name.
echo -e "\t[>] Unsetting old upstream name ..."
git branch --unset-upstream $new_name
echo -e "\t[>] Old upstream name unset."

# Push the new branch to remote
echo -e "\t[>] Pushing new branch to remote ..."
git push $remote $new_name
echo -e "\t[>] New branch pushed to remote."

# Reset the upstream branch for the new_name local branch
echo -e "\t[>] Seting new upstream ..."
git push $remote -u $new_name
echo -e "\t[>] New upstream set."

echo -e "\033[32m[OK]\033[0m Branch renamed successfully!"
