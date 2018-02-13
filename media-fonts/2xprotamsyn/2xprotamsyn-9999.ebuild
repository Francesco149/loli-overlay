# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="strip binchecks mirror"
inherit font font-ebdftopcf

DESCRIPTION="ProFont-11 2x upscaled with a couple extra glyphs from Tamsyn"
HOMEPAGE="https://github.com/Francesco149/2xProTamsyn"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_S="${S}/"
FONT_SUFFIX="pcf.gz"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
	EGIT_REPO_URI="${HOMEPAGE}.git"
	S="${WORKDIR}/2xprotamsyn-${PV}"
	inherit git-r3
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz"
	S="${WORKDIR}/2xProTamsyn-${PV}"
	KEYWORDS="~x86 ~amd64"
fi

src_compile() {
	font-ebdftopcf_src_compile
}
