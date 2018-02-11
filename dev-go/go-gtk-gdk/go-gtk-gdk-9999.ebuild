# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Go binding for GDK"
HOMEPAGE="https://github.com/mattn/go-gtk/gdk"
LICENSE="BSD"

EGO_PN="github.com/mattn/go-gtk/gdk"
export CGO_CFLAGS="${CFLAGS}"
export CGO_CPPFLAGS="${CPPFLAGS}"
export CGO_CXXFLAGS="${CXXFLAGS}"
export CGO_LDFLAGS="${LDFLAGS}"
inherit golang-build
inherit golang-vcs

KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="
	${RDEPEND}
	dev-go/go-gtk-gdkpixbuf
	dev-go/go-gtk-pango
"
