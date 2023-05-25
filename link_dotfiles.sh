#!/usr/bin/env bash
echo "Use 'local' or 'narval'."

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


if [ "$1" = "local" ];
then
  ln -svf ${SCRIPT_DIR}/ssh-config ~/.ssh/config
  ln -svf ${SCRIPT_DIR}/.bashrc ~/.bashrc
  ln -svf ${SCRIPT_DIR}/.inputrc ~/.inputrc
  ln -svf ${SCRIPT_DIR}/.comet.config ~/.comet.config
  ln -svf ${SCRIPT_DIR}/git/.gitconfig ~/.gitconfig
  ln -svf ${SCRIPT_DIR}/git/attributes ~/.config/git/attributes
  ln -svf ${SCRIPT_DIR}/terminator-config ~/.config/terminator/config

  ln -svf ${SCRIPT_DIR}/vscode/.pylintrc ~/.pylintrc
  ln -svf ${SCRIPT_DIR}/vscode/.shellcheckrc ~/.shellcheckrc
  ln -svf ${SCRIPT_DIR}/vscode/general-settings.json /home/local/USHERBROOKE/rabj2301/.config/Code/User/settings.json
  ln -svf ${SCRIPT_DIR}/vscode/workspaces/EPILAP.code-workspace /home/local/USHERBROOKE/rabj2301/Projects/epilap/EPILAP.code-workspace
fi

if [ "$1" = "narval" ];
then
  gen_folder=$SCRIPT_DIR
  ln -svf "${gen_folder}/.inputrc" ~/.inputrc

  vs_folder="${gen_folder}/vscode/workspaces"
  ln -svf "${vs_folder}/NARVAL.code-workspace" /home/rabyj/project-rabyj/NARVAL.code-workspace
  ln -svf "${vs_folder}/narval-server-settings.json" /home/rabyj/.vscode-server/data/Machine/settings.json
  ln -svf ${gen_folder}/vscode/.shellcheckrc ~/.shellcheckrc

  cluster_folder="${gen_folder}/clusters"
  ln -svf "${cluster_folder}/.bashrc-narval" ~/.bashrc
fi
