#!/bin/bash
set -ex
DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPODIR="${DIR}/.."
TAG=$(git describe --tags --abbrev=0 | sed 's/[^0-9.]*//g')

cd ${REPODIR}/python/legion_linux
sed -i "s/version = _VERSION/version = ${TAG}/g" setup.cfg

# Build and install python package
python3 -m pip install --upgrade build installer
python3 -m build

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root to install"
	exit
else
	python3 -m installer --destdir="/" dist/*.whl
	#Create config folder
	#cp -r /usr/share/legion_linux /etc/legion_linux
	cp -r /usr/local/share/legion_linux /etc/legion_linux
fi
# Desktop files
# sudo cp legion_linux/legion_gui.desktop /usr/share/applications/
# sudo cp legion_linux/legion_gui_user.desktop /usr/share/applications/
# sudo mkdir -p /usr/share/icons/
# sudo cp legion_linux/legion_logo.png /usr/share/icons/legion_logo.png

echo "Done"
