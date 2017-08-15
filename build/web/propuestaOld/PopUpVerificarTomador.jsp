<%@ page contentType="text/html" errorPage="/error.jsp" session="true"%>
<%@page import="java.util.*, com.business.beans.*, com.business.util.*" %>
<%@include file="/include/no-cache.jsp"%>
<%
LinkedList lTom = (LinkedList) request.getAttribute("tomadores");
%>
<HTML>
<HEAD>
<style type="text/css">

</style>
    <TITLE>Verificar Datos del Tomador</TITLE>
    <LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion() %>css/estilos.css"/>
    <SCRIPT language='javascript'>
        function Volver() {
            window.close ();
        }

        function Aceptar() {

            if (window.opener) {
                var size =  <%=lTom.size()%>;
                var pos;
                if (size==1) {
                    pos = 0;
                } else {
                    for (i=0;i<size;i++){
                        if (document.formVerifTom.rad_tomador[i].checked) {
                            pos = i;
                            break;
                         }
                    }
                }

                document.formVerifTom.numTomador.value = document.getElementById('numTomador_'+pos).value;
                document.formVerifTom.tipoDoc.value    = document.getElementById('tipoDoc_'+pos).value;
                document.formVerifTom.numDoc.value     = document.getElementById('numDoc_'+pos).value;
                document.formVerifTom.razon.value      = document.getElementById('razon_'+pos).value;
                document.formVerifTom.iva.value        = document.getElementById('iva_'+pos).value;
                document.formVerifTom.domicilio.value  = document.getElementById('domicilio_'+pos).value;
                document.formVerifTom.localidad.value  = document.getElementById('localidad_'+pos).value;
                document.formVerifTom.cp.value         = document.getElementById('cp_'+pos).value;
                document.formVerifTom.provincia.value  = document.getElementById('provincia_'+pos).value;

                window.opener.getDatosTomador( document.formVerifTom );
                window.close ();
            }
        }

    </SCRIPT>
</HEAD>

<BODY>



<TABLE border='0' align='center' >
    <FORM method=POST id=formVerifTom  name=formVerifTom action="">

    <INPUT type='HIDDEN' name='numTomador' id='numTomador' value='' >
    <INPUT type='HIDDEN' name='tipoDoc'    id='tipoDoc'    value='' >
    <INPUT type='HIDDEN' name='numDoc'     id='numDoc'     value='' >
    <INPUT type='HIDDEN' name='razon'      id='razon'      value='' >
    <INPUT type='HIDDEN' name='iva'        id='iva'        value='' >
    <INPUT type='HIDDEN' name='domicilio'  id='domicilio'  value=''>
    <INPUT type='HIDDEN' name='localidad'  id='localidad'  value=''>
    <INPUT type='HIDDEN' name='cp'         id='cp'         value=''>
    <INPUT type='HIDDEN' name='provincia'  id='provincia'  value=''>


    <TR valign='top' align='center'>
        <TD>
            <DIV style="overflow:auto; width: 380px; height: 250px">
                <TABLE border="0" cellspacing="0" cellpadding="2" align="center" style="margin-left:5px;" class='TablasBody'>
                    <THEAD>
                        <TH> Nº Socio</TH>
                        <TH> Nombre y Apellido </TH>
                        <TH> Documento </TH>
                        <TH> &nbsp;</TH>
                    </THEAD>
<%
    if (lTom.size()==0) {
%>
                    <TR>
                        <TD colspan='4'> No hay datos </TD>
                    </TR>
<%
    } else {
        for (int i=0; i < lTom.size() ; i++ ) {
        PersonaPoliza oTom = (PersonaPoliza) lTom.get(i) ;
%>
                    <TR>
                        <TD> <%=oTom.getnumTomador()%> </TD>
                             <INPUT type='HIDDEN' name='numTomador_<%=i%>'id='numTomador_<%=i%>'value='<%=oTom.getnumTomador()%>'>
                             <INPUT type='HIDDEN' name='tipoDoc_<%=i%>'   id='tipoDoc_<%=i%>'   value='<%=oTom.gettipoDoc()%>'>
                             <INPUT type='HIDDEN' name='numDoc_<%=i%>'    id='numDoc_<%=i%>'    value='<%=oTom.getnumDoc()%>'>
                             <INPUT type='HIDDEN' name='razon_<%=i%>'     id='razon_<%=i%>'     value='<%=oTom.getrazonSocial()%>'>
                             <INPUT type='HIDDEN' name='iva_<%=i%>'       id='iva_<%=i%>'       value='<%=oTom.getcodCondicionIVA()%>'>
                             <INPUT type='HIDDEN' name='domicilio_<%=i%>' id='domicilio_<%=i%>' value='<%=oTom.getdomicilio()%>'>
                             <INPUT type='HIDDEN' name='localidad_<%=i%>' id='localidad_<%=i%>' value='<%=oTom.getlocalidad()%>'>
                             <INPUT type='HIDDEN' name='cp_<%=i%>'        id='cp_<%=i%>'        value='<%=oTom.getcodPostal()%>'>
                             <INPUT type='HIDDEN' name='provincia_<%=i%>' id='provincia_<%=i%>' value='<%=oTom.getprovincia ()%>'>

                        <TD> <%=oTom.getrazonSocial()%></TD>
                        <TD> <%=oTom.getnumDoc()%></TD>
                        <TD> <INPUT type='RADIO' name='rad_tomador' id='rad_tomador' <%=(i==0)?"checked":"" %>  ></TD>
                    </TR>
<%
    }
  }
%>
                </TABLE>
            </DIV>
        </TD>
    </TR>
    </FORM>
    <TR valign="bottom" >
        <TD align="center" height='25'>
<% if (lTom.size()>0) {%>
            <INPUT type="button" name="cmdAceptar" value=" Aceptar " height="20px" class="boton" onClick="Aceptar();">&nbsp;&nbsp;&nbsp;&nbsp;
<% } %>
            <INPUT type="button" name="cmdSalir"   value=" Cerrar "  height="20px" class="boton" onClick="Volver();">&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </TR>
</TABLE>



</BODY>
</HTML>
