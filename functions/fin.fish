function fin --description "ggl wrapper for frontend developers"
    argparse \
        -x 'v,h,d,list,long' \
        --stop-nonopt 'v/version' 'h/help' 'd/debug' 'list' 'long' -- $argv
    or return 1

    set --local version_fin "v0.1.2"

    # color shortcut
    set --local cc (set_color $_ggl_color)
    set --local ca (set_color $_ggl_color_accent)
    set --local co (set_color $_ggl_color_other)
    set --local cn (set_color normal)    
    
    # url list
    set --local list_cmd
    ## sorted by category
    set --local site_name_youtube "www.youtube.com"
        set --local query_youtube "www.youtube.com/results?search_query="
        set -a list_cmd "youtube"
    set --local site_name_stackoverflow "stackoverflow.com"
        set --local query_stackoverflow "stackoverflow.com/search?q="
        set -a list_cmd "stackoverflow"
    set --local site_name_github "github.com"
        set --local query_github "github.com/search?q="
        set -a list_cmd "github"
    set --local site_name_gh "cli.github.com"
        set --local docs_gh "cli.github.com/manual/"
        set -a list_cmd "gh"        

    set --local site_name_mdn "developer.mozilla.org"
        set --local query_mdn "developer.mozilla.org/search?q="
        set -a list_cmd "mdn"
    set --local site_name_fish "fishshell.com"
        set --local docs_query_fish "fishshell.com/docs/current/search.html?q="
        set --local docs_fish "fishshell.com/docs/current/index.html"
        set -a list_cmd "fish"

    set --local site_name_tmux "github.com/tmux/tmux"
        set -a list_cmd "tmux"
        set --local docs_tmux "github.com/tmux/tmux/wiki"
    set --local site_name_iterm2 "iterm2.com"
        set --local docs_iterm2 "iterm2.com/documentation.html"
        set -a list_cmd "iterm2"

    set --local site_name_zenn "zenn.dev"
        set --local query_zenn "zenn.dev/search?q="
        set -a list_cmd "zenn"
    set --local site_name_qiita "qiita.com"
        set --local query_qiita "qiita.com/search?q="
        set -a list_cmd "qiita"

    set --local site_name_typescript "typescriptlang.org"
        set --local docs_typesccript "www.typescriptlang.org/docs/"
        set -a list_cmd "typescript"
    set --local site_name_rust "www.rust-lang.org"
        set --local docs_rust "doc.rust-lang.org/reference"
        set --local docs_query_rust "doc.rust-lang.org/reference/index.html?search="
        set -a list_cmd "rust"

    set --local site_name_npm "www.npmjs.com"
        set --local query_npm "www.npmjs.com/search?q="
        set -a list_cmd "npm"
    set --local site_name_yarn "yarnpkg.com"
        set -a list_cmd "yarn"

    set --local site_name_deno "deno.land"
        set --local docs_deno "deno.land/manual"
        set -a list_cmd "deno"
    set --local site_name_node "nodejs.org"
        set --local docs_node "nodejs.org/en/docs/"
        set -a list_cmd "node"

    set --local site_name_tokio "tokio.rs"
        set --local docs_query_tokio "docs.rs/tokio/latest/tokio/?search="
        set -a list_cmd "tokio"

    set --local site_name_angular "angular.io"
        set --local docs_angular "angular.io/docs/ts/latest/api"
        set --local docs_query_angular "angular.io/docs/ts/latest/api/#!?url="
        set -a list_cmd "angular"
    set --local site_name_react "reactjs.org"
        set --local docs_react "reactjs.org/docs/getting-started.html"
        set -a list_cmd "react"
    set --local site_name_vue "vuejs.org"
        set --local docs_vue "vuejs.org/guide/introduction.html"
        set -a list_cmd "vue"
    set --local site_name_nextjs "nextjs.org"
        set --local docs_nextjs "nextjs.org/docs/getting-started"
        set -a list_cmd "nextjs"
    set --local site_name_svelte "svelte.dev"
        set --local docs_svelte "svelte.dev/docs"
        set -a list_cmd "svelte"
    set --local site_name_storybook "storybook.js.org"
        set --local docs_storybook "storybook.js.org/docs/react/get-started/introduction"
        set -a list_cmd "storybook"

    set --local site_name_bem "en.bem.info"
        set --local docs_bem "en.bem.info/methodology/quick-start/"
        set -a list_cmd "bem"
    set --local site_name_tailwindcss "tailwindcss.com"
        set --local docs_tailwindcss "tailwindcss.com/docs"
        set -a list_cmd "tailwindcss"

    set --local site_name_emojipedia "emojipedia.org"
        set --local query_emojipedia "emojipedia.org/search/?q="
        set -a list_cmd "emojipedia"
    set --local site_name_codepen "codepen.io"
        set --local query_codepen "codepen.io/search?q="
        set -a list_cmd "codepen"

    set --local site_name_vscode "code.visualstudio.com"
        set --local docs_query_vscode "code.visualstudio.com/Search?q="
        set --local docs_vscode "code.visualstudio.com/docs"
        set -a list_cmd "vscode"
    set --local site_name_neovim "neovim.io"
        set --local docs_neovim "neovim.io/doc/general/"
        set -a list_cmd "neovim"

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
    else if set -q _flag_list || test "$argv[1]" = "ls" || set -q _flag_long
        if set -q _flag_long
            echo $cc"[Long list]" $cn
        else
            echo $cc"[Site list]" $cn
        end

        for i in (seq (count $list_cmd))
            set --local cmd_name
            set --local indirect_site_name

            set cmd_name $list_cmd[$i]
            set indirect_site_name site_name_$cmd_name
            echo ""$ca $cmd_name':'$co $$indirect_site_name $cn

            if set -q _flag_long
                set --local num_flag
                set --local item_query
                set --local item_docs
                set --local item_docs_query

                set --local flag_query
                set --local flag_docs
                set --local flag_docs_query

                set --local stamp_query "├──"
                set --local stamp_docs "├──"
                set --local stamp_docs_query "├──"

                if set -q query_$cmd_name
                    set item_query query_$cmd_name
                    set flag_query true
                    set num_flag 1
                end

                if set -q docs_$cmd_name
                    set item_docs docs_$cmd_name
                    set flag_docs true
                    set num_flag 2
                end

                if set -q docs_query_$cmd_name
                    set item_docs_query docs_query_$cmd_name
                    set flag_docs_query true
                    set num_flag 3
                end

                switch "$num_flag"
                    case 1
                        set stamp_query "└──"
                    case 2
                        set stamp_docs "└──"
                    case 3
                        set stamp_docs_query "└──"
                end
                test "$flag_query" = "true"; and \
                    echo " "$ca $stamp_query "query: "$co (string join "" "https://" $$item_query) $cn
                test "$flag_docs" = "true"; and \
                    echo " "$ca $stamp_docs "docs: "$co (string join "" "https://" $$item_docs) $cn
                test "$flag_docs_query" = "true"; and \
                    echo " "$ca $stamp_docs_query "docs query: "$co (string join "" "https://" $$item_docs_query) $cn
            end
        end
        return
    end


    # main: new implementation
    if functions --query ggl
        set --local ts (string join "" "$argv")
        if set -q site_name_$argv[1] && test -n "$ts"
            if test (count $argv) -gt 1 && not test "$argv[2]" = "-t"
                # echo "with keyword" # for testing
                set --local indirect
                set --local site_flag
                set --local param
                if set -q docs_query_$argv[1]
                    set indirect docs_query_$argv[1]
                else if set -q query_$argv[1]
                    set indirect query_$argv[1]
                else
                    set indirect site_name_$argv[1]
                    set site_flag "true"
                end

                if test "$site_flag" = "true"
                    eval ggl $argv[2..-1] --site=$$indirect
                else 
                    set param (string join "" "https://" $$indirect)
                    eval ggl $argv[2..-1] --url=$param
                end
            else
                # echo "without keyword" # for testing
                set --local indirect
                if set -q docs_$argv[1]
                    set indirect docs_$argv[1]
                else 
                    set indirect site_name_$argv[1]
                end

                set --local base_url (string join "" "https://" $$indirect)

                if test "$argv[2]" = "-t"
                    eval ggl --test --noq --url=$base_url
                else
                    eval ggl --noq --url=$base_url
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
    echo '          --list      Show the list of all site names'
    echo '          --long      Show the long list of all urls & sites'
    echo 'Subcommands:'
    echo '      [base]          g(ggl) help ls'
    echo '      [basic]         youtube stackoverflow'
    echo '      [MDN]           mdn' 
    echo '      [shell]         fish'
    echo '      [terminal]      tmux iterm2'
    echo '      [editor]        vscode neovim'
    echo '      [github]        github gh'
    echo '      [japanese]      zenn qiita'
    echo '      [language]      rust typescript'
    echo '      [pkg manager]   npm yarn'
    echo '      [js runtime]    node deno'
    echo '      [rust runtime]  tokio'
    echo '      [framework]     vue react angular svelte nextjs storybook'
    echo '      [css]           bem tailwindcss'
    echo '      [emoji]         emojipedia'
    echo '      [other]         codepen'
    set_color normal
end

