<%--
    Document   : formResponderEncuesta
    Created on : 25/05/2011, 07:23:37
    Author     : silvio
--%>   
     

<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.Date"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>

<%@taglib uri="/tld/menu.tld" prefix="menu" %>
<%
    
    com.business.beans.Encuesta oEncuesta  = (com.business.beans.Encuesta) request.getAttribute ("encuesta"); 
    ControlEnvioMail oCEM = (ControlEnvioMail)request.getAttribute ("oCEM");
    if (oEncuesta == null) {     
        System.out.println("no se encontro la encuesta");
    }
   
%>
<HTML>
    <head>
        <title>Formulario de Encuesta</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <script language="javascript">
    if ( history.forward(1) ) {
        history.replace(history.forward(1));
    }
    </script>
    </head>
    <link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
    <script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
    <script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
    <script language='javascript'>     

    function Grabar () {
       
        if (confirm("Desea grabar la encuesta ?  ")) {
       
            document.formEncuesta.opcion.value="grabarEncuesta";
            document.formEncuesta.datoNavegador.value= BrowserDetect.browser+"|"+
                                                       BrowserDetect.version+"|"+
                                                       BrowserDetect.OS ;           
            document.formEncuesta.submit();
        }
    }

    </script>

<body leftMargin="20" topMargin="5" marginheight="0" marginwidth="0"
      onload="Javascript:history.go(1);" onunload="Javascript:history.go(1);">
    <TABLE cellSpacing="0" cellPadding="0" width="750" align="center" border="0" >
      <tr>
          <td><img src="<%=Param.getAplicacion()%>images/template/tem44.jpg" width="750" height="96" /></td>
      </tr>
        <!--TR>
            <TD height="30px" valign="middle" align="center" class='titulo'>FORMULARIO DE ENCUESTA</TD>
        </TR-->
        <TR>
            <TD align="center" valign="top" width='100%'>
                <TABLE border='0' width='100%' >
