<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="java.util.*, com.business.beans.*, com.business.util.*" %>
<%@page import="com.business.db.*"%>
<%@page import="java.sql.*"%>     
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
    int indice = 0;

    if (oPol.getDBExiste (dbCon)) { 
        bExiste = true;
        oPol.getDB(dbCon);

        oPol.setAllClausulas(oPol.getDBAllEmpresasClausulas(dbCon));
//        oPol.setAllClausulas(new LinkedList ());
    }
    int cantMaxCla =  Integer.parseInt(Dbl.DbltoStr(ConsultaMaestros.getParametro( iCodRama , 9),0));
    db.cerrar(dbCon);
    %>    
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <title>Verificación de póliza</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <link rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css"/>
   <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
   <script type="text/javascript" language='javascript'>
        function Volver() {
            window.close ();
        }

        function ValidoCuitEmpresa (empresa) {

            if (empresa && empresa.value !== "") {
                if ( ! ValidoCuit (Trim( empresa.value)) ) {
                    empresa.focus();
                    return false;
                }
            }
            return true;
        }

        function ValidarClausulas () {
        
        var existe = 0;
        
        if (document.getElementById ('cla_no_repeticion').checked || 
            document.getElementById ('cla_subrogacion').checked ) {
            for (var i = 0; i < document.form1.elements.length; i++) {
                var obj = document.form1.elements.item(i);
                if ((typeof(obj) == "object") && obj.name.match(/^CLA_DESCRIPCION./) && Trim (obj.value).length > 0 ) {
                    existe = 1;
                }
            }
            if (existe === 0) return 1; 
        } else {
            for (var i = 0; i < document.form1.elements.length; i++) {
                var obj = document.form1.elements.item(i);
                if ((typeof(obj) == "object") && obj.name.match(/^CLA_DESCRIPCION./) && Trim (obj.value).length > 0 ) {
                    existe = 1;
                }
            }
            if (existe === 1) return 2; 
        }

    return 0;
    }

        function Aceptar() { 

        document.getElementById ('cla_no_repeticion').value = 
        (document.getElementById ('cla_no_repeticion').checked == true ? 'S' : 'N' );

        document.getElementById ('cla_subrogacion').value = 
        (document.getElementById ('cla_subrogacion').checked == true ? 'S' : 'N' );

            if (window.opener) { 
                    var cla = ValidarClausulas ();

                    if ( cla == 1) {
                        alert ("Si seleccciona Clausulas debe detallar por lo menos una empresa ");               
                        return document.form1.CLA_DESCRIPCION_1.focus();
                    }
                    if ( cla == 2) {
                        alert ("Si detalla empresas debe seleccionar al menos una clausula ");               
                        return document.form1.cla_no_repeticion.focus();            
                    }
                    window.opener.CargarClausulas ( document.form1 );
                    window.close ();       
            }
        }        

    </script>
</head>
<script type="" language="JavaScript" src="<%= Param.getAplicacion() %>script/Botones.js"></script>
<body leftmargin="2" topmargin="2" >
<form method="POST" id="form1"  name="form1" action="">
<input type="hidden" NAME="actualiza_cla" id="actualiza_cla" value="S"/>
<input type="hidden" name="cant_max_clausulas"  id="cant_max_clausulas"  value="<%= cantMaxCla %>" />
<table border='0'  width='100%' height='100%' cellpadding='2' cellspacing='2' class='fondoForm'>
    <tr>
        <td width='100%' height='30' valign="top" class='titulo' align="center" >Verificaci&oacute;n de P&oacute;liza</td>
    </tr>
