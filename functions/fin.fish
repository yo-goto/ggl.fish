function fin --description "ggl wrapper for frontend developers"
    argparse \
        -x 'v,h,d,list,long' \
        --stop-nonopt 'v/version' 'h/help' 'd/debug' 'list' 'long' -- $argv
    or return 1

    set -l version_fin "v0.1.5"

    # color shortcut
    set -l cc (set_color $_ggl_color)
    set -l ca (set_color $_ggl_color_accent)
    set -l co (set_color $_ggl_color_other)
    set -l cn (set_color normal)
    set -l tb (set_color -o)
    
    # url list
    set -l list_cmd

    ## sorted by category
    ### basic
    set -l site_name_youtube "www.youtube.com"
        set -l query_youtube "www.youtube.com/results?search_query="
        set -a list_cmd "youtube"
    set -l site_name_stackoverflow "stackoverflow.com"
        set -l query_stackoverflow "stackoverflow.com/search?q="
        set -a list_cmd "stackoverflow"
    
    ### git, github
    set -l site_name_git "git-scm.com"
        set -l docs_query_git "git-scm.com/search/results?search="
        set -l docs_git "git-scm.com/doc"
        set -a list_cmd "git"
    set -l site_name_github "github.com"
        set -l query_github "github.com/search?q="
        set -a list_cmd "github"
    set -l site_name_gh "cli.github.com"
        set -l docs_gh "cli.github.com/manual/"
        set -a list_cmd "gh"        
    
    ### mdn
    set -l site_name_mdn "developer.mozilla.org"
        set -l query_mdn "developer.mozilla.org/search?q="
        set -a list_cmd "mdn"
    set -l site_name_fish "fishshell.com"
        set -l docs_query_fish "fishshell.com/docs/current/search.html?q="
        set -l docs_fish "fishshell.com/docs/current/index.html"
        set -a list_cmd "fish"

    ### terminal
    set -l site_name_tmux "github.com/tmux/tmux"
        set -a list_cmd "tmux"
        set -l docs_tmux "github.com/tmux/tmux/wiki"
    set -l site_name_iterm2 "iterm2.com"
        set -l docs_iterm2 "iterm2.com/documentation.html"
        set -a list_cmd "iterm2"

    ### editor
    set -l site_name_vscode "code.visualstudio.com"
        set -l docs_query_vscode "code.visualstudio.com/Search?q="
        set -l docs_vscode "code.visualstudio.com/docs"
        set -a list_cmd "vscode"
    set -l site_name_neovim "neovim.io"
        set -l docs_neovim "neovim.io/doc/general/"
        set -a list_cmd "neovim"

    ### Japanese knowledgebase
    set -l site_name_zenn "zenn.dev"
        set -l query_zenn "zenn.dev/search?q="
        set -a list_cmd "zenn"
    set -l site_name_qiita "qiita.com"
        set -l query_qiita "qiita.com/search?q="
        set -a list_cmd "qiita"

    ### languages
    set -l site_name_typescript "typescriptlang.org"
        set -l docs_typesccript "www.typescriptlang.org/docs/"
        set -a list_cmd "typescript"
    set -l site_name_rust "www.rust-lang.org"
        set -l docs_rust "doc.rust-lang.org/reference"
        set -l docs_query_rust "doc.rust-lang.org/reference/index.html?search="
        set -a list_cmd "rust"

    ### pkg manager
    set -l site_name_npm "www.npmjs.com"
        set -l query_npm "www.npmjs.com/search?q="
        set -a list_cmd "npm"
    set -l site_name_yarn "yarnpkg.com"
        set -a list_cmd "yarn"

    ### trends
    set -l site_name_npmtrends "www.npmtrends.com"
        set -l query_npmtrends "www.npmtrends.com/"
        set -a list_cmd "npmtrends"

    ### js runtims
    set -l site_name_deno "deno.land"
        set -l docs_deno "deno.land/manual"
        set -a list_cmd "deno"
    set -l site_name_node "nodejs.org"
        set -l docs_node "nodejs.org/en/docs/"
        set -a list_cmd "node"

    ### rust runtime
    set -l site_name_tokio "tokio.rs"
        set -l docs_query_tokio "docs.rs/tokio/latest/tokio/?search="
        set -a list_cmd "tokio"

    ### framework
    set -l site_name_angular "angular.io"
        set -l docs_angular "angular.io/docs/ts/latest/api"
        set -l docs_query_angular "angular.io/docs/ts/latest/api/#!?url="
        set -a list_cmd "angular"
    set -l site_name_react "reactjs.org"
        set -l docs_react "reactjs.org/docs/getting-started.html"
        set -a list_cmd "react"
    set -l site_name_vue "vuejs.org"
        set -l docs_vue "vuejs.org/guide/introduction.html"
        set -a list_cmd "vue"
    set -l site_name_nextjs "nextjs.org"
        set -l docs_nextjs "nextjs.org/docs/getting-started"
        set -a list_cmd "nextjs"
    set -l site_name_svelte "svelte.dev"
        set -l docs_svelte "svelte.dev/docs"
        set -a list_cmd "svelte"
    set -l site_name_storybook "storybook.js.org"
        set -l docs_storybook "storybook.js.org/docs/react/get-started/introduction"
        set -a list_cmd "storybook"

    ### css methodology
    set -l site_name_bem "en.bem.info"
        set -l docs_bem "en.bem.info/methodology/quick-start/"
        set -a list_cmd "bem"
    
    ### css framework
    set -l site_name_tailwindcss "tailwindcss.com"
        set -l docs_tailwindcss "tailwindcss.com/docs"
        set -a list_cmd "tailwindcss"
    set -l site_name_daisyui "daisyui.com"
        set -a list_cmd "daisyui"
    set -l site_name_chakraui "chakra-ui.com"
        set -l docs_chakraui "chakra-ui.com/guides/first-steps"
        set -a list_cmd "chakraui"
    set -l site_name_mui "mui.com"
        set -l docs_mui "mui.com/getting-started/installation/"
        set -a list_mui "mui"

    ### emoji
    set -l site_name_emojipedia "emojipedia.org"
        set -l query_emojipedia "emojipedia.org/search/?q="
        set -a list_cmd "emojipedia"

    ### other
    set -l site_name_codepen "codepen.io"
        set -l query_codepen "codepen.io/search?q="
        set -a list_cmd "codepen"

    # option handling
    if set -q _flag_version
        functions --query ggl; and \
        eval ggl -v
        echo 'fin.fish:' $version_fin
        return
    else if set -q _flag_help || test "$argv[1]" = "help"
        __fin_help
        return
    else if set -q _flag_debug
        __fin_debug
        return
    else if set -q _flag_list || test "$argv[1]" = "ls" || set -q _flag_long
        if set -q _flag_long || test "$argv[2]" = "long"
            echo "[Long list]"
        else
            echo "[Site list]"
        end

        for i in (seq (count $list_cmd))
            set --local cmd_name
            set --local indirect_site_name

            set cmd_name $list_cmd[$i]
            set indirect_site_name site_name_$cmd_name
            echo ""$ca $cmd_name':'$cc $$indirect_site_name $cn

            if set -q _flag_long || test "$argv[2]" = "long"
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
                    echo " " $stamp_query $ca"query: "$co$tb (string join "" "https://" $$item_query) $cn
                test "$flag_docs" = "true"; and \
                    echo " " $stamp_docs $ca"docs: "$co$tb (string join "" "https://" $$item_docs) $cn
                test "$flag_docs_query" = "true"; and \
                    echo " " $stamp_docs_query $ca"docs query: "$co$tb (string join "" "https://" $$item_docs_query) $cn
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
            __fin_help
            return 1
        end
    else
        echo "can't find ggl function"
        return 1
    end
