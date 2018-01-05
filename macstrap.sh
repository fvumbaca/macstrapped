export ANSIBLE_STDOUT_CALLBACK=debug 

function install_or_update_package {
    pkg=$1
    
    which $pkg >/dev/null
    if [ $? -ne 0 ] ; then
        echo "We need to install $pkg!"
        brew install $pkg
    else
        
        brew ls $pkg >/dev/null
        if [ $? -ne 0 ] ; then
            echo "$pkg has to be installed with 'brew'"
            echo "  a) Remove it and run './cli.sh' again"
            echo "      or"
            echo "  b) Manually install it 'brew update && brew install $pkg'"
            exit 1
        fi
        
        brew outdated $pkg >/dev/null
        if [ $? -ne 0 ] ; then
            echo "We need to update $pkg!"
            brew upgrade $pkg
        fi
    fi
}

which brew > /dev/null 
if [ $? -ne 0 ] ; then
  echo "We need to install brew!"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

install_or_update_package ansible

echo 'Rock & Roll, lets do this.'
ansible-playbook macstrap.yml
