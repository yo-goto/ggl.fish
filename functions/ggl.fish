function ggl -d "Search for keywords on Google"
    argparse \
        -x 'v,h,t,o,d,m,quiet' \
        -x 'e,l' \
        -x 'C,S,F,V,B,b' \
        -x 'u,g,y,s,f,z,q' \
        'v/version' 'h/help' 't/test' 'o/output' 'd/debug' 'm/mode' 'quiet' \
        'i/image' 'p/perfect' 'n/nonperson' 'e/english' 'a/additional=+' \
        'l/lang=' 'r/range=' 'x/exclude=+' \
        'C/Chrome' 'S/Safari' 'F/Firefox' 'V/Vivaldi' 'B/Brave' \
        'b/browser=' \
        'u/url=' \
        'g/github' 'y/youtube' 's/stackoverflow' 'f/fishdoc' \
        'z/zenn' 'q/qiita' \
        -- $argv
    or return
    
    set --local gglversion "v1.6.1"
    set --local c yellow # text coloring
    set --local keyword (string join " " $argv)
    set --local baseURL "https://www.google.com/search?q="
    set --local site

    # site option
    set -q _flag_url; and set baseURL (string trim -lc '=' $_flag_url); and set site "specified URL"
    set -q _flag_github; and set baseURL "https://github.com/search?q="; and set site "Github"
    set -q _flag_youtube; and set baseURL "https://www.youtube.com/results?search_query="; and set site "YouTube"
    set -q _flag_stackoverflow; and set baseURL "https://stackoverflow.com/search?q="; and set site "Stack Overflow"
    set -q _flag_fishdoc; and set baseURL "https://fishshell.com/docs/current/search.html?q="; and set site "fish-shell docs"
    ## for Japanese users
    set -q _flag_zenn; and set baseURL "https://zenn.dev/search?q="; and set site "Zenn"
    set -q _flag_qiita; and set baseURL "https://qiita.com/search?q="; and set site "Qiita"

    if set -q _flag_version
        echo 'ggl.fish:' $gglversion
        return
    end

    if set -q _flag_help
        _ggl_help
        return
    end

    if set -q _flag_debug
        _ggl_debug
        return
    end

    if set -q _flag_mode
        _ggl_interactive
        return
    end

    # main
    if test -n "$keyword"

        set --local encoding (string escape --style=url $keyword)
        set --local searchURL
        set --local lang
        set --local range
        set --local exclude
        set --local exlist
        set --local browser
        
        ## google search options: parameter handling
        set -q _flag_lang; and switch "$_flag_lang"
            case =e =en =english =English
                set _flag_lang "lr=lang_en"
                set lang "English"
            case =j =ja =japanese =Japanese
                set _flag_lang "lr=lang_ja"
                set lang "Japanese"
            case =d =de =german =German
                set _flag_lang "lr=lang_de"
                set lang "German"
            case =f =fr =french =French
                set _flag_lang "lr=lang_fr"
                set lang "French"
            case =i =it =italian =Italian
                set _flag_lang "lr=lang_it"
                set lang "Italian"
            case =s =es =spanish =Spanish
                set _flag_lang "lr=lang_es"
                set lang "Spanish"
            case =r =ru =russian =Russian
                set _flag_lang "lr=lang_ru"
                set lang "Russian"
            case =k =ko =korean =Korean
                set _flag_lang "lr=lang_ko"
                set lang "Korean"
            case =z =zh =chinese =Chinese
                set _flag_lang "lr=lang_zh-CH"
                set lang "Chinese"
            case '*'
                set _flag_lang ''
                echo 'Flag: ' $_flag_lang
                echo "Invalid language flag. See help with -h option."
        end

        set -q _flag_english; and set _flag_lang "lr=lang_en"; and set lang "English"
        set -q _flag_image; and set _flag_image "tbm=isch"
        set -q _flag_nonperson; and set _flag_nonperson "pws=0"
        set -q _flag_range; and set range (string trim -lc '=' $_flag_range); and set _flag_range (string join ':' "tbs=qdr" $range)
        
        if set -q _flag_exclude
            for s in (seq 1 (count $_flag_exclude))
                set -a exlist (string trim -lc '=' $_flag_exclude[$s])
            end
            set exclude (string join '+-' (string escape --style=url $exlist))
        end 
        
        set -q _flag_perfect; and set _flag_perfect "%22" # exact match with escaped double quotes
        and set encoding (string join "" $_flag_perfect $encoding $_flag_perfect)

        # complete URL encoding
        set encoding (string replace -a %20 + $encoding)
        set -q _flag_exclude; and set encoding (string join '+-' $encoding $exclude)

        ## final output URL
        set searchURL (string join "&" (string join "" $baseURL $encoding) $_flag_lang $_flag_image $_flag_nonperson $_flag_range) 
        if set -q _flag_additional
            for i in (seq 1 (count $_flag_additional))
                set searchURL (string join "&" $searchURL (string trim -lc '=' $_flag_additional[$i]))
            end
        end

        ## testing for URL generation
        if set -q _flag_test
            echo (set_color $c) "Keyword    :" (set_color normal) "$keyword"
            [ $exclude ]; and \
            echo (set_color $c) "Excluded   :" (set_color normal) "$exlist"
            echo (set_color $c) "Encoded    :" (set_color normal) "$encoding"
            if set -q _flag_lang
                if test -n "$_flag_lang"
                    echo (set_color $c) "Language   :" (set_color normal) "$lang"
                else
                    echo (set_color $c) "Language   :" (set_color normal) "Invalid"
                end
            end
            set -q _flag_range; and \
            echo (set_color $c) "Time Range :" (set_color normal) "$range"
            [ $site ]; and \
            echo (set_color $c) "Site       :" (set_color normal) "$site"
            echo (set_color $c) "Search URL :" (set_color normal) "$searchURL"
            return
        end

        ## just print a generated URL
        if set -q _flag_output
            echo "$searchURL"
            return
        end

        # browser options
        if set -q _flag_Vivaldi; set browser "Vivaldi"
        else if set -q _flag_Chrome; set browser "Google Chrome"
        else if set -q _flag_Safari; set browser "Safari"
        else if set -q _flag_Firefox; set browser "Firefox"
        else if set -q _flag_Brave; set browser "Brave" 
        else if set -q _flag_browser; and set browser (string trim -lc '=' $_flag_browser)
        end        

        # os detection: macOS or other
        set -l comment (echo "Search for" "\"$argv\"" ( [ $site ] && echo "in $site" ) "completed.")
        switch (uname)
            case Darwin
                if test -n "$browser"
                    command open -a "$browser" "$searchURL"
                    and not set -q _flag_quiet; and echo $comment
                else 
                    command open "$searchURL"
                    and not set -q _flag_quiet; and echo $comment
                end 
            case '*'
                ## use xdg-open for linux distributions
                xdg-open "$searchURL"
                and not set -q _flag_quiet; and echo $comment
                or echo "Please Install xdg-utils."
        end

    else 
        set -q _flag_lang || set -q _flag_range
        and echo "Language and Time Range options require = and a valid flag."
        and echo "See help using -h or --help option."
        echo "Execute this command with keywords."
        return 1
    end

