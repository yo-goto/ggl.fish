complete ggl --no-files
complete -c ggl -s h -f -d 'Show Help'
complete -c ggl -s t -l 'test' -f -d 'URL Testing'
complete -c ggl -s o -f -d 'Output URL'
complete -c ggl -s i -f -d 'Image Search'
complete -c ggl -s p -f -d 'Exact Match'
complete -c ggl -s n -f -d 'Non-personalized Search'
complete -c ggl -s e -f -d 'English Search'
complete -c ggl -s b -f -d 'Use Specific Browser'
complete -c ggl -s x -f -d 'Exclude word'

complete -c ggl -l github -f
complete -c ggl -l youtube -f
complete -c ggl -l stackoverflow -f
complete -c ggl -l zenn -f
complete -c ggl -l qiita -f

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

