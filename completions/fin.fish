complete -c fin -s v -l version -f -d 'Show version info'
complete -c fin -s h -l help -f -d "Show help"
complete -c fin -s d -l debug -f -d "Show debug tests"

complete fin -x -n __fish_use_subcommand -a help -d "Show help"
complete fin -x -n __fish_use_subcommand -a ggl -d "Use ggl"
## query exits
complete fin -x -n __fish_use_subcommand -a 'mdn codepen angular npm emojipedia rust'
## query doesn't exist
complete fin -x -n __fish_use_subcommand -a 'node deno vue react typescript storybook bem nextjs yarn'
## from ggl options
complete fin -x -n __fish_use_subcommand -a 'youtube github stackoverflow zenn qiita fish'

## from ggl options
complete -c fin -s i -l image -f -d 'Image Search'
complete -c fin -s p -l perfect -f -d 'Exact Match'
complete -c fin -s n -l nonperson -f -d 'Non-personalized Search'
complete -c fin -s e -l english -f -d 'English Search'

complete -c fin -s x -l exclude -x -d 'Exclude word'
complete -c fin -s b -l browser -x -d 'Use Specific Browser'

complete -c fin -s r -l range -x -d 'Time Range'
complete -c fin -s l -l lang -x -d 'Language Option'
