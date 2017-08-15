!#/bin/bash

echo "inicio del ftp....."
ftp -inv << EOT
passive
open 192.168.2.171
user ftppino kevasduc
ascii
put PROPROPU.TXT*
put PROTOMAD.TXT*
put PROASEGU.TXT*
put PROCOBER.TXT*
put PROACTCA.TXT*
put PROUBIC.TXT*
put PROECLA.TXT*
put PROFLAG.TXT*
quit
EOT
echo "Fin de ftp."