end


# helper functions
## for interactive mode
function _ggl_interactive
    set --local mode

    set --local c yellow
    set --local c_accent blue
    set --local cc (set_color $c)
    set --local ca (set_color $c_accent)
    set --local cn (set_color normal)

    set_color $c    
    echo '>> Interactive Mode' (set_color normal)
    while true
        switch "$mode"
            case sequential 
                set mode "optional"
            case optional
                set mode "sequential"
            case '*'
                read -P 'Select Mode [s/sequential | o/optional | e/exit]: ' mode
        end

        switch "$mode"
            case s S sequential
                set mode "sequential"
                set_color $c
                echo '>>>> Sequential Search Mode' (set_color normal)
                echo 'To stop this mode with Ctrl+C '
                echo 'Or type "EXIT" to exit or "CHANGE" to change mode'
                while true
                    read -l -P 'Type searching keywords: ' newkeyword
                    if test "$newkeyword" = "EXIT"
                        return
                    else if test "$newkeyword" = "CHANGE"
                        set flag_loop_exit "true"
                    else 
                        ggl "$newkeyword" --quiet
                    end
                    test "$flag_loop_exit" = "true"; and set flag_loop_exit "false"; and break
                end
            case o O optional
                set mode "optional"
                set_color $c
                echo '>>>> Option Selective Search Mode' (set_color normal)

                set --local options
                
                set --local flag_image          '1:Image   | ' 
                set --local flag_exact          '2:Exact   | '
                set --local flag_nonpersonal    '3:Non-personal        | '
                set --local flag_exclude        '4:Exclude | '
                set --local flag_lang           '5:Lang    | '
                set --local flag_time           '6:Time    | '
                set --local flag_browser        '7:Browser | '
                set --local flag_site           '8:Site    | '

                set --local opt_image
                set --local opt_exact
                set --local opt_nonpersonal
                set --local opt_exclude
                set --local opt_lang
                set --local opt_time
                set --local opt_browser
                set --local opt_site

                set --local flag_loop_exit 'false'

                while true
                    read -l -P 'Type searching keywords: ' newkeyword
                    while true 
                        read -l -P 'ggl? [y/yes | t/test | o/option | a/again | c/change-mode | e/exit]: ' question
                        switch "$question"
                            case Y y yes
                                [ $options[1] ]; and set -l last (string join "" " -" (string join " -" $options))
                                eval ggl $newkeyword $last
                                # return 0
                            case t T test
                                [ $options[1] ]; and set -l last (string join "" " -" (string join " -" $options))
                                eval ggl --test $newkeyword $last
                            case o O option
                                echo 'Choose Options (type number)'
                                while true
                                    set_color $c_accent
                                    echo '  |' '0:Go Next | 9:Reset   |'
                                    set_color $c
                                    echo '  |' $flag_image$flag_exact$flag_nonpersonal
                                    echo '  |' $flag_exclude$flag_lang$flag_time
                                    echo '  |' $flag_browser$flag_site
                                    set_color normal
                                    read -l -P "Choose Option Number: " opt
                                    switch "$opt"
                                        case 0
                                            ## comment-out for debug
                                            # echo $opt_image $opt_exact $opt_nonpersonal $opt_exclude $opt_lang $opt_time $opt_browser $opt_site
                                            # echo 'Options: ' $options
                                            break
                                        case 1
                                            set flag_image ''
                                            set opt_image '[Image: True]'
                                            set -a options 'i'
                                        case 2
                                            set flag_exact ''
                                            set opt_exact '[Exact: True]'
                                            set -a options 'p'
                                        case 3
                                            set flag_nonpersonal ''
                                            set opt_nonpersonal '[Non-personal: True]'
                                            set -a options 'n'
                                        case 4
                                            set flag_exclude ''
                                            read -P "Excluded words: " opt_exclude
                                            set -a options (string join '' "x=" $opt_exclude)
                                        case 5
                                            set flag_lang ''
                                            read -P "Language: " opt_lang
                                            set -a options (string join '' 'l=' $opt_lang)
                                        case 6
                                            set flag_time ''
                                            read -P "Time Range: " opt_time
                                            set -a options (string join '' 'r=' $opt_time)
                                        case 7
                                            set flag_browser ''
                                            echo "Browser list: "
                                            echo '[C/Chrome | S/Safari | F/Firefox | V/Vivaldi | B/Brave | O/Other]'
                                            while true
                                                read -P "which browser? To exit type e or exit: " opt_browser
                                                switch "$opt_browser"
                                                    case c C Chrome
                                                        set -a options 'C'
                                                        break
                                                    case s S Safari
                                                        set -a options 'S'
                                                        break
                                                    case f F Firefox
                                                        set -a options 'F'
                                                        break
                                                    case v V Vivaldi
                                                        set -a options 'V'
                                                        break
                                                    case b B Brave 
                                                        set -a options 'B'
                                                        break
                                                    case o O Other
                                                        read -l -P "Type browser name" browsername
                                                        set -a options (string join '' 'b=' $browsername)
                                                        break
                                                    case e E exit
                                                        set flag_browser '7:Browser | '
                                                        break
                                                    case '*'
                                                        echo 'Type valid option character'
                                                end
                                            end
                                        case 8
                                            set flag_site ''
                                            while true
                                                read -P "Site [g/github | y/youtube | s/stackoverflow | e/exit]: " opt_site
                                                switch "$opt_site"
                                                    case g
                                                        set -a options 'g'
                                                        break
                                                    case y
                                                        set -a options 'y'
                                                        break
                                                    case s stackoverflow
                                                        set -a options 's'
                                                        break
                                                    case e exit 
                                                        set flag_site '8:Site | '
                                                        break
                                                    case '*'
                                                        echo 'Type valid option character'
                                                end
                                            end 
                                        case 9
                                            set -l options ""
                                            set flag_image          '1:Image   | ' 
                                            set flag_exact          '2:Exact   | '
                                            set flag_nonpersonal    '3:Non-personal        | '
                                            set flag_exclude        '4:Exclude | '
                                            set flag_lang           '5:Lang    | '
                                            set flag_time           '6:Time    | '
                                            set flag_browser        '7:Browser | '
                                            set flag_site           '8:Site    | '
                                            
                                            set opt_image 
                                            set opt_exact 
                                            set opt_nonpersonal 
                                            set opt_exclude 
                                            set opt_lang 
                                            set opt_time 
                                            set opt_browser 
                                            set opt_site
                                    end
                                end
                            case c C change-mode
                                set flag_loop_exit "true"
                                break
                            case e E exit
                                return
                            case a A again
                                read -P 'Type searching keywords: ' newkeyword
                        end
                    end
                    test "$flag_loop_exit" = "true"; and set flag_loop_exit "false"; and break
                end
            case e E exit
                return
        end
    end
