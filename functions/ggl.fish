function ggl -d "Search for keywords on Google"
    argparse \
        -x 'v,h,t,o,d,m' \
        -x 'e,l' \
        -x 'C,S,F,V,B,b' \
        -x 'u,g,y,s,f,z,q' \
        'v/version' 'h/help' 't/test' 'o/output' 'd/debug' 'm/mode' \
        'i/image' 'p/perfect' 'n/nonperson' 'e/english' 'a/additional=+' \
        'l/lang=' 'r/range=' 'x/exclude=+' \
        'C/Chrome' 'S/Safari' 'F/Firefox' 'V/Vivaldi' 'B/Brave' \
        'b/browser=' \
        'u/url=' \
        'g/github' 'y/youtube' 's/stackoverflow' 'f/fishdoc' \
        'z/zenn' 'q/qiita' \
        -- $argv
    or return
    
    set -l gglversion "v1.5.1"
    set -l c yellow # text coloring
    set -l keyword (string join " " $argv)
    set -l encoding (string escape --style=url $keyword)
    set -l baseURL "https://www.google.com/search?q="
    set -l searchURL
    set -l lang
    set -l range
    set -l exclude
    set -l browser
    set -l site

    # site option
    [ $_flag_url ]; and set baseURL (string trim -lc '=' $_flag_url); and set site "specified URL"
    [ $_flag_github ]; and set baseURL "https://github.com/search?q="; and set site "Github"
    [ $_flag_youtube ]; and set baseURL "https://www.youtube.com/results?search_query="; and set site "YouTube"
    [ $_flag_stackoverflow ]; and set baseURL "https://stackoverflow.com/search?q="; and set site "Stack Overflow"
    [ $_flag_fishdoc ]; and set baseURL "https://fishshell.com/docs/current/search.html?q="; and set site "fish-shell docs"
    ## for Japanese users
    [ $_flag_zenn ]; and set baseURL "https://zenn.dev/search?q="; and set site "Zenn"
    [ $_flag_qiita ]; and set baseURL "https://qiita.com/search?q="; and set site "Qiita"

    if [ $_flag_version ]
        echo 'ggl.fish:' $gglversion
        return
    end

    if [ $_flag_help ]
        echo 'Welcom to ggl.fish help.'
        echo 'This is a simple tool for Google searching from the command line.'
        set_color $c
        echo
        echo '  Utility Options (mutually exclusive):' 
        echo '      -h or --help          Show Help'
        echo '      -v or --version       Show Version Info'
        echo '      -t or --test          Test URL Generation' 
        echo '      -o or --output        Print generated URL'
        echo '      -d or --debug         Print some tests'
        echo
        echo '  Browser Options (Uppercase letter):'
        echo '      -C or --Chrome        Use Google Chrome' 
        echo '      -S or --Safari        Use Safari'
        echo '      -F or --Firefox       Use Firefox'
        echo '      -V or --Vivaldi       Use Vivaldi'
        echo '      -B or --Brave         Use Brave'
        echo '      -b or --browser       Use other browser'
        echo
        echo '      If no options are specified, ggl opens a URL with default browser'
        echo
        echo '  Search Options:'
        echo '      -i or --image         Image serch'
        echo '      -p or --perfect       Exact match'
        echo '      -n or --nonperson     Non-Personalized search'
        echo '      -e or --english       English Search'
        echo '      -x or --exclude       Exclude word from search'
        echo '          Use this option with ='
        echo '          Example (exclude the word "bash" from search):'
        echo '              $ ggl fish shell -x=bash'
        echo '          Possible to use -x option more than once'
        echo '              $ ggl exclude mutiple words -x=A -x=B'
        echo 
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
        echo 
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
        echo 
        echo '      -a or --additional         Addtional Query Parameter'
        echo
        echo '  Site Options (mutually exclusive):'
        echo '      -u or --url           Search with specified URL'
        echo '      -g or --github        Search with Github'
        echo '      -y or --youtube       Search with YouTube'
        echo '      -s or --stackoverflow Search with Stack overflow'
        echo '      -f or --fishdoc       Search with fish shell docs'
        echo
        echo '      For Japanese Users:'
        echo '      -z or --zenn          Search with Zenn'
        echo '      -q or --qiita         Search with Qiita'
        echo
        set_color normal
        return
    end

    if [ $_flag_debug ]
        set -l ts
        set ts[1] "ggl -t how to use fish shell"
        set ts[2] "ggl -tei cat cute photo"
        set ts[3] "ggl how to fish -x=shell --test"
        set ts[4] "ggl fish shell -x=advanced -x=bash --test"
        set ts[5] "ggl fishシェル -x=シェルダー -l=ja --test"
        set ts[6] "ggl fish plugin -x=fisher -r=y1 -e --test"
        set ts[7] "ggl --test fish swimming -a=tbm=vid -a=filter=1"
        for i in (seq 1 (count $ts))
            echo '$' $ts[$i]; and eval "$ts[$i]"
        end
        return
    end

    if [ $_flag_mode ]
        echo '>>>Interactive mode'
        while true
            read -l -P 'Enter query keywords: ' query
            read -l -P 'Need any options? [y/n]: ' need_option
            switch $need_option
                case Y y
                    read -l -P 'Choose Options [Image] : ' opt
                case N n
            end
            read -l -P 'ggl? [y/n]: ' question
            switch $question
                case Y y
                    ggl $question
                    return 0
                case '' N n
                    read -l -P 'Exit? [y/n]: ' e
                    switch $e
                        case Y y
                            return
                        case '' N n
                    end
            end
        end
    end

    # main
    if test -n "$encoding"
        
        ## google search options: parameter handling
        [ $_flag_lang ]; and switch "$_flag_lang"
            case =e =en
                set _flag_lang "lr=lang_en"
                set lang "English"
            case =j =ja
                set _flag_lang "lr=lang_ja"
                set lang "Japanese"
            case =d =de
                set _flag_lang "lr=lang_de"
                set lang "German"
            case =f =fr
                set _flag_lang "lr=lang_fr"
                set lang "French"
            case =i =it
                set _flag_lang "lr=lang_it"
                set lang "Italian"
            case =s =es
                set _flag_lang "lr=lang_es"
                set lang "Spanish"
            case =r =ru
                set _flag_lang "lr=lang_ru"
                set lang "Russian"
            case =k =ko
                set _flag_lang "lr=lang_ko"
                set lang "Korean"
            case =z =zh
                set _flag_lang "lr=lang_zh-CH"
                set lang "Chinese"
            case '*'
                echo "Invalid language flag. See help with -h option."
        end

        [ $_flag_english ]; and set _flag_lang "lr=lang_en"; and set lang "English"
        [ $_flag_image ]; and set _flag_image "tbm=isch"
        [ $_flag_nonperson ]; and set _flag_nonperson "pws=0"
        [ $_flag_range ]; and set range (string trim -lc '=' $_flag_range); and set _flag_range (string join ':' "tbs=qdr" $range)
        
        set -l exlist
        if set -q _flag_exclude
            for s in (seq 1 (count $_flag_exclude))
                set -a exlist (string trim -lc '=' $_flag_exclude[$s])
            end
            set exclude (string join '+-' (string escape --style=url $exlist))
        end 
        
        [ $_flag_perfect ]; and set _flag_perfect "%22" # exact match with escaped double quotes
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
        if [ $_flag_test ]
            echo (set_color $c) "Keyword    :" (set_color normal) "$keyword"
            [ $exclude ]; and \
            echo (set_color $c) "Excluded   :" (set_color normal) "$exlist"
            echo (set_color $c) "Encoded    :" (set_color normal) "$encoding"
            [ $_flag_lang ]; and \
            echo (set_color $c) "Language   :" (set_color normal) "$lang"
            [ $_flag_range ]; and \
            echo (set_color $c) "Time Range :" (set_color normal) "$range"
            [ $site ]; and \
            echo (set_color $c) "Site       :" (set_color normal) "$site"
            echo (set_color $c) "Search URL :" (set_color normal) "$searchURL"
            return
        end

        ## just print a generated URL
        if [ $_flag_output ]
            echo "$searchURL"
            return
        end

        # browser options
        if [ $_flag_Vivaldi ]; set browser "Vivaldi"
        else if [ $_flag_Chrome ]; set browser "Google Chrome"
        else if [ $_flag_Safari ]; set browser "Safari"
        else if [ $_flag_Firefox ]; set browser "Firefox"
        else if [ $_flag_Brave ]; set browser "Brave" 
        else if [ $_flag_browser ]; and set browser (string trim -lc '=' $_flag_browser)
        end        

        # os detection: macOS or other
        set -l comment (echo "Search for" "\"$argv\"" ( [ $site ] && echo "in $site" ) "completed.")
        switch (uname)
            case Darwin
                if test -n "$browser"
                    open -a "$browser" "$searchURL"
                    and echo $comment
                else 
                    open "$searchURL"
                    and echo $comment
                end 
            case '*'
                ## use xdg-open for linux distributions
                xdg-open "$searchURL"
                and echo $comment
                or echo "Please Install xdg-utils."
        end

    else 
        [ $_flag_lang ] || [ $_flag_range ]
        and echo "Language and Time Range options require = and a valid flag."
        and echo "See help using -h or --help option."
        echo "Execute this command with keywords."
        return 1
    end

end
