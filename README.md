# ggl.fish

> Simple Google Search from fish shell

This is a simple tool for Google searching from command line made by fish language.   
You can do things below with this script.  

- Select your favorite browser
- Google Search Options
    - Exact Match
    - Language Selection
    - Image Search
- Search with specific sites

## Installation

Using fisher:

```shell
fisher install yo-goto/ggl.fish
```

## Usage

```shell
ggl [OPTIONS] SEARCHWORDS

# possible to type multiple strings
# like this: search by a phrase "how to use fish shell"
ggl how to use fish shell

# if you want to search with exact match, ues -p or --perfect option
ggl -p how to use fish shell
# specific language search with -l or --lang option
ggl -l=e 日本語
# if you want to search in English, you can alse use -e or --english option
ggl -e 日本語
```

`ggl.fish` generate searchable URLs.  
If you want to confirm URL, use `-t` or `--test` option.  
This test option can be combined with any other options.  

```shell
$ ggl -t how to use fish shell
Keyword     :  how to use fish shell
URL encoding:  how%20to%20use%20fish%20shell
Search URL  :  https://www.google.com/search?q=how%20to%20use%20fish%20shell
$ ggl -tei cat cute photo
Keyword     :  cat cute photo
URL encoding:  cat%20cute%20photo
Search URL  :  https://www.google.com/search?q=cat%20cute%20photo&lr=lang_en&tbm=isch
```

### Options

Utility Options
- `-h` or `--help`      : Show Help
- `-t` or `--test`      : Test URL Generation
- `-v` or `--version`   : Show Version Info

```shell
$ ggl -t 
Keyword     : how to use fish
URL encoding: how%20to%20use%20fish
Search URL  : https://www.google.com/search?q=how%20to%20use%20fish
```

The `test` option can be combined with other options below. 

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
- `-z` or `--stack`     : Stack overflow


