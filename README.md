# Ansible Ubuntu

**[Quick Start](#quick-start)** | **[Features](#features)** | **[Custom profiles](#create-custom-profiles)** | **[Test your profile](#test-your-profile)**  | **[Options](#options)** | **[Requirements](#requirements)** | **[License](#license)**

[![CI](https://github.com/skaary/ansible-provision-linux/actions/workflows/ci.yml/badge.svg?branch=main&event=push)](https://github.com/skaary/ansible-provision-linux/actions?query=workflow%3Ci)

Customizable Ansible setup to provision your workstation with Linux Mint or Ubuntu.

#### Table of Contents

1. **[Quick Start](#quick-start)**
2. **[Roles included](#roles-included)**
3. **[Create custom profiles](#create-custom-profiles)**
    1. [Assumption](#assumption)
    2. [Add a new profile](#add-a-new-profile)
    3. [Add a profile configuration](#add-a-profile-configuration)
    4. [Customize your profile](#customize-your-profile)
    5. [Provision your profile](#provision-your-profile)
4. **[Test your profile](#test-your-profile)**
    1. [Docker](#docker)
    2. [Vagrant](#vagrant)
5. **[Options](#options)**
    1. [Enable role](#enable-role)
    2. [Package options](#package-options)
6. **[Requirements](#requirements)**
    1. [Install system requirements](#install-system-requirements)
    2. [Sudo permissions](#sudo-permissions)
7. **[License](#license)**

## Quick Start

Make sure your system meets the **[requirements](#requirements)** before you start. Everything python related (e.g. Ansible) will be installed into a virtual python environment.

### Manually provision your system from scratch

Use this to provision your system from scratch, when you don't have a profile submitted to upstream yet.

```bash
# 1. Clone this project
git clone https://github.com/skaary/ansible-provision-linux
cd ansible-debian

# 2. Add your profile 'skaary' (See 'Create custom profiles' section of this README)

# 3. Provision your system (with profile 'skaary')
# Note when to use sudo and when not
sudo make deploy-init
make deploy-virtualenv
make deploy-import-roles
make deploy-tools PROFILE=skaary
```

The recording below demonstrates a basic manual provision (to view it, click on the embedded image).

[![asciicast](https://asciinema.org/a/514070.png)](https://asciinema.org/a/514070)

### Fully provision your system from scratch

Use this to provision your system from scratch, when you have already submitted your profile upstream.
The only requirements are `bash` and `sudo`, everything else will be installed automatically.

```bash
# Provision default profile
curl https://raw.githubusercontent.com/skaary/ansible-provision-linux/master/bootstrap.sh | bash

# Provision profile 'generic-all'
curl https://raw.githubusercontent.com/skaary/ansible-provision-linux/master/bootstrap.sh | bash -s generic-all
```

#### Dry-run the tools installation

```bash
# Dry-run everything for profile 'generic-all'
make diff-tools PROFILE=generic-all

# Dry-run everything for profile 'generic-all' without role 'i3'
make diff-tools PROFILE=generic-all IGNORE=i3

# Dry-run a specific role 'i3-gaps' 
make diff-tools PROFILE=generic-all ROLE=i3
```

## Roles included

By default, the following roles will be downloaded into the `role/` directory:

| Role Repository                                                                   | Description                                                                                                                                               |
| :-------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Anki](https://github.com/skaary/ansible-role-anki)                               | Installs the space-repetition program [Anki](https://apps.ankiweb.net/).                                                                                  |
| [Discord](https://github.com/skaary/ansible-role-discord)                         | Installs the voice application [Discord](https://discord.com/).                                                                                           |
| [Docker](https://github.com/skaary/ansible-role-docker)                           | Installs [Docker](https://www.docker.com/).                                                                                                               |
| [Dotfiles](https://github.com/skaary/ansible-role-dotfiles)                       | Installs my dotfiles to the system.                                                                                                                       |
| [Fonts](https://github.com/skaary/ansible-role-fonts)                             | Installs fonts from the apt repository and [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts#font-installation).                                       |
| [fzf](https://github.com/skaary/ansible-role-fzf)                                 | Installs the interactive unix filter [fzf](https://github.com/junegunn/fzf).                                                                              |
| [Git](https://github.com/skaary/ansible-role-git)                                 | Installs the version control system [Git](https://git-scm.com/) and enables the configuration of gitconfig and gitignore.                                 |
| [i3](https://github.com/skaary/ansible-role-i3)                                   | Installs the tiling window manager [i3wm](https://www.i3wm.org/) or the fork [i3-gaps](https://github.com/Airblader/i3).                                  |
| [Jetbrains Dev Tools](https://github.com/skaary/ansible-role-jetbrains-dev-tools) | Installs the Jetbrains IDEs [IntelliJ IDEA](https://www.jetbrains.com/idea/) and [PyCharm](https://www.jetbrains.com/pycharm).                            |
| [mpd](https://github.com/skaary/ansible-role-mpd)                                 | Installs [mpd](https://www.musicpd.org/) and optionally [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp).                                                    |
| [Network Manager](https://github.com/skaary/ansible-role-network-manager)         | Installs [NetworkManager](https://wiki.debian.org/NetworkManager) and enables the additional install of its plugins.                                      |
| [Packer](https://github.com/skaary/ansible-role-packer)                           | Installs [packer](https://www.packer.io/) for automated machine image creation.                                                                           |
| [Polybar](https://github.com/skaary/ansible-role-polybar)                         | Installs the status bar [polybar](https://github.com/polybar/polybar).                                                                                    |
| [Qemu](https://github.com/skaary/ansible-role-qemu)                               | Installs the open source machine emulator and virtualizer [qemu](https://www.qemu.org/).                                                                  |
| [Ranger](https://github.com/skaary/ansible-role-ranger)                           | Installs the VI key bindings based file manager [ranger](https://github.com/ranger/ranger).                                                               |
| [Themes](https://github.com/skaary/ansible-role-rtl88_themes)                     | Enables the installation of themes designed by [rtlewis88](https://github.com/rtlewis88/) such as the popular arc dark theme.                             |
| [Syncthing](https://github.com/skaary/ansible-role-syncthing)                     | Installs the file synchronization program [syncthing](https://syncthing.net/).                                                                            |
| [urxvt](https://github.com/skaary/ansible-role-urxvt)                             | Installs the terminal emulator [urxvt](https://linux.die.net/man/1/urxvt).                                                                                |
| [Vagrant](https://github.com/skaary/ansible-role-vagrant)                         | Installs [vagrant](https://www.vagrantup.com/) to build and manage virtual machine environments.                                                          |
| [Vim](https://github.com/skaary/ansible-role-vim)                                 | Installs the the text editor [vim](https://www.vim.org/) and allows for installation of vim plugins.                                                      |
| [VirtualBox](https://github.com/skaary/ansible-role-virtualbox)                   | Installs [VirtualBox](https://www.virtualbox.org/) for virtualization.                                                                                    |
| [Virtual Studio Code](https://github.com/skaary/ansible-role-vscode)              | Installs the code editor [Visual Studio Code](https://code.visualstudio.com/) and allows management (install/uninstall) of Visual Studio Code extensions. |
| [XDG Mime](https://github.com/skaary/ansible-role-xdg-mime-meta)                  | An ansible roles that sets xdg-mime-meta preferences (see [XDG_MIME Applications](https://wiki.archlinux.org/title/XDG_MIME_Applications)).               |
| [yt-dlp](https://github.com/skaary/ansible-role-ytdlp)                            | Installs [yt-dlp](https://github.com/yt-dlp/yt-dlp) to download videos from youtube.com or other video platforms.                                         |
| [Zathura](https://github.com/skaary/ansible-role-zathura)                         | Installs the document viewer [Zathura](https://pwmt.org/projects/zathura/).                                                                               |
| [zsh](https://github.com/skaary/ansible-role-zsh)                                 | Installs the unix shell [zsh](https://www.zsh.org/) with plugins and optionally the [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) framework.        |

Adding new roles can be done by either appending new roles to the `roles/requirements.yml` file or by manually downloading them into the `role/` directory.

> Note: Ansible role names need to be seperated by an underscore instead of dashes. For instance, Ansible only accepts `mysql_aws` and not `mysql-aws`.

## Create custom profiles

In order to customize your workstation, you can create specific profiles for each machine. Each **hostname** (real or made up) in the [inventory](inventory) file automatically represents one **profile**.

Each profile in Ansible automatically inherits all settings from [group_vars/all.yml](group_vars/all.yml); this file holds a sane default showing you all available options for every role.

In order to actually **customize your profile**, you will have to create a file in [host_vars/](host_vars/) by the same name you have specified in [inventory](inventory). You can copy [group_vars/all.yml](group_vars/all.yml) directly or use an already existing profile from `host_vars`, such as [host_vars/generic-all.yml](host_vars/generic-all.yml).

To better understand how it works, you can view the recording in [manually provision your system from scratch](#manually-provision-your-system-from-scratch) or follow this step-by-step example for creating a new profile:

### Assumption

For the sake of this example, let's assume your profile is called `skaary`.

#### Add a new profile

Add the following line to the bottom of [inventory](inventory):

```bash
skaary ansible_connection=local
```

`ansible_connection=local` defines that your profile should be applied to your local computer. If you want to create a profile for a remote computer, your profile name must be a hostname or IP address by which the remote machine is reachable over the network.

#### Add a profile configuration

As already mentioned earlier, you can copy [group_vars/all.yml](group_vars/all.yml) or an already existing `host_vars` file.

Use group_vars/all.yml as a default template:

```bash
cp group_vars/all.yml host_vars/skaary.yml
```

Use an already existing host_vars file as a default template:

```bash
cp host_vars/generic-all.yml host_vars/skaary.yml
```

#### Customize your profile

Simply edit `host_vars/skaary.yml` and adjust the values to your needs. If you have copied an already existing file, it will contain comments for all possible configuration options that lets you quickly see what and how to change.

#### Provision your profile

If you want to test your profile in a Docker container prior actually provisioning your own system, skip to the next section, otherwise just run the following commands.

Run the following command to see what would happen:

```bash
ansible-playbook -i inventory playbook.yml --diff --limit skaary --ask-become-pass --check
```

Run the following command to actually apply your profile:

```bash
ansible-playbook -i inventory playbook.yml --diff --limit skaary --ask-become-pass
```

## Test your profile

Before actually running any new profile / provisioning any system it is advised to first run tests to see if everything works as expected; this can be done in a **Docker container** or in a **Vagrant box**.

### Docker

> **Note:** The Docker image will always be auto-build before running the tests.

Before running you should be aware of a few arguments that can be applied to the `make` commands. See the table below:

| Variable  | Required | Description                                           |
| --------- | -------- | ----------------------------------------------------- |
| `PROFILE` | yes      | The inventory hostname (your profile)                 |
| `VERBOSE` | no       | Ansible verbosity. Valid values: `0`, `1`, `2` or `3` |
| `ROLE`    | no       | Only run this specific tag (role name)                |

Run a full test of profile `generic-all`:

```bash
make test-docker-full PROFILE=generic-all
```

Run a full test of profile `generic-all` in a random order:

```bash
make test-docker-random PROFILE=generic-all
```

Only run `i3` role in profile `generic-all`

```bash
make test-docker-single PROFILE=generic-all ROLE=i3
```

### Vagrant

Run the following in your terminal:

```bash
make test-vagrant PROFILE=desktop_mint
```

Change `PROFILE` accordingly.

## Options

### Enable role

Look for the package section and set them to `true` if an execution of the role is desired; otherwise, set it to `false` to ignore the role.

```bash
$ vi host_vars/<name>.yml
```

```yml
---
i3_install:       'true'    # role will be executed
docker_install:   'true'
discord:          'false'  # role will be ignored and not executed
```

### Package Options

Many packages come with options that are customizable. For instance, it is possible to define the default program(s) to open specific file types:

```yaml
---
xdg_mime_defaults:
  - desktop_file: chromium.desktop
    mime_types:
      - text/html
      - x-scheme-handler/http
```

or choose which apt packages are to be installed or removed:

```yaml
---
apt_packages: []
apt_removals: []
```

For a more exhaustive overview of available options head to the [respective role's repository](#roles-included) for default variables and more information.

## Requirements

Before you can start there are a few tools required that must be present on the system. Just copy-paste those commands into your terminal.

### Install system requirements

```bash
sudo apt-get update
sudo apt-get install --no-install-recommends --no-install-suggests -y \
  make \
  git \
  sudo
```

### Sudo permissions

Make sure your user is allowed run sudo

```bash
usermod -aG sudo <username>
```

## License

[MIT / BSD](LICENSE.md)