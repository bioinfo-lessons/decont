#!/bin/bash

# Check if the inputs are 0 or 4 the program should delete all
# The inputs could be "data" "resources" "output" "logs"

if [ "$#" == 0 ] || [ "$#" == 4 ]; then

	# Delete all
	for file in data/*; do
        	if [ "$file" != "data/urls.txt" ]; then
                	rm -rf "$file"
        	fi
        done
        for file in res/*; do
                if [ "$file" != "res/contaminants_url.txt" ]; then
                        rm -rf "$file"
                fi
        done
	rm -rf out/*
	rm -rf log/*

else

	# Check what input is to delete that directory

	all_inputs="$@"
	for input in $all_inputs; do

		case "$input" in
			
			"data")
				for file in data/*; do
					if [ "$file" != "data/urls.txt" ]; then
						rm -rf "$file"
					fi
				done
				;;
			"resources")
				for file in res/*; do
                                        if [ "$file" != "data/contaminants_url.txt" ]; then
                                                rm -rf "$file"
                                        fi
                                done

				;;
			"output")
				rm -rf out/*
				;;
			"logs")
				rm -rf log/*
				;;
		esac
	done
fi

