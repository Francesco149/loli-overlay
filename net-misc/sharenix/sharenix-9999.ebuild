# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror"

DESCRIPTION="ShareX clone for linux"
HOMEPAGE="https://github.com/Francesco149/sharenix"

EGO_PN="github.com/Francesco149/sharenix"
export CGO_CFLAGS="${CFLAGS}"
export CGO_CPPFLAGS="${CPPFLAGS}"
export CGO_CXXFLAGS="${CXXFLAGS}"
export CGO_LDFLAGS="${LDFLAGS}"
inherit golang-build

if [[ ${PV} == *9999* ]]; then
	inherit golang-vcs
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="${PV//_alpha/a}"
	inherit golang-vcs-snapshot
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-go/go-pointer
	dev-go/jsonpath
	dev-go/goxpath
	dev-go/xurls
	dev-go/xgb
	dev-go/go-gtk
"
RDEPEND=""

src_install() {
	default
	dobin ${PN}
	dobin "${S}/src/${EGO_PN}/${PN}-window"
	dobin "${S}/src/${EGO_PN}/${PN}-section"
	insinto /etc && doins "${S}/src/${EGO_PN}/${PN}.json"
	dodoc "${S}/src/${EGO_PN}/README.md"
}
