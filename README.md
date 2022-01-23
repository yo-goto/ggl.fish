# ggl.fish

> Simple Google Search from [fish shell](https://fishshell.com)

This is a simple tool for Google searching from command line made with fish language.   
You can do things below with this script.  

- Use your favorite browser
- Google Search Options
    - Exact Match
    - Language Selection
    - Image Search
    - Diable Personalized Search by Google
- Search with specific sites(github, youtube, stack overflow)
    - For Japanese Users: Zenn, Qiita

## Installation

Using [fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install yo-goto/ggl.fish
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

ggl -e English search
# search in English, you can alse use -e or --english option
```

`ggl.fish` generates searchable URLs.  
To confirm generated URL, use `-t` or `--test` option.  
This test option can be combined with any other options.  

```console
$ ggl -t how to use fish shell
Keyword     :  how to use fish shell
URL encoding:  how%20to%20use%20fish%20shell
Search URL  :  https://www.google.com/search?q=how%20to%20use%20fish%20shell
$ ggl -tei cat cute photo
Keyword     :  cat cute photo
URL encoding:  cat%20cute%20photo
Search URL  :  https://www.google.com/search?q=cat%20cute%20photo&lr=lang_en&tbm=isch
```

## Options

Utility Options
- `-h` or `--help`      : Show Help
- `-t` or `--test`      : Test URL Generation
- `-v` or `--version`   : Show Version Info

Browser Options
- `-c` or `--chrome`    : Google Chrome
- `-s` or `--safari`    : Safari
- `-f` or `--firefox`   : Firefox
- `-V` or `--vivaldi`   : Vivaldi

Google Search Options
- `-e` or `--english`   : English Search
- `-i` or `--image`     : Image Search
- `-p` or `--perfect`   : Exact Match
- `-n` or `--nonperson` : Disable Personalized Search
- `-l` or `--lang`      : Language
    - `e` or `en`       : English
    - `j` or `ja`       : Japanese
    - `d` or `de`       : German
    - `f` or `fr`       : French
    - `i` or `it`       : Italian
    - `s` or `es`       : Spanish
    - `r` or `ru`       : Russian
    - `k` or `ko`       : Korean
    - `z` or `zh`       : Chinese

Site Options
- `-g` or `--github`    : Github
- `-y` or `--youtube`   : YouTube
- `-S` or `--stack`     : Stack overflow

Sites For Japaense Users
- `-z` or `--zenn`      : Zenn
- `-q` or `--qiita`     : Qiita


