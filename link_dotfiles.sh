#!/usr/bin/env bash
# shellcheck disable=SC2086
echo "Use one of the following arguments: [local, hpc, home]"

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# bashrc+ config
ln -svf ${SCRIPT_DIR}/linux/bash_aliases ~/.bash_aliases
ln -svf ${SCRIPT_DIR}/linux/bash_functions ~/.bash_functions
ln -svf ${SCRIPT_DIR}/linux/inputrc ~/.inputrc

if [ "$1" = "local" ];
then
	ln -svf ${SCRIPT_DIR}/linux/bashrc ~/.bashrc

  ln -svf ${SCRIPT_DIR}/linux/ssh-config ~/.ssh/config
  ln -svf ${SCRIPT_DIR}/linux/keyd_config.conf /etc/keyd/default.conf # for keyboard mapping
  ln -svf ${SCRIPT_DIR}/linux/mimeapps.list ~/.config/mimeapps.list

  ln -svf ${SCRIPT_DIR}/git/gitconfig ~/.gitconfig
  ln -svf ${SCRIPT_DIR}/git/attributes ~/.config/git/attributes
  ln -svf ${SCRIPT_DIR}/other_programs/comet.config ~/.comet.config
  ln -svf ${SCRIPT_DIR}/other_programs/terminator-config ~/.config/terminator/config
  ln -svf ${SCRIPT_DIR}/other_programs/doublecmd_shortcuts.scf ~/.config/doublecmd/shortcuts.scf

  ln -svf ${SCRIPT_DIR}/vscode/shellcheckrc ~/.shellcheckrc
  ln -svf ${SCRIPT_DIR}/vscode/general-settings.json ~/.config/Code/User/settings.json
  ln -svf ${SCRIPT_DIR}/vscode/workspaces/EPILAP.code-workspace ~/Projects/epilap/EPILAP.code-workspace
fi

if [ "$1" = "home" ];
then
	ln -svf ${SCRIPT_DIR}/linux/bashrc ~/.bashrc

  ln -svf ${SCRIPT_DIR}/linux/ssh-config ~/.ssh/config
  ln -svf ${SCRIPT_DIR}/linux/keyd_config.conf /etc/keyd/default.conf # for keyboard mapping

  ln -svf ${SCRIPT_DIR}/git/gitconfig ~/.gitconfig
  ln -svf ${SCRIPT_DIR}/git/attributes ~/.config/git/attributes
  ln -svf ${SCRIPT_DIR}/other_programs/comet.config ~/.comet.config

  ln -svf ${SCRIPT_DIR}/vscode/shellcheckrc ~/.shellcheckrc
  # ln -svf ${SCRIPT_DIR}/vscode/general-settings.json ~/.config/Code/User/settings.json
  # ln -svf ${SCRIPT_DIR}/vscode/workspaces/EPILAP.code-workspace ~/Projects/epilap/EPILAP.code-workspace

fi

if [ "$1" = "hpc" ];
then
  gen_folder=$SCRIPT_DIR

  cluster_folder="${gen_folder}/clusters"
  ln -svf "${cluster_folder}/bashrc-hpc" ~/.bashrc

  echo "Please manually copy .comet.config content (api key kept out of git)"
else # home/local common config
	# gnupg config
	ln -svf ${SCRIPT_DIR}/linux/gnupg/gpg-agent.conf ~/.gnupg/
	ln -svf ${SCRIPT_DIR}/linux/gnupg/gpg.conf ~/.gnupg/
fi
