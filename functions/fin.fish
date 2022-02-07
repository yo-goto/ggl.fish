function fin --description "ggl wrapper for frontend developers"
    argparse --stop-nonopt 'v/version' 'h/help' 'd/debug' 'list' -- $argv

    set --local version_fin "v0.0.8"

    # color shortcut
    set --local cc (set_color $_ggl_color)
    set --local ca (set_color $_ggl_color_accent)
    set --local co (set_color $_ggl_color_other)
    set --local cn (set_color normal)    
    
    # query exists
    set --local param_url
    set --local base_url
    set --local list_url
    set --local list_url_cmd
    # query doesn't exist
    set --local param_site
    set --local list_site
    set --local list_site_cmd

    # url list
    ## also available from ggl command
    set --local url_youtube "https://www.youtube.com/results?search_query="
        set --local base_youtube "https://www.youtube.com"
            set -a list_url $url_youtube
            set -a list_url_cmd "youtube"
    set --local url_github "https://github.com/search?q="
        set --local base_github "https://github.com"
            set -a list_url $url_github
            set -a list_url_cmd "github"
    set --local url_stackoverflow "https://stackoverflow.com/search?q="
        set --local base_stackoverflow "https://stackoverflow.com"
            set -a list_url $url_stackoverflow
            set -a list_url_cmd "stackoverflow"
    set --local url_zenn "https://zenn.dev/search?q="
        set --local base_zenn "https://zenn.dev"
            set -a list_url $url_zenn
            set -a list_url_cmd "zenn"
    set --local url_qiita "https://qiita.com/search?q="
        set --local base_qiita "https://qiita.com"
            set -a list_url $url_qiita
            set -a list_url_cmd "qiita" 
    set --local url_fish "https://fishshell.com/docs/current/search.html?q="
        set --local base_fish "https://fishshell.com/docs/current/index.html"
            set -a list_url $url_fish
            set -a list_url_cmd "fish"

    ## fin specific
    set --local url_mdn "https://developer.mozilla.org/search?q="
        set --local base_mdn "https://developer.mozilla.org"
            set -a list_url $url_mdn
            set -a list_url_cmd "mdn"
    set --local url_angular "https://angular.io/docs/ts/latest/api/#!?url="
        set --local base_angular "https://angular.io/docs/ts/latest/api"
            set -a list_url $url_angular
            set -a list_url_cmd "angluar"
    set --local url_codepen "http://codepen.io/search?q="
        set --local base_codepen "http://codepen.io"
            set -a list_url $url_codepen
            set -a list_url_cmd "codepen"
    set --local url_npm "https://www.npmjs.com/search?q="
        set --local base_npm "https://www.npmjs.com"
            set -a list_url $url_npm
            set -a list_url_cmd "npm"
    set --local url_emojipedia "https://emojipedia.org/search/?q="
        set --local base_emojipedia "https://emojipedia.org"
            set -a list_url $url_emojipedia
            set -a list_url_cmd "emojipedia"
    set --local url_rust "https://doc.rust-lang.org/reference/index.html?search="
        set --local base_rust "https://doc.rust-lang.org/reference"
            set -a list_url $url_rust
            set -a list_url_cmd "rust"

    # site list (no query)
    set --local site_node "nodejs.org"
        set -a list_site $site_node
        set -a list_site_cmd "node"
    set --local site_deno "deno.land"
        set -a list_site $site_deno
        set -a list_site_cmd "deno"
    set --local site_vue "vuejs.org"
        set -a list_site $site_vue
        set -a list_site_cmd "vue"
    set --local site_react "reactjs.org"
        set -a list_site $site_react
        set -a list_site_cmd "react"
    set --local site_typescript "typescriptlang.org"
        set -a list_site $site_typescript
        set -a list_site_cmd "typescript"
    set --local site_storybook "storybook.js.org"
        set -a list_site $site_storybook
        set -a list_site_cmd "storybook"
    set --local site_bem "en.bem.info"
        set -a list_site $site_bem
        set -a list_site_cmd "bem"
    set --local site_nextjs "nextjs.org"
        set -a list_site $site_nextjs
        set -a list_site_cmd "nextjs"
    set --local site_yarn "yarnpkg.com"
        set -a list_site $site_yarn
        set -a list_site_cmd "yarn"
    set --local site_tmux "github.com/tmux/tmux/wiki"
        set --local no_query_flag_tmux 'true'
        set -a list_site $site_tmux
        set -a list_site_cmd "tmux"
    set --local site_iterm2 "iterm2.com"
        set -a list_site $site_iterm2
        set -a list_site_cmd "iterm2"


    # option handling
    if set -q _flag_version
        functions --query ggl; and \
        eval ggl -v
        echo 'fin.fish:' $version_fin
        return
    else if set -q _flag_help || test "$argv[1]" = "help"
        _fin_help
        return
    else if set -q _flag_debug
        _fin_debug
        return
    else if set -q _flag_list || test "$argv[1]" = "ls"
        echo $cc"[Query exists]" $cn
        for i in (seq (count $list_url))
            echo ""$ca $list_url_cmd[$i]':'$co $list_url[$i] $cn
        end
        echo $cc"[Query doesn't exist]" $cn
        for i in (seq (count $list_site))
            echo ""$ca $list_site_cmd[$i]':'$co $list_site[$i] $cn
        end
        return
    end 
    
    # main
    if functions --query ggl
        set --local ts (string join "" "$argv")
        if set -q url_$argv[1] && test -n "$ts"
            if test (count $argv) -gt 1
                # with keyword
                set param_url url_$argv[1]
                # indirect varibale reference
                eval ggl $argv[2..-1] --url=$$param_url
            else
                # without keyword
                set base_url base_$argv[1]
                eval ggl --noq --url=$$base_url
            end 
        else if set -q site_$argv[1] && test -n "$ts"
            if test (count $argv) -gt 1 && not set -q no_query_flag_$argv[1]
                ## with keyword
                set param_site site_$argv[1]
                eval ggl $argv[2..-1] --site=$$param_site
            else
                ## without keyword
                set -l prep site_$argv[1]
                set base_url (string join '' 'https://' $$prep)
                eval ggl --noq --url=$base_url
                if set -q no_query_flag_$argv[1]
                    echo "Query doesn't exsit and this site can't be googled"
                    echo "So just opened a base site"
                end
            end
        else if test "$argv[1]" = "ggl" || test "$argv[1]" = "g"
            eval ggl $argv[2..-1] --site=$$param_site
        else if test -n "$ts"
            ggl $argv
        else 
            _fin_help
            return 1
        end
    else
        echo "can't find ggl function"
        return 1
    end