<%
if ( oEncuesta != null && oEncuesta.getNumEncuesta() != 0  ) {
%>

                <FORM method="post" action="<%= Param.getAplicacion()%>servlet/EncuestaServlet" name='formEncuesta' id='formEncuesta'>
                    <INPUT type="hidden" name="opcion" id="opcion" value='' >
                    <INPUT type="hidden" name="numEncuesta" id="numEncuesta" value='<%=oEncuesta.getNumEncuesta()%>' >
                    <INPUT type="hidden" name="datoNavegador" id="datoNavegador" value='' >
                    <INPUT type="hidden" name="token" id="token" value='<%=oCEM.getToken()  %>' >
                    <INPUT type="hidden" name="enc_usu_destino" id="enc_usu_destino" value='<%=oCEM.getUsuarioDestino()  %>' >
                    <INPUT type="hidden" name="enc_mail_destino" id="enc_mail_destino" value='<%=oCEM.getMailDestino()  %>' >

                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                                <TR>
                                    <TD  colspan='2' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE ENCUESTA </U></TD>
                                </TR>
                                <td >&nbsp;</td>                                
<%
                                if ( oEncuesta.getLPregunta().size() > 0 ) {
                                    int numEncuesta = oEncuesta.getNumEncuesta();

                                    for ( int i = 1; i <= oEncuesta.getLPregunta().size() ; i++  ) {
                                        EncuestaPregunta oEncuestaPregunta = (EncuestaPregunta)oEncuesta.getLPregunta().get(i - 1);
%>
                                <TR>
                                    <TD  colspan='2' valign="middle" align="left" class='subtitulo' >
                                      <%=oEncuestaPregunta.getPregunta()%>                                     
                                   </TD>
                                </TR>
<%
                                        if(oEncuestaPregunta.getLOpcion().size() > 0) {
                                            if (oEncuestaPregunta.getCantOpcion() != 1) {
                                                for ( int j = 1; j<= oEncuestaPregunta.getLOpcion().size() ; j++  ) {
                                                    EncuestaOpcion oEncuestaOpcion = (EncuestaOpcion)oEncuestaPregunta.getLOpcion().get(j - 1);
                                                    if (oEncuestaPregunta.getMultipleChoise().equals("S")) {
                                                        if (oEncuestaOpcion.getMcaCampoAbierto().equals("N") ) {
%>
                                <TR>
                                    <TD WIDTH="15">&nbsp;</TD>
                                    <TD valign="middle" align="left" class='text' >
                                        <INPUT type='checkbox'
                                                value='S'
                                                name='CBX_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                                id='CBX_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'>
                                                <%= oEncuestaOpcion.getDescripcion() %>
                                        </INPUT>
                                    </TD>
                                </TR>
<%                                                      } else { %>
                                <TR>
                                    <TD WIDTH="15">&nbsp;</TD>
                                    <TD valign="middle" align="left" class='text' >
                                        <LABEL><%= (oEncuestaOpcion.getDescripcion()!=null )?oEncuestaOpcion.getDescripcion():"" %></LABEL>
                                        <INPUT type="text"
                                               name='TXT_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                               id='TXT_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                               size="80"
                                               maxleng="<%=oEncuestaOpcion.getLongCampoAbierto()%>"
                                               value="">
                                    </TD>
                                </TR>
<%                                                      } %>
<%                                                 } else { %>
<%                                                     if (oEncuestaOpcion.getMcaCampoAbierto().equals("N") ) {%>
                                <TR>
                                    <TD WIDTH="15">&nbsp;</TD>
                                    <TD  valign="middle" align="left" class='text' >

                                        <INPUT type='radio'

                                                value='<%=oEncuestaOpcion.getNumOpcion()%>'
                                                name='RDO_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>'
                                                id='RDO_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>'>
                                                <%= oEncuestaOpcion.getDescripcion() %>
                                        </INPUT>
                                    </TD>
                                </TR>
<%                                                      } else { %>
                                <TR>
                                    <TD WIDTH="15">&nbsp;</TD>
                                    <TD valign="middle" align="left" class='text' >
                                        <LABEL><%= (oEncuestaOpcion.getDescripcion()!=null )?oEncuestaOpcion.getDescripcion():"" %></LABEL>
                                        <INPUT type="text"
                                               name='TXT_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                               id='TXT_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                               size="80"
                                               maxleng="<%=oEncuestaOpcion.getLongCampoAbierto()%>"
                                               value="">
                                    </TD>
                                </TR>
<%                                                      } %>

<%                                                 }
                                                } //For
%>
                                <tr><td>&nbsp;</td></tr>
<%
                                            } else {
                                                EncuestaOpcion oEncuestaOpcion = (EncuestaOpcion)oEncuestaPregunta.getLOpcion().get(0);
                                                if (oEncuestaOpcion.getMcaCampoAbierto().equals("N")) {
%>
                                <TR>
                                    <TD WIDTH="15">&nbsp;</TD>
                                    <TD valign="middle" align="left" class='' >
                                        <INPUT type='checkbox'
                                                value='S'
                                                name='CBX_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                                id='CBX_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'>
                                                <%= oEncuestaOpcion.getDescripcion() %>
                                        </INPUT>
                                    </TD>
                                </TR>
                                <tr><td>&nbsp;</td></tr>

<%
                                                } else {
                                                    if (oEncuestaOpcion.getDescripcion()!=null ) {
 %>
                                <TR>
                                    <TD  colspan='2' valign="middle" align="left" class=''>
                                        &nbsp;<%= oEncuestaOpcion.getDescripcion() %>
                                    </TD>
                                </TR>
 <%
                                                    }
%>


                                <TR>
                                    <TD WIDTH="15">&nbsp;</TD>
                                    <TD valign="middle" align="left" class='' >
                                        <INPUT type="text"
                                               name='TXT_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                               id='TXT_ENC_<%=oEncuestaOpcion.getNumEncuesta()%>_PRE_<%=oEncuestaOpcion.getNumPregunta()%>_OPC_<%=oEncuestaOpcion.getNumOpcion()%>'
                                               size="100"
                                               maxleng="<%=oEncuestaOpcion.getLongCampoAbierto()%>"
                                               value="">                                    
                                    </TD>
                                </TR>
                                <tr><td>&nbsp;</td></tr>
<%
                                                }
                                            }
                                        }
                                    } // For  oEncuesta.getLPregunta
                               }  else { //cant preguntas
%>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' nowrap>No tiene preguntas informadas.</TD>
                                    

                                    </TD>
                                </TR>
<%                             }%>
                    


                      

<%                                if ( oEncuesta.getLPregunta().size() > 0 ) { %>
                    <tr valign="bottom" >
                        <td width="100%" align="center" colspan="2" >
                            <input type="button" name="cmdGrabar"  value="Enviar Encuesta"  height="20px" class="boton" onClick="Grabar();">
                        </td>
                    </tr>
<%                                } %>

                </FORM>
                </TABLE>
            </TD>
        </TR>


<%
} else {
%>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                                <TR>
                                    <TD  colspan='2' height="30px" valign="middle" align="center" class='titulo'><u>FORMULARIO DE ENCUESTA </U></TD>
                                </TR>
                                <TR>
                                    <TD  colspan='2' height="30px" valign="middle" align="left" class='titulo'><%=(oEncuesta!=null)?oEncuesta.getsMensError():""%></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
<%
}
%>
            <TR>
                <TD width='100%'>
                    <jsp:include flush="true" page="/bottom.jsp"/>
                </TD>
            </TR>
         </TABLE>
    </body>
</html>


