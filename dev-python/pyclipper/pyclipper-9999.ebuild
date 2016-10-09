# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/greginvm/${PN}.git"
	REQUIRED_USE="cython"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"
	DEPEND="app-arch/unzip"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Cython wrapper for the Clipper library"
HOMEPAGE="https://github.com/greginvm/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="+cython"

RDEPEND="
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )
"
DEPEND+="
	${RDEPEND}
	>=dev-python/setuptools_scm-1.11.1[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	use cython || rm -f "${S}"/dev
}