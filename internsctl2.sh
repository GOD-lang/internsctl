#!/bin/bash

# Function to create a new user
create_user() {
    if [ -z "$1" ]; then
        echo "Error: Missing username. Usage: internsctl user create <username>"
        exit 1
    fi

    username="$1"
    sudo useradd -m "$username"
    sudo passwd "$username"
    echo "User $username created successfully."
}

# Function to list all regular users
list_users() {
    dscl . -list /Users | grep -E '/(bin|bash|sh)$'
}

# Function to list users with sudo permissions
list_sudo_users() {
    grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n'
}

# Function to display the help message
display_help() {
    echo "Usage: internsctl COMMAND [OPTION]..."
    echo "Perform custom operations with internsctl."
    echo
    echo "Commands:"
    echo "  user create <username>      Create a new user"
    echo "  user list                    List all regular users"
    echo "  user list --sudo-only        List users with sudo permissions"
    echo
    echo "Options:"
    echo "  --help            Display this help message"
    echo "  --version         Display version information"
    echo
    echo "Examples:"
    echo "  internsctl user create john_doe"
    echo "  internsctl user list"
    echo "  internsctl user list --sudo-only"
}

# Function to display the version
display_version() {
    echo "internsctl v0.1.0"
}

# Main logic
case "$1" in
    user)
        case "$2" in
            create)
                create_user "$3"
                ;;
            list)
                if [ "$3" == "--sudo-only" ]; then
                    list_sudo_users
                else
                    list_users
                fi
                ;;
            *)
                echo "Invalid option. Use 'internsctl user create <username>', 'internsctl user list', or 'internsctl user list --sudo-only'."
                ;;
        esac
        ;;
    --help)
        display_help
        ;;
    --version)
        display_version
        ;;
    *)
        echo "Invalid command. Use 'internsctl --help' for usage instructions."
        ;;
esac
