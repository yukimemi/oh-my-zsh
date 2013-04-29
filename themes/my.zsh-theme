## 256色生成用便利関数
### red: 0-5
### green: 0-5
### blue: 0-5
color256()
{
    local red=$1; shift
    local green=$2; shift
    local blue=$3; shift

    echo -n $[$red * 36 + $green * 6 + $blue + 16]
}

fg256()
{
    echo -n $'\e[38;5;'$(color256 "$@")"m"
}

bg256()
{
    echo -n $'\e[48;5;'$(color256 "$@")"m"
}
### プロンプトバーの左側
### %{%B%}...%{%b%}: 「...」を太字にする。
### %{%F{cyan}%}...%{%f%}: 「...」をシアン色の文字にする。
### %n: ユーザ名
### %m: ホスト名（完全なホスト名ではなくて短いホスト名）
### %{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%f%k%b%}:
### 最後に実行したコマンドが正常終了していれば
### 太字で白文字で緑背景にして異常終了していれば
### 太字で白文字で赤背景にする。
### %{%F{white}%}: 白文字にする。
### %(x.true-text.false-text): xが真のときはtrue-textになり
### 偽のときはfalse-textになる。
### ?: 最後に実行したコマンドの終了ステータスが0のときに真になる。
### %K{green}: 緑景色にする。
### %K{red}: 赤景色を赤にする。
### %?: 最後に実行したコマンドの終了ステータス
### %{%k%}: 背景色を元に戻す。
### %{%f%}: 文字の色を元に戻す。
### %{%b%}: 太字を元に戻す。
### %D{%Y/%m/%d %H:%M}: 日付。「年/月/日 時:分」というフォーマット。
prompt_bar_left_self="(%{%B%}%n%{%b%}%{%F{cyan}%}@%{%f%}%{%B%}%m%{%b%})"
prompt_bar_left_status="(%{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%k%f%b%})"
prompt_bar_left_date="<%{%B%}%D{%Y/%m/%d %H:%M}%{%b%}>"
prompt_bar_left="-${prompt_bar_left_self}-${prompt_bar_left_status}-${prompt_bar_left_date}-"
### プロンプトバーの右側
### %{%B%K{magenta}%F{white}%}...%{%f%k%b%}:
### 「...」を太字のマゼンタ背景の白文字にする。
### %d: カレントディレクトリのフルパス（省略しない）
prompt_bar_right="[%{%B%K{magenta}%F{white}%}%d%{%f%k%b%}]-"

### 2行目左にでるプロンプト。
### %h: ヒストリ数。
### %(1j,(%j),): 実行中のジョブ数が1つ以上ある場合だけ「(%j)」を表示。
### %j: 実行中のジョブ数。
### %{%B%}...%{%b%}: 「...」を太字にする。
### %#: 一般ユーザなら「%」、rootユーザなら「#」になる。
#prompt_left="-[%h]%(1j,(%j),)%{%B%}%#%{%b%} "
prompt_update() {

    echo $[RANDOM % 6] > /dev/null

    #prompt_left="%{%F$(fg256 $[RANDOM % 6] $[RANDOM % 6] $[RANDOM % 6])%}-[%h]%(1j,(%j),)%{%B%}%#%{%b%}%{%f%} "
    prompt_left="%{%F$(fg256 $[RANDOM % 5] $[RANDOM % 5] $[RANDOM % 5])%}-[%h]%(1j,(%j),)%{%B%}%#%{%b%}%{%f%} "
    PROMPT='${prompt_bar_left}${prompt_bar_right}'$'\n''${prompt_left}%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

    ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}
function rbenv_info {
    if which rbenv > /dev/null 2>&1; then
        rbenv version | sed -e 's/ .*//'
    fi
}

#RPROMPT='%{$fg[green]%}$(virtualenv_info)%{$reset_color%}% %{$fg[red]%}$(rvm_ruby_prompt)%{$reset_color%}'
RPROMPT='%{$fg[green]%}$(virtualenv_info) $(rbenv_info)%{$reset_color%}%' 
add-zsh-hook precmd prompt_update
