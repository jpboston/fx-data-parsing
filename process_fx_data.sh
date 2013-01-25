#!

# Purpose: data processing on imported forex data

# set interface colors - can be improved for performance
GREEN="tput setaf 2"
RED="tput setaf 1"
CYAN="tput setaf 6"
BLUE="tput setaf 4"
MAGENTA="tput setaf 5"
YELLOW="tput setaf 3"
NORMAL="tput sgr0"

SET_NORMAL=$(tput sgr0)
SET_GREEN=$(tput setaf 2)
SET_RED=$(tput setaf 1)

# section border
SECTION='...........................................................................'

# COLUMN HEADERS -----------------------------------------
echo ""
echo $SECTION
echo "Forex data column headers:"

FX_DATA_HEADER=$(cat sample_fxdata_280912.txt | head -1 | tr -s '[<>,]' ' '  )
echo ""

$MAGENTA
#cat 280912.txt | head -1 | tr '>' ' ' | tr '<' ' ' | tr ',' '\n'  
cat 280912.txt                        \
            | head -1                 \
            | tr -d '[<>]'            \
            | tr ',' '\n'             \
            | pr -o 5 -w 5 -n1 -l 10 
$NORMAL

# CURRENCY PAIRS -----------------------------------------
echo ""
echo $SECTION
echo "Currency Pairs:"
echo ""

echo "Shell output: ( Pages )"
$YELLOW
cat 280912.txt                         \
            | tail -n +2               \
            | cut -d',' -f1            \
            | sort                     \
            | uniq                     \
            | pr -o 10 -w 5 -n2 -l 20 
$NORMAL
echo ""
echo "Shell output: ( Columns )"
echo ""
$YELLOW
cat 280912.txt                        \
            | tail -n +2              \
            | cut -d',' -f1           \
            | sort                    \
            | uniq                    \
            | rs 6                    
$NORMAL

# HISTORICAL DATA -----------------------------------------
DATA=$( cat 280912.txt | tail -20 | tr ',' ' ' )

echo ""
echo $SECTION
echo "Historical Data:"
echo ""
header="    %-8s %-12s %-10s %-10s %-10s %-10s %-10s\n"
format="%10s    %-10s %-10s %-10s %-10s %-10s %-10s\n"
width=43
printf "$header" $FX_DATA_HEADER
$CYAN
printf "$format" $DATA
$NORMAL
echo ""

# LATEST PAIR RATES -----------------------------------------
echo ""
echo $SECTION
echo "Latest Rates:"
echo ""
LATEST_PRICES=$(cat 280912.txt               \
                | tail -n +2                 \
                | tr ',' ' '                 \
                | sort -n -t' ' -k3  -r      \
                | awk '!x[$1]++'             \
                | sort                       \
                | cut -d' ' -f1,5,6 )

printf "%10s $SET_GREEN%10s $SET_RED%10s$SET_NORMAL\n" "PAIR" "HIGH" "LOW"
echo ""
printf "%10s $SET_GREEN%10s $SET_RED%10s$SET_NORMAL\n" $LATEST_PRICES

echo ""
echo ""
echo ""

