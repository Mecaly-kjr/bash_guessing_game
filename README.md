# 🏷 Project Name

 Guessing_game

## 📌 Problem Statement

Standard terminal guessing games lack persistence, fail to scale dynamically for varying player skill levels, and break down completely when text-based flat-file logs become corrupted by manual human intervention. This game handles structural data anomalies gracefully, provides safe isolated profiles, and guarantees robust validation checkpoints without breaking the gameplay flow.

---

## 🎯 Project Goals

- Establish an active gameplay matrix across three difficulty tiers.
- Build a text-based database filtering routine to seamlessly bypass malformed records.
- Implement profile-isolated log cleaning that keeps other users' data pristine.
- Formulate a deduplicated leaderboard engine sorting players by minimum attempts, then by fastest duration.

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

- **Optional Multi-Tier Difficulty Engine:** Set bounds seamlessly via command-line parameters to initialize `easy` (1–50), `normal` (1–100), or `hard` (1–1000) modes.
- **Corrupt File Data Recovery Engine:** Automatically identifies, isolates, and counts structural database string issues, showing an alert to users on startup without stopping the game.
- **Deduplicated Top 5 High Score Board:** Employs pipe-separated stream processors to isolate and output a user's single best game entry per level, preventing high-performers from dominating the board.
- **Targeted Record Annihilation:** A secure validation workflow wipes a current player's stats while keeping external profiles and malformed storage artifacts completely untouched.

---

## 📷 Screenshots

![alt text](<assets/images/Screenshot From 2026-10-27 12-11-52 (Edited).png>)
![alt text](<assets/images/Screenshot From 2026-10-27 12-14-44 (Edited).png>)
![alt text](<assets/images/Screenshot From 2026-10-27 12-18-43.png>)

## ⚙ Installation & Setup

Clone the repository:

```bash
git clone https://github.com
cd bash_guessing_game
```

Make the script executable:
bash
chmod +x guessing_game.sh

Run the project:
bash
./guessing_game.sh kevin hard

---

## 🧠 Challenges Faced

- **Preventing Variable Masking Errors:** Splitting local variable declarations from command execution streams to ensure system failures aren't concealed behind variable initialization codes.
- **Preserving String Delimiters Through Pipelines:** Keeping strict pipe (`|`) boundaries active through complex sorting layers before converting fields into their final text format, stopping multi-word entries from breaking array positions.
- **Selective Data Erasure via Sed/Awk Contexts:** Building regular expression string rules capable of selectively removing exactly matched user keys without deleting malformed lines or external usernames.

---

## 📚 What I Learned

- Designing robust, standards-compliant input parameters to securely prevent execution leaks or variable cracking.
- Structuring terminal-based data layers to support multi-column filtering, mathematical averaging, and text alignment.
- Utilizing built-in variables like `NR` inside custom display scripts to print clean line ranks.

---

## 🚀 Future Improvements

- Add terminal color themes (Green for low, Red for high) to give immediate visual feedback.
- Introduce advanced game telemetry, like checking the ratio of correct guesses to track player choice efficiency.
- Build a centralized server hook to sync `games.txt` data across networked nodes.

---

## 👨🏽‍💻 Author

Mecaly Luther Bobbilla

[mecalyluther64@gmail.com](mailto:mecalyluther64@gmail.com)

Junior Developer | Software Engineering

Based in Cameroon.
