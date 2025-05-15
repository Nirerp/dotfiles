# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnosterzak"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

##################### MY ALIASES ##############################
alias pip="pip3"
alias py="python3"
alias repl="ipython3"
alias update="sudo pacman -Syu --noconfirm && paru -Syu --noconfirm && yay -Syu --noconfirm"

### venv aliases ###
function venv() {
    case "$1" in
        "switch")
            # Find venv by searching up the directory tree
            local dir=$PWD
            local venv_path=""
            while [[ "$dir" != "/" ]]; do
                if [[ -d "$dir/.venv" ]]; then
                    venv_path="$dir/.venv"
                    break
                elif [[ -d "$dir/venv" ]]; then
                    venv_path="$dir/venv"
                    break
                fi
                dir=$(dirname "$dir")
            done

            if [[ -n "$venv_path" ]]; then
                source "$venv_path/bin/activate"
                echo "Activated virtual environment at $venv_path"
            else
                echo "No virtual environment found in current or parent directories"
            fi
            ;;

        "default")
            if [[ -n "$VIRTUAL_ENV" ]]; then
                deactivate
                echo "Deactivated virtual environment"
            else
                echo "No active virtual environment"
            fi
            ;;

        "create")
            if [[ -d "venv" ]]; then
                echo "Virtual environment already exists"
            else
                python3 -m venv venv
                source venv/bin/activate
                echo "Created and activated new virtual environment"
            fi
            ;;

        *)
            echo "Usage: venv [switch|default|create]"
            ;;
    esac
}

###############################################################

#######################################################
# SOURCED ALIAS'S AND SCRIPTS
#######################################################


# Enable zsh completion features
autoload -Uz compinit
compinit

#######################################################
# EXPORTS
#######################################################

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
SAVEHIST=10000
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST

# Append to history instead of overwriting
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Seeing as other scripts will use it might as well export it
export LINUXTOOLBOXDIR="$HOME/linuxtoolbox"

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias spico='sudo pico'
alias snano='sudo nano'
alias vim='nvim'

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Check if ripgrep is installed
if command -v rg &> /dev/null; then
    # Alias grep to rg if ripgrep is installed
    alias grep='rg'
else
    # Alias grep to /usr/bin/grep with color options if ripgrep is not installed
    alias grep="/usr/bin/grep --color=auto"
fi

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# MACHINE SPECIFIC ALIAS'S
#######################################################

# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

# Alias's to change the directory
alias web='cd /var/www/html'

# Alias's to mount ISO files
# mount -o loop /home/NAMEOFISO.iso /home/ISOMOUNTDIR/
# umount /home/NAMEOFISO.iso
# (Both commands done as root only.)

#######################################################
# GENERAL ALIAS'S
#######################################################
# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit this .zshrc file
alias ezrc='$EDITOR ~/.zshrc'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm --recursive --force --verbose '

# Using lsd for pretty file listings (from your existing zshrc)
alias ls='lsd -aFh --color=always'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

# Original ls aliases (commented out since you're using lsd)
# alias la='ls -Alh'                # show hidden files
# alias ls='ls -aFh --color=always' # add colors and file type extensions
# alias lx='ls -lXBh'               # sort by extension
# alias lk='ls -lSrh'               # sort by size
# alias lc='ls -ltcrh'              # sort by change time
# alias lu='ls -lturh'              # sort by access time
# alias lr='ls -lRh'                # recursive ls
# alias lt='ls -ltrh'               # sort by date
# alias lm='ls -alh |more'          # pipe through 'more'
# alias lw='ls -xAh'                # wide listing format
# alias ll='ls -Fls'                # long listing format
# alias labc='ls -lap'              # alphabetical sort
# alias lf="ls -l | egrep -v '^d'"  # files only
# alias ldir="ls -l | egrep '^d'"   # directories only
# alias lla='ls -Al'                # List and Hidden Files
# alias las='ls -A'                 # Hidden Files
# alias lls='ls -l'                 # List

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)
alias kssh="kitty +kitten ssh"

# alias to cleanup unused docker containers, images, networks, and volumes
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

