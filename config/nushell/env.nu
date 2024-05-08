# Nushell Environment Config File
#
# version = "0.93.0"

# NOTE: in order to get this to work correctly, I had to set XDG_CONFIG_HOME
# using launchctl per https://stackoverflow.com/a/3756686


# TODO: get prompts to show information about kubernetes context
def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " } # If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
 $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
$env.HOMEBREW_PREFIX = "opt/homebrew"
$env.HOMEBREW_CELLAR = "opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "opt/homebrew"
$env.PATH = ($env.PATH | split row (char esep))

use std "path add"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"
path add "/Users/philip.capel/.local/bin"

# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
$env.PATH = ($env.PATH | uniq)

$env.EDITOR = "/opt/homebrew/bin/nvim"
$env.SHELL = "/opt/homebrew/bin/nu"

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

# Vim is Nvim
alias vim = nvim

let _gap = { git add -p }
let _gref = { git --no-pager diff --cached --stat | command grep " |\\s*0$" | awk '{system("command git reset " $1)}' }
let _gnap = { git add -N --ignore-removal .; do $_gap; do $_gref  }

# Git aliases that I'm used to
alias gap = do $_gap
alias gb = git branch
alias gc = git commit -v
alias gca = git commit -a -v
alias gcl = git clean -f -d
alias gco = git checkout
alias gd = git diff
alias gdc = git diff --cached
alias gdh = git diff HEAD
alias gl = git pull
alias glg = git log --graph --oneline --decorate --color --all
alias glod = git log --oneline --decorate
alias glp = git log -p
alias gnap = do $_gnap
alias gp = git push
alias gplease = git push --force-with-lease
alias gpr = git pull --rebase
alias gr = git rebase
alias gra = git rebase --abort
alias grc = git rebase --continue
alias grim = git rebase -i main
alias gst = git status
alias gref = do $_gref

# Fun stuff for mix
alias mget = mix deps.get
alias phs = mix phx.server

# Aliasing kubectl this way has the added benefit of causing the docker prompt to display the configured context prior to opening k9s
alias k = kubectl

# ls easier
alias l = ls -a
alias ll = ls -alh

# Common operations when not inside of a poetry shell
alias pr = poetry run
alias pri = poetry run ipython
alias ppy = poetry run python

# random stuff

# TODO: Figure out how to make this work
# Add a new branch fresh off of main
# Alternatively, a fresh branch off of some other branch
# function fresh-branch() {
#   echo "Creating a new branch for $1"
#   if [ -z "$2" ]; then
#     git checkout main && gpr && git checkout -b $1
#   else
#     git checkout $2 && gpr && git checkout -b $1
#   fi
# }

# TODO: Figure out how to make this work
# gref() {
#   command 
# }

let mise_path = $nu.default-config-dir | path join scripts mise.nu
~/.local/bin/mise activate nu | save $mise_path --force
