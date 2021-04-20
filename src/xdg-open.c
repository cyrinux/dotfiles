/*
 * Copyright © 2021 rusty-snake
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*
 * # xdg-open.c
 *
 * A xdg-open drop-in wrapper to make xdg-open work nicely with firejail.
 *
 * If xdg-open.c is called outside of firejail, it just forwards to `/usr/bin/xdg-open`.
 * If xdg-open.c is called inside of firejail, it uses `org.freedesktop.portal.OpenURI.OpenURI` via
 * gdbus to open URLs.
 *
 * Currently xdg-open.c requires the `gdbus` tool to be in `$PATH`, however this limitation can be
 * lifted by useing gdbus (the library) directly.
 * Maybe helpfull: [GDBUS simple examples](https://github.com/joprietoe/gdbus)
 *
 * ## Compile
 *
 * Just compile the single file. No build system. No configure. Just a simple, painless compiler call.
 *
 * Fedora/RHEL:
 *     gcc $(rpm -E %build_cflags | sed "s/-mtune=generic/-march=native/g") -o xdg-open xdg-open.c
 * Debian (untested):
 *     gcc $(dpkg-buildflags --export=cmdline) -o xdg-open xdg-open.c
 * Other:
 *     gcc -o xdg-open xdg-open.c
 *
 * ## Install
 *
 * Copy it to somewhere in `$PATH` before the real `xdg-open`:
 *
 *     sudo install -Dm0755 -s xdg-open /usr/local/bin/xdg-open
 *
 * ## Usage (with firejail)
 *
 * If the firejail sandbox has no D-Bus policy set (for the session bus) you need nothing to do.
 * Otherwise you need to allow talking to the Desktop portal by
 *
 * ```
 * dbus-user.talk org.freedesktop.portal.Desktop
 * ```
 *
 * if the policy is alread set to `filter` or by
 *
 * ```
 * ignore dbus-user none
 * dbus-user filter
 * dbus-user.talk org.freedesktop.portal.Desktop
 * ```
 *
 * if it is set to `none`.
 *
 * ## Known Bugs
 *
 * Opening of local files (i.e. file://) does not work in firejail-mode because file:// uris are
 * explicitly not supported by `OpenURI.OpenURI()`. `OpenURI.OpenFile()` is the correct method
 * for that.
 *
 * ## Changelog
 *
 * - Initial version
 * - Exit with status-code 4 (instead of 0) if the exec* call fails.
 * - Catch missing arg1 in firejail mode.
*/

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	char *container = getenv("container");
	if (container && strcmp(container, "firejail") == 0) {
		if (argc <= 1) {
			printf("xdg-open.c: Missing command line argument URL. Usage: xdg-open <URL>\n");
			return 1;
		}
		execlp("gdbus",
			"gdbus", "call", "--session",
			"--dest", "org.freedesktop.portal.Desktop",
			"--object-path", "/org/freedesktop/portal/desktop",
			"--method", "org.freedesktop.portal.OpenURI.OpenURI",
			"", argv[1], "{}",
			(char  *) NULL
		);
		printf("xdg-open.c: Failed to execlp gdbus: %s\n", strerror(errno));
	} else {
		execv("/usr/bin/xdg-open", argv);
		printf("xdg-open.c: Failed to execv /usr/bin/xdg-open: %s\n", strerror(errno));
	}
	return 4;
}
