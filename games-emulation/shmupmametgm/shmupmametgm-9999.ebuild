# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror"

DESCRIPTION="Customized MAME for the TGM series. Forked for extra output options and tooling."
HOMEPAGE="https://github.com/MaryHal/shmupmametgm"
LICENSE="GPL-2+ BSD-2 MIT CC0-1.0"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/MaryHal/shmupmametgm/archive/v${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

SLOT="0"
IUSE="gtk gnome debug X bundled-libs opengl sdl xinerama"
REQUIRED_USE="
	gtk gnome
	X? ( xinerama )
"

# TODO: patch gtk/gnome dependencies as they should only be needed
# for the debugger but the makefile hardcodes the ldflags

RDEPEND="
	!bundled-libs? ( dev-libs/expat sys-libs/zlib )
	opengl? ( virtual/opengl )
	sdl? ( >=media-libs/libsdl-1.2.0[joystick,opengl?,sound,video,X] )
	X? ( x11-libs/libXext )
	xinerama? ( x11-libs/libXinerama )
	gtk? ( x11-libs/gtk+:2 )
	gnome? ( gnome-base/gconf:2 )
"
DEPEND="${RDEPEND} virtual/pkgconfig"

# utils to toggle options in the makefile

disable_feature() {
	sed -i -e "/^[  ]*$2.*=/s:^:# :" $1 || die
}

enable_feature() {
	sed -i -e "/^#.*$2.*=/s:^#[     ]*::" $1 || die
}

src_prepare() {
	default

	if ! use bundled-libs; then
		disable_feature makefile BUILD_EXPAT
		disable_feature makefile BUILD_ZLIB
	fi

	use amd64 && enable_feature makefile PTR64
	if use debug; then
		enable_feature makefile DEBUG
		enable_feature makefile PROFILER
	fi
	! use X && enable_feature src/osd/sdl/sdl.mak NO_X11
}

src_compile() {
	emake SUBTARGET=tgm NOWERROR=1
}

src_install() {
	dodoc README.org
	dodoc docs/*.txt
	dodoc whatsnew.txt
	docinto html
	dodoc fumen_encode.{js,html}
	dobin mametgm*
	einfo ""
	einfo "installed as" mametgm*
	einfo "the default mame.ini path is \$HOME/.mame"
	einfo "the default roms path is ./roms"
	einfo "run" mametgm* "-showconfig to check out the default ini"
	einfo ""
}
