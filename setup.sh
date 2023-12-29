#!/bin/bash

# DETECT OS
# Shamelessly copied from stackoverflow:
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# =================================================================================
lowercase() {
	echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS="$(lowercase "$(uname)")"
KERNEL="$(uname -r)"
MACH="$(uname -m)"

if [ "${OS}" = "darwin" ]; then
	OS='mac'
else
	OS="$(uname)"
	if [ "${OS}" = "Linux" ]; then
		if [ -f /etc/debian_version ]; then
			DISTRO_BASE='debian'
			DIST=$(grep '^DISTRIB_ID' </etc/lsb-release | awk -F= '{ print $2 }')
		fi
		if [ -f /etc/UnitedLinux-release ]; then
			DIST="${DIST}[$(tr "\n" ' ' </etc/UnitedLinux-release | sed s/VERSION.*//)]"
		fi
		OS="$(lowercase "$OS")"
		readonly OS
		readonly DIST
		readonly DISTRO_BASE
		readonly KERNEL
		readonly MACH
	fi

fi

echo
echo "===================================================="
echo "            OS:                $OS"
echo "     Distribution (Base):      $DISTRO_BASE"
echo "       Distribution:           $DIST"
echo "      Kernel Version:          $KERNEL"
echo "       Architecture:           $MACH"
echo "===================================================="
echo

if [[ $OS = 'mac' ]]; then
	echo 'Mac detected'

	echo 'Disabling annoying features...'
	# disables the hold key menu to allow key repeat
	defaults write -g ApplePressAndHoldEnabled -bool false
	# The speed of repetition of characters
	defaults write -g KeyRepeat -int 2
	# Delay until repeat
	defaults write -g InitialKeyRepeat -int 15

	if ! command -v brew &>/dev/null; then
		echo 'Homebrew not installed, installing...'
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	if [ -d "$HOME/oh-my-zsh" ]; then
		echo "Oh my zsh!"
	else
		echo "You don't have Oh-My-Zsh installed, installing..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi

	echo 'getting brew packages...'
	brew bundle

	# Deal with fonts
	brew tap homebrew/cask-fonts
	brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install --cask {} || true
fi

python install.py
