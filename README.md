<div align="center">
    <img 
        alt="ggl fish logo" 
        width="100%"
        src="https://user-images.githubusercontent.com/50942816/150681899-38ed9c2b-2867-4011-8d55-204cecfec44f.png" 
    />
</div>

# ggl.fish 🏄🏻‍♂️

> *Simple Google Search from the command line for [fish shell](https://fishshell.com)*

<img src="https://user-images.githubusercontent.com/50942816/151814043-45766fe8-84e1-4eb8-acf1-1fb543335d73.gif" width="100%" height="auto">

This is a simple fish plugin for Google searching from the command line.  
Easy to manipulate Google query parameters with command options.   
You can do the things below with this plugin.  

- URL encoding for multibyte character (CJK)
- Choose your favorite browser
- Google Search Options:
    - Exact Match
    - Image Search
    - Specific Language Search
    - Disable Personalized Search
    - Restrict search results within specified time range
    - Exclude multiple words from your search
    - Suffix addtinal search parameters
    - Autosuggest these options
- Simple search on specific sites:
    - Github
    - Youtube
    - Stack overflow
    - fish shell docs
    - Specified URL (if query is possible)
    - For Japanese Users: Zenn, Qiita
- Interactive Search Mode (Shiny new thing from v1.6.0)
    - Sequential Search Mode
    - Option Selective Search Mode

This plugin is developed mainly for macOS.   
For Linux distributions, `ggl` internally excutes `xdg-open` instead of macOS's `open` command.  

## Requirements
- fish shell 3.2.0+
- For Linux distributions: [xdg-utils](https://www.freedesktop.org/wiki/Software/xdg-utils/)

## Installation

Using [fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install yo-goto/ggl.fish
```

Update

```console
fisher update yo-goto/ggl.fish
```

## Usage

```console
ggl [OPTIONS] SEARCHWORDS
```

`ggl` command can accept mutiple strings (like "how to use fish shell") for searching.  

Examples:  

```shell
ggl how to use fish shell
# search by a phrase "how to use fish shell"

ggl -p how to use fish shell
# search with exact match, ues -p or --perfect option

ggl -l=en English search
ggl -l=ja 日本語検索
# specific language search with -l or --lang option 
# language option is helpful to search with non native language

ggl -e English search
# search in English, you can alse use -e or --english option
```

`ggl.fish` internally generates searchable URLs.  
To confirm a generated URL, use `-t` or `--test` option.  
This test option can be combined with any other options.  

Test Examples:  

```console
$ ggl -t how to use fish shell
 Keyword    :  how to use fish shell
 Encoded    :  how+to+use+fish+shell
 Search URL :  https://www.google.com/search?q=how+to+use+fish+shell
$ ggl -tei cat cute photo
 Keyword    :  cat cute photo
 Encoded    :  cat+cute+photo
 Language   :  English
 Search URL :  https://www.google.com/search?q=cat+cute+photo&lr=lang_en&tbm=isch
$ ggl fish plugin -g --test
 Keyword    :  fish plugin
 Encoded    :  fish+plugin
 Site       :  Github
 Search URL :  https://github.com/search?q=fish+plugin
$ ggl fish shell -x=advanced -x=bash --test
 Keyword    :  fish shell
 Excluded   :  advanced bash
 Encoded    :  fish+shell+-advanced+-bash
 Search URL :  https://www.google.com/search?q=fish+shell+-advanced+-bash
$ ggl fishシェル -x=シェルダー -l=ja --test
 Keyword    :  fishシェル
 Excluded   :  シェルダー
 Encoded    :  fish%E3%82%B7%E3%82%A7%E3%83%AB+-%E3%82%B7%E3%82%A7%E3%83%AB%E3%83%80%E3%83%BC
 Language   :  Japanese
 Search URL :  https://www.google.com/search?q=fish%E3%82%B7%E3%82%A7%E3%83%AB+-%E3%82%B7%E3%82%A7%E3%83%AB%E3%83%80%E3%83%BC&lr=lang_ja
$ ggl fish plugin -x=fisher -r=y1 -e --test
 Keyword    :  fish plugin
 Excluded   :  fisher
 Encoded    :  fish+plugin+-fisher
 Language   :  English
 Time Range :  y1
 Search URL :  https://www.google.com/search?q=fish+plugin+-fisher&lr=lang_en&tbs=qdr:y1
$ ggl --test fish swimming -a=tbm=vid -a=filter=1
 Keyword    :  fish swimming
 Encoded    :  fish+swimming
 Search URL :  https://www.google.com/search?q=fish+swimming&tbm=vid&filter=1
```

These test results can be seen with `-d` or `--debug` option without opening a browser. 
The debug option internally runs `ggl --test` for some test cases.

To pass a generated URL to any text proceccing, use `-o` or `--output` option. It just prints the URL.

```console
$ ggl -o how to use fish shell
https://www.google.com/search?q=how+to+use+fish+shell
$ string split '/' (ggl -o how to use fish shell)
https:

www.google.com
search?q=how+to+use+fish+shell
```

## Options

Help Options
- `-h` or `--help`          : Show Help
- `-v` or `--version`       : Show Version Info

Utility Options
- `-t` or `--test`          : Test URL Generation
- `-o` or `--output`        : Print generated URL
- `-d` or `--debug`         : Print some tests
- `--quiet`                : Open URL without printing anything

Special Option
- `-m` or `--mode`          : Interactive Search Mode
  
Browser Options (uppercase letter)  
If not specified, ggl opens URL with default browser.  
- `-C` or `--Chrome`        : Google Chrome
- `-S` or `--Safari`        : Safari
- `-F` or `--Firefox`       : Firefox
- `-V` or `--Vivaldi`       : Vivaldi
- `-B` or `--Brave`         : Brave
- `-b` or `--browser`       : Other Browser

After `-b` option, type browser name (ex: `-b=Opera`).

Google Search Options
- `-e` or `--english`        : English Search
- `-i` or `--image`          : Image Search
- `-p` or `--perfect`        : Exact Match
- `-n` or `--nonperson`      : Disable Personalized Search
- `-l` or `--lang`           : Specific Language Search
- `-r` or `--range`          : Time Range for Searching
- `-x` or `--exclude`        : Exclude words from search
- `-a` or `--additional`     : Suffix addtional search parameters to URL

After language option `-l`, specify language flag (ex: `-l=en`).

Valid Flag | Language
--|--
`e` or `en` | English
`j` or `ja` | Japanese
`d` or `de` | German
`f` or `fr` | French
`i` or `it` | Italian
`s` or `es` | Spanish
`r` or `ru` | Russian
`k` or `ko` | Korean
`z` or `zh` | Chinese

After `-r` or `--range` option, spcify time range (ex: `-r=y2`).
If no numbers are specified (like `-r=y`), the time range becomes the same as `-r=y1`.

Range | Time | Example
--|--|--
`h` | Past Hour  | `h6` (within the last 6 hours)
`d` | Past Day   | `d5` (within the last 5 days)
`w` | Past Week  | `w4` (within the last 4 weeks)
`m` | Past Month | `m3` (within the last 3 months)
`y` | Past Year  | `y2` (within the last 2 years)


Site Options
- `-g` or `--github`         : Github
- `-y` or `--youtube`        : YouTube
- `-s` or `--stackoverflow`  : Stack overflow
- `-f` or `--fishdoc`        : fish shell docs

Sites For Japaense Users
- `-z` or `--zenn`           : Zenn
- `-q` or `--qiita`          : Qiita

Other URL options
- `-u` or `--url`            : Specified URL with `=` 
- `--local`                  : Open local host with specified port number (by default, ggl opens `localhost:3000`)

```console
$ ggl -t javascript -u=https://developer.mozilla.org/en-US/search?q=
 Keyword    :  javascript
 Encoded    :  javascript
 Site       :  specified URL
 Search URL :  https://developer.mozilla.org/en-US/search?q=javascript
$ ggl -t --local
 Keyword    :
 Encoded    :
 Site       :  localhost:3000
 Search URL :  http://localhost:3000
$ ggl test/page --local=6000 --test
 Keyword    :  test/page
 Encoded    :  test/page
 Site       :  localhost:6000
 Search URL :  http://localhost:6000/test/page
```

## Interactive Mode

To enter the interactive search mode, use `-m` or `--mode` option flag.
Two types of mode are avilable.

```console
$ ggl --mode
>> Interactive Mode
Select Mode [s/sequential | o/optional | e/exit]:
```

## Development

- This code is originally based on my [gist](https://gist.github.com/yo-goto/7acfa712006488466d73ff42b9d952cc).
- Code explanation is [here](https://zenn.dev/estra/articles/google-search-from-fish-shell) (in Japanese).
- Logo font: [Fish font](https://booth.pm/ja/items/2302848)

## Contributing

Pull requests are welcom. 

## Change Log

- v1.6.2
    - New Feature
        - added local host option (ggl opens `localhost:3000` with `--local` flag)
    - Improvement
        - cleaned the code
        - modified test and debug option
- v1.6.1
    - Improvement
        - made option handling more stable
        - made `open` command more stable
        - modified debug & help options
- v1.6.0
    - New Feature
        - Interactive Mode 
        - quiet option
    - Improvement
        - Code Refactoring: Split main function into some helper function


