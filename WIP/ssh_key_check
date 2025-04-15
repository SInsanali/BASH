#!/bin/bash

# Output file
output_file="ssh_file_types.txt"
temp_file="temp_output.txt"

# Clear output files if they already exist
> "$output_file"
> "$temp_file"

# Loop through each user's .ssh folder
for dir in /home/*/.ssh; do
    if [ -d "$dir" ]; then
        # Recursively find all files in the .ssh directory
        find "$dir" -type f | while read -r file; do
            # Use the file command and append output to temp file
            file "$file" >> "$temp_file"
        done
    fi
done

# Sort by file type (everything after the colon)
sort -t: -k2 "$temp_file" > "$output_file"

# Clean up
rm "$temp_file"

echo "File type analysis complete. Output saved to $output_file."
