#!/bin/bash

source dev.sh

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"
ITALICS="\e[3m"
NO_ITALICS="\e[23m"
MOVE_CURSOR_UP="\033[1A"
DELETE_LINE="\033[2K"

printf "${BLUE}Welcome to Conjugation Game!${RESET}\n"

SUBJECTS=("yo" "tu" "el/ella/usted" "nosotros" "vosotros" "ellos/ellas/Ustedes")

verb=tocar

# find verb conjugations and store in arr
conjugations_str=$(fetch_conjugations "$verb" "Presente" "Indicativo")
IFS=',' read -ra conjugations_arr <<< "$conjugations_str"

# convert temp_subject indices list to arr
subjects_arr=()
while IFS= read -r line; do
    subjects_arr+=($line)
done < <(shuffle_indices 0 5)

# single verb loop
conjugated_wrong=false
curr=0

printf "$verb ${ITALICS}means${NO_ITALICS} \"${conjugations_arr[${#conjugations_arr[@]}-1]}\"\n"

while [[ $curr -lt "${#SUBJECTS[@]}" ]]; do
    # fetch curr subject
    subject_idx=${subjects_arr[$curr]}

    # get subject word
    temp_subject=${SUBJECTS[$subject_idx]}

    # fetch correct conjugation
    conj_gt=${conjugations_arr[$subject_idx]}

    if [[ $conjugated_wrong == "true" ]]; then
        printf "${RED}"$verb" ${ITALICS}$temp_subject${NO_ITALICS} ${RESET}"
    else
        printf ""$verb" ${ITALICS}$temp_subject${NO_ITALICS} "
    fi
    read input

    printf "${MOVE_CURSOR_UP}${DELETE_LINE}"

    if [[ $input == $conj_gt ]]; then    
        printf "${GREEN}"$verb" ${ITALICS}$temp_subject${NO_ITALICS} $input${RESET}\n"
        conjugated_wrong=false
        ((curr++))
    else
        conjugated_wrong=true
    fi

    
done



