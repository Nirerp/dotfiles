complete -c ollama -f
complete -c ollama -n "__fish_use_subcommand" -a "serve create show run push pull list ps cp rm help"

complete -c ollama -n "__fish_seen_subcommand_from run show cp rm push list" -a "(ollama list 2>/dev/null | tail -n +2 | cut -d '	' -f 1)" 
