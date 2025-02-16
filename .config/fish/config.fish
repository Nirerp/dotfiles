#!/usr/bin/env fish

# Suppress the welcome message
set -g fish_greeting ""

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

# Add to existing environment variables
set -gx HISTFILESIZE 10000
set -gx HISTTIMEFORMAT "%F %T"
set -gx HISTCONTROL "erasedups:ignoredups:ignorespace"

# Additional aliases
alias h="history | grep "
alias p="ps aux | grep "
alias f="find . | grep "
alias da='date "+%Y-%m-%d %A %T %Z"'
alias ebrc='nvim ~/.config/fish/config.fish'
alias hlp='less ~/.config/fish/config.fish'
alias web='cd /var/www/html'
alias sha1='openssl sha1'
alias clickpaste='sleep 3; xdotool type (xclip -o -selection clipboard)'
alias hug="hugo server -F --bind=10.0.0.97 --baseURL=http://10.0.0.97"

# Additional functions
function ftext
    rg -iIHn --color=always $argv | less -R
end

function cpp
    strace -q -ewrite cp -- $argv[1] $argv[2] 2>&1 | awk '
    {
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
    END { print "" }' total_size=(stat -c '%s' $argv[1]) count=0
end

function cpg
    if test -d $argv[2]
        cp $argv[1] $argv[2] && cd $argv[2]
    else
        cp $argv[1] $argv[2]
    end
end

function mvg
    if test -d $argv[2]
        mv $argv[1] $argv[2] && cd $argv[2]
    else
        mv $argv[1] $argv[2]
    end
end

function mkdirg
    mkdir -p $argv[1]
    cd $argv[1]
end

function up
    cd (string repeat -n (math $argv[1] + 0) ../)
end

function cd
    if count $argv > /dev/null
        builtin cd $argv && ls
    else
        builtin cd ~ && ls
    end
end

function pwdtail
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
end

function distribution
    set -l os_info (cat /etc/os-release 2>/dev/null | string collect)
    if test -n "$os_info"
        # Parse NAME
        set -l name (string match -r 'NAME="?([^"]+)"?' $os_info | tail -1)
        set -l id (string match -r 'ID="?([^"]+)"?' $os_info | tail -1)
        set -l id_like (string match -r 'ID_LIKE="?([^"]+)"?' $os_info | tail -1)

        switch "$id"
            case fedora rhel centos
                echo "redhat"
            case sles opensuse opensuse-tumbleweed
                echo "suse"
            case ubuntu debian
                echo "debian"
            case gentoo
                echo "gentoo"
            case arch manjaro
                echo "arch"
            case slackware
                echo "slackware"
            case '*'
                if test -n "$id_like"
                    string match -qr 'fedora|rhel|centos' "$id_like" && echo "redhat"
                    string match -qr 'sles|opensuse' "$id_like" && echo "suse"
                    string match -qr 'ubuntu|debian' "$id_like" && echo "debian"
                    string match -qr 'gentoo' "$id_like" && echo "gentoo"
                    string match -qr 'arch' "$id_like" && echo "arch"
                    string match -qr 'slackware' "$id_like" && echo "slackware"
                else
                    echo "unknown"
                end
        end
    else
        echo "unknown"
    end
end

function ver
    set dtype (distribution)
    switch "$dtype"
        case redhat
            if test -s /etc/redhat-release
                cat /etc/redhat-release
            else
                cat /etc/issue
            end
            uname -a
        case suse
            cat /etc/SuSE-release
        case debian
            lsb_release -a
        case gentoo
            cat /etc/gentoo-release
        case arch
            cat /etc/os-release
        case slackware
            cat /etc/slackware-version
        case '*'
            if test -s /etc/issue
                cat /etc/issue
            else
                echo "Error: Unknown distribution"
                return 1
            end
    end
end

function install_bashrc_support
    set dtype (distribution)
    switch "$dtype"
        case redhat
            sudo yum install multitail tree zoxide trash-cli fzf bash-completion fastfetch
        case suse
            sudo zypper install multitail tree zoxide trash-cli fzf bash-completion fastfetch
        case debian
            sudo apt-get install multitail tree zoxide trash-cli fzf bash-completion
            set FASTFETCH_URL (curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)
            curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb
            sudo apt-get install /tmp/fastfetch_latest_amd64.deb
        case arch
            sudo paru -S multitail tree zoxide trash-cli fzf bash-completion fastfetch
        case '*'
            echo "No install support for this distribution"
    end
end

function whatsmyip
    echo -n "Internal IP: "
    if type -q ip
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    end
    echo -n "External IP: "
    curl -s ifconfig.me
end

function hb
    if test (count $argv) -eq 0
        echo "No file path specified."
        return
    else if not test -f "$argv[1]"
        echo "File path does not exist."
        return
    end

    set uri "http://bin.christitus.com/documents"
    set response (curl -s -X POST -d @"$argv[1]" "$uri")
    if test $status -eq 0
        set hasteKey (echo $response | jq -r '.key')
        echo "http://bin.christitus.com/$hasteKey"
    else
        echo "Failed to upload the document."
    end
end

# Bind Ctrl+f to insert 'zi'
function fish_user_key_bindings
    bind \cf 'zi'
end

# Set bat alias based on distribution
if contains (distribution) redhat arch
    alias cat='bat'
else
    alias cat='batcat'
end

# Add to existing path configuration
fish_add_path $HOME/.bun/bin

####### Ollama Fish Completions ########
complete -c ollama -f
complete -c ollama -n "not __fish_seen_subcommand_from serve create show run push pull list ps cp rm help" \
    -a "serve create show run push pull list ps cp rm help"
complete -c ollama -n "__fish_seen_subcommand_from run show cp rm push list" \
    -a "(ollama list 2>/dev/null | tail -n +2 | cut -d '	' -f 1)"

####### END OF OLLAMA COMPLETIONS ######

####### ALIASES #######
alias spico='sudo pico'
alias snano='sudo nano'
alias apt-get='sudo apt-get'
alias freshclam='sudo freshclam'
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

####### FUNCTIONS #######
function ftext
    rg -iIHn --color=always $argv | less -R
end

function cpp
    strace -q -ewrite cp -- $argv[1] $argv[2] 2>&1 | awk '
    {
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
    END { print "" }' total_size=(stat -c '%s' $argv[1]) count=0
end

function cpg
    if test -d $argv[2]
        cp $argv[1] $argv[2] && cd $argv[2]
    else
        cp $argv[1] $argv[2]
    end
end

function mvg
    if test -d $argv[2]
        mv $argv[1] $argv[2] && cd $argv[2]
    else
        mv $argv[1] $argv[2]
    end
end

function mkdirg
    mkdir -p $argv[1]
    cd $argv[1]
end

function up
    for i in (seq $argv[1])
        cd ..
    end
end

function cd
    if test -n "$argv"
        builtin cd $argv; and ls
    else
        builtin cd ~; and ls
    end
end

function hb
    if test (count $argv) -eq 0
        echo "No file path specified."
        return
    else if not test -f "$argv[1]"
        echo "File path does not exist."
        return
    end

    set uri "http://bin.christitus.com/documents"
    set response (curl -s -X POST -d @$argv[1] $uri)
    if test $status -eq 0
        set hasteKey (echo $response | jq -r '.key')
        echo "http://bin.christitus.com/$hasteKey"
    else
        echo "Failed to upload the document."
    end
end

####### SHELL CONFIGURATION #######
starship init fish | source
zoxide init fish | source

# Bun configuration
set -gx BUN_INSTALL "$HOME/.bun"

# Terraform completion
complete -c terraform -f -a '(terraform -help)'

# Add missing aliases from original bashrc
alias clickpaste='sleep 3; xdotool type (xclip -o -selection clipboard)'
alias multitail='multitail --no-repeat -c'
alias diskspace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias logs="sudo find /var/www/html -type f -exec file {} \; | grep 'text' | cut -d':' -f1 | xargs tail -f"
alias rmd='/bin/rm --recursive --force --verbose'
function countfiles
    for t in files links directories
        set -l count (find . -type (string sub -l 1 $t) | count)
        echo "$count $t"
    end
end
alias openports='netstat -nape --inet'
alias topcpu="ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Add missing functions
function trim
    set var (string trim "$argv")
    echo -n "$var"
end

function apachelog
    if test -f /etc/httpd/conf/httpd.conf
        cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
    else
        cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
    end
end

function apacheconfig
    if test -f /etc/httpd/conf/httpd.conf
        sudo $EDITOR /etc/httpd/conf/httpd.conf
    else if test -f /etc/apache2/apache2.conf
        sudo $EDITOR /etc/apache2/apache2.conf
    else
        echo "Apache config not found!"
        sudo updatedb && locate httpd.conf apache2.conf
    end
end

function phpconfig
    set config_files /etc/php.ini /etc/php/php.ini /etc/php5/php.ini
    for config in $config_files
        if test -f $config
            sudo $EDITOR $config
            return
        end
    end
    echo "PHP config not found!"
    sudo updatedb && locate php.ini
end

function mysqlconfig
    set config_files /etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf
    for config in $config_files
        if test -f $config
            sudo $EDITOR $config
            return
        end
    end
    echo "MySQL config not found!"
    sudo updatedb && locate my.cnf
end

# Fix HISTCONTROL equivalent for fish
function fish_user_key_bindings
    bind \cf 'zi'
    # Enable Ctrl-S for forward history search
    bind -k nul 'forward-search-history'
end

# Fix directory stack (replaces bash cd history)
set -gx dirstack_size 8

# Fix shell options equivalents
set -U fish_features stderr-nocaret
set -g fish_autosuggestion_enabled 1

# Fix alert function syntax
function alert
    set -l last_cmd (history | tail -n 1 | string trim)
    set -l icon (test $status = 0 && echo terminal || echo error)
    notify-send --urgency=low -i "$icon" "$last_cmd"
end
