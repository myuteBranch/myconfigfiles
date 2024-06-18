
## How to use
1. Install the necessary packages
   ```
   sudo pacman -S ansible git python
   ```
1. Install the Ansible requirements
   ```
   ansible-galaxy install -r requirements.yml
   ```
1. (Optional) Edit the variables in `group_vars`
1. (Optional) Run the playbook in check mode to view potential changes
   ```
   ansible-playbook main.yml --ask-become-pass --check
   ````
1. Run the playbook (enter your user's password when prompted)
   ```
   ansible-playbook main.yml --ask-become-pass
   ```
