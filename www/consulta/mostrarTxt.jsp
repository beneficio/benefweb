<%@page contentType="text/html"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%
String path = request.getParameter ("path");
String file = request.getParameter ("nameFile");

// path "/files/libros"
// nameFile "/nombre.csv"
String nomFile = this.getServletContext().getRealPath(path) + file;
try{
FileInputStream archivo = new FileInputStream(nomFile);
int longitud = archivo.available();
byte[] datos = new byte[longitud];
archivo.read(datos);
archivo.close();
response.setContentType("application/octet-stream");
response.setHeader("Content-Disposition","attachment;filename="+nomFile);
//response.setHeader("Content-Disposition","attachment;filename=\""+ nomFile + "\"");


ServletOutputStream ouputStream = response.getOutputStream();
ouputStream.write(datos);
ouputStream.flush();
ouputStream.close();
}catch(Exception e){ e.printStackTrace(); }

%>