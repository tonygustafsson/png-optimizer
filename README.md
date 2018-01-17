# PNG Optimizer

A PowerShell script for compressing PNG files, using pnggaunt.

## Dependencies
* https://pngquant.org/
* https://www.microsoft.com/en-us/download/details.aspx?id=48145

## Setup
1. Download repo
2. Download dependencies
3. Change settings (top of the script)
4. Create schedule task to run the script every week or so

## About
The script compresses PNG files. Before doing so it will backup the files, just to be safe.
The backups will also be used to keep track of which files that has already been compressed,
for performance.

The script will also log events such as compressions and the results (total bytes saved).
