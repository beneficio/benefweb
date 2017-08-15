!#/bin/bash

echo "inicio del ftp....."
ftp -inv << EOT
passive
open 192.168.1.10
user BENEWEB BENEWEB
cd /benewebf
bin
mget WEB*.GZ
ascii
get WEBCTL.TXT
quit
EOT
echo "Fin de ftp."
