# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="The-${PN}-Font"
FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${MY_PN}"
else
	inherit vcs-snapshot
	MY_PV="e8be3a0"
	SRC_URI="
		mirror://githubcl/impallari/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A bold condensed script font with ligatures and alternates"
HOMEPAGE="http://www.impallari.com/lobster"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		FONT_S=( fonts/{o,t}tf )
	else
		FONT_S=( master_{o,t}tf )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/sources/${PN}.glyphs \
		-o ${FONT_SUFFIX} \
		|| die
}