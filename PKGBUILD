# Maintainer: Versus Void <chaoskeeper@mail.ru>

_source_package=$(curl -s https://www.archlinux.org/packages/core/$CARCH/linux/download/ --write-out '%{redirect_url}')
if [ ! "$_source_package" ]; then
	echo "Can't find current kernel package"
	return 1
fi

_full_version=${_source_package##*linux-}
_full_version=${_full_version%%-$CARCH.pkg.tar*}
pkgver=${_full_version%-*}
pkgrel=${_full_version##*-}
_kernel_version=${pkgver%.*}

pkgname=('linux-rolling' "linux-rolling_${_full_version//[.-]/_}")
pkgdesc="Arch's kernel how it meant to be"
arch=('i686' 'x86_64')
url="https://bugs.archlinux.org/task/16702"
license=('GPL2')
replaces=()
options=('!strip')
source=(
	$_source_package{,.sig}
	"rolling.conf"
	"clean-old-kernels"
	"91-extramodules-version.hook"
	"relink-extramodules-version"
	"91-grub.hook"
	"update-grub"
)
sha256sums=(
	"SKIP" "SKIP"
	"fa56a9d520046462a29ff5c52af2f40026a9c6537cf212b8bb2f1f41ee0838fd"
	"eb087e424d1309edeb0ca9e367d7220dbc309f768aac9d2e3de495a3ad04fb6c"
	"7f11c0e3a11c0088789676c0398d15c6a71dc7094c78e4093bd72e8421fbcb84"
	"dc9912bce065140f5a955795e10490c15b42a95dcf92b5c208fe76f7ac488a0e"
	"bb519b71092079a66498f22ef89feb6d41393d61688896ebe0226f979ed6655e"
	"6a4f3779e07cfbba36fd25fb4853292e4559ca96a750121836c8bedb7e1132bc"
)
validpgpkeys=('5B7E3FB71B7F10329A1C03AB771DF6627EDF681F') # Tobias Powalowski <tobias.powalowski@googlemail.com>

package_linux-rolling() {
	arch=('any')
	depends=("linux-rolling_${_full_version//[.-]/_}=$_full_version" "bash")
	install=linux-transitional.install

	install -Dm644 91-grub.hook "$pkgdir/usr/share/libalpm/hooks/91-grub.hook"
	install -Dm644 91-extramodules-version.hook "$pkgdir/usr/share/libalpm/hooks/91-extramodules-version.hook"
	install -Dm644 rolling.conf "$pkgdir/etc/rolling.conf"
	install -Dm755 clean-old-kernels "$pkgdir/usr/bin/clean-old-kernels"
	install -Dm755 relink-extramodules-version "$pkgdir/usr/lib/linux-rolling/relink-extramodules-version"
	install -Dm755 update-grub "$pkgdir/usr/lib/linux-rolling/update-grub"
}

_package_linux-rolling() {
	pkgdesc="The Linux kernel and modules"
	backup=("etc/mkinitcpio.d/linux-$pkgver-$pkgrel.preset")
	depends=('coreutils' 'linux-firmware' 'kmod' 'mkinitcpio>=0.7')
	optdepends=('crda: to set the correct wireless channels of your country')
	provides=("linux=$pkgver-$pkgrel")
	conflicts=("linux=$pkgver-$pkgrel")
	sed "{
		s#boot/initramfs-linux.img#boot/initramfs-linux-$pkgver-$pkgrel.img#g;
		s#boot/initramfs-linux-fallback.img#boot/initramfs-linux-$pkgver-$pkgrel-fallback.img#g;
	}" .INSTALL > ${startdir}/linux.install.pkg
	true && install=linux.install.pkg

	mkdir -p "$pkgdir/boot"
	mv boot/vmlinuz-linux "$pkgdir/boot/vmlinuz-linux-$pkgver-$pkgrel"

	sed -i "{
		s#/boot/vmlinuz-linux#/boot/vmlinuz-linux-$pkgver-$pkgrel#g;
		s#/boot/initramfs-linux.img#/boot/initramfs-linux-$pkgver-$pkgrel.img#g;
		s#/boot/initramfs-linux-fallback.img#/boot/initramfs-linux-$pkgver-$pkgrel-fallback.img#g;
	}" etc/mkinitcpio.d/linux.preset
	mkdir -p "$pkgdir/etc/mkinitcpio.d"
	mv etc/mkinitcpio.d/linux.preset "$pkgdir/etc/mkinitcpio.d/linux-$pkgver-$pkgrel.preset"

	sed -i "{
		s#boot/vmlinuz-linux#boot/vmlinuz-linux-$pkgver-$pkgrel#g;
		s#mkinitcpio -p linux#mkinitcpio -p linux-$pkgver-$pkgrel#g;
	}" usr/share/libalpm/hooks/90-linux.hook
	mkdir -p "$pkgdir/usr/share/libalpm/hooks"
	mv usr/share/libalpm/hooks/90-linux.hook "$pkgdir/usr/share/libalpm/hooks/90-linux-$pkgver-$pkgrel.hook"

	mv usr/lib "$pkgdir/usr/"

	mv "$pkgdir/usr/lib/modules/extramodules-$_kernel_version-ARCH/version" \
		"$pkgdir/usr/lib/modules/extramodules-$_kernel_version-ARCH/version-$pkgver-$pkgrel"
}

eval "package_${pkgname[1]}() {
	$(declare -f _package_linux-rolling)
	_package_linux-rolling
}"
