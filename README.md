# WaterPlasma2x

A 1kb demo for GP2X written to practice writing ARM assembly code.

The source code is released with MIT license.

To shrink the demo to 1024 bytes, the assembled source code was compressed using 7-zip's gzip implementation and following shell code was added to decompress the file on the fly:

```sh
E=/tmp/p
tail -n+7 $0|zcat ->$E
chmod +x $E
$E
cd /usr/gp2x
exec ./gp2xmenu
