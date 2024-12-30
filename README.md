# gitrepo-iterm2-tab-title-color plugin

`zsh-iterm2-gitrepo-tabtitlecolor` changes iterm2 tab title and color per repo. 

My typical workflow is a fullscreen iterm2 with multiple tabs. In each
tab there are multiple panes in which all tabs per pane are `cd` into
some repo that I'm working on.

This plugin then sets the tab title to the repo name (capitalised) and
the tab title (not background) colour to a colour hashed from the repo
name. This ensure colours are consistent over sessions.

Example, clone this repo, cd there and run;

```
$ zsh_iterm2_gitrepo_tabtitle_git_repo_color
LightBlue #ADD8E6
```

`zsh-iterm2-gitrepo-tabtitlecolor` always resolves to `LightBlue` tab color.

## Installation

1. Clone the repository into the custom plugins directory of Oh My Zsh:

```
git clone https://github.com/eskil/zsh-iterm2-gitrepo-tabtitlecolor.git ~/.oh-my-zsh/custom/plugins/zsh-iterm2-gitrepo-tabtitlecolor
```

2. Add ` gitrepoiterm2tabtitlecolor` to the list of plugins in your `.zshrc` file:

```
plugins=(...  zsh-iterm2-gitrepo-tabtitlecolor)
```

3. Reload your Zsh configuration or restart your terminal session:

```
source ~/.zshrc
```


## Usage

The plugin acts on `chdir`, so simply `cd` into a git repo to see the effect.

If there's colours you really don't like, fork the repo and edit the list of `colors` at the top the plugin.

## Resources


* [How to change tab title](https://superuser.com/questions/292652/change-iterm2-window-and-tab-titles-in-zsh)

```
echo -ne "\e]1;this is the title\a"
```

* [How to change tab color](https://superuser.com/questions/403650/programmatically-set-the-color-of-a-tab-in-iterm2)

```
echo -e "\033]6;1;bg;red;brightness;57\a"
echo -e "\033]6;1;bg;green;brightness;197\a"
echo -e "\033]6;1;bg;blue;brightness;77\a"
```

* Similar plugins

```
git clone git@github.com:SaltedBlowfish/zsh-shellcolor.git
```
