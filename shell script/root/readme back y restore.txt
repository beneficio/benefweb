-- BACK EXITOSO

pg_dump -h 127.0.0.1 -o -v -f benef.pruebas.dump -U postgres -t PRUEBAS BENEF

-- restaurar el backup - antes hay que hacer drop de la tabla

psql -h 127.0.0.1 -f benef.PRUEBAS.dump BENEF postgres
