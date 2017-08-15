<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@page import="java.util.*, com.business.beans.*, com.business.util.*" %>
<%@page import="com.business.db.*"%>
<%@page import="java.sql.*"%>
<%@include file="/include/no-cache.jsp"%>    
<%  int iNumPoliza = (request.getParameter ("num_poliza") == null  ? 0 :
                      Integer.parseInt (request.getParameter ("num_poliza")));
    int iCodRama   = (request.getParameter ("cod_rama") == null  ? 0 :
                      Integer.parseInt (request.getParameter ("cod_rama")));
    Usuario usu = (Usuario) session.getAttribute("user");

    boolean bExiste = false;
   
    Connection dbCon = db.getConnection();
    Poliza oPol = new Poliza ();
    oPol.setcodRama(iCodRama);
    oPol.setnumPoliza(iNumPoliza);
    oPol.setuserId(usu.getusuario());

    PersonaPoliza oPers = new PersonaPoliza ();
    if (oPol.getDBExiste (dbCon)) { 
        bExiste = true;
        oPol.getDB(dbCon);

        oPers.setnumTomador (oPol.getnumTomador());
        oPers.getDB(dbCon);

        if (oPol.getclaNoRepeticion().equals("S") ||  oPol.getclaSubrogacion().equals("S")) {
            oPol.setAllClausulas(oPol.getDBAllEmpresasClausulas(dbCon));
        }
    }
    db.cerrar(dbCon);
    %>
<html>
<head>
    <title>Verificación de póliza</title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
    <script language='javascript'>
        function Volver() {
            window.close ();
        }
    </script>
</head>
  <SCRIPT type="" language="JavaScript" src="<%= Param.getAplicacion() %>script/Botones.js"></script>	
<BODY leftmargin=2 topmargin=2 class='fondoForm'>
<table border='0'  width='100%' height='100%' cellpadding='2' cellspacing='2' class='fondoForm'>
    <tr>
        <td width='100%' height='30' valign="top" class='titulo' align="center" >Verificación de Póliza</td>
    </tr>
<%  if (bExiste) {
    %>
    <tr>
        <td align="left" width='100%' height='190' valign="top">
            <table width='100%' cellpadding='1' cellspacing='1' align="center" style='margin-left:15;'>
                <tr>
                    <td align="left" class='textogriz' width='50' nowrap>Póliza:</td> 
                    <td align="left" class='textonegro' width='170' ><%= oPol.getnumPoliza ()%></td> 
                    <td align="left" class='textogriz' width='25' nowrap>Rama:</td> 
                    <td align="left" class='textonegro' width='160'><%= oPol.getdescRama ()%></td> 
                </tr>
                <tr>
                    <td align="left" class='textogriz' nowrap>Sub Rama:</td> 
                    <td align="left" class='textonegro' colspan='3'><%= oPol.getdescSubRama ()%></td> 
                </tr>
                <tr>
                    <td align="left" class='textogriz' nowrap>Vigencia:</td> 
                    <td align="left" class='textonegro' colspan='3'><%= (oPol.getfechaInicioVigencia() == null ? "no informada" : Fecha.showFechaForm(oPol.getfechaInicioVigencia()))%>
                    &nbsp;&nbsp;hasta&nbsp;&nbsp;<%= (oPol.getfechaFinVigencia() == null ? "no informada" : Fecha.showFechaForm(oPol.getfechaFinVigencia()))%>
                    </td> 
                </tr>
                <tr>
                    <td align="left" class='textogriz'>Tomador:</td> 
                    <td align="left" class='textnegro' colspan='3'><%= oPers.getrazonSocial () %></td> 
                </tr>
                <tr>
                    <td align="left" class='textgriz'><%= oPers.getdescTipoDoc () %>:&nbsp;</td> 
                    <td align="left" class='textonegro' colspan='3'><%= oPers.getnumDoc () %></td> 
                </tr>
                <tr>
                    <td align="left" class='textogriz'>Dirección:</td> 
                    <td align="left" class='textnegro' colspan='3'><%= oPers.getdomicilio () %>&nbsp;,&nbsp;
                     <%= oPers.getlocalidad () %>&nbsp;(<%= oPers.getcodPostal()%>)
                    </td> 
                </tr>

<%
        if (oPol.getclaNoRepeticion().equals("S") ||  oPol.getclaSubrogacion().equals("S")) {
        %>
                <tr>
                    <td align="left" class='textogriz'>Clausulas:</td> 
                    <td align="left" class='textnegro' colspan='3'><%= (oPol.getclaNoRepeticion().equals("S") ? "NO REPETICION" : " " )  %>&nbsp;-&nbsp;
                                                                    <%= (oPol.getclaSubrogacion().equals("S") ? "SUBROGACION " : " " )  %>
                    </td> 
                </tr>
                <TR>
                    <TD align="left" class='textonegro' valign="top" nowrap>Lista de Empresas:</TD>                                
                    <td class='textonegro'  align="left" colspan='3'>&nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</TD>                                
                </TR>                            
<%                  if (oPol.getAllClausulas().size() > 0 ) {    
                        for (int i = 1;i <= oPol.getAllClausulas().size() ;i++) {
                            Clausula oCla = (Clausula) oPol.getAllClausulas().get(i - 1);
                            
    %>
                            <TR>
                                <td >&nbsp;</TD>                                
                                <TD align="left" class='text' colspan='3' >
                                    <input type="text" value="<%= ( oCla.getcuitEmpresa() == null ? " " :  oCla.getcuitEmpresa()) %>" size='11' readonly  class="inputTextNumeric">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" value="<%= oCla.getdescEmpresa() %>" size='50' readonly>
                                 </TD>                                
                            </TR>
<%                      }
                    }
        } else if (oPol.getcodRama () == 10 || oPol.getcodRama () == 22) {
    %>
               <tr>
                    <td align="left" class='textogriz' colspan='4'><b>No existe informaci&oacute;n de cla&uacute;sulas asociadas a la póliza</b></td> 
                </tr>
<%              }
    %>
               <tr>
                    <td align="left" class='textogriz' colspan='4'>Informaci&oacute;n actualizada al&nbsp;<%= (oPol.getfechaFTP() == null ? " " :  Fecha.showFechaForm(oPol.getfechaFTP()))%>
                    </td> 
                </tr>
            </table>
        </td>
    </tr>
<%  } else {
    %>
    <tr>
        <td align="left" width='80%' height='190' valign="top"><font color="#FF0000" size='h1'>
        La póliza no existe. Los motivos pueden ser uno o varios de los siguientes:<br>
        - La emisi&oacute;n de la p&oacute;liza es reciente y a&uacute;n no se encuentra actualizada en la web.<br>
        - El c&oacute;digo de rama es incorrecto.<br>
        - El n&uacute;mero de p&oacute;liza es incorrecto.<br>
        - La p&oacute;liza pertenece a otro productor.<br><br>
        Cualquier problema, contactese con su representante en Beneficio S.A.
        </FONT>
        </td>
    </tr>
<%  }
    %>
    <tr><td height='100%'>&nbsp;</td></tr>
    <tr valign="bottom">
        <TD align="center" height='30' valign="BOTTOM">
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="Volver();">
        </td>
    </tr>
</table>
</body>
</html>