end


function _ggl_debug
    set --local ts
    ## test cases 
    set -a ts "ggl -t how to use fish shell"
    set -a ts "ggl -tei cat cute photo"
    set -a ts "ggl how to fish -x=shell --test"
    set -a ts "ggl fish shell -x=advanced -x=bash --test"
    set -a ts "ggl fishシェル -x=シェルダー -l=ja --test"
    set -a ts "ggl fish plugin -x=fisher -r=y1 -e --test"
    set -a ts "ggl --test fish swimming -a=tbm=vid -a=filter=1"
    for i in (seq 1 (count $ts))
        echo '$' $ts[$i]; and eval "$ts[$i]"
    end
end


function _ggl_help
    set --local c yellow

    echo 'Welcom to ggl.fish help.'
    echo 'This is a simple fish plugin for Google searching from the command line.'
    set_color $c
    echo '  Utility Options (mutually exclusive):' 
    echo '      -h or --help          Show Help'
    echo '      -v or --version       Show Version Info'
    echo '      -m or --mode          Interactive Search Mode'
    echo '      -t or --test          Test URL Generation' 
    echo '      -o or --output        Print generated URL'
    echo '      -d or --debug         Print some tests'
    echo '      --quiet               Do search without complete message'
    echo '  Browser Options (Uppercase letter):'
    echo '      -C or --Chrome        Use Google Chrome' 
    echo '      -S or --Safari        Use Safari'
    echo '      -F or --Firefox       Use Firefox'
    echo '      -V or --Vivaldi       Use Vivaldi'
    echo '      -B or --Brave         Use Brave'
    echo '      -b or --browser       Use other browser'
    echo '      If no options are specified, ggl opens a URL with default browser'
    echo '  Search Options:'
    echo '      -i or --image         Image serch'
    echo '      -p or --perfect       Exact match'
    echo '          Examples'
    echo '              $ ggl fish shell -p'
    echo '                      or'
    echo '              $ ggl \'"fish shell"\' command'
    echo '      -n or --nonperson     Non-Personalized search'
    echo '      -e or --english       English Search'
    echo '      -x or --exclude       Exclude word from search'
    echo '          Use this option with ='
    echo '          Example (exclude the word "bash" from search):'
    echo '              $ ggl fish shell -x=bash'
    echo '          Possible to use -x option more than once'
    echo '              $ ggl exclude mutiple words -x=A -x=B'
    echo '      -l or --lang          Language Option'
    echo '          = e or en         English'
    echo '          = j or ja         Japanese'
    echo '          = d or de         German'
    echo '          = f or fr         French'
    echo '          = i or it         Italian'
    echo '          = s or es         Spanish'
    echo '          = r or ru         Russian'
    echo '          = k or ko         Korean'
    echo '          = z or zh         Chinese'
    echo '          Use language option with ='
    echo '          Example (English Search):'
    echo '              $ ggl -l=en how to use fish shell'
    echo '                            or               '
    echo '              $ ggl -e how to use fish shell'
    echo '      -r or --range         Time Range for Searching'
    echo '          = h               Past Hour'
    echo '          = d               Past Day'
    echo '          = w               Past Week'
    echo '          = m               Past Month'
    echo '          = y               Past Year'
    echo '          Use range option with =, and speficy time range (ex `-r=h3`)'
    echo '          Examples (to restrict search result within the last 2 yeare):'
    echo '              $ ggl -r=y2 Results within the last 2 years'
    echo '          Without number (like `-r=y`), the time range becomes the same as `-r=y1` '
    echo '              $ ggl -r=m Results within the last month'
    echo '      -a or --additional         Addtional Query Parameter'
    echo '  Site Options (mutually exclusive):'
    echo '      -u or --url           Search with specified URL'
    echo '      -g or --github        Search with Github'
    echo '      -y or --youtube       Search with YouTube'
    echo '      -s or --stackoverflow Search with Stack overflow'
    echo '      -f or --fishdoc       Search with fish shell docs'
    echo '      For Japanese Users:'
    echo '      -z or --zenn          Search with Zenn'
    echo '      -q or --qiita         Search with Qiita'
    echo
    set_color normal
end

