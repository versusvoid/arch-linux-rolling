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

pkgname=('linux-rolling-transitional' "linux-rolling_${_full_version//[.-]/_}")
pkgbase=linux-rolling
pkgdesc="Arch's kernel how it meant to be"
arch=('i686' 'x86_64')
url="https://bugs.archlinux.org/task/16702"
license=('GPL2')
replaces=()
options=('!strip')
source=(
	$_source_package{,.sig}
	"91-grub.hook"
	"rolling.conf"
	"clean-old-kernels"
)
sha256sums=(
	"SKIP" "SKIP"
	"a50791c4a0b4d15b803838d8718215c0addf0f849e9db5f94860591a312918ef"
	"2a05e4b8b0f285168863415c49d7259fd4c51bb1e4312b1e9dbe9e4823e61981"
	"eb087e424d1309edeb0ca9e367d7220dbc309f768aac9d2e3de495a3ad04fb6c"
)
validpgpkeys=('5B7E3FB71B7F10329A1C03AB771DF6627EDF681F') # Tobias Powalowski <tobias.powalowski@googlemail.com>

package_linux-rolling-transitional() {
	arch=('any')
	depends=("linux-rolling_${_full_version//[.-]/_}=$_full_version")
	optdepends=('bash: cleanup script')
	install=linux-transitional.install

	install -Dm644 91-grub.hook "$pkgdir/usr/share/libalpm/hooks/91-grub.hook"
	install -Dm644 rolling.conf "$pkgdir/etc/rolling.conf"
	install -Dm755 clean-old-kernels "$pkgdir/usr/bin/clean-old-kernels"
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
		s#boot/initramfs-linux-fallback.img#boot/initramfs-linux-fallback-$pkgver-$pkgrel.img#g;
	}" .INSTALL > ${startdir}/linux.install.pkg
	true && install=linux.install.pkg

	mkdir -p "$pkgdir/boot"
	mv boot/vmlinuz-linux "$pkgdir/boot/vmlinuz-linux-$pkgver-$pkgrel"

	sed -i "{
		s#/boot/vmlinuz-linux#/boot/vmlinuz-linux-$pkgver-$pkgrel#g;
		s#/boot/initramfs-linux.img#/boot/initramfs-linux-$pkgver-$pkgrel.img#g;
		s#/boot/initramfs-linux-fallback.img#/boot/initramfs-linux-fallback-$pkgver-$pkgrel.img#g;
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
