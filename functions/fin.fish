function fin --description "ggl wrapper for frontend developers"
    argparse --stop-nonopt 'v/version' 'h/help' 'd/debug' -- $argv

    set --local version_fin "v0.0.5"
    # color shortcut
    set --local cc (set_color $_ggl_color)
    set --local cn (set_color normal)
    
    set --local param_url
    set --local base_url
    set --local param_site

    ## also available from ggl command
    set --local url_youtube "https://www.youtube.com/results?search_query="
        set --local base_youtube "https://www.youtube.com/"
    set --local url_github "https://github.com/search?q="
        set --local base_github "https://github.com/"
    set --local url_stackoverflow "https://stackoverflow.com/search?q="
        set --local base_stackoverflow "https://stackoverflow.com/"
    set --local url_zenn "https://zenn.dev/search?q="
        set --local base_zenn "https://zenn.dev/"
    set --local url_qiita "https://qiita.com/search?q="
        set --local base_qiita "https://qiita.com/"

    set --local url_mdn "https://developer.mozilla.org/search?q="
        set --local base_mdn "https://developer.mozilla.org/"
    set --local url_angular "https://angular.io/docs/ts/latest/api/#!?url="
        set --local base_angular "https://angular.io/docs/ts/latest/api/"
    set --local url_codepen "http://codepen.io/search?q="
        set --local base_codepen "http://codepen.io/"
    set --local url_npm "https://www.npmjs.com/search?q="
        set --local base_npm "https://www.npmjs.com/"
    set --local url_emojipedia "https://emojipedia.org/search/?q="
        set --local base_emojipedia "https://emojipedia.org/"
    set --local url_rust "https://doc.rust-lang.org/reference/index.html?search="
        set --local base_rust "https://doc.rust-lang.org/reference/"

    set --local site_node "nodejs.org"
    set --local site_deno "deno.land"
    set --local site_vue "vuejs.org"
    set --local site_react "reactjs.org"
    set --local site_typescript "typescriptlang.org"
    set --local site_storybook "storybook.js.org"
    set --local site_bem "en.bem.info"
    set --local site_nextjs "nextjs.org"
    set --local site_yarn "yarnpkg.com"

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
    end 

    if functions --query ggl
        set --local ts (string join "" "$argv")
        if set -q url_$argv[1] && test -n "$ts"
            # indirect varibale reference
            # echo $cc "query URL  :" $cn $$param_url
            if test (count $argv) -gt 2
                set param_url url_$argv[1]
                eval ggl $argv[2..-1] --url=$$param_url
            else 
                set base_url base_$argv[1]
                eval ggl --noq --url=$$base_url
            end 
        else if set -q site_$argv[1] && test -n "$ts"
            # echo $c "Site name  :" $cn $$param_site
            if test (count $argv) -gt 2
                set param_site site_$argv[1]
                eval ggl $argv[2..-1] --site=$$param_site
            else
                set -l prep site_$argv[1]
                set base_url (string join '' 'https://' $$prep)
                eval ggl --noq --url=$base_url
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
    echo '      fin [KEYWORDS...] [ggl options]'
    echo '      fin g [KEYWORDS...] [ggl options]'
    echo '      fin ggl [KEYWORDS...] [ggl options]'
    echo '      fin SUBCOMMAND [KEYWORDS...] [ggl options]'
    echo 'Options: '
    echo '      -v, --version  : Show version info'
    echo '      -h, --help     : Show help'
    echo '      -d, --debug    : Show debug tests'
    echo 'Available subcommands:'
    echo '      [base]         g(ggl) help'
    echo '      [basic]        youtube github stackoverflow,'
    echo '      [japanese]     zenn qiita'
    echo '      [emoji]        emojipedia'
    echo '      [MDN]          mdn' 
    echo '      [js runtime]   node deno'
    echo '      [pkg manger]   npm yarn'
    echo '      [framework]    vue react angular nextjs storybook'
    echo '      [language]     rust typescript'
    echo '      [css]          bem'
    echo '      [other]        codepen'
    set_color normal
end

