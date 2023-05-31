#!/bin/bash

function print_menu() {
	local function_arguments=("$@")
	local selected_item="$1"
	local menu_items=("${function_arguments[@]:1}")
	local menu_size="${#menu_items[@]}"

	for (( i = 0; i < menu_size; ++i ))
	do
		if [ "$i" = "$selected_item" ]
		then
			echo "-> ${menu_items[i]}"
		else
			echo "   ${menu_items[i]}"
		fi
	done
}

function run_menu() {
	local function_arguments=("$@")
	local selected_item="$1"
	local menu_items=("${function_arguments[@]:1}")
	local menu_size="${#menu_items[@]}"
	local menu_limit=$((menu_size - 1))

	clear
	print_menu "$selected_item" "${menu_items[@]}"
	
	while read -rsn1 input
	do
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
								clear
								print_menu "$selected_item" "${menu_items[@]}"
							fi
							;;
						B | 'B')  # Down Arrow or B key
							if [ "$selected_item" -lt "$menu_limit" ]
							then
								selected_item=$((selected_item + 1))
								clear
								print_menu "$selected_item" "${menu_items[@]}"
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
					clear
					print_menu "$selected_item" "${menu_items[@]}"
				fi
				;;
			"w" | "W")
				if [ "$selected_item" -ge 1 ]
				then
					selected_item=$((selected_item - 1))
					clear
					print_menu "$selected_item" "${menu_items[@]}"
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
				clear
				print_menu "$selected_item" "${menu_items[@]}"
				;;
		esac
	done
}


# Usage example:

selected_item=0
menu_items=('Login' 'Register' 'Guest' 'Exit')

run_menu "$selected_item" "${menu_items[@]}"
