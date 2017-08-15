<%@page contentType="text/html"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="java.util.* ,com.business.beans.*, com.business.util.*, com.business.interfaces.*"%>
<%@page import="java.rmi.*"%>
<%@page import="java.util.Vector"%>
<%@page import="com.ibm.as400.access.*"%>
<% out.println ("version: 1");

 AS400JPing pingObj = new AS400JPing("192.168.1.10", AS400.COMMAND, false);
       if (pingObj.ping()) {
         out.println("SATISFACTORIO"); }
          else {
         out.println("AN�MALO"); }

          // Cree un objeto AS400.
     AS400 sys = new AS400("192.168.1.10","PINO", "PINO");

         // En este ejemplo, el programa tiene dos
         // par�metros. Cree una lista que contenga
         // dichos par�metros.
     ProgramParameter[] parmList = new ProgramParameter[2];

         // El primero es un par�metro
         // de entrada.
     byte[] name = {1, 2, 3};
      
    AS400Text param1 = new AS400Text(256);
    
    String nn = "hola pino";

     parmList[0] = new ProgramParameter(ProgramParameter.PASS_BY_VALUE, param1.toBytes( nn), 256);

         // El segundo es un par�metro
         // de salida. Se devuelve un
         // n�mero de cuatro bytes.
     parmList[1] = new ProgramParameter(256);

         // Cree un objeto programa
         // especificando el nombre del programa
         // y la lista de par�metros.
     ProgramCall pgm = new ProgramCall(sys,
                                       "/QSYS.LIB/PINO.LIB/PINO2.PGM",
                                       parmList);

out.println ("pgm --> " + pgm);
         // Ejecute el programa.
     if (pgm.run() != true)
     {
out.println ("pincho  " );
         // Si el iSeries no puede ejecutar el
         // programa, vea la lista de mensajes para
         // averiguar por qu� no se ha ejecutado.
        AS400Message[] messageList = pgm.getMessageList();

     }
     else
     {
         // En caso contrario, el programa se ha ejecutado.
         // Procese el segundo par�metro, que contiene
         // los datos devueltos.
         out.println ("se ejecuto exitosamente !!! ");
         // Cree un conversor para este
         // tipo de datos iSeries.
        AS400Text bin4Converter = new AS400Text(11);

         // Realice la conversi�n desde el tipo iSeries al
         // objeto Java. El n�mero empieza al principio
         // del almacenamiento intermedio.
        byte[] data = parmList[1].getOutputData();
        String  i = (String) bin4Converter.toObject(data);
        out.println ("resultado " + i);
     }

         // Desconecte, puesto que ya ha terminado
         // de ejecutar los programas.
     sys.disconnectService(AS400.COMMAND);
%>
