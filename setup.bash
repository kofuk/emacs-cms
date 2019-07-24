# Setup binary and environment variable to
# execute *.el with specific shebang directly.

# Licensed under the AGPL v3 or later.

CC=${CC:-cc}

if ! command -v $CC &>/dev/null && ! command -v make &>/dev/null; then
    echo "$CC or make not found" >&2
else
    (
        cd loader
        make
    )
    PATH="$PWD/loader:$PATH"
fi
