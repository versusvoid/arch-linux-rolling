# Example wrapper for yaourt, with automaized kernel update and cleanup
function yaourt
	set -l linux_version_before (gunzip -c /var/lib/pacman/sync/core.db ^/dev/null | egrep -ao '^linux-[0-9][0-9.-]*[0-9]' | egrep -o '[0-9].*')
	set -l linux_rolling_version_before (pacman -Q linux-rolling ^/dev/null | egrep -o '[0-9].*')

	/usr/bin/yaourt $argv

	set -l linux_version_after (gunzip -c /var/lib/pacman/sync/core.db ^/dev/null | egrep -ao '^linux-[0-9][0-9.-]*[0-9]' | egrep -o '[0-9].*')
	set -l linux_rolling_version_after (pacman -Q linux-rolling ^/dev/null | egrep -o '[0-9].*')
	if test "$linux_version_before" != "$linux_version_after" \
			-a "$linux_version_after" != "$linux_rolling_version_after" \
			-a "$linux_rolling_version_after"
		echo Building new linux-rolling
		set -l d (mktemp --tmpdir -d linux-rolling-$linux_version_after.XXX)
		test -d $d; or return $status
		pushd $d
		git clone --depth=1 https://github.com/versusvoid/arch-linux-rolling $d; or return $status
		makepkg; or return $status
		set -l p1 linux-rolling_(echo $linux_version_after | sed 's/[.-]/_/g')-$linux_version_after-(uname -m).pkg.tar
		/usr/bin/yaourt -U --asdeps $p1*; or return $status
		set -l p2 linux-rolling-$linux_version_after-any.pkg.tar
		/usr/bin/yaourt -U $p2*; or return $status
		set linux_rolling_version_after $linux_version_after
		rm $p1* $p2* linux-$linux_version_after-(uname -m).pkg.tar.xz{,.sig}; or return $status
		popd
		rm -rf $d
	end

	if test "$linux_rolling_version_before" != "$linux_rolling_version_after" -a -e /usr/bin/clean-old-kernels
		clean-old-kernels
	end
end
