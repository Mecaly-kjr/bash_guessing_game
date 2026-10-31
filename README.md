# 🏷 Guessing_game

 

## 📌 Problem Statement

I developed this Bash guessing game as part of my Rebase Code Camp assignment. The project allows players to guess a randomly generated number and receive hints when their guesses are too high or too low.
I also wanted to make the game more useful by adding different difficulty levels, saving game history, tracking personal best scores, and displaying a leaderboard.

---

## 🎯 Project Goals

- Create a guessing game with three difficulty levels.

- Validate player names and user guesses.

- Save completed games in a text file.

- Display each player's game history.

- Track personal best scores.

- Create a leaderboard showing the top five players.

- Detect damaged records without stopping the game.

- Allow players to delete their own game history.

---

## 🛠 Tech Stack

**Core Scripting:**  
 Bash (Bourne Again Shell)

**POSIX Stream & Processing Utilities:**  
-`awk` (Field extraction, filtering, text isolation, and statistical calculations)
-`sort` (Multi-key text stream organization)
-`mktemp` & `trap` (Safe transient temporary workspace handling and system signal cleanup)

**Testing and Environment Auditing:**  
-ShellCheck (Static analysis verification linting)

---

## 🖥 Features

- Three difficulty levels

Easy: 1–50

Normal: 1–100

Hard: 1–1000

- Player validation: Checks that player names contain 1–20 letters, numbers, or underscores.

- Game history: Saves completed games and displays the player's previous results.

- Personal best: Notifies a player when they complete a game with fewer attempts than their previous best at the same difficulty.

- Leaderboard: Displays the five best players for the selected difficulty.

- Damaged record detection: Identifies invalid records in the game data file and skips them.

- Delete history: Allows a player to delete their own records without deleting other players' records.

---

## 📷 Screenshots

![alt text](<assets/images/Screenshot From 2026-10-27 12-11-52 (Edited).png>)
![alt text](<assets/images/Screenshot From 2026-10-27 12-14-44 (Edited).png>)
![alt text](<assets/images/Screenshot From 2026-10-27 12-18-43.png>)

## ⚙ Installation & Setup

Clone the repository:

```bash
git clone https://https://github.com/Mecaly-kjr/bash_guessing_game/pull/2
cd bash_guessing_game
```

Make the script executable:
bash
chmod +x guessing_game.sh

Run the project:
bash
./guessing_game.sh kevin hard
Replace kevin with your player name and choose easy, normal, or hard.

## Game Menu

After starting the game, the following menu appears:

1) Play
2) My history
3) Leaderboard
4) Delete my history
5) Quit

Option 1 – Play: Start a new guessing game.

Option 2 – My history: View completed games and average attempts.

Option 3 – Leaderboard: View the top five players.

Option 4 – Delete my history: Delete your saved game records.

Option 5 – Quit: Exit the game.

Games File Format

The game stores completed results in games.txt.

Each record contains six fields separated by the | character.

player|level|start_time|end_time|tries|duration

Example:

luther|hard|2026-10-27 11:44:45|2026-10-27 11:48:36|24|231

The fields represent:

player: Player name.

level: Game difficulty.

start_time: Time the game started.

end_time: Time the game finished.

tries: Number of guesses.

duration: Total game duration in seconds.

Note: games.txt is runtime data. It is generated and updated when players complete games. It should not be committed to Git.

---

## 🧠 Challenges Faced

During development, I faced some difficulties with processing game records and calculating the average number of attempts.

I also had to find a way to remove one player's history without affecting other players' records. Another challenge was identifying damaged lines in the data file while keeping the game running.

I tested the script several times and corrected the problems as I worked on the project.

---

## 📚 What I Learned

- Bash functions, variables, loops, and conditions.

- Reading and writing files.

- Processing text using Awk.

- Sorting and filtering data.

- Handling temporary files.

- Testing scripts with ShellCheck.

- Using Git and GitHub to manage my project.

---

## 🚀 Future ImprovementsAdd colours to the terminal interface

- Add more statistics about player performance.

- Improve the game interface.

- Add more game modes.

---

## 👨🏽‍💻 Author

Mecaly Luther Bobbilla

[mecalyluther64@gmail.com](mailto:mecalyluther64@gmail.com)

Junior Developer | Software Engineering

Based in Cameroon.
