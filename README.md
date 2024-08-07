<div align="center">

# asdf-cipherstash [![Build](https://github.com/gunzy83/asdf-cipherstash/actions/workflows/build.yml/badge.svg)](https://github.com/gunzy83/asdf-cipherstash/actions/workflows/build.yml) [![Lint](https://github.com/gunzy83/asdf-cipherstash/actions/workflows/lint.yml/badge.svg)](https://github.com/gunzy83/asdf-cipherstash/actions/workflows/lint.yml)

[cipherstash](https://cipherstash.com/docs/reference/cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add cipherstash
# or
asdf plugin add cipherstash https://github.com/gunzy83/asdf-cipherstash.git
```

cipherstash:

```shell
# Show all installable versions
asdf list-all cipherstash

# Install specific version
asdf install cipherstash latest

# Set a version globally (on your ~/.tool-versions file)
asdf global cipherstash latest

# Now cipherstash commands are available
stash --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/gunzy83/asdf-cipherstash/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Ross Williams](https://github.com/gunzy83/)
