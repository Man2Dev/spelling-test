#!/bin/bash

# Set default values
flag1=false
flag2=false

# Parse command line flags
while getopts "ab" opt; do
	case $opt in
	a)
		flag1=true
		;;
	b)
		flag2=true
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	esac
done

# Set IFS to ', ' to separate words by comma and space
IFS=','
# make folder if there is non
mkdir -p ~/Documents/spelling
# Set paths to the word and correct files in the home directory
word_file=~/Documents/spelling/word.txt
correct_file=~/Documents/spelling/correct.txt
wrong_file=~/Documents/spelling/wrong.txt
reread_file=~/Documents/spelling/reread.txt

# total words
tw=0
# correct counter
cc=0
# wrong counter
wc=0

# Initialize arrays
wordsarr=()
correctarr=()
wrongarr=()

# Read from word file and add unique words to wordsarr
while read -r line; do
	for word in $line; do
		if [[ ! " ${wordsarr[@]} " =~ " ${word} " ]]; then
			# echo -e "${word}"
			wordsarr+=("$word")
			# live stats
			tw=$((tw + 1))
		fi
	done
done <"$word_file"

# Read from correct file and add unique sentences to correctarr
while read -r line; do
	for word in $line; do
		if [[ ! " ${correctarr[@]} " =~ " ${word} " ]]; then
			# echo -e "${word}"
			correctarr+=("$word")
			# reseting previous stats
			cc=$((cc + 1))
		fi
	done
done <"$correct_file"

# Read from wrong file and add unique sentences to wrongarr
while read -r line; do
	for word in $line; do
		if [[ ! " ${wrongarr[@]} " =~ " ${word} " ]]; then
			# echo -e "${word}"
			wrongarr+=("$word")
			# reseting previous stats
			wc=$((wc + 1))
		fi
	done
done <"$wrong_file"

# Remove words in wordsarr that are present in correctarr
for correct_sentence in "${correctarr[@]}"; do
	for i in "${!wordsarr[@]}"; do
		if [[ "${wordsarr[$i]}" = "${correct_sentence}" ]]; then
			unset wordsarr[$i]
			declare -a wordsarr=("${wordsarr[@]}")
			break
		fi
	done
done

# shuffle array
for ((i = ${#wordsarr[@]} - 1; i > 0; i--)); do
	j=$((RANDOM % i))
	temp=${wordsarr[i]}
	wordsarr[i]=${wordsarr[j]}
	wordsarr[j]=$temp
done

function outouts {
	# echo -e "\n"
	clear
	echo -e $((${#wordsarr[@]} - $cc))
	echo -e "\033[32m$cc\033[0m - \033[31m$wc\033[0m"

	if $flag1; then
		espeak-ng "$word"
	else
		gtts-cli "$word" -l en -o .w.mp3
		mpv --no-config profile=big-cache --quiet .w.mp3 1>/dev/null
	fi

	# Prompt user to spell the word
	read -ra spelling

	# inline functions
	# read again if ? is given
	if [[ "$spelling" == "?" ]]; then
		outouts
	fi

	if [[ "$spelling" == "r" ]]; then
		echo "$word, " >>"$reread_file"
		outouts
	fi
}

# Loop over queue array and use espeak-ng to read each word
for word in "${wordsarr[@]}"; do
	# 	gtts-cli "$word" -l en -o .w.mp3
	outouts
	# Check if the spelling is correct
	if [[ "$spelling" == "$word" ]]; then
		echo -e "\033[32mCorrect!\033[0m"
		echo "$word," >>"$correct_file"
		cc=$((cc + 1))

		# remove corect word from current array
		for i in "${!wordsarr[@]}"; do
			if [[ "${wordsarr[$i]}" = "${word}" ]]; then
				unset wordsarr[$i]
				declare -a wordsarr=("${wordsarr[@]}")
				break
			fi
		done
	else
		echo -e "\033[31mIncorrect it's:\033[0m $word"
		echo "$word," >>"$wrong_file"
		wc=$((wc + 1))
		read -n 1 -s -r -p "continue?"
	fi
done
