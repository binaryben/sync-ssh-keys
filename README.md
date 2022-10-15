> **Warning**: The proposal for this software is currently being developed. Please do not attempt to use it yet.

<br /><br /><div align="center">

# 🔐 Sync SSH Keys
<br />

![ISC License](https://img.shields.io/badge/license-ISC-green?style=for-the-badge) &nbsp; ![Project Status](https://img.shields.io/badge/status-💡%20PROPOSAL-yellow?style=for-the-badge)

<strong>Maintain access to your servers without fuss. Automate your `~/.ssh/authorized_keys` with ease.</strong><br />
<sub>The `sync-ssh-keys` command is a tool that downloads public SSH keys from Git providers (GitHub, Gitlab, Gitea and Bitbucket), S3 containers and IAM groups for authorized users of a server.</sub>

<br /></div>

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)

## &nbsp; ✨ Core features

* Support for multiple providers
* Automatic installation of service

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)

## &nbsp; ⌛️ Quick start

### Installation

**Debian / Ubuntu**

```sh
$ sudo add-apt-repository '{url to repo}'
$ apt update
$ apt install sync-ssh-keys
```

<details>

<summary>Instructions for other operating systems</summary><br />

**macOS**

```sh
$ brew install sync-ssh-keys
```

</details>

### ➤ &nbsp; Basic Usage

```sh
# Save me as an authorized user
# Replace my username (binaryben) with your own GitHub username below
$ sync-ssh-keys add --user "binaryben"

# Manually run command to sync the ssh keys
$ sync-ssh-keys
```

### ➤ &nbsp; Scheduled updates

```sh
# Configure `sync-ssh-keys` to run every hour on the hour
sync-ssh-keys config --cron="0 * * * *"

# Install as a service
sync-ssh-keys install
```

### ➤ &nbsp; Advanced usage

Run `sync-ssh-keys --help` for more options

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)

## &nbsp; 🎨 Prior Art

* https://github.com/samber/sync-ssh-keys
* https://github.com/shoenig/ssh-key-sync
* https://github.com/wdatkinson/sync_ssh_keys
* https://github.com/dkbhadeshiya/ssh-iam-sync
* https://gist.github.com/lleger/6947bdecddac6563a05ead204d95af8e