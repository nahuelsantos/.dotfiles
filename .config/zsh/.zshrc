# Set ZDOTDIR if not already set
export ZDOTDIR=${ZDOTDIR:-${HOME}/.config/zsh}

# Load all configuration files
if [[ -d "${ZDOTDIR}/conf.d" ]]; then
    for config_file in "${ZDOTDIR}"/conf.d/*.zsh; do
        [[ -f "${config_file}" ]] && source "${config_file}"
    done
fi

# Load functions
if [[ -d "${ZDOTDIR}/functions" ]]; then
    for function_file in "${ZDOTDIR}"/functions/*.zsh; do
        [[ -f "${function_file}" ]] && source "${function_file}"
    done
fi

# Load completions
# if [[ -d "${ZDOTDIR}/completion" ]]; then
#     for completion_file in "${ZDOTDIR}"/completion/*.zsh; do
#         [[ -f "${completion_file}" ]] && source "${completion_file}"
#     done
# fi