#!/usr/bin/bash

action=$1
path=$2
target_file_name=~/path-test-file

ensure_file_exists () {
	local file=$1
	if [ ! -f $file ];
			then touch $file
	fi

}

add_path_unless_it_exists () {
	local path=$1
	local target_file=$2
	local str="export PATH=\$PATH:$path"
	echo $str
	if grep -q "$str" "$target_file";
		then
			echo "The path is already added"
		else
			echo "$str" >> $target_file
			echo "Added '$path' to $target_file"
	fi
}

add-path () {
	local path=$1
	local target_file_name=$2
	if [ ! -n "$path" ] || [ ! -n "$target_file_name" ];
		then
			echo "Usage: ./path add path-file-name"
			exit 1
		else
			ensure_file_exists $target_file_name
			add_path_unless_it_exists $path $target_file_name
	fi
}

list-paths () {
	local file=$1
	if [ -f $file ];
		then cat $file
		else echo "No paths added"
	fi
}

remove-path () {
	local path=$1
	local file_name=$2
	grep -v "$path" $file_name > tmpfile # inverse grep all lines into a tempfile 
	mv tmpfile $file_name # overwrite the old file
	echo "Removed path"
}

clear-paths () {
	local target_file=$1
	echo "This operation will remove all previously added paths from the file, which may cause things to stop working. Are you sure? (y/N)"
	read confirmation
	if [ "$confirmation" != "y" ]; then 
		exit 0 
	fi
	rm $target_file
	echo "Paths cleared"
}

usage () {
	
cat >&2 << helpMessage

Usage:
- add <path>		Add a path to PATH
- list			List all paths added
- remove <path>		Remove a path
- clear			Clear all paths

Examples:
- add /to/this/file/path.sh
- remove path/to/this/file/path.sh

helpMessage
	  
}

case ${action} in
	"add")
		add-path $path $target_file_name;;
	"list")
		list-paths $target_file_name;;
	"remove")
		remove-path $path $target_file_name;;
	"clear")
		clear-paths $target_file_name;;
	*)
		usage
esac

