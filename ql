#!/bin/bash

FLIP=false

while [[ "$#" -gt 0 ]]; do case $1 in
  -f|--file) FLASHCARDS="$2"; shift;;
  -s|--switch|--flip) FLIP=true; shift;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

if [ -z "$FLASHCARDS" ]; then
    echo "An input file is required"
    echo "EX: ./ql --file basiclinuxcommands.txt"
    exit
fi

#printf "\033c"

if [ ! -f "$FLASHCARDS" ]; then
    echo "The file $FLASHCARDS does not exist"
    exit
fi

echo "$FLASHCARDS has been selected"

if [ ! -f "$FLASHCARDS.db" ]; then
    echo "$FLASHCARDS does not have a database, creating one"
    awk -F'---' '{print "0---" $1}' "$FLASHCARDS"> "$FLASHCARDS.db"

fi

sort -o "$FLASHCARDS.db" "$FLASHCARDS.db" --general-numeric-sort

changePoints(){
    points=$(grep -e "---$2$" "$1.db" | awk -F'---' '{print $1}')
    newpoints=$(( "$points" + $3 ))
    sed -i "s/$points---$2/$newpoints---$2/g" "$FLASHCARDS.db" 
}

shuffle() { 
    awk 'BEGIN{srand();} {printf "%0El dedo6d %s\n", rand()*1000000, $0;}' | sort -n | cut -c8-
}

testCard() {

    line=$(awk "NR == $2" "$1".db)
    id="$(echo "$line" | awk -F'---' '{print $2}')"
    
    back=""
    front=""

    if $FLIP; then 
        back="$id"
        front=$(grep "$id---" "$1" | awk -F'---' '{print $2}')
    else
        front="$id"
        back=$(grep "$id---" "$1" | awk -F'---' '{print $2}')
    fi

    echo "The front is \"$front\""
    read -r -p 'Back? ' answer

    if [ "$answer" = "$back" ]; then
        echo "You were correct the back was \"$back\""
        changePoints "$FLASHCARDS" "$id" "1"

        read -r -p 'Press enter to continue
' next
    else
        echo "The back was \"$back\" you typed \"$answer\""
        changePoints "$FLASHCARDS" "$id" "-2"
	
        read -r -p 'If you were right press "r". Press enter to continue
' next
    fi

    if [ "$next" = "q" ]; then
        exit;
    fi

    if [ "$next" = "k" ]; then
        changePoints "$FLASHCARDS" "$id" "5"
    fi

    if [ "$next" = "r" ]; then
        changePoints "$FLASHCARDS" "$id" "3"
        read -r -p 'Marked as correct. Press enter to continue
'
    fi

    printf "\033c"
}

min() {
   (( $1 <= $2 )) && echo "$1" || echo "$2" 
}

length=$(wc -l "$FLASHCARDS.db" | cut -d' ' -f1)
count=$(min "$length" 5)
count=$(( "$count" + 0 ))

while :
do
    for lineNumber in $( eval echo "{1..$count}" )
    do
        testCard "$FLASHCARDS" "$lineNumber"
    done

    sort -o "$FLASHCARDS.db" "$FLASHCARDS.db" --general-numeric-sort
done