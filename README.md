<div align="center">

# asdf-checkmake [![Build](https://github.com/Luzilla/asdf-checkmake/actions/workflows/build.yml/badge.svg)](https://github.com/Luzilla/asdf-checkmake/actions/workflows/build.yml) [![Lint](https://github.com/Luzilla/asdf-checkmake/actions/workflows/lint.yml/badge.svg)](https://github.com/Luzilla/asdf-checkmake/actions/workflows/lint.yml)

[checkmake](https://github.com/checkmake/checkmake) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `asdf` (`bash`, `curl`)

# Install

Plugin:

```shell
asdf plugin add checkmake
# or
asdf plugin add checkmake https://github.com/Luzilla/asdf-checkmake.git
```

checkmake:

```shell
# Show all installable versions
asdf list-all checkmake

# Install specific version
asdf install checkmake latest

# Set a version globally (on your ~/.tool-versions file)
asdf global checkmake latest

# Now checkmake commands are available
checkmake --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Luzilla/asdf-checkmake/graphs/contributors) and [the authors/contributors](https://github.com/checkmake/checkmake/graphs/contributors) of checkmake!

# License

See [LICENSE](LICENSE) © [Luzilla Capital GmbH](https://github.com/Luzilla/)
