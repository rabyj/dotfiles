#!/usr/bin/env bash
# shellcheck disable=SC2086
echo "Use 'local' or 'narval'."

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


if [ "$1" = "local" ];
then
  ln -svf ${SCRIPT_DIR}/linux/ssh-config ~/.ssh/config
  ln -svf ${SCRIPT_DIR}/linux/Xmodmap ~/.Xmodmap # for keyboard mapping, use in startup apps
  ln -svf ${SCRIPT_DIR}/linux/bashrc ~/.bashrc
  ln -svf ${SCRIPT_DIR}/linux/inputrc ~/.inputrc
  ln -svf ${SCRIPT_DIR}/linux/mimeapps.list ~/.config/mimeapps.list
  ln -svf ${SCRIPT_DIR}/linux/remap_keys.desktop ~/.config/autostart/remap_keys.desktop
  ln -svf ${SCRIPT_DIR}/git/gitconfig ~/.gitconfig
  ln -svf ${SCRIPT_DIR}/git/attributes ~/.config/git/attributes
  ln -svf ${SCRIPT_DIR}/other_programs/comet.config ~/.comet.config
  ln -svf ${SCRIPT_DIR}/other_programs/terminator-config ~/.config/terminator/config
  ln -svf ${SCRIPT_DIR}/other_programs/doublecmd_shortcuts.scf ~/.config/doublecmd/shortcuts.scf

  ln -svf ${SCRIPT_DIR}/vscode/shellcheckrc ~/.shellcheckrc
  ln -svf ${SCRIPT_DIR}/vscode/general-settings.json /home/local/USHERBROOKE/rabj2301/.config/Code/User/settings.json
  ln -svf ${SCRIPT_DIR}/vscode/workspaces/EPILAP.code-workspace /home/local/USHERBROOKE/rabj2301/Projects/epilap/EPILAP.code-workspace
fi

if [ "$1" = "narval" ];
then
  gen_folder=$SCRIPT_DIR
  ln -svf "${gen_folder}/linux/inputrc" ~/.inputrc

  vs_folder="${gen_folder}/vscode/workspaces"
  ln -svf "${vs_folder}/NARVAL.code-workspace" /home/rabyj/project-rabyj/NARVAL.code-workspace
  ln -svf "${vs_folder}/narval-server-settings.json" /home/rabyj/.vscode-server/data/Machine/settings.json
  ln -svf ${gen_folder}/vscode/shellcheckrc ~/.shellcheckrc

  cluster_folder="${gen_folder}/clusters"
  ln -svf "${cluster_folder}/bashrc-narval" ~/.bashrc
  echo "Please manually copy .comet.config content (api key kept out of git)"
fi
