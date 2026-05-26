#!/bin/bash

# grammar
SUBJECTS=("yo" "tu" "el/ella/usted" "nosotros" "vosotros" "ellos/ellas/Ustedes")
TENSES=("Presente" "Preterito perfecto" "Preterito")

# game config
QUIZ_LEN=2

# text colors
RED="\e[31m" 
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"

# background colors
BG_RED="\e[41m"
BG_YELLOW="\e[43m"

# styling
ITALICS="\e[3m"
NO_ITALICS="\e[23m"

# misc formatting
MOVE_CURSOR_UP="\033[1A"
DELETE_LINE="\033[2K"
RESET="\e[0m"
SPANISH_FLAG="\t${BG_RED}          ${RESET}\n\t${BG_YELLOW}          ${RESET}\n\t${BG_YELLOW}          ${RESET}\n\t${BG_RED}          ${RESET}\n"

# verbs.csv column numbers
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