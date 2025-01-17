#!/bin/bash
#Author: lisek84
#https://github.com/lisek84/wordpress-updater

# Path to the directory containing WordPress installations
BASE_DIR="/var/www"

# Dry run flag
DRY_RUN=false

# Allow root flag for wp-cli commands (1 to enable, 0 to disable)
ALLOW_ROOT_ENABLED=1
ALLOW_ROOT=""
if [ "$ALLOW_ROOT_ENABLED" -eq 1 ]; then
    ALLOW_ROOT="--allow-root"
fi

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Automatically updates WordPress installations in the $BASE_DIR directory."
    echo
    echo "Options:"
    echo "  --dry-run           Displays the actions that would be taken without executing them."
    echo "  --help              Displays this help message."
    echo "  --notification-test <email>  Send a test email to <email> to verify mail delivery."
}

# Function to check if wp-cli is installed
check_wp_cli() {
    if ! command -v wp &> /dev/null; then
        echo "wp-cli is not installed. Installing..."
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
        echo "wp-cli installed."
    fi
}

# Function to check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        echo "jq is not installed. Installing..."
        apt-get update && apt-get install -y jq
        echo "jq installed."
    fi
}

# Function to send notification email
send_notification() {
    local dir=$1
    local email=$2

    if [ -n "$email" ]; then
        SUBJECT="Wordpress has been updated on your site"
        BODY="Hello, \n\nUpdates has been made on your wordpress site. Please check is site ok. Or contact your webmaster to solve issues.\n\nRegards,\nHosting Team"

        echo -e "$BODY" | mail -s "$SUBJECT" "$email"
        echo "Notification sent to: $email"
    fi
}

# Function to send test email
send_test_notification() {
    local email=$1

    if [ -n "$email" ]; then
        SUBJECT="Wordpress Notification test"
        BODY="Hi,\n\nThis is just a dummy e-mail delivery test. If you got that - that is great.\n\nCheers,\nHosting Team"

        echo -e "$BODY" | mail -s "$SUBJECT" "$email"
        echo "Notification sent to: $email"
    fi
}

# Function to update WordPress
update_wordpress() {
    local dir=$1
    cd "$dir" || return

    # Check if the directory contains WordPress
    if wp core is-installed --quiet $ALLOW_ROOT 2>/dev/null; then
        # Check for available updates
        local updates_available=0

        if [ "$(wp core check-update --format=json $ALLOW_ROOT 2>/dev/null | jq '. | length > 0')" = "true" ]; then
            updates_available=1
        fi

        if [ "$(wp plugin list --update=available --format=json $ALLOW_ROOT 2>/dev/null | jq '. | length > 0')" = "true" ]; then
            updates_available=1
        fi

        if [ "$(wp theme list --update=available --format=json $ALLOW_ROOT 2>/dev/null | jq '. | length > 0')" = "true" ]; then
            updates_available=1
        fi

        if [ "$(wp language core list --update=available --format=json $ALLOW_ROOT 2>/dev/null | jq '. | length > 0')" = "true" ]; then
            updates_available=1
        fi

        if [ "$updates_available" -eq 1 ]; then
            echo "[Server: $(hostname)] WordPress found in $dir. Checking for updates..."

            if [ "$DRY_RUN" = false ]; then
                # Update core, plugins, themes, and translations
                wp core update $ALLOW_ROOT
                wp plugin update --all $ALLOW_ROOT
                wp theme update --all $ALLOW_ROOT
                wp language core update $ALLOW_ROOT
                wp language plugin update --all $ALLOW_ROOT
                wp language theme update --all $ALLOW_ROOT

                echo "[Server: $(hostname)] Updates for $dir completed."
            else
                echo "[Dry Run] Updates available for $dir."
            fi

            # Check for the owner email and send notification
            if [ -f "$dir/owner_notification.txt" ] && [ -s "$dir/owner_notification.txt" ]; then
                OWNER_EMAIL=$(cat "$dir/owner_notification.txt")
                send_notification "$dir" "$OWNER_EMAIL"
            fi
        fi
    fi
}

# Main logic of the script
main() {
    # Check if wp-cli is installed
    check_wp_cli

    # Check if jq is installed
    check_jq

    # Iterate through directories in BASE_DIR
    for dir in "$BASE_DIR"/*; do
        if [ -d "$dir" ]; then
            update_wordpress "$dir"
        fi
    done
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        --notification-test)
            shift
            if [ -n "$1" ]; then
                send_test_notification "$1"
                exit 0
            else
                echo "Please provide an email address for the test."
                exit 1
            fi
            ;;
        *)
            echo "Unknown option $1"
            show_help
            exit 1
            ;;
    esac
done

# Run the main function
main
