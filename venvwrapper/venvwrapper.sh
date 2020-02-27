# Lightweight virtualenvwrapper (mkvirtualenv/workon/rmvirtualenv)
# Uses some bits of setV (psachin.gitlab.io)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

VIRTUAL_DIR_PATH="$HOME/virtualenvs/"
mkdir -p $VIRTUAL_DIR_PATH
export PATH="$DIR:$PATH"

function _setvcomplete_()
{
    # Bash-autocompletion.
    # This ensures Tab-auto-completions work for virtual environment names.
    local cmd="${1##*/}" # to handle command(s).

    local word=${COMP_WORDS[COMP_CWORD]} # Words thats being completed
    local xpat='${word}'		 # Filter pattern. Include
					 # only words in variable '$names'
    local names=$(ls -l "${VIRTUAL_DIR_PATH}" | egrep '^d' | awk -F " " '{print $NF}') # Virtual environment names

    COMPREPLY=($(compgen -W "$names" -X "$xpat" -- "$word")) # compgen generates the results
}

function workon() {
    if (( $# != 1 )); then
        echo "Usage: workon NAME"
    else
        if [ -d ${VIRTUAL_DIR_PATH}${1} ]; then
            source ${VIRTUAL_DIR_PATH}${1}/bin/activate
        else
            echo "Error: No virtual environment found by the name: ${1}"
        fi
    fi
}

function rmvirtualenv() {
    if (( $# != 1 )); then
        echo "Usage: rmvirtualenv NAME"
    else
        DEACTIVATE=$(command -v deactivate)
        if ! [ -z $DEACTIVATE ] ; then
            echo "Deactivating virtualenv before deleting"
            deactivate
        fi
        if [ -d ${VIRTUAL_DIR_PATH}${1} ];
        then
            read -p "Really delete this virtual environment(Y/N)? " yes_no
            case $yes_no in
            Y|y) rm -rf ${VIRTUAL_DIR_PATH}${1};;
            N|n) echo "Leaving the virtual environment as it is.";;
            *) echo "You need to enter either Y/y or N/n"
            esac
        else
            echo "Error: No virtual environment found by the name: ${1}"
        fi
    fi
}

# Calls bash-complete. The compgen command accepts most of the same
# options that complete does but it generates results rather than just
# storing the rules for future use.
complete -F _setvcomplete_ workon
complete -F _setvcomplete_ rmvirtualenv
