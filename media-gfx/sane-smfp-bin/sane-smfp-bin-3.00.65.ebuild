# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib

DESCRIPTION="SANE backend for Samsung MFP devices"
HOMEPAGE="http://www.samsung.com"
SRC_URI="
http://downloadcenter.samsung.com/content/DR/201002/20100226135701765/UnifiedLinuxDriver_1.02.tar.gz
-> ${P}.tar.gz
"

LICENSE="Samsung-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="primaryuri strip"

DEPEND=""
RDEPEND="
	sys-libs/libstdc++-v3
	media-gfx/sane-backends
"

S="${WORKDIR}/cdroot/Linux"

src_install() {
	local _arch="i386" _libd="$(get_libdir)"
	use amd64 && _arch="x86_64"

	dolib ${_arch}/at_root/usr/${_libd}/libmfp.so.1.0.1

	insinto /etc/sane.d
	doins noarch/at_root/etc/sane.d/smfp.conf

	exeinto /usr/${_libd}/sane/
	doexe ${_arch}/at_root/usr/${_libd}/sane/libsane-smfp.so.1.0.1
	dosym libsane-smfp.so.1.0.1 /usr/${_libd}/sane/libsane-smfp.so.1

	dosbin ${_arch}/at_root/usr/sbin/smfpd
}

pkg_postinst() {
	elog "You need to add smfp to /etc/sane.d/dll.conf:"
	elog " # echo smfp >> /etc/sane.d/dll.conf"
}