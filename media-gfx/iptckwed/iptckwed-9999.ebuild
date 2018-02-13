# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 toolchain-funcs

DESCRIPTION="IPTC keyword editor"
HOMEPAGE="https://github.com/muennich/iptckwed"
EGIT_REPO_URI="https://github.com/muennich/iptckwed.git"

LICENSE="unknown"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/libexif"
RDEPEND="${DEPEND}"

src_compile() {
	emake V=1 CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
}
