function ggl -d "Search for keywords on Google"
    argparse \
        -x 't,h,v' \
        -x 'c,s,f,V' \
        -x 'e,l' \
        -x 'g,y,s,z,q' \
        't/test' 'h/help' 'v/version' \
        'i/image' 'p/perfect' 'n/nonperson' 'e/english' 'l/lang=?' \
        'c/chrome' 's/safari' 'f/firefox' 'V/vivaldi' \
        'g/github' 'y/youtube' 'S/stack' \
        'z/zenn' 'q/qiita' \
        -- $argv
    or return
    
    set -l c yellow # text coloring
    set -l keyword (string join " " $argv)
    set -l encoding (string escape --style=url $keyword)
    set -l baseURL "https://www.google.com/search?q="
    set -l lang

    # site option
    [ $_flag_github ]; and set -l baseURL "https://github.com/search?q="
    [ $_flag_youtube ]; and set -l baseURL "https://www.youtube.com/results?search_query="
    [ $_flag_stack ]; and set -l baseURL "https://stackoverflow.com/search?q="
    ## for Japanese users
    [ $_flag_zenn ]; and set -l baseURL "https://zenn.dev/search?q="
    [ $_flag_qiita ]; and set -l baseURL "https://qiita.com/search?q="

    if set -q _flag_version
        echo 'ggl.fish: v1.1.0'
        return
    end

    # help option
    if set -q _flag_help
        echo 'welcom to ggl.fish'
        set_color $c
        echo 'Utilities:' 
        echo '    -t or --test       URL generation test' 
        echo '    -h or --help       Print this help message'
        echo '    -v or --version    Print command version'
        echo 'Browser Option:'
        echo '    -c or --chrome     Use Google Chrome' 
        echo '    -s or --safari     Use Safari'
        echo '    -f or --firefox    Use Firefox'
        echo '    -V or --vivaldi    Use Vivaldi'
        echo 'Search Options:'
        echo '    -i or --image      Image serch'
        echo '    -p or --perfect    Exact match'
        echo '    -n or --nonperson  Non-Personalized search'
        echo '    -e or --english    English Search'
        echo '    -l or --lang       Language Option'
        echo '          = e or en    English'
        echo '          = j or ja    Japanese'
        echo '          = d or de    German'
        echo '          = f or fr    French'
        echo '          = i or it    Italian'
        echo '          = s or es    Spanish'
        echo '          = r or ru    Russian'
        echo '          = k or ko    Korean'
        echo '          = z or zh    Chinese'
        echo '    Use language option with `=`'
        echo '    Eample (English Search): '
        echo '    $ ggl -l=en how to use fish shell'
        echo 'Site Option:'
        echo '    -g or --github     Search with Github'
        echo '    -y or --youtube    Search with YouTube'
        echo '    -S or --stack      Search with Stack overflow'
        echo '    -z or --zenn       Search with Zenn'
        echo '    -q or --qiita      Search with Qiita'
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
        set -l searchURL (string join "&" (string join "" $baseURL $encoding) $lang $_flag_image $_flag_nonperson) 

        ## testing for URL generation
        if set -q _flag_test
            echo (set_color $c)"Keyword     :" (set_color normal) "$keyword"
            echo (set_color $c)"URL encoding:" (set_color normal) "$encoding"
            echo (set_color $c)"Search URL  :" (set_color normal) "$searchURL"
            return
        end

        ## browser selction
        if set -q _flag_vivaldi
            open -a Vivaldi "$searchURL"
        else if set -q _flag_chrome
            open -a "Google Chrome" "$searchURL"
        else if set -q _flag_safari
            open -a Safari "$searchURL"
        else if set -q _flag_firefox
            open -a Firefox "$searchURL"
        else
            ### Open default browser
            open "$searchURL"
        end
        echo "Search Completed:" "\"$argv\""
    else 
        echo "Execute this command with arguments."
    end

end
