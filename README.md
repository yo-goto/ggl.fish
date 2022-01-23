<div align="center">
    <img 
        alt="ggl fish logo" 
        width="100%"
        src="https://user-images.githubusercontent.com/50942816/150681899-38ed9c2b-2867-4011-8d55-204cecfec44f.png" 
    />
</div>

# ggl.fish 🏄🏻‍♂️

> *Simple Google Search from [fish shell](https://fishshell.com)*

This is a simple tool for Google searching from command line made with fish language.   
You can do things below with this script.  

- Choose your favorite browser
- Google Search Options
    - Exact Match
    - Image Search
    - Language Setting
    - Disable Personalized Search
- Search with specific sites:
    - Github
    - Youtube
    - Stack overflow
    - For Japanese Users: Zenn, Qiita

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
- `-v` or `--version`   : Show Version Info
- `-t` or `--test`      : Test URL Generation

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

After language option, pass language flag with `=`.

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

Site Options
- `-g` or `--github`    : Github
- `-y` or `--youtube`   : YouTube
- `-S` or `--stack`     : Stack overflow

Sites For Japaense Users
- `-z` or `--zenn`      : Zenn
- `-q` or `--qiita`     : Qiita


## Develpment

- This code is originally based on my [gist](https://gist.github.com/yo-goto/7acfa712006488466d73ff42b9d952cc).
- Code explanation is [here](https://zenn.dev/estra/articles/google-search-from-fish-shell) (in Japanese).

## Contributing

Pull requests are welcom. 

