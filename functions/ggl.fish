function ggl --description "A simple search plugin for keywords on Google"
    argparse \
        -x 'v,h,t,o,d,m,quiet' \
        -x 'e,l' \
        -x 'C,S,F,V,B,b' \
        -x 'u,L,site,g,y,s,f,z,q' \
        'v/version' 'h/help' 't/test' 'o/output' 'd/debug' 'm/mode' 'quiet' \
        'i/image' 'p/perfect' 'n/nonperson' 'e/english' 'a/additional=+' \
        'l/lang=' 'r/range=' 'x/exclude=+' \
        'C/Chrome' 'S/Safari' 'F/Firefox' 'V/Vivaldi' 'B/Brave' \
        'b/browser=' \
        'noq' \
        'u/url=' 'L/local=?' 'site=' \
        'g/github' 'y/youtube' 's/stackoverflow' 'f/fishdoc' \
        'z/zenn' 'q/qiita' \
        -- $argv
    or return 1
    
    set --local version_plugin "v1.7.12"
    set --local version_ggl "v1.8.0"
    ## color
    set --local cc (set_color $_ggl_color)
    set --local cn (set_color normal)
    ## process
    set --local keyword (string join -- " " $argv)
    set --local baseURL "https://www.google.com/search?q="
    set --local site "Google"

    if set -q _flag_version
        echo 'Plugin  :' $version_plugin
        echo 'ggl.fish:' $version_ggl
        return
    else if set -q _flag_help
        __ggl_help
        return
    else if set -q _flag_debug
        __ggl_debug
        return
    else if set -q _flag_mode
        __ggl_interactive
        return
    end

    # main
    if test -n "$keyword" || set -q _flag_local || set -q _flag_noq

        set --local encoding (string escape --style=url $keyword)
        set --local searchURL
        set --local lang
        set --local range
        set --local exclude
        set --local exlist
        set --local browser
        set --local within

        # site options
        set -q _flag_github; and set baseURL "https://github.com/search?q="; and set site "Github"
        set -q _flag_youtube; and set baseURL "https://www.youtube.com/results?search_query="; and set site "YouTube"
        set -q _flag_stackoverflow; and set baseURL "https://stackoverflow.com/search?q="; and set site "Stack Overflow"
        set -q _flag_fishdoc; and set baseURL "https://fishshell.com/docs/current/search.html?q="; and set site "fish-shell docs"
        ## for Japanese users
        set -q _flag_zenn; and set baseURL "https://zenn.dev/search?q="; and set site "Zenn"
        set -q _flag_qiita; and set baseURL "https://qiita.com/search?q="; and set site "Qiita"
        ## other URL options 
        if set -q _flag_url
            set baseURL (string trim -lc '=' $_flag_url)
            set site $baseURL
        end
        set -q _flag_local; and \
        if test -n "$_flag_local"
            set --local port (string trim -lc '=' $_flag_local)
            set baseURL (string join "" "http://localhost:" $port "/")
            set site (string join "" 'localhost:' $port)
        else 
            set baseURL "http://localhost:3000/"
            set site 'localhost:3000'
        end
        if set -q _flag_site
            set within (string trim -lc '=' $_flag_site)
            set _flag_site (string join "" "as_sitesearch=" $within)
        end
        
        ## google search options: parameter handling
        if set -q _flag_lang
            switch "$_flag_lang"
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
                    echo "\"$_flag_lang\"" "is invalid language flag. See help with -h option."
                    set _flag_lang
            end
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
        set searchURL (string join "&" (string join "" $baseURL $encoding) $_flag_lang $_flag_image $_flag_nonperson $_flag_range $_flag_site) 
        if set -q _flag_additional
            for i in (seq 1 (count $_flag_additional))
                set searchURL (string join "&" $searchURL (string trim -lc '=' $_flag_additional[$i]))
            end
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

        ## testing for URL generation
        if set -q _flag_test
            if test -n "$keyword"
                echo $cc "Keyword    :" $cn "$keyword"
                [ $exclude ]; and \
                echo $cc "Excluded   :" $cn "$exlist"
                echo $cc "Encoded    :" $cn "$encoding"
            end
            if set -q _flag_lang
                if test -n "$_flag_lang"
                    echo $cc "Language   :" $cn "$lang"
                else
                    echo $cc "Language   :" $cn "Invalid"
                end
            end
            set -q _flag_range; and \
            echo $cc "Time Range :" $cn "$range"
            if not test "$site" = "Google"
                echo $cc "Site       :" $cn "$site"
            end
            set -q _flag_site; and \
            echo $cc "Site       :" $cn 'Within "'$within'" on Google'
            test -n "$browser"; and \
            echo $cc "Browser    :" $cn "$browser"
            echo $cc "Search URL :" $cn "$searchURL"
            return
        end

        # os detection: macOS or other
        set -l comment (echo "Search for" "\"$argv\"" (echo "on $site" ) "completed.")
        set -q _flag_local; and set comment (echo "Opened" $searchURL)
        set -q _flag_noq; and set comment "opening" (test "$site" = "Google" && echo 'a site' || echo "$site") "without keywords"

        if command -q open
            if test -n "$browser"
                command open -a "$browser" "$searchURL"
            else 
                command open "$searchURL"
            end 
            not set -q _flag_quiet; and echo $comment
        else
            if type -q xdg-open
                ## for linux distributions
                xdg-open "$searchURL"
                not set -q _flag_quiet; and echo $comment
            else if type -q cygstart
                ## for windows Cygwin
                cygstart "$searchURL"
                not set -q _flag_quiet; and echo $comment
            else
                echo $cc"Please Install xdg-utils for Linux distributions."$cn
                echo $cc"Please Install cygutils for Windows Cygwin."$cn
            end
        end
    else 
        not test -n "$keyword"; and echo "Execute this command with keywords."
        return 1
    end

