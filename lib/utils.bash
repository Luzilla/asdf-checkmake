#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/checkmake/checkmake"
TOOL_NAME="checkmake"
TOOL_TEST="checkmake --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

# taken from asdf-golang
get_platform() {
  local silent=${1:-}
  local platform=""

  platform="$(uname | tr '[:upper:]' '[:lower:]')"

  case "$platform" in
    linux | darwin | freebsd)
      [ -z "$silent" ] && msg "Platform '${platform}' supported!"
      ;;
    *)
      fail "Platform '${platform}' not supported!"
      ;;
  esac

  printf "%s" "$platform"
}

get_arch() {
  local arch=""
  local arch_check=${ASDF_GOLANG_OVERWRITE_ARCH:-"$(uname -m)"}
  case "${arch_check}" in
    x86_64 | amd64) arch="amd64" ;;
    i686 | i386 | 386) arch="386" ;;
    armv6l | armv7l) arch="armv6l" ;;
    aarch64 | arm64) arch="arm64" ;;
    ppc64le) arch="ppc64le" ;;
    loongarch64 | loong64) arch="loong64" ;;
    riscv64) arch="riscv64" ;;
    *)
      fail "Arch '${arch_check}' not supported!"
      ;;
  esac

  printf "%s" "$arch"
}


sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	local platform=""
	local arch=""

	platform=$(get_platform)
	arch=$(get_arch)

	version="$1"
	filename="$2"

	url="${GH_REPO}/releases/download/${version}/${TOOL_NAME}-${version}.${platform}.${arch}"

	# TODO: Adapt the release URL convention for checkmake
	# url="$GH_REPO/archive/v${version}.tar.gz"

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
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