# Pokemon colorscripts (from your existing zshrc)
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Extracts any archive(s) (if unp isn't installed)
extract() {
for archive in "$@"; do
if [ -f "$archive" ]; then
case $archive in
*.tar.bz2) tar xvjf $archive ;;
*.tar.gz) tar xvzf $archive ;;
*.bz2) bunzip2 $archive ;;
*.rar) rar x $archive ;;
*.gz) gunzip $archive ;;
*.tar) tar xvf $archive ;;
*.tbz2) tar xvjf $archive ;;
*.tgz) tar xvzf $archive ;;
*.zip) unzip $archive ;;
*.Z) uncompress $archive ;;
*.7z) 7z x $archive ;;
*) echo "don't know how to extract '$archive'..." ;;
esac
else
echo "'$archive' is not a valid file!"
fi
done
}

# Searches for text in all files in the current folder
ftext() {
# -i case-insensitive
# -I ignore binary files
# -H causes filename to be printed
# -r recursive search
# -n causes line number to be printed
# optional: -F treat search term as a literal, not a regular expression
# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
if [ -d "$2" ]; then
cp "$1" "$2" && cd "$2"
else
cp "$1" "$2"
fi
}

# Move and go to the directory
mvg() {
if [ -d "$2" ]; then
mv "$1" "$2" && cd "$2"
else
mv "$1" "$2"
fi
}

# Create and go to the directory
mkdirg() {
mkdir -p "$1"
cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
local d=""
limit=$1
for ((i = 1; i <= limit; i++)); do
d=$d/..
done
d=$(echo $d | sed 's/^\///')
if [ -z "$d" ]; then
d=..
fi
cd $d
}

# Automatically do an ls after each cd, z, or zoxide
function chpwd() {
    ls
}

# Returns the last 2 fields of the working directory
pwdtail() {
pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Show the current distribution
distribution() {
    local dtype="unknown"  # Default to unknown

    # Use /etc/os-release for modern distro identification
    if [ -r /etc/os-release ]; then
        source /etc/os-release
        case $ID in
            fedora|rhel|centos)
                dtype="redhat"
                ;;
            sles|opensuse*)
                dtype="suse"
                ;;
            ubuntu|debian)
                dtype="debian"
                ;;
            gentoo)
                dtype="gentoo"
                ;;
            arch|manjaro)
                dtype="arch"
                ;;
            slackware)
                dtype="slackware"
                ;;
            *)
                # Check ID_LIKE only if dtype is still unknown
                if [ -n "$ID_LIKE" ]; then
                    case $ID_LIKE in
                        *fedora*|*rhel*|*centos*)
                            dtype="redhat"
                            ;;
                        *sles*|*opensuse*)
                            dtype="suse"
                            ;;
                        *ubuntu*|*debian*)
                            dtype="debian"
                            ;;
                        *gentoo*)
                            dtype="gentoo"
                            ;;
                        *arch*)
                            dtype="arch"
                            ;;
                        *slackware*)
                            dtype="slackware"
                            ;;
                    esac
                fi

                # If ID or ID_LIKE is not recognized, keep dtype as unknown
                ;;
        esac
    fi

    echo $dtype
}

DISTRIBUTION=$(distribution)
if [ "$DISTRIBUTION" = "redhat" ] || [ "$DISTRIBUTION" = "arch" ]; then
      alias cat='bat'
else
      alias cat='batcat'
fi

# Show the current version of the operating system
ver() {
    local dtype
    dtype=$(distribution)

    case $dtype in
        "redhat")
            if [ -s /etc/redhat-release ]; then
                cat /etc/redhat-release
            else
                cat /etc/issue
            fi
            uname -a
            ;;
        "suse")
            cat /etc/SuSE-release
            ;;
        "debian")
            lsb_release -a
            ;;
        "gentoo")
            cat /etc/gentoo-release
            ;;
        "arch")
            cat /etc/os-release
            ;;
        "slackware")
            cat /etc/slackware-version
            ;;
        *)
            if [ -s /etc/issue ]; then
                cat /etc/issue
            else
                echo "Error: Unknown distribution"
                exit 1
            fi
            ;;
    esac
}

