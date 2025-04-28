#!/bin/bash

# This script automates the process of getting the REF (commit hash) and SHA512 hash for a GitHub repository
# and updates the vcpkg port file.

# Step 1: Define the repository and branch
REPO="jianglibo/rmqcpp"
BRANCH="main"  # Change this if you are using a different branch

# Step 2: Clone the repository (if not already cloned)
# if [ ! -d "rmqcpp" ]; then
#   echo "Cloning repository: $REPO..."
#   git clone "https://github.com/$REPO.git"
# fi

# cd rmqcpp
git pull "https://github.com/$REPO.git"

# Step 3: Fetch the latest changes from the repository (optional if already up to date)
echo "Fetching latest changes for $BRANCH..."
git fetch origin

# Step 4: Get the latest commit hash (REF)
REF=$(git log -1 --format=%H)

echo "Latest commit hash (REF): $REF"

# Step 5: Generate the SHA512 hash for the commit
echo "Generating SHA512 hash..."
SHA512=$(git archive --format=tar --prefix=rmqcpp/ "$REF" | sha512sum | awk '{print $1}')

echo "SHA512: $SHA512"

# Step 6: Update the vcpkg port file
VCPKG_PORT_FILE="./rmqcpp-port/portfile.cmake"
echo "current path: $(pwd)"

echo "Updating vcpkg port file: $VCPKG_PORT_FILE..."

# Use sed to update the vcpkg.json with the new REF and SHA512
sed -i "s|REF [a-f0-9]\+|REF $REF|" "$VCPKG_PORT_FILE"
sed -i "s|SHA512 [a-f0-9]\+|SHA512 $SHA512|" "$VCPKG_PORT_FILE"

echo "vcpkg port file updated with the new REF and SHA512."

# Done
echo "Process completed successfully."

