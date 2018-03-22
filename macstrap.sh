export ANSIBLE_STDOUT_CALLBACK=debug 

which brew > /dev/null 
if [ $? -ne 0 ] ; then
  echo "We need to install brew!"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
fi

which ansible > /dev/null 
if [ $? -ne 0 ] ; then
  echo "We need to install ansible!"
  brew install ansible
fi

echo 'Rock & Roll, lets do this.'
ansible-vault decrypt --vault-password-file ~/.vault.key config/vault
chmod u+x config/vault
source ./config/vault
ansible-vault encrypt --vault-password-file ~/.vault.key config/vault
ansible-galaxy install --force azohra.macstrap
ansible-playbook -i "localhost," -c local playbook.yml 