#!/bin/bash

source constants.sh
source dev.sh

printf "${BLUE}Welcome to Conjugation Game!${RESET}\n\n"
printf "$SPANISH_FLAG\n"

SUBJECTS=("yo" "tu" "el/ella/usted" "nosotros" "vosotros" "ellos/ellas/Ustedes")

# TODO: temporary arrays
VERBS=("tocar" "jugar" "ser" "nadar")
TENSES=("Presente" "Preterito perfecto" "Preterito")


#for verb in "${VERBS[@]}"; do
#    quiz_verb "${verb}" "${TENSES[0]}"
#    printf "\n\n"
#done

universe_options=("all verbs" "only my verbs")
printf "${BLUE}Select universe:${RESET}\n"
select selected_universe in "${universe_options[@]}"; do
    break
done

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

echo $selected_universe $selected_tense $selected_subject

