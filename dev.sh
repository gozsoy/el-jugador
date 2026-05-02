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
    result=$(awk -F'","' 'BEGIN {OFS=","} {print $8, $9, $10, $11, $12, $13, $2}' <<< $result)

    # print the output to stdout 
    echo $result
}



