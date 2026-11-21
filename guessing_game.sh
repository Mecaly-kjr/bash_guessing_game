#!/bin/bash
# Guess the Number - Weekend Edition

GAMES_FILE="${GAMES_FILE:-games.txt}"
USAGE="Usage: ./guessing_game.sh PLAYER [easy|normal|hard]"

# 1. Argument Validation
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "$USAGE"
    exit 1
fi

# 2. Player Name Validation
name=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if [[ ! "$name" =~ ^[a-z0-9_]{1,20}$ ]]; then
    echo "Error: the name must be 1-20 letters, digits or underscores."
    echo "$USAGE"
    exit 1
fi

# 3. Difficulty Setting and Range Configuration
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

# 4. Temporary File Setup
clean=$(mktemp) || {
    echo "Error: could not create temporary file."
    exit 1
}

trap 'rm -f "$clean"' EXIT

# ---- Generate a clean copy containing valid records ----
make_clean() {
    : > "$clean"
    damaged=0

    [[ -f "$GAMES_FILE" ]] || return 0

    damaged=$(awk -F'|' '
        NF == 6 &&
        $2 ~ /^(easy|normal|hard)$/ &&
        $5 ~ /^[0-9]+$/ &&
        $6 ~ /^[0-9]+$/ {
            print
            next
        }
        { bad++ }
        END {
            print bad + 0 > "/dev/stderr"
        }
    ' "$GAMES_FILE" 2> "$clean.damaged")

    if [[ -s "$clean.damaged" ]]; then
        damaged=$(cat "$clean.damaged")
        rm -f "$clean.damaged"
    else
        damaged=0
    fi

    awk -F'|' '
        NF == 6 &&
        $2 ~ /^(easy|normal|hard)$/ &&
        $5 ~ /^[0-9]+$/ &&
        $6 ~ /^[0-9]+$/ {
            print
        }
    ' "$GAMES_FILE" > "$clean"
}

# ---- Format duration ----
fmt_time() {
    printf '%dm%02ds' "$(( $1 / 60 ))" "$(( $1 % 60 ))"
}

# ---- Option 1: Play Game ----
play() {
    local number guess tries=0 start_s start_t end_t duration prev

    number=$((RANDOM % (max - min + 1) + min))
    start_s=$SECONDS
    start_t=$(date "+%Y-%m-%d %H:%M:%S")

    while true; do
        read -r -p "Please guess a number between $min and $max (or q to quit): " guess || return

        if [[ "$guess" == "q" || "$guess" == "Q" ]]; then
            echo "You quit the game."
            return
        fi

        # Validate the guess
        if [[ -z "$guess" ]] ||
            ! [[ "$guess" =~ ^[0-9]+$ ]] ||
            (( guess < min || guess > max )); then
            echo "Please enter a valid number between $min and $max."
            continue
        fi

        ((tries += 1))

        if (( guess > number )); then
            echo "Your guess is too high."
        elif (( guess < number )); then
            echo "Your guess is too low."
        else
            end_t=$(date "+%Y-%m-%d %H:%M:%S")
            duration=$((SECONDS - start_s))

            echo "You nailed it, good job, $name!"

            # Find the previous personal best for this player and level
            make_clean

            prev=$(awk -F'|' -v p="$name" -v l="$level" '
                $1 == p && $2 == l {
                    print $5
                }
            ' "$clean" | sort -n | head -n 1)

            # Create the games file if it does not exist
            if ! touch "$GAMES_FILE"; then
                echo "Error: could not create or access games file."
                return 1
            fi

            # Save the completed game
            if ! printf '%s|%s|%s|%s|%s|%s\n' \
                "$name" "$level" "$start_t" "$end_t" "$tries" "$duration" >> "$GAMES_FILE"; then
                echo "Error: could not save game."
                return 1
            fi

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

    local count=0
    local total_tries=0
    local avg_tries=0
    local human_time game_date

    echo -e "\n=== History for $name ==="
    echo -e "#\tLEVEL\tTRIES\tTIME\tDATE"

   while IFS='|' read -r p lvl st _ trs secs; do
        if [[ "$p" == "$name" ]]; then
            ((count += 1))
            total_tries=$((total_tries + trs))

            human_time=$(fmt_time "$secs")
            game_date=${st%% *}

            echo -e "${count}\t${lvl}\t${trs}\t${human_time}\t${game_date}"
        fi
    done < "$clean"

    if (( count == 0 )); then
        echo "No games yet."
    else
        # Calculate average using integer division
        avg_tries=$((total_tries / count))

        echo -e "\nSummary: $count game(s) played across all levels · Average: $avg_tries tries"
    fi
}

# ---- Option 3: Leaderboard ----
leaderboard() {
    make_clean

    echo "Leaderboard · $level · best game per player"

    local checks

    checks=$(awk -F'|' -v l="$level" '
        $2 == l { count++ }
        END { print count + 0 }
    ' "$clean")

    if (( checks == 0 )); then
        echo "No $level games played yet."
        return
    fi

    echo -e "#    PLAYER          TRIES     TIME  DATE"

    awk -F'|' -v l="$level" '
        $2 == l {
            print $1 "|" $5 "|" $6 "|" substr($3, 1, 10)
        }
    ' "$clean" |
        sort -t'|' -k1,1 -k2,2n -k3,3n |
        awk -F'|' '!seen[$1]++' |
        sort -t'|' -k2,2n -k3,3n |
        head -n 5 |
        awk -F'|' '{
            m = int($3 / 60)
            s = $3 % 60
            time_str = sprintf("%dm%02ds", m, s)
            printf "%-5d%-16s%5d%9s  %s\n", NR, $1, $2, time_str, $4
        }'
}

# ---- Option 4: Delete History ----
delete_history() {
    local confirm normalized tmp_file
    local total_before=0 total_after=0 deleted_count=0

    read -r -p "Are you sure you want to delete your entire history? (y/n): " confirm
    normalized=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

    if [[ "$normalized" == "y" || "$normalized" == "yes" ]]; then

        if [[ ! -f "$GAMES_FILE" ]]; then
            echo "Deleted 0 game(s)."
            return
        fi

        tmp_file=$(mktemp) || {
            echo "Error: could not create temporary file."
            return 1
        }

        total_before=$(wc -l < "$GAMES_FILE")

        # Remove every record belonging to this player,
        # including damaged records.
        if ! awk -F'|' -v p="$name" '
            $1 == p { next }
            { print }
        ' "$GAMES_FILE" > "$tmp_file"; then
            rm -f "$tmp_file"
            echo "Error: could not process game history."
            return 1
        fi

        total_after=$(wc -l < "$tmp_file")
        deleted_count=$((total_before - total_after))

        if ! mv "$tmp_file" "$GAMES_FILE"; then
            rm -f "$tmp_file"
            echo "Error: could not update game history."
            return 1
        fi

        echo "Deleted $deleted_count game(s)."

    elif [[ "$normalized" == "n" || "$normalized" == "no" ]]; then
        echo "Nothing deleted."
    else
        echo "Please answer y or n. Nothing deleted."
    fi
}

# ---- Option 5: Main Menu Loop ----
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

    read -r -p "Choose: " choice || break

    case "$choice" in
        1) play ;;
        2) history ;;
        3) leaderboard ;;
        4) delete_history ;;
        5)
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid choice. Please choose between 1 and 5."
            ;;
    esac
done
