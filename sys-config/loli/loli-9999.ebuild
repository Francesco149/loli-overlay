# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs
RESTRICT="strip binchecks"
PROPERTIES="interactive"

DESCRIPTION="loli's personal gentoo config"
HOMEPAGE="https://github.com/Francesco149/loli-overlay"
KEYWORDS="~amd64 ~x86"

SRC_URI=""

LICENSE="UNLICENSE"
SLOT="0"
IUSE=""

# required overlays: mv lto-overlay

# TODO: ranger config
# TODO: temps and rpm monitoring

DEPEND="
	>=sys-kernel/gentoo-sources-4.15.1
	sys-kernel/linux-firmware
	dev-libs/cloog
	>=sys-devel/gcc-7.2.0
	sys-config/ltoize
	app-admin/sudo
"
RDEPEND="${DEPEND}"

XMAMEDIR="/usr/share/games/xmame"
OVERLAYFILESDIR="" # determined in pkg_setup

pkg_setup() {
	local overlaydir

	overlaydir=$(portageq get_repo_path / loli-overlay)
	OVERLAYFILESDIR="${overlaydir}/${CATEGORY}/${PN}/files"

	ewarn "--------------------------------------------------------------------"
	ewarn "you are about to overwrite system-wide files with my own"
	ewarn "as well as setting up your entire system to be recompiled with -O3,"
	ewarn "lto and graphite. everything is specifically tweaked for my hardware"
	ewarn
	ewarn "THIS WILL BREAK YOUR SYSTEM IF YOU'RE NOT ME. PLEASE FORK IT INSTEAD"
	ewarn
	ewarn "to fork this ebuild, make your own local overlay and copy:"
	ewarn "    ${OVERLAYFILESDIR//\/files/}"
	ewarn "then edit the configs in files with your own"
	ewarn
	ewarn "press return if you're me or hit CTRL+C to abort"
	ewarn "--------------------------------------------------------------------"
	read || die "your system is broken"
	ewarn ":: you accepted the risk, I really hope you're me!"
	ewarn
}

install_sym() {
	local fname dstfile
	fname="$(basename "${1}")"
	dstfile="${EPREFIX}/${1}"
	einfo "${1}"
	dosym "${OVERLAYFILESDIR}/${fname}" "${dstfile}"
}

pkg_preinst() {
	local f dst filelist

	einfo
	einfo "--------------------------------------------------------------------"
	einfo "system config"
	install_sym "/usr/src/linux/.config"
	dodir /etc/X11/xinit/xinitrc.d # X is most likely not yet built

	filelist="
		resolv.conf
		conf.d/net
		portage/make.conf
		portage/package.cflags/local_ltoworkarounds.conf
		fstab
		asound.conf
		X11/xinit/xinitrc
		bash/bashrc.d/bashrc
		bash/shit
		sudoers.d/wheel
		profile.d/xdg_cache_home.sh
		vim/vimrc.local
		htoprc
		inputrc
		portage/postsync.d/eix
		portage/repo.postsync.d/egencache
		eixrc/00-eixrc
		local.d/90_eix-update.start
	"

	for f in ${filelist}; do
		install_sym "/etc/${f}"
	done

	for f in 00cpu-flags 01global misc; do
		install_sym "/etc/portage/package.use/${f}"
	done

	dosym net.lo "${EPREFIX}/etc/init.d/net.br0"
	rc-update delete net.enp2s0 boot
	rm /etc/init.d/net.enp2s0

	einfo
	einfo "--------------------------------------------------------------------"
	einfo "savedconfig"
	for f in x11-terms/st-9999 x11-wm/dwm-6.1; do
		install_sym "/etc/portage/savedconfig/${f}"
	done

	einfo
	einfo "--------------------------------------------------------------------"
	einfo "patches"
	dst="/etc/portage/patches/x11-terms/st"
	dodir "${dst}"
	install_sym "${dst}/st-disable-bold-italic-fonts.patch"

	dst="/etc/portage/patches/x11-wm/dwm"
	dodir "${dst}"
	install_sym "${dst}/dwm-scratchpad-20170207-bb3bd6f.patch"

	einfo
	einfo "--------------------------------------------------------------------"
	einfo "misc application configs"
	install_sym "/etc/mpv/mpv.conf"

	filelist="
		gitconfig
		streamlinkrc
		tmux.conf
		rtorrent.rc
		psd.conf
		qemu/bridge.conf
	"

	for f in ${filelist}; do
		install_sym "/etc/${f}"
	done

	einfo "eixpaths"
	$(tc-getCC) ${FILESDIR}/eixpaths.c -o eixpaths || die
	dobin eixpaths

	fowners root:loli /etc/qemu/bridge.conf
	fperms 640 /etc/qemu/bridge.conf

	install_sym "/usr/bin/webcam"

	dst="${XMAMEDIR}"
	einfo "creating" "${dst}"{,/nvram,/cfg,/roms}
	dodir "${dst}"{,/nvram,/cfg,/roms}
	install_sym "${dst}/xmamerc"
	install_sym "${dst}/mame.ini"
	for f in tgm{2p,j}; do
		install_sym "${dst}/nvram/${f}.nv"
		install_sym "${dst}/cfg/${f}.cfg"
	done

	einfo "/usr/bin/tgm1"
	dosym xmame "${EPREFIX}/usr/bin/tgm1"
	install_sym "/usr/bin/tgm2"

	einfo
	einfo "--------------------------------------------------------------------"
	einfo "tmux plugins"
	# TODO: make tpm a package
	dodir /etc/tmux
	git clone https://github.com/tmux-plugins/tpm \
		/etc/tmux/plugins/tpm /dev/null 2>&1 \
	|| git -C /etc/tmux/plugins/tpm pull \
	|| die "your /etc/tmux/plugins/tpm directory is broken, delete/move it"
}

pkg_postinst() {
	elog
	elog "good job, me! you're almost done! if prompted, run"
	elog
	elog "    sudo dispatch-config"
	elog
	elog "and accept everything by pressing u at each prompt, then"
	elog
	elog "    sudo binutils-config --linker ld.gold"
	elog "    sudo emerge gcc"
	elog "    sudo emerge -e @world"
	elog
	elog "to enable gold and rebuild everything with optimizations"
	elog
	elog "if you haven't already, emerge the metapackage"
	elog
	elog "    sudo emerge -a sys-config/loli-packages"
	elog
	elog "for tgm you need to manually put the following roms:"
	elog
	elog "  " cpzn{1,2}.zip tgm{2p,j}.zip
	elog
	elog "in ${XMAMEDIR}/roms"
	elog
	elog "after you're done, recompile the kernel and reboot"
	elog
	elog "    su -"
	elog "    cd /usr/src/linux"
	elog "    make -j13 && make -j13 modules_install && make install"
	elog "    reboot"
	elog
	elog "on your first tmux run, do C-b I to install tmux plugins"
}
