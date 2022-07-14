# Ansible Ubuntu

Customizable Ansible setup to provision Ubuntu based workstations offering following features:

- Any bundled package can be either installed or ignored, in case only specific packages are required.
- It is possible to add many different profiles (e.g. for different hardware on different workstations) with different profile configurations.
- Provisioning can be done locally or over the network.

## Roles included

| Role | Description |
| [Anki](https://github.com/skaary/ansible-role-anki) | Installs the space-repetition program [Anki](https://apps.ankiweb.net/) |
| [Discord](https://github.com/skaary/ansible-role-discord) | Installs the voice application [Discord](https://discord.com/) |

| [Docker](https://github.com/skaary/ansible-role-docker) | Installs the space-repetition program [Docker](https://apps.ankiweb.net/) |
| [Dotfiles](https://github.com/skaary/ansible-role-dotfiles) | Installs the space-repetition program [dotfiles](https://apps.ankiweb.net/) |
| [Fonts](https://github.com/skaary/ansible-role-fonts) | Installs the space-repetition program [Anki](https://apps.ankiweb.net/) |
| [fzf](https://github.com/skaary/ansible-role-fzf) | Installs the space-repetition program [Anki](https://apps.ankiweb.net/) |

| [Gimp](https://github.com/skaary/ansible-role-gimp) | Installs the image editor [Gimp](https://www.gimp.org/) |
| [Git](https://github.com/skaary/ansible-role-git) | Installs the version control system [Git](https://git-scm.com/) and enables the configuration of gitconfig and gitignore. |

| [i3](https://github.com/skaary/ansible-role-i3) | Installs the space-repetition program [i3](https://apps.ankiweb.net/) |

| [Jetbrains Dev Tools](https://github.com/skaary/ansible-role-jetbrains-dev-tools) | Installs the Jetbrains IDEs [IntelliJ IDEA](https://www.jetbrains.com/idea/) and [PyCharm](https://www.jetbrains.com/pycharm)] |

| [mpd](https://github.com/skaary/ansible-role-mpd) | Installs the space-repetition program [mpd](https://apps.ankiweb.net/) |
| [Network Manager](https://github.com/skaary/ansible-role-network-manager) | Installs the space-repetition program [Anki](https://apps.ankiweb.net/) |
| [Packer](https://github.com/skaary/ansible-role-packer) | Installs the space-repetition program [packer](https://apps.ankiweb.net/) |
| [Polybar](https://github.com/skaary/ansible-role-polybar) | Installs the space-repetition program [polybar](https://apps.ankiweb.net/) |
| [Qemu](https://github.com/skaary/ansible-role-qemu) | Installs the space-repetition program [qemu](https://apps.ankiweb.net/) |
| [Ranger](https://github.com/skaary/ansible-role-ranger) | Installs the space-repetition program [ranger](https://apps.ankiweb.net/) |

| [Themes repository](https://github.com/skaary/ansible-role-rtl88_themes) | Enables the installation of themes designed by [rtlewis88](https://github.com/rtlewis88/) such as the popular arc dark theme. |

| [Syncthing](https://github.com/skaary/ansible-role-syncthing) | Installs the space-repetition program [syncthing](https://apps.ankiweb.net/) |
| [urxvt](https://github.com/skaary/ansible-role-urxvt) | Installs the space-repetition program [urxvt](https://apps.ankiweb.net/) |
| [Vagrant](https://github.com/skaary/ansible-role-vagrant) | Installs the space-repetition program [vagrant](https://apps.ankiweb.net/) |
| [Vim](https://github.com/skaary/ansible-role-vim) | Installs the space-repetition program [vim](https://apps.ankiweb.net/) |
| [VirtualBox](https://github.com/skaary/ansible-role-virtualbox) | Installs the space-repetition program [VirtualBox](https://apps.ankiweb.net/) |
| [Virtual Studio Code](https://github.com/skaary/ansible-role-vscode) | Installs the space-repetition program [Visual Studio Code](https://apps.ankiweb.net/) |
| [XDG Mime Meta](https://github.com/skaary/ansible-role-xdg-mime-meta) | Installs the space-repetition program [Anki](https://apps.ankiweb.net/) |
| [yt-dlp](https://github.com/skaary/ansible-role-ytdlp) | Installs the space-repetition program [yt-dlp](https://apps.ankiweb.net/) |
| [Zathura](https://github.com/skaary/ansible-role-zathura) | Installs the space-repetition program [Zathura](https://apps.ankiweb.net/) |
| [zsh](https://github.com/skaary/ansible-role-zsh) | Installs the space-repetition program [zsh](https://apps.ankiweb.net/) |


## Installation

```bash
sudo apt install python3-venv
python3 -m venv .venv
source ./.venv/bin/activate
python -m pip install -r requirements.txt
```

## Create custom profiles

In order to customize your workstation, you can create specific profiles for each machine. Each **hostname** (real or made up) in the [inventory](inventory) file automatically represents one **profile**.

Each profile in Ansible automatically inherits all settings from [group_vars/all.yml](group_vars/all.yml); this file holds a sane default showing you all available options for every role.

In order to actually **customize your profile**, you will have to create a file in [host_vars/](host_vars/) by the same name you have specified in [inventory](inventory). You can copy [group_vars/all.yml](group_vars/all.yml) directly or use an already existing profile from `host_vars`, such as [host_vars/generic-all.yml](host_vars/generic-all.yml).

To better understand how it works, you can follow this step-by-step example for creating a new profile:

### Assumption

For the sake of this example, let's assume your profile is called `desktop_mint`.

#### Add a new profile

Add the following line to the bottom of [inventory](inventory):

```bash
desktop_mint ansible_connection=local
```

`ansible_connection=local` defines that your profile should be applied to your local computer. If you want to create a profile for a remote computer, your profile name must be a hostname or IP address by which the remote machine is reachable over the network.

#### Add a profile configuration

As already mentioned earlier, you can copy [group_vars/all.yml](group_vars/all.yml) or an already existing `host_vars` file.

Use group_vars/all.yml as a default template:

```bash
cp group_vars/all.yml host_vars/desktop_mint.yml
```

Use an already existing host_vars file as a default template:

```bash
cp host_vars/generic-all.yml host_vars/desktop_mint.yml
```

#### Customize your profile

Simply edit `host_vars/desktop_mint.yml` and adjust the values to your needs. If you have copied an already existing file, it will contain comments for all possible configuration options that let's you quickly see what and how to change.

#### Provision your profile

If you want to test your profile in a Docker container prior actually provisioning your own system, skip to the next section, otherwise just run the following commands.

Run the following command to see what would happen:

```bash
ansible-playbook -i inventory playbook.yml --diff --limit desktop_mint --ask-become-pass --check
```

Run the following command to actually apply your profile:

```bash
ansible-playbook -i inventory playbook.yml --diff --limit desktop_mint --ask-become-pass
```

## Test profiles

Before actually running any new profile / provisioning any system it is advised to first run tests to see if everything works as expected; this can be done in a **Vagrant box**.

### Vagrant

Run the following in your terminal:

```bash
make test-vagrant PROFILE=desktop_mint
```

## Options

### Package Options

Many packages come with options that are customizable. For instance, it is possible to define the default program(s) to open specific file types:

```yaml
xdg_mime_defaults:
  - desktop_file: chromium.desktop
    mime_types:
      - text/html
      - x-scheme-handler/http
```

or choose which apt packages are to be installed or removed:

```yaml
apt_packages: []
apt_removals: []
```

For a more exhaustive overview of available options head to the [respective role's repository](#roles-included) for default variables and more information.
