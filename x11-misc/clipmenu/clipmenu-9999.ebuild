# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror"

DESCRIPTION="Clipboard management using dmenu"
HOMEPAGE="https://github.com/cdown/clipmenu"
LICENSE="public-domain"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/cdown/clipmenu/archive/${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	x11-misc/dmenu
	x11-misc/xsel
"

src_install() {
	dobin clipmenu
	dobin clipmenud
	dodoc LICENSE
	dodoc README.md
	systemd_newunit "init/clipmenud.service" "clipmenud@.service"
}

src_test() {
	local t
	for t in "tests/*"; do
		einfo "running ${t}"
		. ${t} || die "${t} failed"
	done
}
