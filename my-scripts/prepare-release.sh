#!/usr/bin/env bash

set -e
cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source fn.sh

function prepare_arch() {
	local SYSTEM="$1"

	export ARCH="$2"
	export npm_config_arch="$ARCH"
	source common.sh "${ARCH}"

	mkdir -p "${ARCH_RELEASE_ROOT}"
	mkdir -p "${HOME}"

	### install nodejs
	if [ ! -e "${NODEJS}" ]; then
		"install_node_${SYSTEM}" "${ARCH}" "${RELEASE_ROOT}/nodejs/${ARCH}"
	fi
	echo "Node.js version: $("${NODEJS}" -v)"

	### install yarn (local install)
	local YARN=$(nodeBinPath yarn)
	if ! command -v "${YARN}" &>/dev/null ; then
		echo "install yarn to $YARN..."
		"$(nodeBinPath npm)" -g install yarn
	fi
}

function install_node_linux() {
	echo "install nodejs on linux $1 to $2"
	local ARCH="$1"
	local INSTALL_NODE="$2"
	mkdir -p "${INSTALL_NODE}"
	if [ ! -e "${INSTALL_NODE}.tar.xz" ]; then
		wget -c -O "${INSTALL_NODE}.tar.xz.downloading" "https://nodejs.org/dist/v8.11.2/node-v8.11.2-linux-${ARCH}.tar.xz"
		mv "${INSTALL_NODE}.tar.xz.downloading" "${INSTALL_NODE}.tar.xz"
	fi

	tar xf "${INSTALL_NODE}.tar.xz" --strip-components=1 -C "${INSTALL_NODE}"
}
function install_node_windows() {
	local ARCH="$1"
	local INSTALL_NODE="$2"

	echo "${INSTALL_NODE}/node.exe"
	if [ -e "${INSTALL_NODE}/node.exe" ]; then
		return
	fi
	echo "install nodejs on windows $1 to $2"
	mkdir -p "${INSTALL_NODE}"
	if [ ! -e "${INSTALL_NODE}.zip" ]; then
		wget -c -O "${INSTALL_NODE}.zip.downloading" "https://nodejs.org/dist/v8.11.2/node-v8.11.2-win-${ARCH}.zip"
		mv "${INSTALL_NODE}.zip.downloading" "${INSTALL_NODE}.zip"
	fi

	unzip -u "${INSTALL_NODE}.zip" -d "${INSTALL_NODE}/.."
	cp -ru "${INSTALL_NODE}/../node-v8.11.2-win-x64/." "${INSTALL_NODE}"
}

FOUND_CYGWIN=$(find /bin -name 'cygwin*.dll')
if [ -n "${FOUND_CYGWIN}" ]; then
	SYSTEM="windows"
else
	SYSTEM="linux"
fi

prepare_arch "$SYSTEM" x64
