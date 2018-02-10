# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The X Go Binding is a low-level API to communicate with the X server. It is modeled on XCB and supports many X extensions."
HOMEPAGE="https://github.com/BurntSushi/xgb"
LICENSE="BSD-3-Clause"

EGO_PN="github.com/BurntSushi/xgb"
export CGO_CFLAGS="${CFLAGS}"
export CGO_CPPFLAGS="${CPPFLAGS}"
export CGO_CXXFLAGS="${CXXFLAGS}"
export CGO_LDFLAGS="${LDFLAGS}"
inherit golang-build
inherit golang-vcs

KEYWORDS=""
SLOT="0"
IUSE=""

DEPEND="dev-lang/go"
RDEPEND=""
