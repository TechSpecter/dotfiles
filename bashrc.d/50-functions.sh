js() {
  # JSON scroll
  jq -C . < "$1" | less -R
}

# make directory and enter it
mcd() { mkdir -p "$@" && cd "$@"; }

# Display text "in large, friendly letters"
dp() { 
    clear
    figlet -w "$(tput cols)" "$@" | lolcat
}
#look up synonym - (word)
# slow and buggy
syn() {
  curl --silent "https://api.dictionaryapi.dev/api/v2/entries/en/${1}" | ijq '.[] #.meanings[].definitions[].synonyms[]'
}