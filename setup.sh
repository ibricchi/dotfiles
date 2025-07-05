#!/bin/env sh

set -e

# check that gcc and git are installed
required_tools=( "git" "gcc" )
for tool in ${required_tools[@]}; do
    if ! [[ $(command -v $tool) ]]; then
        echo "Required tool $tool is not installed. Please install it and try again."
        exit 1
    fi
done

# make sure HOME is not /root
if [[ "$HOME" == "/root" || $USER == "root" ]]; then
    echo "This script should not be run as root. Please run it as a normal user."
    exit 1
fi

BASE_DIR=$HOME
if [[ -d $HOME/Documents ]]; then
  BASE_DIR=$HOME/Documents
fi
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# install cargo for gobi
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env
if ! [[ $(command -v cargo) ]]; then
    rust_setup_script=$(mktemp)
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > $rust_setup_script
    sh $rust_setup_script -y 
fi
source $HOME/.cargo/env

# install gobi
if ! [[ $(command -v gobi) ]]; then
    git clone https://github.com/ibricchi/gobi $BASE_DIR/gobi
    cd $BASE_DIR/gobi
    cargo build -r
    mkdir -p $HOME/.local/bin
    ln -s $BASE_DIR/gobi/target/release/gobi_cli $HOME/.local/bin/gobi_cli
    ln -s $BASE_DIR/gobi/scripts/gobi $HOME/.local/bin/gobi
    mkdir -p $HOME/.config/gobi
    echo "[gobi.projects]" > $HOME/.config/gobi/gobi.toml
    echo "setup=\"$SCRIPT_DIR/gobi/setup.toml\"" >> $HOME/.config/gobi/gobi.toml
fi

gobi setup everything

