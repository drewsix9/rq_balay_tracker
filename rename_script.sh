#!/bin/bash
# Script to rename files with prefix flutter_ and suffix .png to mobile_

# Change to your target directory if needed
# cd /path/to/your/directory

for file in flutter_*.png; do
  # Check if the file exists to avoid errors if no match
  if [[ -f "$file" ]]; then
    newname="tablet_10_inch_${file#flutter_}"
    mv "$file" "$newname"
    echo "Renamed $file to $newname"
  fi
done