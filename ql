#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit
fi

printf "\033c"

if [ ! -f "$1" ]; then
    echo "$1 does not exist"
    exit
fi

echo "$1 has been selected"

if [ ! -f "$1.db" ]; then
    echo "$1 does not have a database, creating one"
    cat "$1" | awk -F'---' '{print "0---" $1}' > "$1.db"

fi

sort -o "$1.db" "$1.db" --general-numeric-sort

addPoints(){
    points=`cat "$1.db" | grep -e "---$front$" | awk -F'---' '{print $1}'`
    newpoints=`expr $points + 1`
    sed -i "s/$points---$front/$newpoints---$front/g" "$1.db" 
}

removePoints(){
    points=`cat "$1.db" | grep -e "---$front$" | awk -F'---' '{print $1}'`
    newpoints=`expr $points - 2`
    sed -i "s/$points---$front/$newpoints---$front/g" "$1.db" 
}

shuffle() { 
    awk 'BEGIN{srand();} {printf "%0El dedo6d %s\n", rand()*1000000, $0;}' | sort -n | cut -c8-
}

testCard() {
    line=`awk "NR == $2" $1.db`
    id="$(echo $line | awk -F'---' '{print $2}')"
    front="$id"
    #points="$(echo $line | awk -F'---' '{print $1}')"
	#front=`$(grep "$word" "$1" | awk -F'---' '{print $1}')`
    back=`cat "$1" | grep "$id---" | awk -F'---' '{print $2}'`

    echo "The front is $front"
    read -p 'Back? ' answer

    if [ "$answer" = "$back" ]; then
        echo "You were correct the back was $back"
        addPoints $1 $id

        read -p 'Press enter to continue
' next
    else
        echo "The back was \"$back\" you typed \"$answer\""
        removePoints $1 $id
	
        read -p 'If you were right press "r". Press enter to continue
' next
    fi

    if [ "$next" = "q" ]; then
        exit;
    fi

    if [ "$next" = "k" ]; then
        addPoints $1 $id
        addPoints $1 $id
	addPoints $1 $id
	addPoints $1 $id
    fi

    if [ "$next" = "r" ]; then
        addPoints $1 $id
        addPoints $1 $id
	addPoints $1 $id
        read -p 'Marked as correct. Press enter to continue
'
    fi

    printf "\033c"
}

min() {
   (( $1 <= $2 )) && echo "$1" || echo "$2" 
}

length=`wc -l "$1.db" | cut -d' ' -f1`
count=`min "$length" 5`
count=`expr $count + 0`

while :
do
    for lineNumber in $( eval echo {1..$count} )
    do
        testCard $1 $lineNumber
    done

    sort -o "$1.db" "$1.db" --general-numeric-sort
done
