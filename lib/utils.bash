#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/cipherstash/cli-releases"
TOOL_NAME="cipherstash"
TOOL_TEST="stash --help"
OS="${OS:-unknown}"
ARCH="${ARCH:-unknown}"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if cipherstash is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^release-//'
}

list_all_versions() {
	list_github_tags
}

detect_os() {
	if [ "$OS" = "unknown" ]; then
		UNAME="$(command -v uname)"

		case $("${UNAME}" | tr '[:upper:]' '[:lower:]') in
		linux*)
			echo 'unknown-linux-gnu'
			;;
		darwin*)
			echo 'apple-darwin.dmg'
			;;
		# Unsupported for now, I have no machine to test this on.
		# msys* | cygwin* | mingw*)
		# 	echo 'Windows'
		# 	;;
		# nt | win*)
		# 	echo 'Windows'
		# 	;;
		*)
			fail "Unknown operating system. Please provide the operating system version by setting \$OS."
			;;
		esac
	else
		echo "$OS"
	fi
}

detect_arch() {
	if [ "$ARCH" = "unknown" ]; then
		if ! ARCH="$(uname -m)"; then
			fail "\$ARCH not provided and could not call uname -m."
		fi

		# Translate to Auth0 CLI arch names/explicit list of supported arch
		if [ "${ARCH}" == "x86_64" ]; then
			echo "$ARCH"
		elif [ "${ARCH}" == "amd64" ]; then
			echo "x86_64"
		elif [ "${ARCH}" == "arm64" ]; then
			echo "aarch64"
		elif [ "${ARCH}" == "i386" ]; then
			fail "Unsupported architecture: $ARCH"
		elif [ "${ARCH}" == "armv7" ]; then
			fail "Unsupported architecture: $ARCH"
		else
			fail "Unknown architecture. Please provide the architecture by setting \$ARCH."
		fi
	else
		echo "$ARCH"
	fi
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	os=$(detect_os)
	arch=$(detect_arch)
	url="$GH_REPO/releases/download/release-${version}/stash-${arch}-${os}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		mv "$ASDF_DOWNLOAD_PATH/stash" "$install_path/stash"
		chmod +x "$install_path/stash"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
