# Ansible host setup
```shell
# Run ansible command
ansible all -m ping --user myu
# gather facts
ansible all --user myu -m gather_facts
# run as sudo
ansible all --user myu -m apt -a update_cache=true --become --ask-become-pass
# run install package
ansible all --user myu -m apt -a name=git --become --ask-become-pass
# run playbook
ansible-playbook --ask-become-pass install_tools.yml
# run playbook on local
ansible-playbook --connection=local --inventory 127.0.0.1, --ask-become-pass playbook.yml
```

