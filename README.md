> **Warning**: The proposal for this software is currently being developed. Please do not attempt to use it yet.

<br /><br /><div align="center">

# 🔐 Sync SSH Keys
<br />

![ISC License](https://img.shields.io/badge/license-ISC-green?style=for-the-badge) &nbsp; ![Project Status](https://img.shields.io/badge/status-💡%20PROPOSAL-yellow?style=for-the-badge)

<strong>Maintain access to your servers without fuss. Automate your `~/.ssh/authorized_keys` with ease.</strong><br />
<sub>The `sync-ssh-keys` command is a tool that downloads public SSH keys from Git providers (GitHub, Gitlab, Gitea and Bitbucket), S3 containers and IAM groups for authorized users of a server.</sub>

<br /></div>

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)

## ✨ &nbsp; Core features

* Support for multiple providers
* Automatic installation of service

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)

## ⌛️ &nbsp; Quick start

### Installation

**Debian / Ubuntu**

```sh
$ sudo add-apt-repository '{url to repo}'
$ apt update
$ apt install ssh-keys
```

<details>

<summary>Instructions for other operating systems</summary><br />

**Alpine**

```sh
apk add ssh-keys
```

**macOS**

```sh
$ brew install ssh-keys
```

> **Warning:** the below distros have not been tested by myself

**CentOS**

TODO:

**OpenSUSE**

TODO:

**FreeBSD**

TODO:

**Fedora**

TODO:

</details>

### ➤ &nbsp; Basic Usage

```sh
# Save me as an authorized user
# Replace my username (binaryben) with your own GitHub username below
$ ssh-keys add --user=binaryben

# Manually run command to sync the ssh keys
$ ssh-keys sync
```

### ➤ &nbsp; Scheduled updates

```sh
# Configure `ssh-keys sync` to run every hour on the hour
# Optional: This is already configured as the default update interval
ssh-keys config cron "0 * * * *"

# Install as a service
ssh-keys install
```

### ➤ &nbsp; Advanced usage

Run `ssh-keys --help` for more options

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)

## 🏎💨 &nbsp; Rate limiting

You most likely won't need to worry about being rate limited for very simple use cases. Once everything is setup and running (APIs may be called when adding users for the first time), running unauthenticated will work for servers with a few dozen users being synced once per hour.

If you run into rate limiting issues, follow the instructions below for the provider you are using:

<hr />

<details><summary><strong>Github</strong></summary><br />

GitHub limits at a rate of 60 requests per hour for unauthenticated requests. Follow the instructions below to increase this to 5,000 per hour.

1. Visit your **Settings** > **Developer settings** > [**Personal access tokens**](https://github.com/settings/tokens) page
2. Click the "Generate token" button
3. Authenticate if requested
4. Give the token a title (e.g. "Sync SSH Keys")
5. Select no expiration[^expiration-security]
6. Tick `read:public_key`
7. Click generate token and copy the token to the clipboard
8. Run `ssh-keys config github.token <token>`

Make sure you replace `<token>` in Step 8 with the copied token from Step 7

[^expiration-security]: Give any personal authentication token a fixed expiration if you are enabling any scope that accesses private data.

</details>

<hr />

Keep in mind the steps above are only for accessing public data via the respective APIs (i.e. publically available SSH keys). Other tokens may need to be provided elsewhere, but `ssh-keys` will prompt you when this is likely to be needed.

![Divider](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png)


## 🎨 &nbsp; Prior Art

* https://github.com/samber/sync-ssh-keys
* https://github.com/shoenig/ssh-key-sync
* https://github.com/wdatkinson/sync_ssh_keys
* https://github.com/dkbhadeshiya/ssh-iam-sync
* https://gist.github.com/lleger/6947bdecddac6563a05ead204d95af8e
* [And others...](https://github.com/search?q=sync+ssh+keys&type=Repositories)