#!/bin/bash
# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Set the output file path
vagrant_file="$SCRIPT_DIR/ssh-config-vagrant"
# List of additional users
users=(sasada user1 user2)
# vagrant_file=ssh-config-vagrant
# Get Vagrant SSH config
vagrant ssh-config > $vagrant_file

# Function to generate a unique Host name
generate_host_name() {
    local user=$1
    echo "${user}-vagrant"
}

# Iterate over users and append their configs
for user in "${users[@]}"; do
    host_name=$user
    
    # Append a new Host section for each user
    echo "" >> $vagrant_file
    echo "Host $host_name" >> $vagrant_file
    sed -n '/Host default/,/^$/p' $vagrant_file | 
    sed '/^Host/d; /^$/d; s/User vagrant/User '"$user"'/' >> $vagrant_file
done

echo "SSH configurations for all users have been appended to $vagrant_file"
