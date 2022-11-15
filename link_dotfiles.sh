#!/bin/bash
echo "Use 'local' or 'narval'."
if [ "$1" = "local" ];
then
  ln -svf ~/dotfiles/ssh-config ~/.ssh/config
  ln -svf ~/dotfiles/.bashrc ~/.bashrc
  ln -svf ~/dotfiles/.comet.config ~/.comet.config
  ln -svf ~/dotfiles/.gitconfig ~/.gitconfig
  ln -svf ~/dotfiles/terminator-config ~/.config/terminator/config

  ln -svf ~/dotfiles/vscode/.pylintrc ~/.pylintrc
  ln -svf ~/dotfiles/vscode/general-settings.json /home/local/USHERBROOKE/rabj2301/.config/Code/User/settings.json
  ln -svf ~/dotfiles/vscode/workspaces/EPILAP.code-workspace /home/local/USHERBROOKE/rabj2301/Projects/epilap/EPILAP.code-workspace
fi

if [ "$1" = "narval" ];
then
  folder="$HOME/project-rabyj/sources/dotfiles/vscode/workspaces"
  ln -svf "${folder}/NARVAL.code-workspace" /home/rabyj/project-rabyj/NARVAL.code-workspace
  ln -svf "${folder}/narval-server-settings.json" /home/rabyj/.vscode-server/data/Machine/settings.json
fi
