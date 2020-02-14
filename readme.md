# fc
A simple shell based flash card program

## Features
- Keeps a running score of each card
- Command Line Based
- Simple file formatting
- Force mark as correct option
- Shows worst scoring cards first

## Usage
```
./fc basiclinuxcommands.txt
```

## Flashcard Datasets
A flashcard data set should have the front side and backside seperated by "---". This format can be easily exported from Quizlet by selecting Export, custom, and typing "---"
```
How do you view the working directory in linux---pwd
How do you secure shell in linux---ssh
How do you list a directory in linux---ls
```

## How it works
To store the success on each a .db file is created with the same name as the text file just with .db appended. The .db file is the same as the source file but instead of having the data stored as front---back it just stores front---points

