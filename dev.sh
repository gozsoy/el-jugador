#!/bin/bash

infinitive=1
infinitive_english=2
mood=3
mood_english=4
tense=5
tense_english=6
verb_english=7
form_1s=8
form_2s=9
form_3s=10
form_1p=11
form_2p=12
form_3p=13
gerund=14
gerund_english=15
pastparticiple=16
pastparticiple_english=17

# randint[low, high]
function random_int {
    echo $(( $1 + RANDOM % ($2 - $1 + 1) ))
}

# shuffled indices [low, high] on stdout
function shuffle_indices {
    echo $(seq $1 $2 | sort -R)
}

# shuffle elements of given array
function shuffle_array {
    local given_arr=("$@")
    local shuffled_arr=()

    local arr_size=$((${#given_arr[@]}-1))

    while IFS= read -r line; do
        shuffled_arr+=(${given_arr[$line]})
    done < <(seq 0 $arr_size | sort -R)

    # shuffled arr to stdout
    echo "${shuffled_arr[@]}"
}

# infinitive, infinitive_english, tense, form_1p ... form 3p
# gerund and pastparticiple have special rules
function fetch_conjugations {
    local verb="\"$1\""
    local tense="\"$2\""
    local mood="\"$3\""

    # grab the correct line
    local result=$(grep "$verb" verbs.csv | grep "$tense" | grep "$mood")

    # check if word found
    if [[ 0 -eq $(wc -w <<< "$result") ]]; then
        echo "unknown verb"
        return
    fi

    # only retain 6 conjugations and translation
    result=$(awk -F'","' '{print $8, $9, $10, $11, $12, $13, $2}' <<< $result)

    # print the output to stdout 
    echo $result
}



# asks the user all 6 conjugations of a given verb in random manner
function quiz_verb {
    verb=$1
    tense=$2

    # find verb conjugations and store in arr
    conjugations_arr=($(fetch_conjugations "$verb" "$tense" "Indicativo"))

    # shuffle subject indices for randomization
    subject_idx_arr=($(shuffle_indices 0 5))

    # single verb loop
    conjugated_wrong=false
    curr=0

    printf "$verb ${ITALICS}means${NO_ITALICS} \"${conjugations_arr[${#conjugations_arr[@]}-1]}\"."
    printf " ${ITALICS}conjugate in${NO_ITALICS} $tense.\n" 

    # iterate over all subjects random manner
    while [[ $curr -lt "${#SUBJECTS[@]}" ]]; do
        # fetch curr subject id
        subject_idx=${subject_idx_arr[$curr]}

        # get subject
        temp_subject=${SUBJECTS[$subject_idx]}

        # get verb's conjugation for temp_subject
        temp_conj=${conjugations_arr[$subject_idx]}
        
        # if tried and wrong
        if [[ $conjugated_wrong == "true" ]]; then
            printf "${RED}"$verb" ${ITALICS}$temp_subject${NO_ITALICS} ${RESET}"
        # initial try
        else
            printf ""$verb" ${ITALICS}$temp_subject${NO_ITALICS} "
        fi
        # get stdin from keyboard
        read input

        # remove 1 line up
        printf "${MOVE_CURSOR_UP}${DELETE_LINE}"

        # if tried and correct
        if [[ $input == $temp_conj ]]; then    
            printf "${GREEN}"$verb" ${ITALICS}$temp_subject${NO_ITALICS} $input${RESET}\n"
            conjugated_wrong=false
            ((curr++))
        else
            conjugated_wrong=true
        fi
    done
}