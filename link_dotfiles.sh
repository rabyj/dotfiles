#!/bin/bash
echo "Use 'local' or 'narval'."
if [ "$1" = "local" ];
then
  ln -svf ~/dotfiles/ssh-config ~/.ssh/config
  ln -svf ~/dotfiles/.bashrc ~/.bashrc
  ln -svf ~/dotfiles/.inputrc ~/.inputrc
  ln -svf ~/dotfiles/.comet.config ~/.comet.config
  ln -svf ~/dotfiles/git/.gitconfig ~/.gitconfig
  ln -svf ~/dotfiles/git/attributes ~/.config/git/attributes
  ln -svf ~/dotfiles/terminator-config ~/.config/terminator/config

  ln -svf ~/dotfiles/vscode/.pylintrc ~/.pylintrc
  ln -svf ~/dotfiles/vscode/general-settings.json /home/local/USHERBROOKE/rabj2301/.config/Code/User/settings.json
  ln -svf ~/dotfiles/vscode/workspaces/EPILAP.code-workspace /home/local/USHERBROOKE/rabj2301/Projects/epilap/EPILAP.code-workspace
fi

if [ "$1" = "narval" ];
then
  gen_folder="$HOME/project-rabyj/sources/dotfiles"
  ln -svf "${gen_folder}/.inputrc" ~/.inputrc

  vs_folder="${gen_folder}/vscode/workspaces"
  ln -svf "${vs_folder}/NARVAL.code-workspace" /home/rabyj/project-rabyj/NARVAL.code-workspace
  ln -svf "${vs_folder}/narval-server-settings.json" /home/rabyj/.vscode-server/data/Machine/settings.json

  cluster_folder="${gen_folder}/clusters"
  ln -svf "${cluster_folder}/.bashrc-narval" ~/.bashrc
fi
