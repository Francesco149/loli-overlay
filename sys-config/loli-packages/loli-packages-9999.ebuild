# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="strip binchecks"
inherit multilib multilib-minimal

DESCRIPTION="loli's personal gentoo package config"
HOMEPAGE="https://github.com/Francesco149/loli-overlay"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="psd"

# this is in a separate metapackage simply to avoid installing the packages
# before optimizations are enabled

DEPEND="
	sys-config/loli
	sys-apps/lm_sensors
	sys-apps/busybox
	sys-process/htop
	psd? (
		sys-process/dcron
		=www-misc/profile-sync-daemon-5.75
	)
	app-portage/gentoolkit
	app-portage/eix
	net-misc/curl
	app-editors/vim
	app-editors/emacs
	app-emacs/ebuild-mode
	app-misc/neofetch
	app-misc/ranger
	app-misc/tmux
	net-p2p/rtorrent
	app-shells/peco
	dev-python/m2crypto
	dev-python/pip
	dev-python/requests
	media-libs/exiftool
	>=media-libs/mesa-18.0.0_rc3[${MULTILIB_USEDEP}]
	x11-base/xorg-server
	x11-base/xorg-drivers
	x11-wm/dwm
	=x11-terms/st-9999
	x11-misc/xclip
	x11-misc/clipmenu
	x11-misc/slock
	x11-misc/xautolock
	x11-apps/xrectsel
	x11-apps/xfontsel
	x11-misc/gbdfed
	x11-apps/xprop
	x11-apps/xrandr
	x11-apps/xset
	=www-client/qutebrowser-9999
	www-client/w3m
	=net-misc/sharenix-9999
	app-emulation/qemu
	games-emulation/xmame
	=games-emulation/shmupmametgm-9999
	=net-misc/streamlink-9999
	=net-misc/youtube-dl-99999999
	net-misc/megatools
	media-video/mpv
	media-video/mplayer
	media-gfx/fbgrab
	media-gfx/gimp
	media-gfx/imagemagick
	media-gfx/scrot
	=media-gfx/sxiv-9999
	media-gfx/exiv2
	media-gfx/iptckwed
	media-fonts/noto
	media-fonts/noto-cjk
	media-fonts/font-misc-misc
	media-fonts/corefonts
	=media-fonts/2xprotamsyn-9999
"
RDEPEND="${DEPEND}"
S="${WORKDIR}" # why do I need this?

pkg_postinst() {
	use psd || return
	einfo "adding and starting services"
	rc-update add dcron default && rc-service dcron start
	rc-update add psd default && rc-service psd start
}