<%  if (bExiste) {
    %>
    <tr>
        <td align="left" width='100%' height='190' valign="top">
            <table width='100%' cellpadding='1' cellspacing='1' align="center" style='margin-left:15;'>
                <tr>
                    <td align="left" class='textogriz' width='50' nowrap>P&oacute;liza:</td>
                    <td align="left" class='textonegro' width='170' ><%= oPol.getnumPoliza ()%></td> 
                    <td align="left" class='textogriz' width='25' nowrap>Rama:</td> 
                    <td align="left" class='textonegro' width='300'><%= oPol.getdescRama ()%></td> 
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
                    <td align="left" class='text' valign="top"  nowrap>Cl&aacute;usulas:</td>
                    <td align="left" class='text' colspan='3' >
                        <input type="CHECKBOX" value='<%= oPol.getclaNoRepeticion () %>' name='cla_no_repeticion'  id='cla_no_repeticion'  <%= (oPol.getclaNoRepeticion ().equals ("S") ? "checked" : " ") %>>&nbsp;Cl&aacute;usula de No Repetición<br>
                        <input type="CHECKBOX" value='<%= oPol.getclaSubrogacion () %>' name='cla_subrogacion' id='cla_subrogacion' <%= (oPol.getclaSubrogacion ().equals ("S") ? "checked" : " ") %>>&nbsp;Cl&aacute;usula de Subrogación
                     </td>
                </tr>
                <tr>
                    <td align="left" class='text' colspan='4' >
                        <span style="color:red;font-weight: bold">
                            Ingrese las cl&aacute;usulas que usted desea que aparezcan en el certificado.
                            Estas se actualizar&aacute;n en la p&oacute;liza mediante un endoso en unos minutos.
                        </span>
                     </td>
                </tr>
                <tr>
                    <td align="left" class='text' valign="top" nowrap colspan='4'>Ingrese Empresas:
                    &nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</td>
                </tr>
<%                  if (oPol.getAllClausulas().size() >= 0 && oPol.getAllClausulas().size() < cantMaxCla ) {
                        for (int i = 1;i <= oPol.getAllClausulas().size() ;i++) {
                            Clausula oCla = (Clausula) oPol.getAllClausulas().get(i - 1);
                            indice += 1;
                            
    %>
                            <tr>
                                <td  >&nbsp;</td>
                                <td align="left" class='text' colspan='3' >
                                    <input type="hidden" name="CLA_ITEM_<%= indice %>"/>
                                    <input type="text" name="CLA_CUIT_<%= indice %>" value="<%= ( oCla.getcuitEmpresa() == null ? " " :  oCla.getcuitEmpresa()) %>" size='11' maxlength='11'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= indice %>" value="<%= oCla.getdescEmpresa() %>" size='50' maxlength='30'/>
                                 </td>
                            </tr>
<%                      }
                    } else {
    %>
                            <tr>
                                <td  >&nbsp;</td>
                                <td align="left" class='text' colspan='3' >
                                    <span style="color:red;font-weight: bold">
                                        Como la p&oacute;liza tiene m&aacute;s de <%= cantMaxCla %> cl&aacute;usulas  agregue solo las que a&uacute;n no existan.
                                    </span>
                                 </td>
                            </tr>
<%                  }
                    if ( oPol.getcantMaxClausulas () > oPol.getAllClausulas().size() || oPol.getAllClausulas().size() >= cantMaxCla ) {
                     
                      for (int ii = indice + 1 ; ii <= oPol.getcantMaxClausulas () ;ii++) {
    %>
                            <tr>
                                <td>&nbsp;</td>
                                <td align="left" class='text' colspan='3' >
                                    <input type="hidden" name="CLA_ITEM_<%= ii %>" id="CLA_ITEM_<%= ii %>"/>
                                    <input type="text" name="CLA_CUIT_<%= ii %>" id="CLA_CUIT_<%= ii %>" size='11' maxlength='11'  onkeypress="return Mascara('D',event);" onblur="ValidoCuitEmpresa ( this );"  class="inputTextNumeric"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="text" name="CLA_DESCRIPCION_<%= ii %>" id="CLA_DESCRIPCION_<%= ii %>" size='50' maxlength='30'/>
                                 </td>
                            </tr>
<%                     }
                   }
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
        <td align="left" width='80%' height='190' valign="top">
            <font color="#FF0000" size='h1'>
        La póliza no existe. Los motivos pueden ser uno o varios de los siguientes:<br/>
        - La emisi&oacute;n de la p&oacute;liza es reciente y a&uacute;n no se encuentra actualizada en la web.<br/>
        - El c&oacute;digo de rama es incorrecto.<br/>
        - El n&uacute;mero de p&oacute;liza es incorrecto.<br/>
        - La p&oacute;liza pertenece a otro productor.<br/><br/>
        Cualquier problema, contactese con su representante en Beneficio S.A.
            </font>
        </td>
    </tr>
<%  }
    %>
    <tr valign="bottom" >
        <td align="center" height='30'>
            <input type="button" name="cmdSalir" value=" Cerrar " height="20px" class="boton" onClick="Volver();"/>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdAcetar" value=" Aceptar " height="20px" class="boton" onClick="Aceptar();"/>
        </td>
    </tr>
</table>
</form>
</body>
</html>
