# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An XPath 1.0 implementation written in the Go programming language."
HOMEPAGE="https://github.com/ChrisTrenkamp/goxpath"
LICENSE="MIT"

EGO_PN="github.com/ChrisTrenkamp/goxpath"
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
	EGIT_COMMIT="${PV//_alpha/-alpha}"
	EGIT_COMMIT="v${EGIT_COMMIT//_p/}"
	inherit golang-vcs-snapshot
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
fi

SLOT="0"
IUSE=""

DEPEND="
	dev-lang/go
	dev-go/go-text
	dev-go/go-net
"
RDEPEND=""
