#!/bin/bash

source constants.sh

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
    result=$(awk -F'","' '{print $8"\n"$9"\n"$10"\n"$11"\n"$12"\n"$13"\n"$2}' <<< $result)

    # print the output to stdout 
    echo "$result"
}

# fetch all unique verbs from verbs.csv
function fetch_all_verbs {
    echo "$(awk -F',' 'NR>1 {print substr($1,2,length($1)-2)}' verbs.csv | sort -u)"
}

# checks if given verb is valid
# validity: exists in verbs.csv and does not in my_verbs.txt
function check_if_valid {
    # grab the correct line
    local result1=$(grep "\"$1\"" verbs.csv)
    local result2=$(grep "$1" my_verbs.txt)

    # check if word found
    if [[ 0 -eq $(wc -w <<< "$result1") ]]; then
        echo "false"
    elif [[ 0 -lt $(wc -w <<< "$result2") ]]; then
        echo "duplicate"
    else
        echo "true"
    fi
}

# query db to fetch saved verbs
function fetch_my_verbs {
    cat my_verbs.txt
}

# asks the user subject_cnt conjugations of a given verb in given tense in random manner
function quiz_verb {
    local verb=$1
    local tense=$2
    local subject_cnt=$3

    # find verb conjugations and store in arr
    local conjugations_arr=()
    while IFS= read -r line; do
        conjugations_arr+=("$line")
    done < <(fetch_conjugations "$verb" "$tense" "Indicativo")

    # shuffle subject indices for randomization
    subject_idx_arr=($(shuffle_indices 0 5))

    # single verb loop
    conjugated_wrong=false
    curr=0

    printf "$verb ${ITALICS}means${NO_ITALICS} \"${conjugations_arr[${#conjugations_arr[@]}-1]}\"."
    printf " ${ITALICS}conjugate in${NO_ITALICS} $tense.\n" 

    # iterate over all subjects random manner
    while [[ $curr -lt "${subject_cnt}" ]]; do
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
        # if typed "hint", show answer
        elif  [[ $input == "hint" ]]; then
            printf ""$verb" ${ITALICS}$temp_subject${NO_ITALICS} ${YELLOW}$temp_conj${RESET}\n"
            conjugated_wrong=false
            ((curr++))
        else
            conjugated_wrong=true
        fi
    done
}