<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.db.db"%>
<%@page import="com.business.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.*"%>
<%@taglib uri="/tld/menu.tld" prefix="menu"%>   
<%@taglib uri="/WEB-INF/jsp/pager-taglib.tld" prefix="pg" %>
<%  
    Usuario usu = (Usuario) session.getAttribute("user");
    if (usu.getiCodTipoUsuario() != 0) {
        request.setAttribute("javax.servlet.jsp.jspException", new SurException ("acceso denegado"));
        getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
    }

    String sEstado = request.getParameter ("estado");
    String tipoEmision = request.getParameter ("tipo_emision");

    String  _flag   = "/home/adrian/enviar/bloq.flag";
    if (tipoEmision.equals("ESTADO_INTERFACE_BATCH")) {
        _flag   = "/home/adrian/enviar/bloq_batch.flag";
    } else if (tipoEmision.equals("ESTADO_INTERFACE_ONLINE")) {
        _flag   = "/home/adrian/enviar/bloq_new.flag";
    }

    Connection dbCon = null;

    boolean bCambiar = true;
    try {

        dbCon = db.getConnection();

        Parametro oParam = new Parametro ();

        if (tipoEmision.equals("ESTADO_INTERFACE") && usu.getusuario().equals("AUTOMAT")) {
            oParam.setsCodigo(tipoEmision);

            bCambiar = ( oParam.getDBValor(dbCon).equals(sEstado) ? false : true );
        }

        if (bCambiar) {
            oParam.setsCodigo(tipoEmision);
            oParam.setsValor (sEstado);
            oParam.setsUserid (usu.getusuario());
            oParam.setDB (dbCon);

            if (oParam.getiNumError() == 0) {
                if (sEstado.equals ("N")) {
                    // bloquear
                    FileOutputStream fos = new FileOutputStream (_flag);
                    OutputStreamWriter osw = new OutputStreamWriter (fos);
                    BufferedWriter bw = new BufferedWriter (osw);
                    
                    bw.write(Fecha.getFechaActual());
                    bw.flush();
                    bw.close();
                    osw.close();
                    fos.close();
                } else {
                    // desbloqear
                    File file = new File(_flag );
                    if (file.exists()) {
                        file.delete ();
                    }
                }
            }
        }

        } catch (Exception e) {
            throw new SurException (e.getMessage());
        }

   response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
   response.setHeader( "Location",  "/benef/usuarios/formInterfaces.jsp");
%>
