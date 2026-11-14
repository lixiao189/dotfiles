# My dotfiles config backup

Config files back up for zsh, neovim, vim, wezterm, ghostty, rime, etc.

Git clone this repo to your home directory.

```bash
git clone https://github.com/lixiao189/dotfiles.git ~/.dotfiles
```

If you are Mac OS user, please install xcode command line tools first.

```bash
xcode-select --install
```

Run the command behind to install the dependencies.

```bash
cd ~/.dotfiles
chmod +x ./install.sh
./install.sh
```

## Neovim AI configuration

Configure the OpenAI-compatible Chat Completions API in `~/.zshrc.local`
(outside this repository):

```bash
export AVANTE_API_URL="https://your-api.example/v1"
export AVANTE_MODEL="your-model-id"
export AVANTE_API_KEY="your-api-key"

# Optional model parameters
export AVANTE_CONTEXT_WINDOW="128000"
export AVANTE_MAX_TOKENS="8192"
export AVANTE_REASONING_EFFORT="high"
```

Run `source ~/.zshrc.local` and restart Neovim after changing these values.
