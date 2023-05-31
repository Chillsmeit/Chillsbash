#!/bin/bash

function print_menu() {
	local function_arguments=("$@")
	local selected_item="$1"
	local menu_items=("${function_arguments[@]:1}")
	local menu_size="${#menu_items[@]}"
	local frame_top="+------------------------------------------------------------------+"
	clear

	echo "$frame_top"
	echo "|                                                                  |"
	echo "|                                                                  |"
	echo "|                                                                  |"
	for (( i = 0; i < menu_size; ++i ))
	do
		if [ "$i" = "$selected_item" ]
		then
			echo "|                          -> ${menu_items[i]}$(printf '%*s' $((36 - ${#menu_items[i]}))) |"
		else
			echo "|                             ${menu_items[i]}$(printf '%*s' $((36 - ${#menu_items[i]}))) |"
		fi
	done
	echo "|                                                                  |"
	echo "|                                                                  |"
	echo "|                                                                  |"
	echo "$frame_top"
}

function run_menu() {
	local function_arguments=("$@")
	local selected_item="$1"
	local menu_items=("${function_arguments[@]:1}")
	local menu_size="${#menu_items[@]}"
	local menu_limit=$((menu_size - 1))

	clear

	while true
	do
		print_menu "$selected_item" "${menu_items[@]}"
		
		read -rsn1 input

		case "$input" in
			$'\x1B')
				read -rsn1 -t 0.1 input
				if [ "$input" = "[" ]
				then
					read -rsn1 -t 0.1 input
					case "$input" in
						A | 'A')  # Up Arrow or A key
							if [ "$selected_item" -ge 1 ]
							then
								selected_item=$((selected_item - 1))
							fi
							;;
						B | 'B')  # Down Arrow or B key
							if [ "$selected_item" -lt "$menu_limit" ]
							then
								selected_item=$((selected_item + 1))
							fi
							;;
					esac
				fi
				read -rsn5 -t 0.1
				;;
			'q' | 'Q')
				exit 0  # Exit script when 'q' or 'Q' is pressed
				;;
			"s" | "S")
				if [ "$selected_item" -lt "$menu_limit" ]
				then
					selected_item=$((selected_item + 1))
				fi
				;;
			"w" | "W")
				if [ "$selected_item" -ge 1 ]
				then
					selected_item=$((selected_item - 1))
				fi
				;;
			"")
				if [ "$selected_item" -eq "$menu_limit" ]
				then
					exit 0  # Exit script when "Exit" option is selected
				fi
				clear
				echo "Option selected: ${menu_items[selected_item]}"
				sleep 2
				;;
		esac
	done
}

# Usage example:
selected_item=0
menu_items=('Option 1' 'Option 2' 'Option 3' 'Exit')

run_menu "$selected_item" "${menu_items[@]}"
