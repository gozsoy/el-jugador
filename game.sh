#!/bin/bash

# import helpers
source constants.sh
source dev.sh

printf "${BOLD}${BLUE}Welcome to Conjugation Game!${RESET}\n\n"
printf "$SPANISH_FLAG\n"

# print game rules
printf "${ITALICS}Each game consists of ${BOLD}${QUIZ_LEN}${NO_BOLD} conjugations. Type ${BOLD}hint${NO_BOLD} anytime to see the answer.${NO_ITALICS}\n"

# print number of saved verbs at the start
printf "${ITALICS}You have already saved ${BOLD}$(wc -l < my_verbs.txt | xargs)${NO_BOLD} verbs.${NO_ITALICS}\n\n"

# serve actions menu
mode_options=("new game!" "add new verb")
printf "${BLUE}Select action:${RESET}\n"
select selected_mode in "${mode_options[@]}"; do
    break
done

# loop until user stops adding new verbs
while [[ $selected_mode == "add new verb" ]]; do
    # wait user input
    printf "Enter verb:\n"
    read input

    # check if exists in verbs.csv
    is_valid=$(check_if_valid $input)

    if [[ $is_valid == "true" ]]; then
        # save to my_verbs.txt
        echo $input >> my_verbs.txt
        printf "${GREEN}${input} saved successfully.${RESET}\n"
    elif [[ $is_valid == "duplicate" ]]; then
        printf "${RED}${input} already exists in your verbs.${RESET}\n"
    else
        printf "${RED}${input} is not valid. Try again.${RESET}\n"
    fi

    # serve actions menu again
    printf "${BLUE}Select new action:${RESET}\n"
    select selected_mode in "${mode_options[@]}"; do
        break
    done
done


# user starts the new game
universe_options=("all verbs" "only my verbs")
printf "${BLUE}Select universe:${RESET}\n"
select selected_universe in "${universe_options[@]}"; do
    break
done

# convert subject mode to number of subjects (either 6 or 1)
if [[ $selected_universe == "all verbs" ]]; then
    verb_universe=($(fetch_all_verbs))
else
    verb_universe=($(fetch_my_verbs))
fi

tense_options=("${TENSES[@]}" "All")
printf "${BLUE}Select tense:${RESET}\n"
select selected_tense in "${tense_options[@]}"; do
    break
done

subject_options=("Given verb, ask all 6 subjects" "Given verb, ask 1 random subject")
printf "${BLUE}Select subject mode:${RESET}\n"
select selected_subject in "${subject_options[@]}"; do
    break
done

# convert subject mode to number of subjects (either 6 or 1)
if [[ $selected_subject == "Given verb, ask all 6 subjects" ]]; then
    subject_cnt=6
else
    subject_cnt=1
fi

# returns a tense from selected tenses
function get_tense {
    if [[ $1 == "All" ]]; then
        echo "${TENSES[$(random_int 0 $((${#TENSES[@]} - 1)))]}"
    else
        echo $1
    fi
}

# returns a verb from selected universe
function get_verb {
    echo "${verb_universe[$(random_int 0 $((${#verb_universe[@]} - 1)))]}"
}

# runs 1 quiz game session of QUIZ_LEN long
function run_game {
    while true; do
        cnt=0

        # main iteration loop
        while [[ $cnt -lt $QUIZ_LEN ]]; do
            quiz_verb "$(get_verb)" "$(get_tense $selected_tense)" $subject_cnt
            printf "\n"
            cnt=$(( cnt + subject_cnt ))
        done

        echo "Game ended. Press ENTER for new game or ESC to exit."
        read -rsn1 input

        if [[ $input == $'\e' ]]; then
            break
        fi
    done
}

run_game