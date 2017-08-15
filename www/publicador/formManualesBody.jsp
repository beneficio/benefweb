<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.beans.Usuario"%>
<%
 Usuario oUsuario = (Usuario) session.getAttribute ("user");

 LinkedList lSecciones = new LinkedList ();
 LinkedList lCodigos   = new LinkedList ();

  	Connection dbCon = null;
        dbCon = db.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String SQL = " SELECT A.\"SECCION\", A.\"TITULO\" AS \"DESC_SECCION\", ";
	SQL =  SQL + "A.\"TIPO_USUARIO\" ";
	SQL =  SQL + " FROM \"MANUALES\" AS A ";
	SQL =  SQL + "WHERE A.\"CATEGORIA\" = 'S' ";
	SQL =  SQL + " ORDER BY A.\"SECCION\"; ";


        System.out.println (SQL);

	pstmt = dbCon.prepareStatement(SQL);
        rs = pstmt.executeQuery();
         while (rs.next ()) {
             String sTipo = "";
             switch (rs.getInt ("TIPO_USUARIO")) {
                 case 0 :
                    sTipo = "Usuarios internos";
                    break;
                 case 1 :
                    sTipo = "Productores" ;
                    break;
                 case 2 :
                    sTipo = "Clientes";
                    break;
                 default:
                    sTipo = "Todos los usuarios";
                 }
             String sSeccion = rs.getString ("DESC_SECCION") + " (" +  sTipo + ")";
             lCodigos.add(String.valueOf(rs.getInt ("SECCION")));
             lSecciones.add(sSeccion);
             }
        rs.close ();
     rs.close();
     pstmt.close();
     db.cerrar(dbCon);
%> 
<SCRIPT language="javascript">
	function publicar(){
            if (document.getElementById('orden').value == "" || 
                document.getElementById('orden').value == "0") {
                alert ("Debe ingresar el orden");
                document.getElementById('orden').focus();
                return false; 
            }

            if (document.getElementById('titulo').value == "" ) {
                alert ("Debe ingresar el titulo");
                document.getElementById('titulo').focus();
                return false; 
            }

            if (document.getElementById('detalle').value == "" ) {
                alert ("Debe ingresar el detalle");
                document.getElementById('detalle').focus();
                return false; 
            }

  //          if (document.getElementById('FILE1').value == "" ) {
 //               alert ("Debe ingresar el el archivo a publicar");
 //               document.getElementById('FILE1').focus();
 //               return false; 
 //           }
	
            document.getElementById('Publicacion').submit();

	}
</SCRIPT>
<FORM id='Publicacion' METHOD="POST" ACTION="<%=Param.getAplicacion()%>publicador/publicarPublicacion.jsp" ENCTYPE="multipart/form-data">
<input name="cod_compania" id="cod_compania" type="Hidden" value="1">
<TABLE  class="fondoForm" align="center" cellpadding="2" cellspacing="2" width="100%">
    <TR>
        <TD valign="top" class="subtitulo" height="30px" align="center">PUBLICACION DE MANUALES Y FORMULARIOS</TD>
    </TR>
    <TR>
        <TD class='text'>Llene por favor el formulario, con todos sus datos.</TD>
    </TR>
    <tr>
        <TD>
            <TABLE  align="center" width="100%" border="0" cellpadding="4" cellspacing="2"  >
                <TR>
                    <TD nowrap class='text'>Orden N°:</TD>
                    <TD class='text'><input type="text" id="orden" name="orden" onKeyPress="return Mascara('D',event);"  class="inputTextNumeric" size="5" maxlength="5"> </TD>
                </TR>
                <TR>
                    <TD class="text">Secci&oacute;n:</TD>
                    <TD class="text" class='select'>
                        <select name="seccion" id="seccion">
<%                      for (int i=0; i < lCodigos.size(); i++) {
    %>
    <option value="<%= ((String) lCodigos.get(i)) %>" ><%= ((String) lSecciones.get(i)) %></option>
<%                      }
    %>
                        </select>
                    </TD>
                </TR>
                <TR>
                    <TD class="text">Tipo de usuario:</TD>
                    <TD class="text" class='select'>
                        <select name="tipoUsuario" id="tipoUsuario">
                            <option value="99999999">Todos los usuarios</option>
                            <option value="0" >Internos</option>
                            <option value="1" >Productores</option>
                            <option value="2" >Clientes</option>
                        </select>
                    </TD>
                </TR>
                <TR>
                    <TD nowrap class='text'>Categoria:</TD>
                    <TD width="100%" class='select'>
                    <select name="categoria" id="categoria">
                            <option value="M" SELECTED>Manual</option>
                            <option value="F">Formulario</option>
                    </select>
                    </TD>
                </TR>
                <TR>
                    <TD nowrap class='text'>Título de la Publicación:</TD>
                    <TD class='text'>
                        <INPUT type="text" name="titulo" id="titulo" value="" size="53" maxlengh="50">
                    </TD>
                </TR>
                <TR>
                    <TD nowrap class='text'>Detalle:</TD>
                    <TD class class="fondoForm">
                        <textarea cols="40" rows="4" name="detalle" id="detalle"></textarea>
                    </TD>
                </TR>
                <TR>
                <TD colspan="2">&nbsp;</TD>
                </TR>
                <TR>
                    <TD colspan="2" class='text'>Seleccione el archivo a publicar. Este archivo será
                                    enviado al servidor Web y estará<bR> disponible en
                                        el link de Manuales y Formularios.
                    </TD>
                </TR>
                <TR>
                    <TD nowrap class='text'>Archivo a Publicar:</TD>
                    <TD class='text'>
                        <INPUT TYPE="FILE" NAME="FILE1" id="FILE1" SIZE="50"><BR>
                    </TD>
                </TR>
                <TR>
                    <TD colspan="2" align="center" height="30px">
                        <input class="Boton" style="width: 120px;" type="button" name="cmdSalir" value="Cancelar" onClick="javascript:history.back();">
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input class="Boton" style="width: 120px;" type="button" name="cmdAceptar" value="Publicar" onClick="publicar();">
                    </TD>
                </TR>
            </TABLE>
    </TD>
    </tr>
</TABLE>
</FORM>

