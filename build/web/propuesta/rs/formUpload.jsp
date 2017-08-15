<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Documentacion"%>
<%@page import="java.util.LinkedList"%>

<%
   Usuario usu = (Usuario) session.getAttribute("user");
    String numPropuesta = (request.getParameter ("num_propuesta") == null ? "0" : request.getParameter ("num_propuesta")); 
    String codRama      = (request.getParameter ("cod_rama") == null ? "0" : request.getParameter ("cod_rama")); 
    String numPoliza    = (request.getParameter ("num_poliza") == null ? "0" : request.getParameter ("num_poliza")); 
    String certificado  = (request.getParameter ("certificado") == null ? "0" : request.getParameter ("certificado")); 
    String subCertificado = (request.getParameter ("sub_certificado") == null ? "0" : request.getParameter ("sub_certificado")); 
    String tipoDocumento= (request.getParameter ("tipo_documento") == null ? "0" : request.getParameter ("tipo_documento")); 
    String codProd      = (request.getParameter ("cod_prod") == null ? "0" : request.getParameter ("cod_prod")); 
    String numSini      = (request.getParameter ("num_sini") == null ? "0" : request.getParameter ("num_sini")); 
    String numTomador   = (request.getParameter ("num_tomador") == null ? "0" : request.getParameter ("num_tomador")); 
    int numOrden        = 0;
    
    String sMensaje     = ((String)request.getAttribute ("mensaje") == null ? "" : (String)request.getAttribute("mensaje")); 
    String estado       = ((String)request.getAttribute ("estado") == null ? "" : (String)request.getAttribute("estado"));     
    
    Tablas oTabla = new Tablas();
    
 System.out.println ( numPropuesta + " " + codRama + " " + numPoliza + " " + 
  certificado + " " + subCertificado + " " + tipoDocumento + " " + codProd + " " + 
   numSini + " " + numTomador );   
 
    LinkedList <Documentacion> lDoc = oTabla.getAllDocumentos (Integer.parseInt(codRama), 
            Integer.parseInt(numPoliza), Integer.parseInt(numPropuesta), Integer.parseInt(codProd), 
            Integer.parseInt(numSini), Integer.parseInt(numTomador), Integer.parseInt(certificado), 
            Integer.parseInt(subCertificado), usu.getusuario());
    if (lDoc != null) {
        numOrden = lDoc.size();
        System.out.println ("lDoc.size --> " + lDoc.size());
    }
    
%>
<html>
<head>
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/main.css">
<script type="text/javascript">
    function eliminarDoc (numDoc) {
        document.getElementById ("opcion").value = 'delFile';
        document.getElementById ("num_documento").value = numDoc;
        document.formDel.submit();
    }

    function sendFile () {
    //    alert ("Por el momento no es posible adjuntar archivos hasta nuevo aviso. Gracias");
        
    //    return false;
        
        if (document.getElementById('select_documento').value === "0") {
            alert ("Seleccione tipo de documento ");
            document.getElementById('select_documento').focus ();
            return false;
        } else {
            document.formUp.submit();
            return true;
        }
    }
    
</script>
</head>
<body >
<form action="<%=Param.getAplicacion()%>servlet/FileUploadServlet" method="post" name="formDel" id="formDel" >
   <input type="hidden" name="opcion"       id="opcion"         value="delFile"/>
   <input type="hidden" name="num_documento" id="num_documento" value="0"/>
   <input type="hidden" name="num_propuesta" id="num_propuesta" value="<%= numPropuesta %>"/>
   <input type="hidden"  name="cod_rama" id="cod_rama" value="<%= codRama %>"/>
   <input type="hidden"  name="num_poliza" id="num_poliza"  value="<%= numPoliza %>"/>
   <input type="hidden"  name="certificado" id="certificado"  value="<%= certificado %>"/>
   <input type="hidden"  name="sub_certificado" id="sub_certificado" value="<%= subCertificado %>"/>
   <input type="hidden"  name="tipo_documento" id="tipo_documento" value="<%= tipoDocumento %>"/>
   <input type="hidden"  name="cod_prod" id="cod_prod"  value="<%= codProd %>"/>
   <input type="hidden"  name="num_sini" id="num_sini" value="<%= numSini  %>"/>
   <input type="hidden"  name="num_tomador" id="num_tomador"  value="<%= numTomador  %>"/>
