# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

MY_PN="browser-token-signing"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/v${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit nsplugins

DESCRIPTION="Estonian ID card browser plugin"
HOMEPAGE="http://id.ee/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

DEPEND="
	x11-libs/gtk+:2
	dev-libs/openssl
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"
CMAKE_IN_SOURCE_BUILD='y'
DOCS=( README.md RELEASE-NOTES.txt )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CFLAGS}" \
		plugin
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins npesteid-firefox-plugin.so
	einstalldocs
}

pkg_postinst() {
	elog "Estonian ID Card PKCS11 module loader is available at"
	elog "https://addons.mozilla.org/firefox/addon/est-pkcs11-load"
}
