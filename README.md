# 🏷 Guessing_game

 A bash terminal game where players guess a random number, save thier game history, and complete for the best scores across different difficulty levels.

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

## ⚙️ Installation & Setup

### Prerequisites

- Linux (Ubuntu recommended)
- Bash
- Git

### 1. Clone the repository

```bash
git clone https://github.com/Mecaly-kjr/bash_guessing_game.git
```

### 2. Navigate to the project directory

```bash
cd bash_guessing_game
```

### 3. Make the script executable

```bash
chmod +x guessing_game.sh
```

### 4. Start the game

Normal difficulty:

```bash
./guessing_game.sh ama
```

Easy difficulty:

```bash
./guessing_game.sh ama easy
```

Hard difficulty:

```bash
./guessing_game.sh ama hard
```

Replace `ama` with your player name.

## 🎮 Difficulty Levels

| Level | Number Range |
| Easy | 1–50 |
| Normal | 1–100 |
| Hard | 1–1000 |

Normal is the default difficulty.

## 🖥️ Menu Options

1. **Play:** Start a new guessing game.
2. **My history:** Display your previous games and statistics.
3. **Leaderboard:** Display the top five players for the selected difficulty.
4. **Delete my history:** Delete your own game records after confirmation.
5. **Quit:** Exit the game.

## 💾 Game Data Format

Finished games are saved in `games.txt`.

Each record contains six fields separated by `|`:

```text
player|level|start_time|end_time|tries|duration_seconds
```

Example:

```text
ama|hard|2026-10-24 16:45:00|2026-10-24 16:47:12|11|132
```

The program checks game records and skips damaged lines without crashing.

## 🧠 How the Program Works

### Cleaning game records

The `make_clean` function checks the game file before displaying statistics. It validates the records and copies valid lines into a temporary clean file. Damaged lines are skipped and counted.

### Leaderboard

The leaderboard filters games by the selected difficulty, finds each player's best game, sorts players by the fewest attempts and fastest time, and displays the top five.

## 🧠 Challenges Faced

- Handling different difficulty levels.
- Validating player input and game records.
- Keeping damaged records from breaking the program.
- Making sure each player has only one entry on the leaderboard.
- Deleting one player's history without affecting other players.

## 📚 What I Learned

- Working with Bash functions, loops and conditions.
- Reading and validating text files.
- Using temporary files to safely update data.
- Sorting and filtering game records.
- Managing Git branches and commits.
- Testing different inputs and handling errors.

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
