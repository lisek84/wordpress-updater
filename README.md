
# WordPress Auto-Update Script

This script automatically updates all WordPress installations in a specified directory. It can update the core, plugins, themes, and translations of each WordPress site. It uses `wp-cli` for managing WordPress updates and `jq` for parsing JSON data.

## Features

- Automatically checks for updates to WordPress core, plugins, themes, and translations.
- Allows dry-run mode to preview the actions without making any changes.
- Automatically installs required dependencies (`wp-cli`, `jq`) if they are missing.
- Can be used with or without root privileges for `wp-cli` commands.

## Requirements

- **wp-cli**: A command-line interface for WordPress.
- **jq**: A lightweight and flexible command-line JSON processor.
- Both of these tools will be installed automatically if they are not found on the system.

## Installation

1. Clone or download the script to your local machine.
2. Ensure the script has executable permissions:

   ```bash
   chmod +x wordpress-auto-update.sh
   ```

3. Make sure the `BASE_DIR` in the script points to the correct directory where your WordPress installations are located. The default is `/var/www`.

## Usage

```bash
./wordpress-auto-update.sh [OPTIONS]
```

### Options

- `--dry-run`  
  Displays the actions that would be taken without executing them. This is useful for previewing the changes that will be made.
  
- `--help`  
  Displays the help message.

### Example Usage

#### Dry Run (Preview updates without applying them)

```bash
./wordpress-auto-update.sh --dry-run
```

#### Full Run (Apply updates)

```bash
./wordpress-auto-update.sh
```

## How It Works

1. The script starts by checking if the necessary dependencies (`wp-cli` and `jq`) are installed. If not, it installs them automatically.
2. It then iterates through all directories in the specified `BASE_DIR` and checks if each directory contains a WordPress installation.
3. If a WordPress installation is found, it checks for available updates for the core, plugins, themes, and translations.
4. If updates are available, the script updates WordPress and its components, unless the `--dry-run` option is specified.

## Notes

- The script assumes the WordPress installations are in the `BASE_DIR` directory. You can modify the `BASE_DIR` variable in the script to match your setup.
- You can enable or disable root privileges for `wp-cli` commands by adjusting the `ALLOW_ROOT_ENABLED` variable. Setting it to `1` enables root privileges; setting it to `0` disables them.
- The script will display logs indicating which updates were performed, or it will show what would have been updated in dry-run mode.

## License

This script is licensed under the MIT License. See [LICENSE](LICENSE) for details.
