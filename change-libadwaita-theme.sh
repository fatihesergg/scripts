#!/usr/bin/env bash


listthemes(){
	themes=(`ls .themes`)

	len=${#themes[@]}
	for (( i=0; i<$len; i++ )); do echo "$((i+1)):  ${themes[$i]}" ; done
	echo -n "Choose theme : "
	read -r choice
	echo "$choice"


}

linktheme(){
	
	echo "Removing folders"
	`sudo rm -rf .config/gtk-3.0/*`
	`sudo rm -rf .config/gtk-4.0/*`
	echo "Linking theme to gtk folders"
	echo `clear`
	`sudo ln -s .themes/$1 .config/gtk-3.0/`
	`sudo ln -s  .themes/$1 .config/gtk-4.0/`
	echo "Finished."
}


listthemes
linktheme "${themes[choice - 1]}"


