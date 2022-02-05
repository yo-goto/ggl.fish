function fin --description "A web search interface"
    argparse 'v/version' 'h/help' -- $argv
    or return

    set --local url_mdn "https://developer.mozilla.org/search?q="
    set --local url_angular "https://angular.io/docs/ts/latest/api/#!?query="
    set --local url_codepen "http://codepen.io/search?q="
    set --local url_cssflow "http://www.cssflow.com/search?q="

    echo "テスト完了"
end