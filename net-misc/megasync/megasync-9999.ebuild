# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools versionator gnome2 qmake-utils
MY_PN="MEGAsync"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	SRC_URI=
else
	MY_P="${MY_PN}-$(replace_all_version_separators '_')_Linux"
	MY_SDK="f1f9d50"
	SRC_URI="
		mirror://githubcl/meganz/${MY_P%-*}/tar.gz/v${MY_P##*-}
		-> ${MY_P}.tar.gz
		mirror://githubcl/meganz/sdk/tar.gz/${MY_SDK}
		-> meganz-sdk-${MY_SDK}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Easy automated syncing with MEGA Cloud Drive"
HOMEPAGE="https://github.com/meganz/MEGAsync"

LICENSE="EULA"
LICENSE_URL="https://raw.githubusercontent.com/meganz/MEGAsync/master/LICENCE.md"
SLOT="0"
IUSE="examples nautilus qt5"

DEPEND=""
RDEPEND="
	dev-libs/libuv
	dev-libs/crypto++
	dev-db/sqlite:3
	net-dns/c-ares
	dev-libs/openssl:0
	net-misc/curl
	!qt5? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtwidgets:5 )
	nautilus? ( >=gnome-base/nautilus-3 )
	examples? ( sys-libs/readline )
"
DOCS=( CREDITS.md README.md )
PATCHES=( "${FILESDIR}"/${PN}-qmake.diff )

src_prepare() {
	default
	local _sdk="${S}/src/MEGASync/mega"
	if [[ -n ${PV%%*9999} ]]; then
		rm -r "${_sdk}"
		mv -f "${WORKDIR}"/sdk-${MY_SDK} "${_sdk}"
	fi
	cd "${_sdk}"
	eautoreconf
}

src_configure() {
	pushd "${S}"/src/MEGASync/mega > /dev/null
	econf \
		--with-sqlite \
		--with-cryptopp \
		--with-curl \
		--without-sodium \
		--without-freeimage
	popd > /dev/null

	local _qmake="eqmake$(usex qt5 5 4)"
	cd src
	${_qmake} \
		$(usex nautilus 'CONFIG+=with_ext' '') \
		$(usex examples 'CONFIG+=with_tools' '') \
		'CONFIG+=no_desktop'
}

src_compile() {
	cd src
	local _qdir=$(usex qt5 $(qt5_get_bindir) $(qt4_get_bindir))
	${_qdir}/lrelease MEGASync/MEGASync.pro
	default
}

src_install() {
	einstalldocs
	emake -C src INSTALL_ROOT="${D}" install
}