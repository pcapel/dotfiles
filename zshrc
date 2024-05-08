eval "$(/opt/homebrew/bin/brew shellenv)"
alias reload='source ~/.zshrc; echo -e "\n \u2699  \e[33mReloaded ZSH Config\e[0m \u2699"'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Explicitly set the path for vim init.lua
# TODO: figure out how I borked this installation to not look in the right place...
export MY_VIMRC="$HOME/.config/nvim/init.lua"
alias vim="nvim -u $MY_VIMRC"

export EDITOR=nvim
export OMZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# set XDG paths
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"


# AWS cli Configs
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"

# ASDF path
export ASDF_DIR=~/.asdf

# Setup env vars for gene synthesis scripting
export GENE_SYNTHESIS_OUTPUT_DIR=/Users/Philip.Capel/tmp/gene_synth
export GENE_SYNTHESIS_INPUT_DIR=/Users/Philip.Capel/tools/aws_lambda/containers/gene_synthesis/test/files

# https://stackoverflow.com/questions/62931101/i-have-multiple-files-of-zcompdump-why-do-i-have-multiple-files-of-these
export ZSH_COMPDUMP=$OMZSH/cache/.zcompdump-$HOST

# default apps
(( ${+PAGER}   )) || export PAGER='less'
(( ${+EDITOR}  )) || export EDITOR='nvim'
export PSQL_EDITOR='vim -c"setf sql"'


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $OMZSH/oh-my-zsh.sh
source $XDG_CONFIG_HOME/zsh/aliases.zsh


# history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

. $ASDF_DIR/asdf.sh
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# bun completions
[ -s "/Users/philip.capel/.bun/_bun" ] && source "/Users/philip.capel/.bun/_bun"

# [ -s "/Users/philip.capel/projects/lex-workflows/_workflow_completions" ] && source "/Users/philip.capel/projects/lex-workflows/_workflow_completions"

case ":$PATH:" in
  *:"/usr/local/sbin":*)
    PATH=$PATH
    ;;
  *) 
    PATH="/usr/local/sbin:$PATH"
    ;;
esac

case ":$PATH:" in
  *:"/Users/Philip.Capel/.local/bin":*)
    PATH=$PATH
    ;;
  *) 
    PATH="/Users/Philip.Capel/.local/bin:$PATH"
    ;;
esac

case ":$PATH:" in
  *:"/usr/local/bin":*)
    PATH=$PATH
    ;;
  *) 
    PATH="/usr/local/bin:$PATH"
    ;;
esac
