echo $(date) + ' --------- inicio -----------' >> /home/adrian/interfases.log
cat /opt/tomcat/webapps/benef/sql/INTERFASES_MODIF.sql | psql BENEF -U postgres
echo $(date) + ' --------  final  -----------' >> /home/adrian/interfases.log
