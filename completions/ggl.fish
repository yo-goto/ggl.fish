complete -c ggl -s h -l help -f -d 'Show Help'
complete -c ggl -s t -l test -f -d 'URL Testing'
complete -c ggl -s o -l output -f -d 'Output URL'
complete -c ggl -s m -l mode -f -d 'Interactive Search Mode'
complete -c ggl -l quiet -f -d 'Not show complete message'

complete -c ggl -s i -l image -f -d 'Image Search'
complete -c ggl -s p -l perfect -f -d 'Exact Match'
complete -c ggl -s n -l nonperson -f -d 'Non-personalized Search'
complete -c ggl -s e -l english -f -d 'English Search'

complete -c ggl -s x -l exclude -x -d 'Exclude word'
complete -c ggl -s b -l browser -x -d 'Use Specific Browser'

complete -c ggl -s g -l github -f -d 'Search in Github'
complete -c ggl -s y -l youtube -f -d 'Search in YouTube'
complete -c ggl -s s -l stackoverflow -f -d 'Search in StackOverflow'
complete -c ggl -s f -l fishdoc -f -d 'Search in fish-shell docs'
complete -c ggl -s z -l zenn -f -d 'Search in Zenn'
complete -c ggl -s q -l qiita -f -d 'Search in Qiita'
complete -c ggl -s u -l url -f -d 'Search in specified ULR'
complete -c ggl -s L -l local -d 'Open local host'
complete -c ggl -l site -f -d 'Search within specific site on Google'
complete -c ggl -l noq -f -d 'Open a site without any keywords'

function __complete_ggl_range
    printf '%s\t%s\n' '=h' 'Past Hour'
    printf '%s\t%s\n' '=d' 'Past Day'
    printf '%s\t%s\n' '=w' 'Past Week'
    printf '%s\t%s\n' '=m' 'Past Month'
    printf '%s\t%s\n' '=y' 'Past Year'
end
complete -c ggl -s r -xa '(__complete_ggl_range)' -d 'Time Range'

function __complete_ggl_lang
    printf '%s\t%s\n' '=en' 'English'
    printf '%s\t%s\n' '=ja' 'Japanese'
    printf '%s\t%s\n' '=de' 'German'
    printf '%s\t%s\n' '=fr' 'French'
    printf '%s\t%s\n' '=it' 'Italian'
    printf '%s\t%s\n' '=es' 'Spanish'
    printf '%s\t%s\n' '=ru' 'Russian'
    printf '%s\t%s\n' '=ko' 'Korean'
    printf '%s\t%s\n' '=zh' 'Chinese'
end
complete -c ggl -s l -xa '(__complete_ggl_lang)' -d 'Language Option'

