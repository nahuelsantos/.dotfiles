# Prompt — oh-my-posh, themed by .config/ohmyposh/base.toml
# The config is stowed to ~/.config/ohmyposh/base.toml, so this never hardcodes
# where the repo was cloned.
if [[ -o interactive ]] && command -v oh-my-posh >/dev/null 2>&1; then
    _omp_config="${XDG_CONFIG_HOME:-$HOME/.config}/ohmyposh/base.toml"
    if [[ -f "$_omp_config" ]]; then
        eval "$(oh-my-posh init zsh --config "$_omp_config")"
    fi
    unset _omp_config
fi
