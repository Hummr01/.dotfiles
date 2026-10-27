#!/usr/bin/env bash
# Smart Zellij + Neovim + OpenCode Project Launcher & Scaffolder

set -e

PROJECTS_ROOT="$HOME/Projects"
mkdir -p "$PROJECTS_ROOT"

# Generate a clean Zellij session name from a directory path
get_session_name() {
    local target_dir
    target_dir=$(realpath "$1")
    local base_name
    base_name=$(basename "$target_dir")
    local parent_dir
    parent_dir=$(dirname "$target_dir")
    local parent_name
    parent_name=$(basename "$parent_dir")
    local combined

    if [ "$parent_dir" = "$HOME" ] || [ "$parent_dir" = "/" ] || [ "$parent_dir" = "$PROJECTS_ROOT" ]; then
        combined="$base_name"
    else
        combined="${parent_name}_${base_name}"
    fi

    echo "$combined" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]' | sed 's/^_//' | sed 's/_$//'
}

# Auto-detect the best Zellij layout for a directory
detect_layout() {
    local dir="$1"
    if [ -f "$dir/package.json" ]; then
        echo "web"
    elif [ -f "$dir/pyproject.toml" ] || [ -f "$dir/requirements.txt" ] || [ -d "$dir/.venv" ]; then
        echo "python"
    elif compgen -G "$dir/*.tex" > /dev/null; then
        echo "latex"
    else
        echo "ai-dev"
    fi
}

# Normalize layout shorthand names
normalize_layout() {
    case "$1" in
        web|node|vite|next|js|ts) echo "web" ;;
        py|python) echo "python" ;;
        tex|latex) echo "latex" ;;
        ai|ai-dev|default|"") echo "ai-dev" ;;
        *) echo "" ;;
    esac
}

# Launch or attach to a Zellij session for a directory + layout
launch_zellij_workspace() {
    local target_dir="${1:-$PWD}"
    local layout="${2:-}"

    target_dir=$(realpath "$target_dir")
    if [ ! -d "$target_dir" ]; then
        echo "Error: Directory '$target_dir' does not exist." >&2
        exit 1
    fi

    if [ -z "$layout" ]; then
        layout=$(detect_layout "$target_dir")
    fi

    local session_name
    session_name=$(get_session_name "$target_dir")

    cd "$target_dir"

    if [ -n "$ZELLIJ" ]; then
        echo "Already inside Zellij — opening new tab with layout '$layout' in $target_dir..."
        zellij action new-tab --layout "$layout" --cwd "$target_dir" --name "$(basename "$target_dir")"
        return 0
    fi

    if zellij list-sessions -n 2>/dev/null | awk '{print $1}' | grep -qx "$session_name"; then
        echo "Attaching to existing Zellij session '$session_name'..."
        zellij attach "$session_name"
    else
        echo "Starting Zellij session '$session_name' with layout '$layout'..."
        zellij --new-session-with-layout "$layout" --session "$session_name"
    fi
}

# Create a new project from a template and launch its Zellij workspace
create_new_project() {
    local proj_type="$1"
    local proj_name="$2"

    if [ -z "$proj_type" ]; then
        proj_type=$(printf "web\npython\nlatex\narduino\nempty\n" | fzf \
            --height 35% \
            --layout=reverse \
            --border \
            --prompt="Select New Project Type: ")
        [ -z "$proj_type" ] && exit 0
    fi

    if [ -z "$proj_name" ]; then
        printf "Enter new project name: "
        read -r proj_name
        [ -z "$proj_name" ] && { echo "Project name required."; exit 1; }
    fi

    local target_dir="$PROJECTS_ROOT/$proj_name"
    local layout="ai-dev"

    case "$proj_type" in
        web|node|vite)
            mkdir -p "$target_dir"
            cd "$target_dir"
            [ ! -d .git ] && git init -q
            if [ ! -f package.json ]; then
                npm init -y >/dev/null 2>&1 || true
            fi
            layout="web"
            ;;
        python|py)
            mkdir -p "$target_dir"
            cd "$target_dir"
            [ ! -d .git ] && git init -q
            if [ ! -d .venv ]; then
                echo "🐍 Creating Python virtual environment (.venv)..."
                python3 -m venv .venv
            fi
            if [ ! -f main.py ]; then
                cat << 'EOF' > main.py
def main() -> None:
    print("Hello from Python!")


if __name__ == "__main__":
    main()
EOF
            fi
            [ ! -f .gitignore ] && printf ".venv/\n__pycache__/\n*.pyc\n" > .gitignore
            layout="python"
            ;;
        latex|tex)
            mkdir -p "$target_dir"
            cd "$target_dir"
            [ ! -d .git ] && git init -q
            if [ ! -f main.tex ]; then
                cat << 'EOF' > main.tex
\documentclass[11pt,a4paper]{article}
\usepackage{amsmath,amssymb}
\usepackage{hyperref}

\title{Document Title}
\author{}
\date{\today}

\begin{document}
\maketitle

\section{Introduction}

\end{document}
EOF
            fi
            [ ! -f .gitignore ] && printf "*.aux\n*.fdb_latexmk\n*.fls\n*.log\n*.out\n*.synctex.gz\n*.toc\n" > .gitignore
            layout="latex"
            ;;
        arduino|ino)
            target_dir="$HOME/Arduino/$proj_name"
            mkdir -p "$target_dir"
            cd "$target_dir"
            if [ ! -f "$proj_name.ino" ]; then
                cat << 'EOF' > "$proj_name.ino"
void setup() {
    Serial.begin(115200);
}

void loop() {
}
EOF
            fi
            layout="ai-dev"
            ;;
        empty|*)
            mkdir -p "$target_dir"
            cd "$target_dir"
            [ ! -d .git ] && git init -q
            layout="ai-dev"
            ;;
    esac

    launch_zellij_workspace "$target_dir" "$layout"
}

mode="${1:-start}"
shift || true

case "$mode" in
    new)
        create_new_project "$1" "$2"
        ;;
    start|*)
        # Usage: zellij_project.sh start [layout-or-dir] [dir]
        arg1="$1"
        arg2="$2"
        parsed_layout=$(normalize_layout "$arg1")
        if [ -n "$parsed_layout" ]; then
            launch_zellij_workspace "${arg2:-$PWD}" "$parsed_layout"
        elif [ -n "$arg1" ]; then
            launch_zellij_workspace "$arg1" ""
        else
            launch_zellij_workspace "$PWD" ""
        fi
        ;;
esac
