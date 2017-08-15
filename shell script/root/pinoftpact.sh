!#/bin/bash

echo "inicio del ftp....."
ftp -inv << EOT
passive
open 192.168.2.171
user ftppino kevasduc
ascii
get ACTMTOMA.TXT
get ACTTAFIP.TXT
get ACTTASEG.TXT
get ACTTASEV.TXT
get ACTTBENE.TXT
get ACTTCLAE.TXT
get ACTTCOBE.TXT
get ACTTDEUD.TXT
get ACTTMOVI.TXT
get ACTTPAGO.TXT
get ACTTPOLI.TXT
get ACTTPPAG.TXT
get ACTTTXVA.TXT
get ACTTURIE.TXT
quit
EOT
echo "Fin de ftp."

