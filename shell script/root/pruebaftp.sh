!#/bin/bash

echo "inicio del ftp....."
ftp -inv << EOT
passive
open 192.168.2.171
user ftppino kevasduc
cd ..
cd ftpprueba
ascii
get WEBMCOBE2.TXT
get WEBMCOBER.TXT
get WEBMCPRO.TXT
get WEBMPRO2.TXT
get WEBMPROD.TXT
get WEBMPRODA.TXT
get WEBMRAMA.TXT
get WEBMSUBRA.TXT
get WEBMTOMA.TXT
get WEBTAJUP.TXT
get WEBTAJUZ.TXT
get WEBTASEG.TXT
get WEBTBENE.TXT
get WEBTCLAE.TXT
get WEBTCOBE.TXT
get WEBTDEUD.TXT
get WEBTMOVI.TXT
get WEBTPAGO.TXT
get WEBTPOLI.TXT
get WEBTPPAG.TXT
get WEBTTXVA.TXT
get WEBTURIE.TXT
get WEBTASEV.TXT
get WEBTAFIP.TXT
get WEBCTL.TXT
quit
EOT
echo "Fin de ftp."

