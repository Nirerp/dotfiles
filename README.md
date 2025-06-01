# My Personal Dotfiles

These are my personal configuration files for a customized Linux environment. This repository helps me keep track of my settings and makes it easier to set up a new system.

## Configured Applications

This repository contains configurations for the following applications:

*   **Shells:**
    *   Bash (`.bashrc`)
    *   Zsh (`.zshrc`)
    *   Fish (`.config/fish/`)
*   **Terminal Emulators:**
    *   Kitty (`.config/kitty/`)
    *   Ghostty (`.config/ghostty/`)
*   **Window Manager:**
    *   Hyprland (`.config/hypr/`) (includes settings for hypridle, hyprlock, hyprpaper)
*   **Text Editor:**
    *   Neovim (`.config/nvim/`)
*   **Prompt:**
    *   Starship (`.config/starship.toml`)
*   **Status Bar:**
    *   Waybar (`.config/waybar/`)
*   **Application Launcher:**
    *   Wofi (`.config/wofi/`)
*   **File Manager:**
    *   Yazi (`.config/yazi/`)
*   **System Information Tools:**
    *   Fastfetch (`.config/fastfetch/`)
    *   Neofetch (`.config/neofetch/`)

## Usage

1.  **Clone the repository:**
    ```bash
    git clone <repository_url> ~/.dotfiles
    ```
    (Replace `<repository_url>` with the actual URL of this repository). You can choose a different directory than `~/.dotfiles` if you prefer.

2.  **Back up your existing dotfiles:**
    Before proceeding, it is crucial to back up any existing configuration files you have. This will allow you to revert to your previous setup if anything goes wrong.
    ```bash
    # Example: backing up existing nvim config
    mv ~/.config/nvim ~/.config/nvim.bak
    # Back up other relevant files and directories accordingly
    ```

3.  **Symlink or copy the configuration files:**
    You can either symlink the files from the cloned repository to their respective locations in your home directory or copy them. Symlinking is generally recommended as it allows the configurations to be automatically updated when you pull changes from the repository.

    *   **Symlinking example (for nvim):**
        ```bash
        ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
        ```
    *   **Copying example (for nvim):**
        ```bash
        cp -r ~/.dotfiles/.config/nvim ~/.config/
        ```
    You will need to do this for each application configuration you want to use from this repository.

4.  **Dependencies and Prerequisites:**
    Some configurations might depend on specific fonts, icons, themes, or other programs being installed on your system. If you encounter issues, ensure that all necessary dependencies for the respective applications (e.g., Hyprland, Waybar, Kitty) are installed.

    *It is highly recommended to review the configuration files before applying them to understand what they do.*

## Customization

These dotfiles are personalized for my workflow and preferences. You will likely need to customize them to fit your own needs. Feel free to fork this repository and modify the configurations as you see fit.

## License

The files and scripts in this repository are released under the [MIT License](LICENSE).
