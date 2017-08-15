<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="java.util.*, com.business.beans.Usuario, com.business.util.*" %>
<%@include file="/include/no-cache.jsp"%>    
<%  String sOpcion  = (request.getParameter ("opcion") == null ? "poliza" : request.getParameter ("opcion") );
    int iNumPoliza  = (request.getParameter ("F1num_poliza_sel") == null  ? 0 :
                      Integer.parseInt (request.getParameter ("F1num_poliza_sel")));
    int iCodRama    = (request.getParameter ("F1cod_rama_sel") == null  ? 0 :
                      Integer.parseInt (request.getParameter ("F1cod_rama_sel")));
    int iEndoso     = (request.getParameter ("endoso") == null  ? 0 :
                      Integer.parseInt (request.getParameter ("endoso")));

    Usuario usu     = (Usuario) session.getAttribute("user");
    
    String sTitulo  = "copia de  p�liza / endoso";
    if (sOpcion.equals ("cupon")) {
        sTitulo = "cup�n de deuda actualizada";
    }
    %>
<html>
<head>
    <title><%= sTitulo %></title>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css">	
    <script language='javascript'>
        function Volver() {
            window.close ();
        }

        function validateEmail(emailID){

           atpos = emailID.indexOf("@");
           dotpos = emailID.lastIndexOf(".");
           if (atpos < 1 || ( dotpos - atpos < 2 ))
           {
               alert("Por favor, escriba bien su direcci�n de correo")
               document.form1.email.focus() ;
               return false;
           }
           return( true );
        }

    function Aceptar () {
        if ( document.form1.email.value !== "" ) {
            if ( document.form1.email.value.length > 60  ) {
                alert ("La suma de todos los mail no deber�a superar los 60 caracteres. Por favor, elimine alg�n mail !! ");
                return false;
            } else {
                if ( validateEmail (document.form1.email.value) ) {
                    if (document.form1.chk_nomina ) { 
                        if ( document.form1.chk_nomina.checked === false) {
                            document.form1.nomina.value = "N";
                        }
                    }
                    
                    if (window.opener) {
                        window.opener.Submitir ( document.form1 );
                    }

                    alert ("La solicitud de env�o fue realizada exitosamente.\n En unos minutos recibir� la misma v�a mail. Muchas gracias ");
                    window.close ();
                    return true;
                }
            }
        } else {
            alert ("Debe ingresar una cuenta de mail v�lida !! ");
            return false;
        }
     }
    </script>
</head>
  
<BODY leftmargin=2 topmargin=2 >
<form name='form1'>
<input type="hidden" name="endoso" id="endoso" value="<%= iEndoso %>">
<input type="hidden" name="opcion" id="opcion" value="<%= sOpcion %>">
<input type="hidden" name="nomina" id="nomina"  value="S">
<table border='0'  width='100%' height='100%' cellpadding='2' cellspacing='2' class='fondoForm'>
<% if (iEndoso == 0) {
    %>
    <tr>
        <td width='100%' height='30' valign="top" class='titulo' align="center" >Solicitud de <%= sTitulo %></td>
    </tr>
<%  } 
    %>
    <tr>
        <td align="left" width='90%' valign="top" class='textonegro'><br>
        Estimado, usted esta solicitando que le enviemos <%= sTitulo %>&nbsp;<%= Formatos.showNumPoliza(iNumPoliza) %><%= (iEndoso != 0 ? ( ", endoso " + Formatos.showNumPoliza(iEndoso)) : " ") %>
        a la siguiente casilla de correo: <br><br>
        </td>
    </tr>
    <tr>
        <td align="center"  valign="top">
            <input type="text" name="email" id="email" size='45' maxlength='60' value=<%= (usu.getEmail () == null ? "" : usu.getEmail ()) %>><br><br></td>
    </tr>
    <tr>
        <td align="left" valign="top" class='textonegro'>
        Verifique la casilla de correo destino, y en caso que la misma no sea la correcta puede modificarla.<br>Luego presione el bot�n Aceptar.
        <br><br>
        </td>
    </tr>
    <tr>
        <td align="left"  valign="top" colspan="2" class="subtitulo">
            Si NO desea incluir la n�mina destilde aqu&iacute; &nbsp;<input type="checkbox" name="chk_nomina" id="chk_nomina"  checked>
        </td>
    </tr>
    <tr valign="bottom" >
        <td align="center" height='25'>
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="javascript: Volver();">&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdAceptar" value=" Aceptar " height="20px" class="boton" onClick="javascript: Aceptar ();">
        </td>
    </tr>
</table>
</form>
</body>
</html>
