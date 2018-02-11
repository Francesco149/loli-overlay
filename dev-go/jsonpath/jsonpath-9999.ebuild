# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror"

DESCRIPTION="OpenSource JSON-Path"
HOMEPAGE="https://github.com/NodePrime/jsonpath"
LICENSE="MIT"

EGO_PN="github.com/NodePrime/jsonpath"
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
	EGIT_COMMIT="v${PV}"
	inherit golang-vcs-snapshot
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
