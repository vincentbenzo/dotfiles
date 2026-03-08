# --- OH MY ZSH SETUP ---
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  kubectl
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- PLUGIN TWEAKS (Best after source) ---

# 1. Prevent autosuggestions from interfering with Vi movement
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(
  vi-backward-char
  vi-forward-char
  vi-insert
  vi-add-next
  vi-add-eol
  vi-end-of-line
  history-search-forward
  history-search-backward
)

# 2. Clear suggestions when entering Normal Mode
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(vicmd-mode)

# --- BATTLE STATION CORE ---

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

alias ls="eza --icons --group-directories-first"
alias ll="eza -al --icons --group-directories-first"
alias cat="bat"
alias vim="nvim"
alias k="kubectl"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- VI-MODE KEYBINDINGS ---
bindkey -v

# Fix: 'A' and '$' in Normal mode should not accept the autosuggestion
function vi-move-no-autosuggest() {
  zle autosuggest-clear
  zle $WIDGET_ORIG
}

# Wrap 'A' (vi-add-eol)
function vi-append-no-autosuggest() {
  zle autosuggest-clear
  zle vi-add-eol
}
zle -N vi-append-no-autosuggest
bindkey -M vicmd 'A' vi-append-no-autosuggest

# Wrap '$' (vi-end-of-line)
function vi-eol-no-autosuggest() {
  zle autosuggest-clear
  zle vi-end-of-line
}
zle -N vi-eol-no-autosuggest
bindkey -M vicmd '$' vi-eol-no-autosuggest

bindkey '^f' autosuggest-accept        # Ctrl+f
bindkey '^[[C' autosuggest-accept     # Right Arrow
bindkey -M vicmd '^[[C' autosuggest-accept
bindkey -M viins 'jj' vi-cmd-mode     # Quick 'Esc'

# --- CLOUD & K8S POWER TOOLS ---

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
GRANTED_PATH="/opt/homebrew/bin/assume"

if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
    alias k='kubectl'
    compdef _kubectl k
fi

alias kctx="kubectx | fzf --height 40% --reverse | xargs kubectx"
alias kns="kubens | fzf --height 40% --reverse | xargs kubens"

AWS_COMPLETER_PATH=$(which aws_completer)
[ -n "$AWS_COMPLETER_PATH" ] && complete -C "$AWS_COMPLETER_PATH" aws

alias kgp="k get pods"
alias kgs="k get svc"
alias kgi="k get ingress"

# --- THE FUZZY SWITCHER ENGINE ---

unalias assume ass dass ksw 2>/dev/null

if [ -f "$GRANTED_PATH" ]; then
    alias assume=". $GRANTED_PATH"
    alias ass='unset AWS_PROFILE; assume $(aws configure list-profiles | fzf --height 40% --reverse --header "Select AWS Profile")'

    ksw() {
      local cluster
      echo "🔍 Fetching EKS clusters for current account..."
      cluster=$(aws eks list-clusters --query 'clusters' --output text | tr '\t' '\n' | fzf --height 40% --reverse --header "Select EKS Cluster")

      if [ -n "$cluster" ]; then
        echo "☸️ Connecting to: $cluster..."
        aws eks update-kubeconfig --name "$cluster" --region ${AWS_REGION:-us-east-1}
        echo "✅ Connected to $cluster."
      fi
    }

    alias dass='unset AWS_PROFILE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN; kubectl config unset current-context; echo "☁️ AWS Disconnected & ☸️ K8s Context Cleared"'
else
    echo "⚠️ Warning: Granted 'assume' binary not found at $GRANTED_PATH"
fi

export PATH="$PATH:$(python3 -m site --user-base)/bin"
export PATH="$PATH:$HOME/.local/bin"
