#!/usr/bin/env bash
##
# Script name: create_directory_structure.sh
# Description: Creates a custom directory structure containing empty files and directories given as input.
# Usage: create_directory_structure.sh [...OPTIONS]
# Options:
# -n [directory_name]: Directory name.
# -f [...file_names]: Names of empty files to be created inside the directory (separated by space: file1 file2 file3).
# -d [...directory_names]: Names of empty directories to be created inside the directory (spearated by space: dir1 dir2 dir3).

# Read flags
while [[ $# -gt 0 ]]; do		# $#: number of remaining arguments 
	case "$1" in		# $opt is the current option
		-n)
			name="$2"
			shift 2		# shift everything left by 2 positions
			;;
		-f)
			shift
			files=()	# intitialize files list

			while [[ $# -gt 0 &&  "$1" != -* ]]; do	# $#: number of remaining arguments, $1: current argument (must not begin with -, because that is the next option to be parsed)
				files+=("$1")		# add current file name to list
				shift 	# shift left to move to next file or option
			done
			;;
		-d)
			shift
                        directories=()        # intitialize directories list

                        while [[ $# -gt 0 &&  "$1" != -* ]]; do # $#: number of remaining arguments, $1: current argument (must not begin with -, because that is the next option to be parsed)
                                directories+=("$1")           # add current directory name to list
                                shift   # shift left to move to next directory or option
                        done
			;;
		*)
			echo "Unknown option: $1"
			exit
			;;
	esac
done

# Create directory
if [[ -n "$name" ]]; then	# -n checks if string has non-zero length
	echo "[>] Creating empty directory [ $name ] ..."
	mkdir "$name"
	echo "Empty directory [ $name ] created."
fi

# Create files
if [[ ${#files[@]} -gt 0 ]]; then
	echo "[>] Creating files ..."

	# Change current working directory
	cd "$name"

	# Create each file
	for file in "${files[@]}"; do
		echo -e "\t Creating filee [ $file ]..."
		touch "$file"
		echo -e "\t Created file [ $file ]."
	done

if [[ ${#directories[@]} -gt 0 ]]; then
	echo "[>] Creating directories ..."
	# Create each directory
        for directory in "${directories[@]}"; do
                echo -e "\t Creating directory [ $directory ]..."
                mkdir "$directory"
                echo -e "\t Created directory [ $directory ]."
        done
fi

echo "Directory structure successfully created."
fi