end


## helper functions
function __fin_debug
    set --local ts
    set -a ts "fin deno fetch -t"
    set -a ts "fin npm gray-matter --test"
    set -a ts "fin mdn JavaScript --test"
    for i in (seq 1 (count $ts))
        echo '$' $ts[$i]; and eval "$ts[$i]"
    end
end


function __fin_help
    set_color $_ggl_color
    echo 'Usage: '
    echo '      fin [fin-OPTION]'
    echo '      fin [KEYWORDS...] [ggl-OPTIONS...]'
    echo '      fin g [KEYWORDS...] [ggl-OPTIONS...]'
    echo '      fin ggl [KEYWORDS...] [ggl-OPTIONS...]'
    echo '      fin SUBCOMMAND [KEYWORDS...] [ggl-OPTIONS...]'
    echo 'Options: '
    echo '      -v, --version      Show version info'
    echo '      -h, --help         Show help'
    echo '      -d, --debug        Show debug tests'
    echo '          --list         Show the list of all site names'
    echo '          --long         Show the long list of all urls & sites'
    echo 'Subcommands:'
    echo '      [base]             g(ggl) help ls'
    echo '      [basic]            youtube stackoverflow'
    echo '      [MDN]              mdn' 
    echo '      [shell]            fish'
    echo '      [terminal]         tmux iterm2'
    echo '      [editor]           vscode neovim'
    echo '      [git,github]       git github gh'
    echo '      [japanese]         zenn qiita'
    echo '      [language]         rust typescript'
    echo '      [pkg manager]      npm yarn'
    echo '      [trends]           npmtrends'
    echo '      [js runtime]       node deno'
    echo '      [rust runtime]     tokio'
    echo '      [framework]        vue react angular svelte nextjs storybook'
    echo '      [css methodology]  bem'
    echo '      [css framework]    tailwindcss daisyui chakraui mui'
    echo '      [emoji]            emojipedia'
    echo '      [other]            codepen'
    set_color normal
end