end


## helper functions
function _fin_debug
    set --local ts
    set -a ts "fin deno fetch -t"
    set -a ts "fin npm gray-matter --test"
    set -a ts "fin mdn JavaScript --test"
    for i in (seq 1 (count $ts))
        echo '$' $ts[$i]; and eval "$ts[$i]"
    end
end


function _fin_help
    set_color $_ggl_color
    echo 'Usage: '
    echo '      fin [fin-OPTION]'
    echo '      fin [KEYWORDS...] [ggl-OPTIONS...]'
    echo '      fin g [KEYWORDS...] [ggl-OPTIONS...]'
    echo '      fin ggl [KEYWORDS...] [ggl-OPTIONS...]'
    echo '      fin SUBCOMMAND [KEYWORDS...] [ggl-OPTIONS...]'
    echo 'Options: '
    echo '      -v, --version   Show version info'
    echo '      -h, --help      Show help'
    echo '      -d, --debug     Show debug tests'
    echo '          --list      Show the list of all urls & sites'
    echo 'Subcommands:'
    echo '      [base]          g(ggl) help ls'
    echo '      [basic]         youtube github stackoverflow'
    echo '      [MDN]           mdn' 
    echo '      [shell]         fish'
    echo '      [terminal]      tmux iterm2'
    echo '      [japanese]      zenn qiita'
    echo '      [emoji]         emojipedia'
    echo '      [js runtime]    node deno'
    echo '      [pkg manager]   npm yarn'
    echo '      [framework]     vue react angular nextjs storybook'
    echo '      [language]      rust typescript'
    echo '      [css]           bem'
    echo '      [other]         codepen'
    set_color normal
end

