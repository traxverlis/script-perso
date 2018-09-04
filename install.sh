#!/bin/bash
_PKG="tmux htop iftop git"

clear

echo ""




######Check to make sure script is being run as root######
if [ `whoami` != root ]; then
    echo "This script must be run as root"
    exit 1
fi

###
### Helpers
###

_os_is() {
  [[ "$_OSTYPE" = "$*" ]]
}

_exec_() {
  local _type="$1"
  shift
  if _os_is $_type; then
    [[ -z "$_VERBOSE" ]] || _error "Going to execute: $* $_VERBOSE $_FORCE"
    eval "$* $_VERBOSE $_FORCE"
  fi
}



# Detect package type from /etc/issue
_found_arch() {
  local _ostype="$1"
  grep -qis "$2" /etc/issue && _OSTYPE="$_ostype"
}

# Detect package type
_OSTYPE_detect() {
  #_found_arch PACMAN "Arch Linux" && return
  _found_arch DPKG   "Debian GNU/Linux" && return
  _found_arch DPKG   "Ubuntu" && return
  _found_arch YUM    "CentOS" && return
  _found_arch YUM    "Red Hat" && return
  _found_arch YUM    "Fedora" && return


 
  #[[ -x "/usr/bin/pacman" ]]           && _OSTYPE="PACMAN" && return
  [[ -x "/usr/bin/apt-get" ]]          && _OSTYPE="DPKG" && return
  [[ -x "/usr/bin/yum" ]]              && _OSTYPE="YUM" && return

  if [[ -z "$_OSTYPE" ]]; then
    _error "No supported package manager installed on system"
    _error "(supported: apt, homebrew, pacman, portage, yum)"
    exit 1
  fi
}


###
### Main
###

cat 1>&2 <<-EOF
WARNING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

_OSTYPE_detect


_exec_ YUM      "yum -y install $_TOPT $_PKG"
_exec_ DPKG     "apt-get install -y $_TOPT $_PKG"


