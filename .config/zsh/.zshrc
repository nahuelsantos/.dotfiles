# Set ZDOTDIR if not already set
export ZDOTDIR=${ZDOTDIR:-${HOME}/.config/zsh}

# Load all configuration files
for config_file in ${ZDOTDIR}/conf.d/*.zsh; do
    source "${config_file}"
done

# Load functions
for function_file in ${ZDOTDIR}/functions/*.zsh; do
    source "${function_file}"
done

# Load completions
# for completion_file in ${ZDOTDIR}/completion/*.zsh; do
#     source "${completion_file}"
# done