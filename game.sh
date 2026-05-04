#!/bin/bash

# load env vars
set -a
source .env
set +a

# import helpers
source constants.sh
source dev.sh

printf "${BLUE}Welcome to Conjugation Game!${RESET}\n\n"
printf "$SPANISH_FLAG\n"

SUBJECTS=("yo" "tu" "el/ella/usted" "nosotros" "vosotros" "ellos/ellas/Ustedes")
TENSES=("Presente" "Preterito perfecto" "Preterito")

# TODO: temporary
VERBS=("tocar" "jugar" "ser" "nadar")
temp_user=gozsoy

universe_options=("all verbs" "only my verbs")
printf "${BLUE}Select universe:${RESET}\n"
select selected_universe in "${universe_options[@]}"; do
    break
done

# convert subject mode to number of subjects (either 6 or 1)
if [[ $selected_universe == "all verbs" ]]; then
    verb_universe=($(fetch_all_verbs))
else
    verb_universe=($(fetch_my_verbs "$temp_user"))
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


# main iteration loop
for verb in "${VERBS[@]}"; do
    quiz_verb "${verb}" "$(get_tense $selected_tense)" $subject_cnt
    printf "\n"
done