# Automatically install the needed support files for this .zshrc file
install_zshrc_support() {
local dtype
dtype=$(distribution)

case $dtype in
"redhat")
sudo yum install multitail tree zoxide trash-cli fzf fastfetch
;;
"suse")
sudo zypper install multitail tree zoxide trash-cli fzf fastfetch
;;
"debian")
sudo apt-get install multitail tree zoxide trash-cli fzf
# Fetch the latest fastfetch release URL for linux-amd64 deb file
FASTFETCH_URL=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)

# Download the latest fastfetch deb file
curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb

# Install the downloaded deb file using apt-get
sudo apt-get install /tmp/fastfetch_latest_amd64.deb
;;
"arch")
sudo paru multitail tree zoxide trash-cli fzf fastfetch
;;
"slackware")
echo "No install support for Slackware"
;;
*)
echo "Unknown distribution"
;;
esac
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s ifconfig.me
}

# View Apache logs
apachelog() {
if [ -f /etc/httpd/conf/httpd.conf ]; then
cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
else
cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
fi
}

# Edit the Apache configuration
apacheconfig() {
if [ -f /etc/httpd/conf/httpd.conf ]; then
$EDITOR /etc/httpd/conf/httpd.conf
elif [ -f /etc/apache2/apache2.conf ]; then
$EDITOR /etc/apache2/apache2.conf
else
echo "Error: Apache config file could not be found."
echo "Searching for possible locations:"
sudo updatedb && locate httpd.conf && locate apache2.conf
fi
}

# Edit the PHP configuration file
phpconfig() {
if [ -f /etc/php.ini ]; then
$EDITOR /etc/php.ini
elif [ -f /etc/php/php.ini ]; then
$EDITOR /etc/php/php.ini
elif [ -f /etc/php5/php.ini ]; then
$EDITOR /etc/php5/php.ini
elif [ -f /usr/bin/php5/bin/php.ini ]; then
$EDITOR /usr/bin/php5/bin/php.ini
elif [ -f /etc/php5/apache2/php.ini ]; then
$EDITOR /etc/php5/apache2/php.ini
else
echo "Error: php.ini file could not be found."
echo "Searching for possible locations:"
sudo updatedb && locate php.ini
fi
}

# Edit the MySQL configuration file
mysqlconfig() {
if [ -f /etc/my.cnf ]; then
$EDITOR /etc/my.cnf
elif [ -f /etc/mysql/my.cnf ]; then
$EDITOR /etc/mysql/my.cnf
elif [ -f /usr/local/etc/my.cnf ]; then
$EDITOR /usr/local/etc/my.cnf
elif [ -f /usr/bin/mysql/my.cnf ]; then
$EDITOR /usr/bin/mysql/my.cnf
elif [ -f ~/my.cnf ]; then
$EDITOR ~/my.cnf
elif [ -f ~/.my.cnf ]; then
$EDITOR ~/.my.cnf
else
echo "Error: my.cnf file could not be found."
echo "Searching for possible locations:"
sudo updatedb && locate my.cnf
fi
}

# Trim leading and trailing spaces (for scripts)
trim() {
local var=$*
var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
echo -n "$var"
}

# GitHub Additions
gcom() {
git add .
git commit -m "$1"
}

lazyg() {
git add .
git commit -m "$1"
git push
}

function hb() {
    if [ $# -eq 0 ]; then
        echo "No file path specified."
        return
    elif [ ! -f "$1" ]; then
        echo "File path does not exist."
        return
    fi

    uri="http://bin.christitus.com/documents"
    response=$(curl -s -X POST -d @"$1" "$uri")
    if [ $? -eq 0 ]; then
        hasteKey=$(echo $response | jq -r '.key')
        echo "http://bin.christitus.com/$hasteKey"
    else
        echo "Failed to upload the document."
    fi
}

alias hug="hugo server -F --bind=10.0.0.97 --baseURL=http://10.0.0.97"

# Key bindings
bindkey -e  # Use emacs key bindings (default in zsh)
bindkey "^f" "zi^M" # Bind Ctrl+f to insert 'zi' followed by a newline

# Set up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# Path updates
export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"

# Starship prompt (if installed)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Zoxide integration
eval "$(zoxide init zsh)"

# Cargo/Rust
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# End of .zshrc
