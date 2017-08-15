<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  
    Usuario usu = (Usuario) session.getAttribute("user"); 
    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");
    int    codProceso   = oProp.getCodProceso();
    String codBoca      = oProp.getBoca();
    int    numPropuesta = oProp.getNumPropuesta();
    int    cantVidas    = oProp.getCantVidas() ;
   // 
    int cantNominas = 0 ;
   
    if (request.getAttribute("nominas") != null ) {
        LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;        
        cantNominas = lNom.size();       
    }

    int posOrden = 1;
   
    String pathReal = this.getServletConfig().getServletContext().getRealPath("") ;

%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>JSP Page</title></head>
<link rel="icon" href="http://www.beneficioweb.com.ar/favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language="javascript">

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    
    function ValidarDatos() {


        if (document.formNom.prop_nom_orden.value == "" ) {            
          alert ("Ingrese el Orden");
          return false; 
        }

        if (document.formNom.prop_nom_ApeNom.value == "" ) {            
          alert ("Ingrese el Apellido y Nombre");
          return false; 
        }
        
        if (document.formNom.prop_nom_numDoc.value == "" ) {            
          alert ("Ingrese el Documento");
          return false; 
        }

        if  ( !ControlarDNI ( document.formNom.prop_nom_numDoc.value ) ) {
            return false;
        }

        if (document.formNom.prop_nom_fechaNac.value == "" ) {            
          alert ("Ingrese Fecha Nacimiento");
          return false; 
        }

        if ( !ValidarDoc() ){
          return false;  
        } 

        return true; 

    } 

    function ValidarDoc(){

        var cantNom  = document.formNom.prop_cantNom.value;                      

        for (i=0;i < cantNom ; i++){
            var tipo = document.getElementById('prop_tipoDoc_'+i).value;
            var doc = document.getElementById('prop_numDoc_'+i).value;
            
            if ( tipo == document.formNom.prop_nom_tipDoc.value && 
                 doc  == document.formNom.prop_nom_numDoc.value
               ) {
                   alert( " El documento ingresado ya existe ..."  );
                   return false; 
               }
        }                

        return true;
    }

    function ControlarDNI ( dni ) {
       
        if ( document.getElementById('prop_nom_tipDoc').value == '80') {
            if ( ! ValidoCuit (document.getElementById('prop_nom_numDoc').value)) {
                document.getElementById('prop_nom_numDoc').focus ();
                return false;
            }
        } else {
            if (document.formNom.prop_nom_numDoc.value.length < 7) {
                alert ("Documento inválido !");
                document.formNom.prop_nom_numDoc.focus ();
                return false;
            } 
        }

        return true;
    }

    function AddNomina () {       

        var cantNom   = parseInt(document.formNom.prop_cantNom.value) + parseInt(1);        
        var cantVidas = document.formNom.prop_cantVidas.value ;

        // alert (" cantNom " + cantNom  + "  cantVidas " + cantVidas);

        if ( cantNom > cantVidas ) {            
          alert (" La nómina debe tener " + cantVidas + " personas");
          return false; 
        }         

        if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.opcion.value="grabarNomina";
            document.formNom.submit();            
        }  
    }

    function Grabar () {
        if ( ValidarDatos() ) {            
            desbloquea();
            document.formNom.opcion.value="grabarNomina";
            document.formNom.submit();            
        }  
    }

    function Enviar () {
        var cantNom   = document.formNom.prop_cantNom.value ;
        var cantVidas = document.formNom.prop_cantVidas.value ;
        if( cantNom == cantVidas ) {
            desbloquea();
            document.formNom.opcion.value="enviarPropuesta";
            document.formNom.submit();            
            return true;
        } else {
            alert(" La nómina no puede ser enviada. Debe tener " + cantVidas + " personas " ); 
            return true;
        }
    }  


    function DelNomina (param) {
        if (confirm("Esta usted seguro que desea eliminar la persona de la nómina ?  ")) {
            desbloquea();
            document.formNom.prop_del_orden.value = document.getElementById(param).value;
            document.formNom.opcion.value="borrarNomina"; 
            document.formNom.submit();            
            return true;
        } else {
            return false;
        }
    }

    function desbloquea(){
        document.formNom.prop_numero.disabled = false;      
        document.formNom.prop_nom_orden.disabled = false;      
            
    }

    function ControlarFecha (fecha, desde) {

//        var edad =  calcular_edad (fecha, desde );
        var Fecha_nac = new Date (FormatoFec( fecha));
        var Fecha_desde = new Date (FormatoFec( desde));
        var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));
        if ( edad > 64 ) {
            alert ("Fecha de nacimiento incorrecta, debe tener a lo sumo 64 años \n a la fecha de inicio de vigencia");
            document.formNom.prop_nom_fechaNac.value = "";
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else if ( edad < 18) {
            alert ("Fecha de nacimiento incorrecta, debe ser mayor de 18 años !!");
            document.formNom.prop_nom_fechaNac.value = "";
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else {
            return true;
        }
    }    
</script>
<body>
    <table cellSpacing="0" cellPadding="0" width="960" align="center" border="0">
        <tr>
            <td>
                <jsp:include page="/header.jsp">
                    <jsp:param name="aplicacion" value="<%= Param.getAplicacion() %>" />
                    <jsp:param name="usuario" value="<%= usu.getusuario() %>" />
                    <jsp:param name="descripcion" value="<%= usu.getRazonSoc() %>" />
                </jsp:include>
                <div class="menu">
                    <menu:renderMenuFromDB    aplicacion="1"  userLogon="<%= usu.getusuario()%>" />
                </div>
            </td>
        </tr>
    <TR>
        <TD align="center" valign="top" width='100%'>            
            <TABLE border='0' width='100%'>             
                <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formNom' id='formNom'>
                <input type="hidden" name="opcion"         id="opcion"           value='' >
                <input type="hidden" name="siguiente"      id="siguiente"        value='Volver' >
                <input type="hidden" name="prop_proceso"   id="prop_proceso"     value="<%=codProceso%>"  >
                <input type="hidden" name="prop_codBoca"   id="prop_codBoca"     value="<%=codBoca%>"  >
                <input type="hidden" name="prop_cantVidas" id="prop_cantVidas"   value="<%=cantVidas%>"  >
                <input type="hidden" name="volver"         id="volver"
                       value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" >
                <input type="hidden" name="prop_del_orden" id="prop_del_orden"   value=""  >
                <TR>
                    <TD>
                        <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                                                   
                            <TR>
                                <TD align="left" class='titulo'>Propuesta Nº:                                
                                    <input type="text" name="prop_numero" id="prop_numero"  size="10" maxleng="20" value="<%=numPropuesta%>"  disabled >
                                </TD>
                            </TR>                        
                            <TR>
                                <TD  colspan='4' valign="middle" align="left" class='titulo'>Carga de N&oacute;mina de Asegurados</TD>
                            </TR>
                        </TABLE>		
                    </TD>
                </TR>
                <TR>
                    <TD class='titulo'>Ingrese desde aqu&iacute; el asegurado:</TD>
                </TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Orden</th>
                                <th width="200px">Apellido y Nombre</th>
                                <th width="50px">Tipo</th>
                                <th width="140px">Documento</th>
                                <th width="80px">Fecha Nac.</th>
                                <th width="100px">Mano</th>
                                <th  width="60px">&nbsp;</th>
                            </thead>
                            <TD> <input id='prop_nom_orden'  name='prop_nom_orden'  type='TEXT' value='<%=posOrden%>' style="WIDTH: 50px;" disabled></TD>
                            <TD> <input id='prop_nom_ApeNom' name='prop_nom_ApeNom' type='TEXT' value='' style="WIDTH: 200px;"></TD>
                            <TD>                                    
                                <SELECT id='prop_nom_tipDoc' name='prop_nom_tipDoc' style="WIDTH: 50px"  class="select">
                                    <OPTION value="80"> CUIL </OPTION>
                                    <OPTION value="96"> DNI </OPTION> 
                                </SELECT>	
                            </TD>        
                            <TD> <input type='TEXT' id='prop_nom_numDoc'   name='prop_nom_numDoc' style="WIDTH: 140px;" value=''
                                        size='12' maxlength='12'  onkeypress="return Mascara('D',event);" class="inputTextNumeric"></TD>
                            <TD> <input type="text" id='prop_nom_fechaNac' name='prop_nom_fechaNac' style="WIDTH: 80px;"
                                        size="8"  maxlength='10' onblur="ControlarFecha (validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                        onkeypress="return Mascara('F',event);" value=''> </TD>
                            <td><SELECT id='prop_nom_mano' name='prop_nom_mano' style="WIDTH:100px" class="select">
                                    <option value="D">Diestro</Option>
                                    <option value="I">Zurdo</option> 
                                </select>
                            </td>
                            <TD> <input type='BUTTON' value='Agregar' style="WIDTH: 60px;" class="boton" onClick="AddNomina();"  ></TD>
                        </TABLE>
                    </TD>
                </TR>           
<%
        if (cantNominas > 0) { 
%>                
                <TR>
                    <TD class='titulo'>N&oacute;mina de asegurados</TD>
                <TR>
                <TR>
                    <TD>
                       <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <thead>
                                <th width="50px">Orden</th>
                                <th width="200px">Apellido y Nombre</th>
                                <th width="150px">Tipo</th>
                                <th width="140px">Documento</th>
                                <th width="80px">Fecha Nac.</th>
                                <th width="50px">Mano</th>
                                <th width="60px">&nbsp;</th>                                                         
                            </thead>
<%

            LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;

            for( int i=0; i < cantNominas; ++i) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta)lNom.get(i);
                int    orden       = oAseg.getOrden();
                if (orden > posOrden) { posOrden = orden; }
                String fechaNac    = (oAseg.getFechaNac() == null ? "No informada" : Fecha.showFechaForm(oAseg.getFechaNac()));
%>
                            <TR>                                  
                                <TD    style="WIDTH: 50px;"  align='right'><%=orden%>&nbsp;</TD>

                                <input type="hidden" id='prop_nom_orden_<%=i%>' name='prop_nom_orden_<%=i%>' value='<%=oAseg.getOrden () %>' >
                                <input type="hidden" id='prop_tipoDoc_<%=i%>'   name='prop_tipoDoc_<%=i%>' value='<%=oAseg.getTipoDoc () %>' >
                                <input type="hidden" id='prop_numDoc_<%=i%>'    name='prop_numDoc_<%=i%>' value='<%=oAseg.getNumDoc () %>' >

                                <TD    style="WIDTH: 200px;" align='left'>&nbsp;<%=oAseg.getNombre ()%></TD>                         
                                <TD    style="WIDTH: 150px;" align='left'>&nbsp;<%=oAseg.getDescTipoDoc () %></TD>                         
                                <TD    style="WIDTH: 140px;" align='right'><%=oAseg.getNumDoc()%>&nbsp;</TD>                         
                                <TD    style="WIDTH: 80px;"  align='right'><%=fechaNac%>&nbsp;</TD>          
<%                              if (oAseg.getmano() == null || oAseg.getmano ().equals ("")) {
%>
                                <TD align='center'>no info</TD>
<%                              } else {
%>
                                <TD align='center'><%= (oAseg.getmano().equals ("D") ? "Diestro" : "Zurdo") %>&nbsp;</TD>
<%                              }
%>

                                <TD> <input type='BUTTON' value='Borrar' style="WIDTH: 60px;" class="boton" onClick="DelNomina('prop_nom_orden_<%=i%>');"  ></TD>


                            </TR>
<%
            }
            posOrden += 1;

