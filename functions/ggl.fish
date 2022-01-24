function ggl -d "Search for keywords on Google"
    argparse \
        -x 'v,h,t,o' \
        -x 'C,S,F,V,B,b' \
        -x 'e,l' \
        -x 'g,y,s,z,q' \
        'v/version' 'h/help' 't/test' 'o/output' \
        'i/image' 'p/perfect' 'n/nonperson' 'e/english' 'l/lang=?' \
        'C/Chrome' 'S/Safari' 'F/Firefox' 'V/Vivaldi' 'B/Brave' 'b/browser=?' \
        'g/github' 'y/youtube' 's/stackoverflow' \
        'z/zenn' 'q/qiita' \
        -- $argv
    or return
    
    set -l gglversion "v1.2.1"
    set -l c yellow # text coloring
    set -l keyword (string join " " $argv)
    set -l encoding (string escape --style=url $keyword)
    set -l baseURL "https://www.google.com/search?q="
    set -l lang
    set -l os
    set -l browser

    # site option
    [ $_flag_github ]; and set -l baseURL "https://github.com/search?q="
    [ $_flag_youtube ]; and set -l baseURL "https://www.youtube.com/results?search_query="
    [ $_flag_stackoverflow ]; and set -l baseURL "https://stackoverflow.com/search?q="
    ## for Japanese users
    [ $_flag_zenn ]; and set -l baseURL "https://zenn.dev/search?q="
    [ $_flag_qiita ]; and set -l baseURL "https://qiita.com/search?q="

    if set -q _flag_version
        echo 'ggl.fish:' $gglversion
        return
    end

    # help option
    if set -q _flag_help
        echo 'Welcom to ggl.fish help.'
        echo 'This is a simple tool for Google searching from the command line.'
        set_color $c
        echo ''
        echo '  Utility Options:' 
        echo '      -h or --help          Show Help'
        echo '      -v or --version       Show Version Info'
        echo '      -t or --test          Test URL Generation' 
        echo '      -o or --output        Print generated URL'
        echo
        echo '  Browser Options (Uppercase letter):'
        echo '      -C or --Chrome        Use Google Chrome' 
        echo '      -S or --Safari        Use Safari'
        echo '      -F or --Firefox       Use Firefox'
        echo '      -V or --Vivaldi       Use Vivaldi'
        echo '      -B or --Brave         Use Brave'
        echo '      -b or --browser       Use other browser'
        echo
        echo '      If not specified, ggl opens a URL with default browser'
        echo
        echo '  Search Options:'
        echo '      -i or --image         Image serch'
        echo '      -p or --perfect       Exact match'
        echo '      -n or --nonperson     Non-Personalized search'
        echo '      -e or --english       English Search'
        echo '      -l or --lang          Language Option'
        echo '            = e or en       English'
        echo '            = j or ja       Japanese'
        echo '            = d or de       German'
        echo '            = f or fr       French'
        echo '            = i or it       Italian'
        echo '            = s or es       Spanish'
        echo '            = r or ru       Russian'
        echo '            = k or ko       Korean'
        echo '            = z or zh       Chinese'
        echo
        echo '      Use language option with `=`'
        echo '      Example(English Search):'
        echo '            $ ggl -l=en how to use fish shell'
        echo '                          or               '
        echo '            $ ggl -e how to use fish shell'
        echo
        echo '  Site Options:'
        echo '      -g or --github        Search with Github'
        echo '      -y or --youtube       Search with YouTube'
        echo '      -s or --stackoverflow Search with Stack overflow'
        echo ''
        echo '  For Japanese Users:'
        echo '      -z or --zenn          Search with Zenn'
        echo '      -q or --qiita         Search with Qiita'
        echo
        set_color normal
        return
    end


    # open a browser
    if test -n "$encoding"
        
        ## language
        if set -q _flag_lang
            switch "$_flag_lang"
                case =e =en
                    set lang "lr=lang_en"
                case =j =ja
                    set lang "lr=lang_ja"
                case =d =de
                    set lang "lr=lang_de"
                case =f =fr
                    set lang "lr=lang_fr"
                case =i =it
                    set lang "lr=lang_it"
                case =s =es
                    set lang "lr=lang_es"
                case =r =ru
                    set lang "lr=lang_ru"
                case =k =ko
                    set lang "lr=lang_ko"
                case =z =zh
                    set lang "lr=lang_zh-CH"
                case '*'
                    echo "Invalid language flag. See help with -h option."
            end
        end
        
        ## google search options
        [ $_flag_english ]; and set lang "lr=lang_en"
        [ $_flag_image ]; and set _flag_image "tbm=isch"
        [ $_flag_nonperson ]; and set _flag_nonperson "pws=0"
        ### perfect match with double quotes "" 
        [ $_flag_perfect ]; and set _flag_perfect "%22"
        and set encoding (string join "" $_flag_perfect $encoding $_flag_perfect)

        ## final output
        set -l searchURL (string join "&" (string join "" $baseURL $encoding) $lang $_flag_image $_flag_nonperson) 

        ## testing for URL generation
        if set -q _flag_test
            echo (set_color $c)"Keyword     :" (set_color normal) "$keyword"
            echo (set_color $c)"URL encoding:" (set_color normal) "$encoding"
            echo (set_color $c)"Search URL  :" (set_color normal) "$searchURL"
            return
        end

        ## print a generated URL
        if set -q _flag_output
            echo "$searchURL"
            return
        end

        # detect OS: macOS or other
        if test (uname -s) = "Darwin"
            set os 'macOS'
        else 
            set os 'unknown'
        end

        # browser 
        if [ $_flag_Vivaldi ]; set browser "Vivaldi"
        else if [ $_flag_Chrome ]; set browser "Google Chrome"
        else if [ $_flag_Safari ]; set browser "Safari"
        else if [ $_flag_Firefox ]; set browser "Firefox"
        else if [ $_flag_Brave ]; set browser "Brave" 
        else if [ $_flag_browser ]; and set browser (string trim -lc '=' $_flag_browser)
        end        

        switch "$os"
            case "macOS"
                if test -n "$browser"
                    open -a "$browser" "$searchURL"
                else 
                    open "$searchURL"
                end 
                echo "Search Completed:" "\"$argv\""
            case "unkonwn"
                ## use xdg-open
                xdg-open "$searchURL"
        end

    else 
        echo "Execute this command with arguments."
    end

end
