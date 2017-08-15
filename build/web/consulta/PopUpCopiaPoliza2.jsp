<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="java.util.*"%> 
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.util.*" %>
<%@include file="/include/no-cache.jsp"%>    
<%  Usuario usu = (Usuario) session.getAttribute("user");
    String sOpcion  = (request.getParameter ("opcion") == null ? "getCopiaPoliza" : request.getParameter ("opcion") );
    HtmlBuilder ohtml       = new HtmlBuilder();
    Tablas oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();

    String sTitulo  = "copia de  póliza / endoso";
    if (sOpcion.equals ("getCuponPoliza")) {
        sTitulo = "cupón de deuda actualizada";
    }  
    %>
<html>
<head>
    <title><%= sTitulo %></title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
    <SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script language='javascript'>
        function Volver() {
            window.close ();
        }
        
        function Aceptar () {

                if ( document.form1.email.value === "" ) {
                    alert ("Debe ingresar una cuenta de mail válida !! ");
                    return false;
                }

                if ( document.form1.num_poliza.value === "" ) {
                    alert ("Debe ingresar el número de póliza completo sin barra !! ");
                    return false;
                }

                if ( document.form1.endoso.value === "" ) {
                    document.form1.endoso.value = 0;
                }
                
                if ( document.form1.endoso.value === "999999" ) {
                    alert ("Los endosos 9999999 no se puede imprimir porque aún no estan emitidos ");
                    return false;
                }
                
                if (document.form1.chk_nomina ) { 
                    if ( document.form1.chk_nomina.checked === false ) {                      
                        document.form1.nomina.value = "N";
                    }
                }

                if (window.opener) {
                    window.opener.Submitir ( document.form1 );
                }
                window.close ();
                return true;
        }
        
    </script>
</head>
  
<BODY leftmargin="2" topmargin="2" >
<form name='form1'  class="fondoForm">
<input type="hidden" name="opcion" id="opcion"  value="<%= sOpcion %>">
<input type="hidden" name="nomina" id="nomina"  value="S">
<table border='0'  width='100%' cellpadding='1' cellspacing='1'>
    <tr>
        <td width='100%' height='20' valign="top" class='titulo' align="center" >Solicitud de  <%= sTitulo %> </td>
    </tr>
    <tr>
        <td align="left" valign="top" class='textonegro'><br>
        Estimado, Ingrese el número de la póliza/endoso:&nbsp;<br><br>
        </td>
    </tr>
    <tr>
        <td width='100%'>
            <table border='0' width='100%'>
                <tr>
                    <td width='20%' align="left"  class="text" valign="top">Rama:&nbsp;</td>
                    <td width='80%'>
                        <SELECT name="cod_rama" id="cod_rama"   class="select">
                            <%                  lTabla = oTabla.getRamas ();
                                out.println(ohtml.armarSelectTAG(lTabla)); 
            %>
                            </select>
                     </td>
                </tr>
                <tr>
                    <td align="left"  class="text" valign="top">P&oacute;liza:&nbsp;</td>
                    <td ><input name="num_poliza" id="num_poliza"  size='12' maxlength='8' value=""  onkeypress="return Mascara('D',event);" class="inputTextNumeric"></td>
                </tr>
                <tr>
                    <td align="left"  class="text" valign="top">Endoso:&nbsp;</td>
                    <td ><input name="endoso" id="endoso"  size='12' maxlength='7' value=""  onkeypress="return Mascara('D',event);" class="inputTextNumeric"></td>
                </tr>
<%        if (sOpcion.equals ("getCopiaPoliza")) {
    %>                
                <tr>
                    <td align="left"  valign="top" colspan="2" class="subtitulo">
                        Si NO desea incluir la nómina destilde aqu&iacute; &nbsp;<input type="checkbox" name="chk_nomina" id="chk_nomina"  checked>
                    </td>
                </tr>
<%         }
    %>
             </table>
        </td>
    </tr>
    <tr>
        <td align="left" valign="top" class='textonegro'>
        Verifique la casilla de correo destino, y en caso que la misma no sea la correcta puede modificarla.<br>Luego presione el botón Aceptar.
        <br><br>
        </td>
    </tr>
    <tr>
        <td align="center"  valign="top" colspan='2' height='35'><input type="text" name="email" id="email" size='60' maxlength='80' value=<%= (usu.getEmail () == null ? "" : usu.getEmail ()) %>><br><br></td>
    </tr>
    <tr valign="bottom">
        <td align="center" height="100%">
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdAceptar" value=" Aceptar " height="20px" class="boton" onClick="Aceptar ();">
        </td>
    </tr>
</table>
</form>
</body>
</html>
