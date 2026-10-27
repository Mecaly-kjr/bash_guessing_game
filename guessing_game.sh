#!/bin/bash
# Guess the Number - Weekend Edition

GAMES_FILE="${GAMES_FILE:-games.txt}"
USAGE="Usage: ./guess-game.sh PLAYER [easy|normal|hard]"

# 1. Argument Validation
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "$USAGE"
    exit 1
fi

# Day 3 Name Validation
name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
if [[ ! "$name" =~ ^[a-z0-9_]{1,20}$ ]]; then
    echo "Error: the name must be 1-20 letters, digits or underscores."
    echo "$USAGE"
    exit 1
fi

# Difficulty Setting & Range Configuration
level=$(echo "${2:-normal}" | tr '[:upper:]' '[:lower:]')
case "$level" in
    easy)   min=1; max=50 ;;
    normal) min=1; max=100 ;;
    hard)   min=1; max=1000 ;;
    *)
        echo "Error: unknown level '$2'."
        echo "$USAGE"
        exit 1
        ;;
esac

# Create temporary file for clean data operations
clean=$(mktemp)
trap 'rm -f "$clean"' EXIT

# ---- Clean copy generator: valid lines only, returns damaged count ----
make_clean() {
    : > "$clean"
    damaged=0
    [[ -f "$GAMES_FILE" ]] || return
    damaged=$(awk -F'|' -v out="$clean" '
        NF == 6 && $2 ~ /^(easy|normal|hard)$/ && $5 ~ /^[0-9]+$/ && $6 ~ /^[0-9]+$/ { print > out; next }
        { bad++ }
        END { print bad + 0 }' "$GAMES_FILE")
}

fmt_time() { printf '%dm%02ds' $(($1 / 60)) $(($1 % 60)); }

# ---- Option 1: Play Game ----
play() {
    local number guess tries=0 start_s start_t end_t duration best prev
    number=$((RANDOM % (max - min + 1) + min))
    start_s=$SECONDS
    start_t=$(date "+%Y-%m-%d %H:%M:%S")

    while true; do
        read -r -p "Please guess a number between $min and $max (or q to quit): " guess || return
        if [[ "$guess" == "q" || "$guess" == "Q" ]]; then
            echo "You quit the game."
            return
        fi

        # Strict boundary verification
        if [[ -z "$guess" ]] || ! [[ "$guess" =~ ^[0-9]+$ ]] || (( guess < min || guess > max )); then
            echo "Please enter a valid number between $min and $max."
            continue
        fi

        ((tries++))

        if (( guess > number )); then
            echo "Your guess is too high."
        elif (( guess < number )); then
            echo "Your guess is too low."
        else
            end_t=$(date "+%Y-%m-%d %H:%M:%S")
            duration=$((SECONDS - start_s))
            echo "You nailed it, good job, $name!"
            
            # Fetch personal best strictly for the current level
            make_clean
            prev=$(awk -F'|' -v p="$name" -v l="$level" '
                $1 == p && $2 == l { print $5 }' "$clean" | sort -n | head -n 1)

            # Append new entry directly to persistent source
            echo "$name|$level|$start_t|$end_t|$tries|$duration" >> "$GAMES_FILE"
            
            if [[ -z "$prev" ]] || (( tries < prev )); then
                echo "New personal best on $level!"
            fi
            return
        fi
    done
}

# ---- Option 2: History ----
history() {
    make_clean
    local count=0 total_tries=0 avg_tries=0
    
    echo -e "\n=== History for $name ==="
    echo -e "#\tLEVEL\tTRIES\tTIME\tDATE"
    
    while IFS='|' read -r p lvl st et trs secs; do
        if [[ "$p" == "$name" ]]; then
            ((count++))
            total_tries=$((total_tries + trs))
            local human_time=$(fmt_time "$secs")
            local game_date=$(echo "$st" | cut -d' ' -f1)
            echo -e "${count}\t${lvl}\t${trs}\t${human_time}\t${game_date}"
        fi
    done < "$clean"

    if (( count == 0 )); then
        echo "No games yet."
    else
        # Correctly rounded average calculation
        avg_tries=$(( (total_tries + count / 2) / count ))
        echo -e "\nSummary: $count game(s) played across all levels · Average: $avg_tries tries"
    fi
}

# ---- Option 3: Leaderboard ----
leaderboard() {
    make_clean
    echo "Leaderboard · $level · best game per player"
    
    # Pre-flight check to see if games exist for this level
    local checks=$(awk -F'|' -v l="$level" '$2 == l { count++ } END { print count + 0 }' "$clean")
    if (( checks == 0 )); then
        echo "No $level games played yet."
        return
    fi

    echo -e "#    PLAYER          TRIES     TIME  DATE"
    
    # Pipeline breakdown:
    # 1. Isolate and parse targets matching level -> Name, Tries, Seconds, YYYY-MM-DD
    # 2. Sort by Name ascending, then Tries ascending, then Seconds ascending
    # 3. Use awk to capture only the first encounter per unique username (their best single entry)
    # 4. Re-sort the unique list by Tries ascending, then Seconds ascending
    # 5. Take top 5 and visually scale fields
    awk -F'|' -v l="$level" '$2 == l { print $1, $5, $6, substr($3,1,10) }' "$clean" | \
    sort -k1,1 -k2,2n -k3,3n | \
    awk '!seen[$1]++' | \
    sort -k2,2n -k3,3n | \
    head -n 5 | \
    awk '{ 
        m = int($3 / 60); s = $3 % 60;
        time_str = sprintf("%dm%02ds", m, s);
        printf "%-5d%-16s%5d%9s  %s\n", NR, $1, $2, time_str, $4 
    }'
}

# ---- Option 4: Delete History ----
delete_history() {
    read -r -p "Are you sure you want to delete your entire history? (y/n): " confirm
    local normalized=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$normalized" == "y" || "$normalized" == "yes" ]]; then
        local tmp_file=$(mktemp)
        local total_before=0 total_after=0 deleted_count=0
        
        if [[ -f "$GAMES_FILE" ]]; then
            # Track overall structural records before stripping lines
            total_before=$(wc -l < "$GAMES_FILE")
            
            # Match fields perfectly to retain other users' data AND any un-parseable corrupt lines
            awk -F'|' -v p="$name" '
                # If the line matches a valid game string layout for this user, drop it
                ($1 == p && NF == 6 && $2 ~ /^(easy|normal|hard)$/) { next }
                # Keep everything else (other players, custom format layouts, and broken rows)
                { print }' "$GAMES_FILE" > "$tmp_file"
                
            total_after=$(wc -l < "$tmp_file")
            deleted_count=$((total_before - total_after))
            mv "$tmp_file" "$GAMES_FILE"
        fi
        echo "Deleted $deleted_count game(s)."
    elif [[ "$normalized" == "n" || "$normalized" == "no" ]]; then
        echo "Nothing deleted."
    else
        echo "Please answer y or n. Nothing deleted."
    fi
}

# ---- Main Menu Loop ----
while true; do
    make_clean
    echo -e "\n=== GUESS THE NUMBER · Player: $name · Level: $level (1-$max) ==="
    if (( damaged > 0 )); then
        echo "Warning: $damaged damaged line(s) in the games file were skipped."
    fi
    
    echo "1) Play"
    echo "2) My history"
    echo "3) Leaderboard"
    echo "4) Delete my history"
    echo "5) Quit"
    
    read -r -p "Choose: " choice
    case "$choice" in
        1) play ;;
        2) history ;;
        3) leaderboard ;;
        4) delete_history ;;
        5) echo "Goodbye!"; break ;;
        *) echo "Invalid choice. Please choose between 1 and 5." ;;
    esac
done