#!/bin/sh

# Function to display help message
show_help() {
    echo "Usage: $0 [USER]"
    echo
    echo "Connect to the Vagrant machine as a specific user using a custom SSH config."
    echo
    echo "Arguments:"
    echo "  USER    The username to connect as. If not provided, it will use the default Vagrant user."
    echo
    echo "Examples:"
    echo "  $0 user1     # Connect as user1"
    echo "  $0           # Connect with default Vagrant user"
    echo
    echo "Note: This script assumes that the SSH config file is located at ./setup/ssh-config-vagrant"
    echo "      and that it contains configurations for the specified users."
}

# Check if help is requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Use the provided user or default to 'default' if no user is specified
USER=${1:-default}

# Connect using SSH with the specified config and user
ssh -F ./setup/ssh-config-vagrant "$USER"
