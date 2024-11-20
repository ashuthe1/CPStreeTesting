#!/bin/bash

# Set your paths
SRC_DIR="../../src"
CODE_TRAVEL_DIR="../codeTravel"
REPO_DIR="../../"  # Path to the root of the Local Git repository

# Navigate to the source directory
cd "$SRC_DIR" || exit 1

# Extract the second line from solution.cpp
SECOND_LINE=$(sed -n '2p' solution.cpp)

# Debug print: Check what is being extracted as the second line
echo "Extracted second line: '$SECOND_LINE'"

# Ensure a valid second line is extracted
if [[ -z "$SECOND_LINE" ]]; then
  echo "No second line found in solution.cpp. Exiting."
  exit 1
fi

# Extract the second word from the second line
SECOND_WORD=$(echo "$SECOND_LINE" | awk '{print $2}')

# Debug print: Check what is being extracted as the second word
echo "Extracted second word: '$SECOND_WORD'"

# Ensure a valid second word is extracted
if [[ -z "$SECOND_WORD" ]]; then
  echo "Invalid second line format in solution.cpp. Exiting."
  exit 1
fi

# Split the second word into directory name and file name based on '/'
DIR_NAME=$(echo "$SECOND_WORD" | cut -d'/' -f1)
FILE_NAME=$(echo "$SECOND_WORD" | cut -d'/' -f2)

# Debug print: Check the directory name and file name extracted
echo "Extracted directory name: '$DIR_NAME'"
echo "Extracted file name: '$FILE_NAME'"

# Ensure both directory name and file name are valid
if [[ -z "$DIR_NAME" || -z "$FILE_NAME" ]]; then
  echo "Invalid @path format in solution.cpp. Exiting."
  exit 1
fi

# Check if DIR_NAME matches any folder name in CODE_TRAVEL_DIR
TARGET_DIR="$CODE_TRAVEL_DIR/$DIR_NAME"
if [[ ! -d "$TARGET_DIR" ]]; then
  TARGET_DIR="$CODE_TRAVEL_DIR/unspecified"
fi

# Debug print: Check the target directory
echo "Target directory: '$TARGET_DIR'"

# Replace spaces with underscores in the file name
FILE_NAME="${FILE_NAME// /_}.cpp"

# Debug print: Final file name
echo "Final file name: '$FILE_NAME'"

# Full path of the new file
NEW_FILE_PATH="$TARGET_DIR/$FILE_NAME"

# Debug print: Check the full path of the new file
echo "New file path: '$NEW_FILE_PATH'"

# Create the file in the appropriate directory
cp solution.cpp "$NEW_FILE_PATH"

cd ..

# Debug print: Indicate that the file was copied successfully
echo "Copied solution.cpp to '$NEW_FILE_PATH'"

# Add the new file to git
git add "."
git commit -m "Added $FILE_NAME from solution.cpp to $DIR_NAME folder"
git push origin main