end


# helper functions
## for interactive mode
function __ggl_interactive

    set --local cc (set_color $_ggl_color)
    set --local ca (set_color $_ggl_color_accent)
    set --local co (set_color $_ggl_color_other)
    set --local cn (set_color normal)

    set --local options
    set --local option_flag
    set --local flag_loop_exit 'false'
    set --local mode
    
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

    set --local site

    set_color $_ggl_color
    echo '> Interactive Mode' $cn
    while true
        set_color $_ggl_color_accent
        echo '>> Base Mode' $cn
        # read -l -P 'Type searching keywords: ' newkeyword
        while true
            set_color $_ggl_color_accent
            echo '<< [y:yes | k:keyword | t:test | s:seq-mode | o:option | c:check-option | e:exit] >>' $cn
            read -l -P 'ggl? : ' question
            switch "$question"
                case Y y yes
                    [ $options[1] ]; and set option_flag (string join "" " -" (string join " -" $options))
                    eval ggl $newkeyword $option_flag
                    # return 0
                case t T test
                    [ $options[1] ]; and set option_flag (string join "" " -" (string join " -" $options))
                    eval ggl --test $newkeyword $option_flag
                case s S seq-mode
                    [ $options[1] ]; and set option_flag (string join "" " -" (string join " -" $options))
                    set mode "seq"
                    set_color $_ggl_color_other
                    echo '>>> Sequential Search Mode' 
                    echo 'Type "EXIT" (or Ctrl+C) to exit, '
                    echo 'Type "BACK" to change mode, or "CHECK" to see the current options'
                    set_color normal
                    while true
                        read -l -P 'Keywords: ' newkeyword
                        if test "$newkeyword" = "EXIT"
                            return
                        else if test "$newkeyword" = "BACK"
                            set mode "base"
                            set flag_loop_exit "true"
                            break
                        else if test "$newkeyword" = "CHECK"
                            # option check mod
                            test -n "$opt_image"; and \
                            echo $cc "Image?     :" $cn "True"
                            test -n "$opt_exact"; and \
                            echo $cc "Exact?     :" $cn "True"
                            test -n "$opt_nonpersonal"; and \
                            echo $cc "Non Personalized? :" $cn "True"
                            test -n "$opt_exclude"; and \
                            echo $cc "Excluded   :" $cn "$opt_exclude"
                            test -n "$opt_lang"; and \
                            echo $cc "Language   :" $cn "$opt_lang"
                            test -n "$opt_time"; and \
                            echo $cc "Time Range :" $cn "$opt_time"
                            if test -n "$opt_site"
                                echo $cc "Site       :" $cn "$site"
                            else
                                echo $cc "Site       :" $cn "Google"
                            end 
                            if test -n "$opt_browser"
                                echo $cc "Browser    :" $cn "$opt_browser"
                            else 
                                echo $cc "Browser    :" $cn "Default browser"
                            end
                        else 
                            eval ggl --quiet $newkeyword $option_flag
                        end
                    end
                    test "$flag_loop_exit" = "true"; and set flag_loop_exit "false"; and break
                case c C check
                    # option check mod
                    test -n "$opt_image"; and \
                    echo $cc "Image?     :" $cn "True"
                    test -n "$opt_exact"; and \
                    echo $cc "Exact?     :" $cn "True"
                    test -n "$opt_nonpersonal"; and \
                    echo $cc "Non Personalized? :" $cn "True"
                    test -n "$opt_exclude"; and \
                    echo $cc "Excluded   :" $cn "$opt_exclude"
                    test -n "$opt_lang"; and \
                    echo $cc "Language   :" $cn "$opt_lang"
                    test -n "$opt_time"; and \
                    echo $cc "Time Range :" $cn "$opt_time"
                    if test -n "$opt_site"
                        echo $cc "Site       :" $cn "$site"
                    else
                        echo $cc "Site       :" $cn "Google"
                    end 
                    if test -n "$opt_browser"
                        echo $cc "Browser    :" $cn "$opt_browser"
                    else 
                        echo $cc "Browser    :" $cn "Default browser"
                    end
                case o O option
                    echo 'Choose Options (type number)'
                    while true
                        set_color $_ggl_color_accent
                        echo '  |' '0:Go Next | 9:Reset   |'
                        set_color $_ggl_color
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
                                echo '[C:Chrome | S:Safari | F:Firefox | V:Vivaldi | B:Brave | O:Other]'
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
                                    read -P "Site [l:localhost | g:github | y:youtube | s:stackoverflow | e:exit]: " opt_site
                                    switch "$opt_site"
                                        case l local localhost 
                                            set site "Local host"
                                            set -a options 'L'
                                            break
                                        case g github
                                            set site "Github"
                                            set -a options 'g'
                                            break
                                        case y youtube
                                            set site "Youtube"
                                            set -a options 'y'
                                            break
                                        case s stackoverflow
                                            set site "Stack overflow"
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
                case e E exit
                    return
                case k K keyword
                    read -P 'Type searching keywords: ' newkeyword
            end
        end
        test "$flag_loop_exit" = "true"; and set flag_loop_exit "false"; and break
    end
