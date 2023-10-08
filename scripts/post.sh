#!/usr/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file.txt"
    exit 1
fi

input_file="$1"


# Read the input file and assign values to variables
title=$(sed -n '1p' "$input_file")
date=$(sed -n '2p' "$input_file")
paragraphs=$(sed -e '1,2d' "$input_file")

#touch ./posts/html/$title.html
output_file=$(echo "$title" | tr -d ' ')


# Create HTML content
html_content="<h2>$title</h2>
              <p>Date: $date</p>"

# Loop through paragraphs and add to HTML content (empty paragraphs are added as <br>)
while IFS= read -r paragraph; do
    if [[ -z "${paragraph}" || "${paragraph}" =~ ^[[:space:]]*$ ]]; then
        html_content+="<br>"
    else
        html_content+="<p>${paragraph}</p>"
    fi
done <<< "$paragraphs"


# Generate the HTML file
cat <<EOL > "./posts/archive/$output_file.html"
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Emily Dickinson Simulator</title>
	<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<header>
		<h1><a href="index.html">emily dickinson simulator</a></h1>
	</header>

	<nav>
		<ul>
			<li><a href="about.html">about</a></li>
			<li><a href="archive.html">archive</a></li>
		</ul>
	</nav>

    $html_content

</body>
</html>
EOL



###UPDATE ARCHIVE

# Generate the HTML link
link="<li><a href="./posts/html/$output_file.html">$date - $title</a></li>"

# Define the file
file="archive.html"

# Find the position of the second <ul> element
ul_position=$(awk '/<ul>/{c++} c==2{print NR; exit}' "$file")

# Insert the link after the second <ul> element
awk -v line=$ul_position -v value="$link" 'NR==line+1 {$0=value ORS $0} 1' "$file" > tmpfile && mv tmpfile "$file"


### UPDATE INDEX
rm index.html
cp "./posts/archive/$output_file.html" index.html
