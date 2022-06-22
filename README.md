[![minimal-readme compliant](https://img.shields.io/badge/readme%20style-minimal-brightgreen.svg)](https://github.com/RichardLitt/standard-readme/blob/master/example-readmes/minimal-readme.md) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) <a href="https://benz0li.b-data.io/donate?project=4"><img src="https://benz0li.b-data.io/donate/static/donate-with-fosspay.png" alt="Donate with fosspay"></a> <a href="https://liberapay.com/benz0li/donate"><img src="https://liberapay.com/assets/widgets/donate.svg" alt="Donate using Liberapay" height="20"></a>

# Dockerised Git LFS installation

[This project](https://gitlab.com/b-data/git-lfs/glfsi) is intended for system
administrators who want to perform an installation of Git LFS on any Linux
distribution.

## Table of Contents

*  [Prerequisites](#prerequisites)
*  [Install](#install)
*  [Usage](#usage)
*  [Contributing](#contributing)
*  [License](#license)

## Prerequisites

This projects requires an installation of docker and docker compose.

### Docker

To install docker, follow the instructions for your platform:

*  [Install Docker Engine | Docker Documentation > Supported platforms](https://docs.docker.com/engine/install/#supported-platforms)
*  [Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/engine/install/linux-postinstall/)

### Docker Compose

*  [Install Docker Compose | Docker Documentation](https://docs.docker.com/compose/install/)

## Install

Clone the source code of this project:

```bash
git clone https://gitlab.com/b-data/git-lfs/glfsi.git
```

## Usage

Change directory and make a copy of all `sample.` files:

```bash
cd glfsi

for file in sample.*; do cp "$file" "${file#sample.}"; done;
```

In `.env`, set `GIT_LFS_VERSION` to the desired version of Git LFS
(`<major>.<minor>.<patch>`) and `PREFIX` to the location, where you want the
`git-lfs` programm to be installed (default: `/usr/local`).

Then, create and start container _glfsi_ using options `--build` (_Build images
before starting containers_) and `-V` (_Recreate anonymous volumes instead of
retrieving data from the previous containers_):

```bash
docker-compose up --build -V
```

## Contributing

PRs accepted.

This project follows the
[Contributor Covenant](https://www.contributor-covenant.org)
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE) © 2022 b-data GmbH
