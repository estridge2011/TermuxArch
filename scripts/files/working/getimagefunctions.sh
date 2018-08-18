#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  š š š š šŗ
# Hosting https://sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# https://sdrausty.github.io/TermuxArch/README has information about this project. 
################################################################################

fstnd=""
ftchit() {
	printdownloadingftchit 
	if [[ "$dm" = aria2c ]];then
		aria2c http://"$mirror$path$file".md5 
		aria2c -c http://"$mirror$path$file"
	elif [[ "$dm" = axel ]];then
		axel http://"$mirror$path$file".md5 
		axel http://"$mirror$path$file"
	elif [[ "$dm" = wget ]];then 
		wget "$dmverbose" -N --show-progress http://"$mirror$path$file".md5 
		wget "$dmverbose" -c --show-progress http://"$mirror$path$file" 
	else
		curl "$dmverbose" -C - --fail --retry 4 -OL http://"$mirror$path$file".md5 -O http://"$mirror$path$file" 
	fi
}

ftchstnd() {
	fstnd=1
	printcontacting 
	if [[ "$dm" = aria2c ]];then
		aria2c "$cmirror" | tee /dev/fd/1 > "${tdir}gmirror"
		nmirror="$(grep Redir "${tdir}gmirror" | awk {'print $8'})" 
		printdone 
		printdownloadingftch 
		aria2c http://"$mirror$path$file".md5 
		aria2c -c -m 4 http://"$mirror$path$file"
# 	elif [[ "$dm" = axel ]];then
# 		printf "\\n\\nā%s\\n\\n""Axel is being implemented: curl (command line tool and library for transferring data with URLs) alternative https://github.com/curl/curl chosen: DONE"
# 		axel http://"$mirror$path$file".md5 
# 		axel http://"$mirror$path$file"
	elif [[ "$dm" = wget ]];then 
		wget -v -O/dev/null "$cmirror" 2>"${tdir}gmirror"
		nmirror="$(grep Location "${tdir}gmirror" | awk {'print $2'})" 
		printdone 
		printdownloadingftch 
		wget "$dmverbose" -N --show-progress "$nmirror$path$file".md5 
		wget "$dmverbose" -c --show-progress "$nmirror$path$file" 
	else
		curl -v "$cmirror" 2>"${tdir}gmirror"
		nmirror="$(grep Location "${tdir}gmirror" | awk {'print $3'})" 
		printdone 
		printdownloadingftch 
		curl "$dmverbose" -C - --fail --retry 4 -OL "$nmirror$path$file".md5 -O "$nmirror$path$file"
	fi
}

getimage() {
	printdownloadingx86 
	if [[ "$dm" = aria2c ]];then
		aria2c http://"$mirror$path$file".md5 
		if [[ "$cpuabi" = "$cpuabix86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		aria2c -c http://"$mirror$path$file"
	elif [[ "$dm" = axel ]];then
		axel http://"$mirror$path$file".md5 
		if [[ "$cpuabi" = "$cpuabix86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		axel http://"$mirror$path$file"
	elif [[ "$dm" = wget ]];then 
		wget "$dmverbose" -N --show-progress http://"$mirror${path}"md5sums.txt
		if [[ "$cpuabi" = "$cpuabix86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		printdownloadingx86two 
		wget "$dmverbose" -c --show-progress http://"$mirror$path$file" 
	else
		curl "$dmverbose" --fail --retry 4 -OL http://"$mirror${path}"md5sums.txt
		if [[ "$cpuabi" = "$cpuabix86" ]];then
			file="$(grep i686 md5sums.txt | awk {'print $2'})"
		else
			file="$(grep boot md5sums.txt | awk {'print $2'})"
		fi
		sed '2q;d' md5sums.txt > "$file".md5
		rm md5sums.txt
		printdownloadingx86two 
		curl "$dmverbose" -C - --fail --retry 4 -OL http://"$mirror$path$file" 
	fi
}

# EOF