end


function __ggl_debug
    set --local ts
    ## test cases 
    set -a ts "ggl -t how to use fish shell"
    set -a ts "ggl -tei cat cute photo"
    set -a ts "ggl fish plugin -g --test"
    set -a ts "ggl fish shell -x=advanced -x=bash --test"
    set -a ts "ggl fishシェル -x=シェルダー -l=ja --test"
    set -a ts "ggl fish plugin -x=fisher -r=y1 -e --test"
    set -a ts "ggl --test fish swimming -a=tbm=vid -a=filter=1"
    for i in (seq 1 (count $ts))
        echo '$' $ts[$i]; and eval "$ts[$i]"
    end
end


function __ggl_help
    echo 'Welcom to ggl.fish help.'
    echo 'This is a simple fish plugin for Google searching from the command line.'
    echo 'From v1.7.0, you can also use fin command as the search interface for frontend dev.'
    echo 'To see the usage of fin command, use "fin -h".'
    set_color $_ggl_color
    printf '%s\n' \
        '' \
        '  HELP OPTIONS:' \
        '      -h, --help            Show Help' \
        '      -v, --version         Show Version Info' \
        '' \
        '  UTILITY OPTIONS (mutually exclusive):'  \
        '      -t, --test            Test URL Generation'  \
        '      -o, --output          Print generated URL' \
        '      -d, --debug           Print some tests' \
        '          --quiet           Do search without complete message' \
        '' \
        '  SPECIAL OPTION:' \
        '      -m, --mode            Interactive Search Mode' \
        '' \
        '  BROWSER OPTIONS (Uppercase letter):' \
        '      -C, --Chrome          Use Google Chrome'  \
        '      -S, --Safari          Use Safari' \
        '      -F, --Firefox         Use Firefox' \
        '      -V, --Vivaldi         Use Vivaldi' \
        '      -B, --Brave           Use Brave' \
        '      -b, --browser         Use other browser' \
        '' \
        '  SEARCH OPTIONS:' \
        '      -i, --image           Image serch' \
        '      -p, --perfect         Exact match' \
        '      -n, --nonperson       Non-Personalized search' \
        '      -e, --english         English Search' \
        '      -x, --exclude         Exclude word from search' \
        '      -l, --lang            Language Option' \
        '          = e or en         English' \
        '          = j or ja         Japanese' \
        '          = d or de         German' \
        '          = f or fr         French' \
        '          = i or it         Italian' \
        '          = s or es         Spanish' \
        '          = r or ru         Russian' \
        '          = k or ko         Korean' \
        '          = z or zh         Chinese' \
        '      -r, --range           Time Range for Searching' \
        '          = h               Past Hour' \
        '          = d               Past Day' \
        '          = w               Past Week' \
        '          = m               Past Month' \
        '          = y               Past Year' \
        '      -a, --additional      Addtional Query Parameter' \
        '' \
        '  SITE OPTIONS (mutually exclusive):' \
        '      -g, --github          Search with Github' \
        '      -y, --youtube         Search with YouTube' \
        '      -s, --stackoverflow   Search with Stack overflow' \
        '      -f, --fishdoc         Search with fish shell docs' \
        '' \
        '  FOR JAPANESE USERS:' \
        '      -z, --zenn            Search with Zenn' \
        '      -q, --qiita           Search with Qiita' \
        '' \
        '  OTHER URL OPTIONS:' \
        '      -u, --url             Search with specified URL' \
        '      -L, --local           Open localhost (by default host:3000)' \
        '          --site            Search within specific site on Google' \
        '          --noq             Open a site without any keywords' \
        ''
    set_color normal
    echo 'For more infomation, see "https://github.com/yo-goto/ggl.fish"'
end

