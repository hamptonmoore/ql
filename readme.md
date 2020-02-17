# ql
A simple shell based flash card program

## Features
- Keeps a running score of each card
- Command Line Based
- Simple file formatting
- Force mark as correct option
- Shows worst scoring cards first

## Usage
```
./ql --file basiclinuxcommands.txt
```

## Flashcard Datasets
A flashcard data set should have the front side and backside seperated by "---". This format can be easily exported from Quizlet by selecting Export, custom, and typing "---"
```
List directory contents---ls
Searches files for the occurrence of a string of characters---grep
Changes the working directory---cd
Shuts down the machine---shutdown
```
The basiclinuxcommands.txt was taken from https://quizlet.com/423431303/linux-commands-flash-cards/

## How it works
To store the success on each a .db file is created with the same name as the text file just with .db appended. The .db file is the same as the source file but instead of having the data stored as front---back it just stores front---points

