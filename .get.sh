#!/usr/bin/env bash
#
# some parts shamelessly borrowed from NVM
#

{ # this ensures the entire script is downloaded #

msg() {
	echo >&2 "$@"
}

host_has() {
  type "$1" > /dev/null 2>&1
}

download() {
  if host_has "curl"; then
    curl -L -q $*
  elif host_has "wget"; then
    # Emulate curl with wget
    ARGS=$(echo "$*" | command sed -e 's/--progress-bar /--progress=bar /' \
                           -e 's/-L //' \
                           -e 's/-I /--server-response /' \
                           -e 's/-s /-q /' \
                           -e 's/-o /-O /' \
                           -e 's/-C - /-c /')
    wget $ARGS
  fi
}

die() {
	echo >&2 $*
	exit 1
}

#
# Detect profile file if not specified as environment variable
# (eg: PROFILE=~/.myprofile)
# The echo'ed path is guaranteed to be an existing file
# Otherwise, an empty string is returned
#
detect_profile() {
  if [ -n "$PROFILE" -a -f "$PROFILE" ]; then
    echo "$PROFILE"
    return
  fi

  local DETECTED_PROFILE
  DETECTED_PROFILE=''
  local SHELLTYPE
  SHELLTYPE="$(basename "/$SHELL")"

  if [ "$SHELLTYPE" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    fi
  elif [ "$SHELLTYPE" = "zsh" ]; then
    DETECTED_PROFILE="$HOME/.zshrc"
  fi

  if [ -z "$DETECTED_PROFILE" ]; then
    if [ -f "$HOME/.profile" ]; then
      DETECTED_PROFILE="$HOME/.profile"
    elif [ -f "$HOME/.bashrc" ]; then
      DETECTED_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
      DETECTED_PROFILE="$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
      DETECTED_PROFILE="$HOME/.zshrc"
    fi
  fi

  if [ ! -z "$DETECTED_PROFILE" ]; then
    echo "$DETECTED_PROFILE"
  fi
}

cmd() {
	label="$1"
	shift

	if [ -n "$label" ]; then
		msg "$label"
	fi

	"$@" || {
		echo >&2 "Unable to run: $@"
		exit 1
	}
}

has_cmd() {
    name="$1"
	expl="$2"
	if ! host_has $name ; then
		cat <<END

--> Pre-Requisite: You need \`$name\`, try:
$expl
END
		let errs++
	fi
}

# if called from within an existing virtual env, strip it out
if [ -n "$VIRTUAL_ENV" ]; then
    p=$(echo "$PATH" | sed -e 's!'${VIRTUAL_ENV}'/bin!!;s/::/:/')
    export PATH=$p
    unset VIRTUAL_ENV
fi

base=~/.docker-tools
if [ -e $base -a ! -d $base ]; then
	msg "Cannot continue: $base is not a directory"
	exit 1
fi
if [ ! -d $base ]; then
	mkdir $base
fi
cd $base
rm -rf bin
mkdir bin

gitraw=https://raw.github.com/srevenant/docker-tools/master/
dlurl=https://github.com/srevenant/docker-tools/archive/$version.tar.gz

files=$(download -s $gitraw/.files)
for f in $files; do
	download -s $gitraw/$f -o $f
	chmod 755 $f
done

profile=$(detect_profile)
sed -io -e '/#DOCKER-TOOLS-PATH/d' $profile
echo "export PATH=\$PATH:$base/bin #DOCKER-TOOLS-PATH" >> $profile

echo ""
echo "Done installing.  Please reload your shell to get the new PATH."
echo ""

} # this ensures the entire script is downloaded #

