# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Aften is an open-source A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/aften"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=""
RDEPEND=""

src_compile() {
	local myconf
	use debug || myconf="${myconf} --disable-debug"
	./configure \
		--prefix=/usr \
		--log=config.log \
		--disable-strip \
		--disable-opts \
		${myconf} || die
	make || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc Changelog README
}
