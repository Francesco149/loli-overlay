# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Forked from https://data.gpo.zugaina.org/reagentoo/

EAPI=6

inherit savedconfig eutils gnome2-utils xdg cmake-utils \
	    toolchain-funcs flag-o-matic multilib git-r3

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"
EGIT_REPO_URI="https://github.com/telegramdesktop/tdesktop.git"
EGIT_SUBMODULES=(
	Telegram/ThirdParty/crl
	Telegram/ThirdParty/libtgvoip
	Telegram/ThirdParty/variant
	Telegram/ThirdParty/GSL
)

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
IUSE="gtk3"

RDEPEND="
	dev-libs/openssl:0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5[jpeg,png,xcb]
	dev-qt/qtnetwork
	dev-qt/qtimageformats
	dev-qt/qtwidgets[png,xcb]
	media-libs/openal
	media-libs/opus
	media-sound/pulseaudio
	sys-libs/zlib[minizip]
	virtual/ffmpeg
	x11-libs/libdrm
	x11-libs/libva[X,drm]
	x11-libs/libX11
	!net-im/telegram
	!net-im/telegram-desktop-bin
	gtk3? (
		x11-libs/gtk+:3
		dev-libs/libappindicator:3
		dev-qt/qtgui:5[gtk(+)]
	)
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

CMAKE_MIN_VERSION="3.8"
CMAKE_USE_DIR="${S}/Telegram"

PATCHES=("${FILESDIR}/patches")

pkg_pretend() {
	if tc-is-gcc && ! version_is_at_least 7.0 "$(gcc-version)"; then
		die "gcc >= 7.0 is required"
	fi
}

src_prepare() {
	default

	cat > config.h << "EOF"
#pragma once

/* the default values for these are my own app id.
 * if you edit this, you should get your own at
 * https://core.telegram.org/api/obtaining_api_id */
#define TELEGRAM_API_ID   33266
#define TELEGRAM_API_HASH "8b40dc9cf6427eb16c493e78ac4630ac"

/* original telegram desktop key */
/* #define TELEGRAM_API_ID   17349 */
/* #define TELEGRAM_API_HASH "344583e45741c457fe1862106095a5eb" */

/* change these to any font name to override the defaults.
   example: qsl("Arial") */
#define TELEGRAM_FT_OVERRIDE           qsl("")
#define TELEGRAM_FT_SEMIBOLD_OVERRIDE  qsl("")
#define TELEGRAM_FT_MONOSPACE_OVERRIDE qsl("")

EOF

	restore_config config.h

	local CMAKE_MODULES_DIR="${S}/Telegram/cmake"
	local THIRD_PARTY_DIR="${S}/Telegram/ThirdParty"
	local LIBTGVOIP_DIR="${THIRD_PARTY_DIR}/libtgvoip"

	cp "${FILESDIR}/Telegram.cmake" "${S}/Telegram/CMakeLists.txt"
	cp "${FILESDIR}/ThirdParty-crl.cmake" "${THIRD_PARTY_DIR}/crl/CMakeLists.txt"
	cp "${FILESDIR}/ThirdParty-libtgvoip.cmake" "${LIBTGVOIP_DIR}/CMakeLists.txt"
	cp "${FILESDIR}/ThirdParty-libtgvoip-webrtc.cmake" \
		"${LIBTGVOIP_DIR}/webrtc_dsp/webrtc/CMakeLists.txt"

	mkdir "${CMAKE_MODULES_DIR}" || die
	cp "${FILESDIR}/FindBreakpad.cmake" "${CMAKE_MODULES_DIR}"
	cp "${FILESDIR}/TelegramCodegen.cmake" "${CMAKE_MODULES_DIR}"
	cp "${FILESDIR}/TelegramCodegenTools.cmake" "${CMAKE_MODULES_DIR}"
	cp "${FILESDIR}/TelegramTests.cmake" "${CMAKE_MODULES_DIR}"

	unset EGIT_COMMIT
	unset EGIT_SUBMODULES
	unset PATCHES

	EGIT_REPO_URI="https://github.com/ericniebler/range-v3.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/range-v3"
	EGIT_COMMIT_DATE=$(GIT_DIR=${S}/.git git show -s --format=%ct || die)

	git-r3_src_unpack
	cmake-utils_src_prepare

	mv "${S}"/lib/xdg/telegram{,-}desktop.desktop || \
		die "Failed to fix .desktop-file name"
}

src_configure() {
	local mycxxflags=(
		-isystem"${WORKDIR}/range-v3/include"
		-DLIBDIR="$(get_libdir)"
	)

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS:="${mycxxflags[*]}"
		-DENABLE_CRASH_REPORTS=0
		-DENABLE_GTK_INTEGRATION=$(usex gtk3)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	default

	local icon_size
	for icon_size in 16 32 48 64 128 256 512; do
		newicon -s "${icon_size}" \
			"${S}/Telegram/Resources/art/icon${icon_size}.png" \
			telegram-desktop.png
	done

	save_config config.h
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
