#!/usr/bin/env fish

# Environment Variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx HISTSIZE 500
set -gx HISTFILEFORMAT "%F %T"

# XDG directories
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

set -gx LINUXTOOLBOXDIR "$HOME/linuxtoolbox"

# Colors for ls and grep
set -gx CLICOLOR 1

# Basic aliases
alias pip="pip3"
alias py="python3"
alias repl="ipython3"
alias vim='nvim'
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias home='cd ~'

# Directory listing
alias la='ls -Alh'
alias ls='ls -aFh --color=always'
alias lx='ls -lXBh'
alias lk='ls -lSrh'
alias lc='ls -ltcrh'
alias lu='ls -lturh'
alias lr='ls -lRh'
alias lt='ls -ltrh'
alias lm='ls -alh | more'
alias lw='ls -xAh'
alias ll='ls -Fls'
alias labc='ls -lap'
alias lla='ls -Al'
alias las='ls -A'
alias lls='ls -l'

# Chmod aliases
alias mx='chmod a+x'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Docker cleanup
alias docker-clean='docker container prune -f; docker image prune -f; docker network prune -f; docker volume prune -f'

# Kitty SSH
alias kssh="kitty +kitten ssh"

# venv function converted to fish
function venv
    switch $argv[1]
        case "switch"
            set dir $PWD
            set venv_path ""
            while test "$dir" != "/"
                if test -d "$dir/.venv"
                    set venv_path "$dir/.venv"
                    break
                else if test -d "$dir/venv"
                    set venv_path "$dir/venv"
                    break
                end
                set dir (dirname "$dir")
            end
            
            if test -n "$venv_path"
                source "$venv_path/bin/activate.fish"
                echo "Activated virtual environment at $venv_path"
            else
                echo "No virtual environment found in current or parent directories"
            end
            
        case "default"
            if set -q VIRTUAL_ENV
                deactivate
                echo "Deactivated virtual environment"
            else
                echo "No active virtual environment"
            end
            
        case "create"
            if test -d "venv"
                echo "Virtual environment already exists"
            else
                python3 -m venv venv
                source venv/bin/activate.fish
                echo "Created and activated new virtual environment"
            end
            
        case '*'
            echo "Usage: venv [switch|default|create]"
    end
end

# Extract function converted to fish
function extract
    for file in $argv
        if test -f $file
            switch $file
                case '*.tar.bz2'
                    tar xvjf $file
                case '*.tar.gz'
                    tar xvzf $file
                case '*.bz2'
                    bunzip2 $file
                case '*.rar'
                    rar x $file
                case '*.gz'
                    gunzip $file
                case '*.tar'
                    tar xvf $file
                case '*.tbz2'
                    tar xvjf $file
                case '*.tgz'
                    tar xvzf $file
                case '*.zip'
                    unzip $file
                case '*.Z'
                    uncompress $file
                case '*.7z'
                    7z x $file
                case '*'
                    echo "don't know how to extract '$file'..."
            end
        else
            echo "'$file' is not a valid file!"
        end
    end
end

# Git shortcuts
function gcom
    git add .
    git commit -m "$argv[1]"
end

function lazyg
    git add .
    git commit -m "$argv[1]"
    git push
end

# Initialize starship prompt
starship init fish | source

# Initialize zoxide
zoxide init fish | source

# Set PATH
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /var/lib/flatpak/exports/bin
fish_add_path /.local/share/flatpak/exports/bin
fish_add_path $HOME/.bun/bin

# Run fastfetch if installed
if type -q fastfetch
    fastfetch --logo-type small --structure OS:Kernel:Shell:CPU:GPU --separator ": "
end

# Check for ripgrep and set grep alias accordingly
if type -q rg
    alias grep='rg'
else
    alias grep="/usr/bin/grep --color=auto"
end