</form>
   
<form action="<%= Param.getAplicacion()%>servlet/FileUploadServlet" method="post" 
    enctype="multipart/form-data" name="formUp" id="formUp" >
   <input type="hidden" name="num_propuesta" id="num_propuesta" value="<%= numPropuesta %>"/>
   <input type="hidden"  name="cod_rama" id="cod_rama" value="<%= codRama %>"/>
   <input type="hidden"  name="num_poliza" id="num_poliza"  value="<%= numPoliza %>"/>
   <input type="hidden"  name="certificado" id="certificado"  value="<%= certificado %>"/>
   <input type="hidden"  name="sub_certificado" id="sub_certificado" value="<%= subCertificado %>"/>
   <input type="hidden"  name="tipo_documento" id="tipo_documento" value="<%= tipoDocumento %>"/>
   <input type="hidden"  name="cod_prod" id="cod_prod"  value="<%= codProd %>"/>
   <input type="hidden"  name="num_sini" id="num_sini" value="<%= numSini  %>"/>
   <input type="hidden"  name="num_tomador" id="num_tomador"  value="<%= numTomador  %>"/>
   <input type="hidden"  name="num_orden" id="num_orden"  value="<%= numOrden  %>"/>
   <table border="0" width="100%" height="100%" class="fondoForm" >
        <tr>
            <td class="text" nowrap valign="top" align="left">
                <select id="select_documento" name="select_documento" style="width:180px;" class="select">
                    <option value="0" <%= (tipoDocumento.equals ("0") ? "selected" : "") %>>Seleccione tipo de documento</option>                                        
                    <option value="1" <%= (tipoDocumento.equals ("1") ? "selected" : "") %>>Ficha de propuesta</option>
                    <option value="2" <%= (tipoDocumento.equals ("2") ? "selected" : "") %>>Designaci&oacute;n de beneficiarios</option>
                </select>
            </td>
            <td> 
                <input type="file" size="50"  name= "FILE1" id="FILE1" value=" Adjunte archivo "/>
                &nbsp;&nbsp;&nbsp;
                <input type="button" name="enviarArchivo" id="enviarArchivo" value=" Subir archivo" height="20px" class="boton" onclick="javascript:sendFile();" >
            </td>
        </tr>
<%      if ( lDoc != null ) {
            for (int i=0;i<lDoc.size();i++) {
                Documentacion oDoc = (Documentacion) lDoc.get(i);
                if (oDoc.getmcaBaja() == null || 
                        (oDoc.getmcaBaja() != null && oDoc.getmcaBaja().equals("") )) { 
    %>
    <tr>
        <td class="text" align="left" colspan="2"><%= oDoc.getDescTipoDoc() %>:&nbsp;<%= oDoc.getnomArchivo() %>&nbsp;&nbsp;
            <a href="#" onclick="javascript:eliminarDoc (<%= oDoc.getnumDocumento() %>);">Eliminar</a>&nbsp;&nbsp;&nbsp;
            <a href="<%= Param.getAplicacion() %>files/doc/<%= oDoc.getnomArchivo() %>" target="_blank">Ver</a>
        </td>        
    </tr>
<%    
                } 
            }
        }
    %>


     
<%  if (estado.equals("ERROR")) {
    %>
    <tr>
        <td class="text" colspan="2"><span style="color:red;"><%= sMensaje %></span></td> 
    </tr>    
<%    
    }
   if (estado.equals("OK")) {
    %>
    <tr>
        <td class="text" colspan="2"><span style="color:green;"><%= sMensaje %></span></td> 
    </tr>    
<%    
    }
   %>
   
   </table>
</form>
</body>
</html>