#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file.txt output_file.html"
    exit 1
fi

input_file="$1"
output_file="$2"

# Read the input file and assign values to variables
title=$(sed -n '1p' "$input_file")
date=$(sed -n '2p' "$input_file")
paragraphs=$(sed -e '1,2d' "$input_file")

# Create HTML content
html_content="<h2>$title</h2>
              <p>Date: $date</p>"

# Loop through paragraphs and add to HTML content
while IFS= read -r paragraph; do
    html_content+="\n<p>$paragraph</p>"
done <<< "$paragraphs"

# Generate the HTML file
cat <<EOL > "$output_file"
<!DOCTYPE html>
<html>
<head>
    <title>$title</title>
</head>
<body>
    $html_content
</body>
</html>
EOL

echo "HTML file generated successfully!"