%>
                        </TABLE>		
                    </TD>
                </TR>
<%
        } 
%>
                <input type="hidden" id='prop_cantNom' name='prop_cantNom' value="<%=cantNominas%>"  >
                </FORM>            

<% if (cantVidas >= 5 ) { %>

                <TR>
                    <TD>
                        <TABLE border='0' align="center" class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>
                            <TR bgcolor="#E8F2F6"> 
                                <TD valign="top" bgcolor="#C8E0EA" class="txt2">                                
                                    <I>
                                    <P>&nbsp;Estimado, como la cantidad de asegurados de la propuesta supera los 10,como alternativa usted podrá ingresar los 
                                    <BR>&nbsp;mismos desde una planilla Excel que nosotros le facilitaremos.
                                    <BR>
                                    <BR>
                                    <P>&nbsp;Si asi lo desea, por favor siga las siguientes instrucciones: 
                                    <BR>
                                    <BR>                         
                                    &nbsp;1 - Si a&uacute;n no se ha bajado la planilla Excel, por favor hagalo
                                        <A class="link" target='_blank' href='<%= Param.getAplicacion()%>files\manuales\nominaBenef.xls'>            
                                            <B> desde aqu&iacute;. </B>
                                        </A>  Recuerde que usted <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;puede reusar la misma planilla utilizada en la carga de otra propuesta.<BR>

                                    &nbsp;2 - Lea con mucha atenci&oacute;n las instrucciones de la primera hoja. La n&oacute;mina la deber&aacute; <BR>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;completar en la segunda hoja.<BR>
                                    &nbsp;3 - Luego de completar la carga de la n&oacute;mina, grabe el archivo en su disco(desde Archivos -> Guardar como...)<BR>
                                    &nbsp;4 - Haga click en Examinar para buscar el archivo en su disco, y luego <BR> 
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;haga click en Cargar Nomina.<BR>    
                                    </I>
                                        <FORM id='fromPropuesta' METHOD="POST" ACTION="/benef/propuesta/upload.jsp?num_propuesta=<%=numPropuesta%>&prop_cantVidas=<%=cantVidas%>" ENCTYPE="multipart/form-data">                  
                                            <TABLE border="0" cellpadding="0" cellspacing="4" width="100%" >                                     
                                                <TR>                                                                        
                                                    <TD>                            
                                                        <input type="FILE"   name= "FILE1"   id="FILE1" SIZE="50">
                                                       <input type="submit" name="Enviar" value="Cargar Nomina">
                                                    </TD>                     
                                                </TR>
                                            </TABLE>
                                        </FORM>                                    
                                    &nbsp;<LABEL style='color:red;'><I><U>IMPORTANTE:</U></I></LABEL> &nbsp;&nbsp;la carga desde esta via pisa la nomina ya ingresada manualmente<BR>
                                    &nbsp;o desde otro archivo Excel.<BR>    
                        </TABLE>		
                    </TD>
                </TR>
<%  }  %>

                <TR valign="bottom" >
                    <TD width="100%" align="center">
                        <TABLE border='0' align='left' class="" width='700'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD align="center">
                                    <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">
                                    &nbsp;&nbsp;    
                                    <%--                                            
                                    <input type="button" name="cmdGrabar"  value="Grabar"  height="20px" class="boton" onClick="Grabar();">
                                    &nbsp;&nbsp;                                                
                                    --%>
                                    <input type="button" name="cmdEnviar"  value="Enviar Propuesta"    height="20px" class="boton" onClick="Enviar();">
                                </TD>
                            </TR>
                        </TABLE>		
                    </TD>
                </TR>

            </TABLE>
        </TD>
    </TR>





    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>

</TABLE>
<script>
document.getElementById ('prop_nom_orden').value = <%= posOrden %>;
CloseEspere();
</script>
</body>
</html>
