
# WordPress Auto Update Script

This script automatically updates WordPress installations, plugins, themes, and language packs on your server. It supports dry-run mode, allows you to check for updates and provides a notification to the site owner once updates are completed.

## Features

- Check and update WordPress core, plugins, themes, and languages
- Send a notification email to the site owner once updates are applied
- Test email delivery using `--notification-test`
- Support for dry-run mode to simulate updates

## Prerequisites

- `wp-cli` must be installed on the server.
- `jq` is required for JSON parsing of `wp-cli` outputs.
- Linux mail system configured to send emails.

## Installation

1. Download the script:
    ```bash
    wget https://example.com/wordpress-auto-update.sh
    ```

2. Make the script executable:
    ```bash
    chmod +x wordpress-auto-update.sh
    ```

3. Run the script.

## Usage

### Run the script without updating (dry-run):
```bash
./wordpress-auto-update.sh --dry-run
```

### Run the script to apply updates:
```bash
./wordpress-auto-update.sh
```

### Test Email Delivery:
To test if your mail system is working correctly, run the script with `--notification-test`:
```bash
./wordpress-auto-update.sh --notification-test email@example.com
```

### Options:

- `--dry-run`: Display actions without executing them.
- `--help`: Display the help message.
- `--notification-test <email>`: Send a test email to `<email>` to verify mail delivery.

## Script Explanation

### What it does:

- It checks for WordPress core, plugin, theme, and language updates.
- It sends an email notification to the site owner (if `owner_notification.txt` exists and contains a valid email).
- The notification includes details that updates have been applied, or issues need to be resolved.
- It allows for testing email functionality by using the `--notification-test` option.

### Email Notification:

- Subject: "Aktualizacja WordPressa na Twojej stronie"
- Body (Polish without special characters): 

  ```
  Witaj,

  Na Twojej stronie WordPress zostaly przeprowadzone aktualizacje. Jesli wszystko dziala poprawnie, prosimy o ignorowanie tej wiadomosci. W przypadku problemow prosimy o kontakt z administratorem strony.

  Pozdrawiamy,
  Zespol
  ```

### Notes:

- The script assumes WordPress installations are located in the `/var/www` directory.
- If the file `owner_notification.txt` is empty or does not exist, no notification is sent.

## License

MIT License
