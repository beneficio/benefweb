<%@page contentType="text/html"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="java.util.* ,com.business.beans.*, com.business.util.*, com.business.interfaces.*, com.business.db.*,java.sql.*,java.io.*"%>
<% // String sCommand = "SNDMSG MSG('la prueba del comando anduvo bien') TOUSR(ADRIAN)";
        Connection dbCon = null;
        String  _file ="/opt/tomcat/webapps/benef/propiedades/config.xml";//"./www/propiedades/config.xml";
        String  _fileLog     ="/opt/tomcat/webapps/benef/files/renovar/renovar.log";
        ResultSet rs = null;
        FileWriter fw = null;
        BufferedWriter bw = null;
        PrintWriter  salida = null;

        try {
           fw = new FileWriter( _fileLog );
           bw = new BufferedWriter(fw);
           salida = new PrintWriter(bw);

            java.io.File config1 = new java.io.File(_file);
            if(!config1.exists()){
                // ------------------------------------------------------------
                // En caso que si no toma los datos del config.xml
                // Configurar los Datos de conexion.
                // ------------------------------------------------------------
                salida.println(" ********************************** ") ;
                salida.println(" No se encontro el archivo config.xml") ;
                salida.println(" ********************************** ") ;
                throw new SurException("NO SE ENCONTRO EL ARCHIVO config.xml");
            } else {
                db.realPath(config1.getAbsolutePath()) ;
                dbCon = db.getConnection();
            }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
            if (salida != null) salida.close();
            if (bw != null) bw.close();
            if (fw != null) fw.close();
            try {
                if (rs != null ) dbCon.close();
            } catch (SQLException se) {
                throw new SurException (se.getMessage());
            }
            dbCon.close();
        }

 
%>
<HTML>
  <HEAD>
    <TITLE></TITLE>
  </HEAD>
  <BODY>
  </BODY>
</HTML>

