<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.Date"%>
<%@page import="com.business.beans.AseguradoPropuesta"%>
<%@page import="com.business.beans.Propuesta"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  Usuario usu = (Usuario) session.getAttribute("user");
    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");
    int    numPropuesta = oProp.getNumPropuesta();
    int    cantVidas    = oProp.getCantVidas() ;
    int    codRama      = oProp.getCodRama();

    AseguradoPropuesta oTit = new AseguradoPropuesta();
    AseguradoPropuesta oCony = new AseguradoPropuesta();
    LinkedList lHijos = new LinkedList();
    LinkedList lAdher = new LinkedList();
    LinkedList lOtros = new LinkedList();
    int iGrupo = 1;
    int cantNomina = 0;
    double totalHijos   = 0;
    double totalAdher   = 0;
    double totalGrupo   = 0;

    if (request.getAttribute("nominas") != null ) {
        LinkedList lNom = (LinkedList)request.getAttribute("nominas") ;
        cantNomina = lNom.size();
        if (lNom.size() > 0 ) {
            for (int i=0; i< lNom.size();i++) {
                AseguradoPropuesta oAseg = (AseguradoPropuesta) lNom.get(i);
                iGrupo = oAseg.getCertificado();
                totalGrupo = totalGrupo + oAseg.getimpPremio();
                switch (oAseg.getparentesco())   {
                     case 1 :
                         oTit = oAseg;
                         break;
                     case 2 :
                         oCony = oAseg;
                         break;
                     case 3 :
                        lHijos.add(oAseg);
                        totalHijos = totalHijos + oAseg.getimpPremio();
                         break;
                     case 4 :
                        lAdher.add(oAseg);
                        totalAdher  = totalAdher + oAseg.getimpPremio();
                         break;
                     default :lOtros.add(oAseg) ;
                }
            }
        }
    }
%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>JSP Page</title></head>
<link rel="icon" href="http://www.beneficioweb.com.ar/favicon.ico" type="image/x-icon"/>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css"/>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/fechas.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script>
    var codRama     = <%= codRama %>;
    var codSubRama  = <%=  oProp.getCodSubRama() %>;
    var codProducto = <%=  oProp.getcodProducto() %>;
    var codProd     = <%=  oProp.getCodProd() %>;

    String.prototype.trim =  function() {
                    return (this.replace(/^[\s\xA0]+/, "").replace(/[\s\xA0]+$/, ""));
                }

    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }
    
    function ValidarDatos( parentesco ) {
    var prefijo = "";
    var desc = "";
    if (parentesco == '3' && document.getElementById('prop_mca_hijos').value != "S") {
        alert ("la cobertura seleccionada del titular es SIN HIJOS");
        return false;
    }

    switch( parentesco ){
        case 1: prefijo = 'tit_';
            desc = " titular ";
        break;
    case 2: prefijo = 'cony_';
        desc = " conyuge ";
        break;
    case 3: prefijo = 'hijo_';
        desc = " hijo ";
        break;
    default:
      prefijo = 'adher_';
      desc = " adherente ";
    }
        if ( parentesco == 1 || parentesco == 3 || parentesco == 4 ) {
            if (document.getElementById ( prefijo + 'nom_ApeNom').value == "" ) {
              alert ("Ingrese el Nombre y Apellido " + desc);
              return document.getElementById ( prefijo + 'nom_ApeNom').focus ();
            }
        }
        if (parentesco != 2 || (parentesco == 2 && document.getElementById ( prefijo + 'nom_ApeNom').value != "" )) {
            if (document.getElementById ( prefijo + 'nom_numDoc').value == "") {
              alert ("Documento inválido del " + desc);
              return document.getElementById ( prefijo + 'nom_numDoc').focus();
            }
            if  ( !ControlarDNI (document.getElementById ( prefijo + 'nom_tipDoc'),
                                 document.getElementById ( prefijo + 'nom_numDoc') ) ) {
                alert ("Documento inválido del " + desc);
                return document.getElementById ( prefijo + 'nom_numDoc').focus();
            }
            if ( document.getElementById ( prefijo + 'nom_fechaNac').value == "" ) {
              alert ("Ingrese Fecha Nacimiento del " + desc);
              return document.getElementById ( prefijo + 'nom_fechaNac').focus();
            }
        }
//        if ( !ValidarDoc() ){
//          return false;
//        }
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


    function addPersona (parentesco) {
        document.formNom.prop_add_parentesco.value = parentesco;
       if ( ValidarDatos (parentesco) ) {
            document.formNom.opcion.value="grabarNominaVC";
            document.formNom.submit();   
            return true;
        } 
        return false;
    }

    function Enviar ( sigte ) {

    if (ValidarDatos (1) && ValidarDatos (2)) {
//        var cantNom   = document.formNom.prop_cantNom.value ;
//        var cantVidas = document.formNom.prop_cantVidas.value ;
//        if( ValidarEdad() ) {
    document.formNom.siguiente.value = sigte;
    document.formNom.opcion.value="grabarNominaVC";
    document.formNom.submit();
    return true;
    }
 //       } else {
 //           return false;
 //       }
    }    


    function delPersona (parentesco, subCertificado) {
        document.formNom.prop_del_sub_certificado.value = subCertificado;
        document.formNom.opcion.value="delPersona";
        document.formNom.submit();
    }

    function ControlarFecha (fecha) {
       var edad =  calcular_edad ( fecha, getFechaActual () );

        if ( ! edad || edad < 1) {
            alert ("Fecha de nacimiento incorrecta");
            document.formNom.prop_nom_fechaNac.focus ();
            return false;
        } else {
            return true;
        }
         if (document.formNom.prop_nom_fechaNac.value == "" ) {            
           alert ("Fecha de nacimiento incorrecta");
           document.formNom.prop_nom_fechaNac.focus ();
          return false; 
        }

   }

    function ControlarDNI (tipo, dni ) {
       
        if ( tipo.value == '80') {
            if ( ! ValidoCuit ( dni.value.trim() )) {
                return dni.focus ();
            }
        } else {
            if ( dni.value.length < 7) {
                alert ("Documento inválido !");
                return dni.focus ();
            } 
        }

        return true;
    }

    function ControlarFechaEdad (campo, fecha, desde) {

        var Fecha_nac = new Date (FormatoFec( fecha));
        var Fecha_desde = new Date (FormatoFec( desde));
        var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));

//        var edad =  calcular_edad (fecha, desde );
        if (edad > 64) {
            alert ("Debe tener a lo sumo 64 años de edad !!!");
            campo.value = "";
            campo.focus ();
            return false;
        }  else if (  edad < 18) {
            alert ("Debe ser mayor a 18 años \n a la fecha de inicio de vigencia !!");
            campo.value = "";
            campo.focus ();
            return false;
        } else {
            return true;
        }
    }

    function ValidarEdad() {        
        var rama = document.getElementById('prop_rama').value ;
        if (rama ==22) {
            var cantVidas = document.formNom.prop_cantVidas.value ;
            var fechaVig  = "<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>";

            for (i=0;i < cantVidas; i++) {            
                var nac  = document.getElementById('prop_fechaNac_'+i).value;
                if (nac != "no info") {
                    var Fecha_nac = new Date (FormatoFec( nac));
                    var Fecha_desde = new Date (FormatoFec( fechaVig));
                    var edad = parseInt (dateDiff('y', Fecha_nac, Fecha_desde ));
                    if ( ! edad || edad > 64 || edad < 18 ) {
                        var j = i+1;
                        alert ("Fecha de nacimiento " + nac + " del Orden " + j + " es incorrecta, debe tener a lo sumo 64 años \n a la fecha de inicio de vigencia");
                        return false;
                    }
                }
            }            
        } 
        return true;
    }

    function DoChangeCobTit () {
    var cod_opcion = "0";
    var cod_agrup_tit = "0";
        if ( oFrameTit ) {
            cod_opcion    = oFrameTit.document.getElementById ('cod_cob').value.split("|")[0];
            cod_agrup_tit = oFrameTit.document.getElementById ('cod_cob').value.split("|")[1];

            if (oFrameTit.document.getElementById ('mca_hijos_' + cod_opcion + "|" + cod_agrup_tit) ) {
                document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
                                                                  + cod_opcion + "|" + cod_agrup_tit ).value;
            }
            if (oFrameTit.document.getElementById ('imp_premio_anual_' + cod_opcion + "|" + cod_agrup_tit)) {
                document.getElementById('tit_premio_anual').value   = oFrameTit.document.getElementById ('imp_premio_anual_' +
                                                                       cod_opcion + "|" + cod_agrup_tit ).value;
            }
        }

       document.getElementById('prop_cod_cob_opcion').value = cod_opcion;
       document.getElementById('prop_cod_agrup_cob_tit').value = cod_agrup_tit;

       var sUrl3 = "<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp" +
           "?cod_agrup_cob=" + document.formNom.prop_cod_agrup_cob_cony.value +
            "&cod_cob_opcion=" + cod_opcion + "&cod_rama=" + codRama + "&cod_sub_rama=" + codSubRama +
            "&cod_producto=" + codProducto + "&cod_prod=" + codProd + "&parentesco=CO";
        
        if (oFrameCon ) {
            oFrameCon.location = sUrl3;
        }
    }

    function DoChangeCobCony () {
    var cod_agrup_cony = "0";

        if ( oFrameCon ) {
            if (oFrameCon.document.getElementById ('cod_cob')){
                cod_agrup_cony = oFrameCon.document.getElementById ('cod_cob').value.split("|")[1];
            }

            if (oFrameCon.document.getElementById ('imp_premio_anual_' + oFrameCon.document.getElementById ('cod_cob').value)){
                document.getElementById('cony_premio_anual').value = oFrameCon.document.getElementById ('imp_premio_anual_' +
                                                                 oFrameCon.document.getElementById ('cod_cob').value).value;
            }
        }
        if (document.getElementById('prop_cod_agrup_cob_cony')) {
           document.getElementById('prop_cod_agrup_cob_cony').value = cod_agrup_cony;
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
            <TABLE border='0' width='100%'  class="fondoForm" >
                <form method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formNom' id='formNom'>
                <input type="hidden" name="opcion"         id="opcion"          value=''>
                <input type="hidden" name="siguiente"      id="siguiente"       value='Volver'>
                <input type="hidden" name="prop_cantVidas" id="prop_cantVidas"  value="<%=cantVidas%>">
                <input type="hidden" name="prop_del_orden" id="prop_del_orden"  value="<%= iGrupo %>">
                <input type="hidden" name="prop_del_sub_certificado" id="prop_del_sub_certificado"  value="">
                <input type="hidden" name="prop_rama"      id="prop_rama"       value="<%=codRama%>">
                <input type="hidden" name="prop_grupo"     id="prop_grupo"      value="<%= iGrupo %>">
                <input type="hidden" name="prop_tipo_nomina"    id="prop_tipo_nomina"    value="<%= oProp.gettipoNomina() %>">
                <input type="hidden" name="prop_add_parentesco" id="prop_add_parentesco" value="99">
                <input type="hidden" name="volver"              id="volver"
                       value="<%= (request.getParameter("volver") == null ? "filtrarPropuestas" : request.getParameter("volver"))%>" >
                <input type="hidden" name="prop_cod_cob_opcion" id="prop_cod_cob_opcion" value="<%= oTit.getcodCobOpcion() %>">
                <input type="hidden" name="prop_cod_agrup_cob_cony" id="prop_cod_agrup_cob_cony" value="<%= oCony.getcodAgrupCob() %>">
                <input type="hidden" name="prop_cod_agrup_cob_tit" id="prop_cod_agrup_cob_tit" value="<%= oTit.getcodAgrupCob() %>">
                <input type="hidden" name="prop_mca_hijos" id="prop_mca_hijos" value="">
                <input type="hidden" name="prop_numero" id="prop_numero" value="<%=numPropuesta%>">
                <TR>
                    <TD>
                        <TABLE border='0' align="center" width='95%'>
                            <TR>
                                <TD  valign="middle" align="center" class='titulo' colspan="2" height="25">Alta de n&oacute;mina de <%= oProp.getDescRama() %>&nbsp;-&nbsp;<%= oProp.getDescSubRama() %></TD>
                            </TR>
                            <TR>
                                <TD align="left" class='subtitulo' valign="middle" height="25">Propuesta Nº:&nbsp;<%=numPropuesta%></TD>
                                <TD valign="middle" align="right" class='subtitulo'>Grupo:&nbsp;<%= iGrupo %></TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD class='subtitulo' align="left" valign="middle" height="30">Titular:</TD>
                <TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody"
                                style='margin-left:10;'>
                            <thead>
                                <th >Apellido y nombre</th>
                                <th nowrap>Documento</th>
                                <th >Fecha Nac.</th>
                                <th width="60">Premio<br>Anual</th>
                                <th width="240px" nowrap>Suma Muerte</th>
                            </thead>
                            <TD><input id='tit_nom_ApeNom' name='tit_nom_ApeNom' type='TEXT' value="<%=(oTit.getNombre() == null ? "" : oTit.getNombre())%>"
                                       style="WIDTH: 200px;">
                            </TD>
                            <TD nowrap><SELECT id='tit_nom_tipDoc' name='tit_nom_tipDoc' style="WIDTH:50px"  class="select">
                                    <OPTION value="96" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("96") ? "selected" : "")%>>DNI</OPTION>
                                    <OPTION value="80" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("80") ? "selected" : "")%>>CUIL</OPTION>
                                    <OPTION value="90" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("90") ? "selected" : "")%>>LC</OPTION>
                                    <OPTION value="94" <%=(oTit.getTipoDoc() != null && oTit.getTipoDoc().equals("94") ? "selected" : "")%>>PAS</OPTION>
                                </SELECT>	
                                    &nbsp;
                                    <input type='TEXT' id="tit_nom_numDoc" name="tit_nom_numDoc" value="<%= (oTit.getNumDoc() == null ? "" : oTit.getNumDoc())%>"
                                       size='11' maxlength='11'  onkeypress="return Mascara('D',event);"
                                        class="inputTextNumeric" onchange="ControlarDNI (document.formNom.tit_nom_tipDoc, this);">
                            </TD>
                            <TD><input type="text" id="tit_nom_fechaNac" name="tit_nom_fechaNac" style="WIDTH:70px;" value="<%= oTit.getFechaNac() == null ? "":Fecha.showFechaForm(oTit.getFechaNac()) %>"
                                        size="8"  maxlength='10' onblur="ControlarFechaEdad (this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                        onkeypress="return Mascara('F',event);">
                            </TD>
                            <TD><input type='TEXT' id="tit_premio_anual" name="tit_premio_anual" size='8' class="inputTextNumeric" readonly value="<%= Dbl.DbltoStr(oTit.getimpPremio(),2) %>"></TD>
                            <TD>
                                <iframe  name="oFrameTit" id="oFrameTit" width="240" height="22"  marginheight="0"
                                         marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"
src="<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp?cod_agrup_cob=<%= oTit.getcodAgrupCob() %>&cod_cob_opcion=<%= oTit.getcodCobOpcion() %>&cod_rama=<%=oProp.getCodRama()%>&cod_sub_rama=<%=oProp.getCodSubRama()%>&cod_producto=<%=oProp.getcodProducto()%>&cod_prod=<%= oProp.getCodProd()%>&parentesco=TI">
                                </iframe>
                            </TD>
                        </TABLE>
                    </TD>
                </TR>           
                <TR>
                    <TD class='subtitulo' align="left" valign="middle" height="30">Conyuge: (si no tiene conyuge deje el campo "Apellido y nombre" en blanco)</TD>
                <TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody"
                                style='margin-left:10;'>
                            <TD><input type="hidden" id='cony_nom_orden' name='cony_nom_orden' value='<%=(oCony.getSubCertificado() == 0 ? 1 :oCony.getSubCertificado()) %>' >
                                <input id='cony_nom_ApeNom' name='cony_nom_ApeNom' type='TEXT' value="<%=(oCony.getNombre() == null ? "" : oCony.getNombre())%>"
                                       style="WIDTH: 200px;">
                            </TD>
                            <TD nowrap><SELECT id='cony_nom_tipDoc' name='cony_nom_tipDoc' style="WIDTH:50px"  class="select">
                                    <OPTION value="96" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("96") ? "selected" : "")%>>DNI</OPTION>
                                    <OPTION value="80" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("80") ? "selected" : "")%>>CUIL</OPTION>
                                    <OPTION value="90" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("90") ? "selected" : "")%>>LC</OPTION>
                                    <OPTION value="94" <%=(oCony.getTipoDoc() != null && oCony.getTipoDoc().equals("94") ? "selected" : "")%>>PAS</OPTION>
                                </SELECT>&nbsp;
                                <input type='TEXT' id="cony_nom_numDoc" name="cony_nom_numDoc"  value="<%= (oCony.getNumDoc() == null ? "" : oCony.getNumDoc())%>"
                                       size='11' maxlength='11'  onkeypress="return Mascara('D',event);"
                                        class="inputTextNumeric" onchange="ControlarDNI (document.formNom.cony_nom_tipDoc, this);">
                            </TD>
                            <TD><input type="text" id="cony_nom_fechaNac" name="cony_nom_fechaNac" style="WIDTH:70px;" value="<%= oCony.getFechaNac() == null ? "":Fecha.showFechaForm(oCony.getFechaNac()) %>"
                                        size="8"  maxlength='10' onblur="ControlarFechaEdad (this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                        onkeypress="return Mascara('F',event);">
                            </TD>
                            <TD  width="60"><input type='TEXT' id="cony_premio_anual" name="cony_premio_anual" size='8' class="inputTextNumeric"
                                       readonly value="<%= Dbl.DbltoStr(oCony.getimpPremio(),2) %>"></TD>
                            <td>
                                <iframe  name="oFrameCon" id="oFrameCon" width="160" height="22"  marginheight="0"
                                         marginwidth="0" marginheight="0" align="top"  frameborder="0"  scrolling="no"
src="<%= Param.getAplicacion()%>propuesta/rs/formCoberturasOpcion.jsp?cod_agrup_cob=<%= oCony.getcodAgrupCob() %>&cod_cob_opcion=<%= oCony.getcodCobOpcion() %>&cod_rama=<%=oProp.getCodRama()%>&cod_sub_rama=<%=oProp.getCodSubRama()%>&cod_producto=<%=oProp.getcodProducto()%>&cod_prod=<%= oProp.getCodProd()%>&parentesco=CO">
                                </iframe>
                            </td>
                            <TD><input type='BUTTON' value='Eliminar' class="boton" onClick="delPersona( 2, <%=oCony.getSubCertificado() %>);"></TD>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD class='subtitulo' align="left" valign="middle" height="30">Hijos: (por cada hijo que desea incorporar haga clic en el botón "Agregar hijo")</TD>
                <TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody"
                                style='margin-left:10;'>
<%
        if (lHijos.size() > 0 ) {
                      int orden = 0;
                        for( int i=0; i < lHijos.size(); ++i) {
                            AseguradoPropuesta oAseg = (AseguradoPropuesta)lHijos.get(i);
                            orden              = oAseg.getSubCertificado();
                            String tipoDoc     = oAseg.getTipoDoc();
                            String descTipoDoc = oAseg.getDescTipoDoc();
                            String numDoc      = oAseg.getNumDoc();
                            String nombre      = oAseg.getNombre();
                            String fechaNac    = (oAseg.getFechaNac() == null ? "no info" : Fecha.showFechaForm(oAseg.getFechaNac()));

%>
                            <TR>                                  
                                <input type="hidden" id="hijo_nom_orden_<%=orden%>" name="hijo_nom_orden_<%=orden%>" value="<%=orden%>">
                                <TD align='left'>&nbsp;<%=nombre%></TD>
                                <TD align='center' nowrap>&nbsp;<%=descTipoDoc%>&nbsp;<%=numDoc%>&nbsp;</TD>
                                <TD align='right'><%=fechaNac%>&nbsp;</TD>
                                <TD  width="60"><input type='TEXT' id="hijo_premio_anual" name="hijo_premio_anual" size='8' class="inputTextNumeric" readonly value="<%= Dbl.DbltoStr(oAseg.getimpPremio(),2) %>"></TD>
                                <TD><input type='BUTTON' value='Eliminar' class="boton" onClick="delPersona(3, <%=orden%>);"></TD>
                            </TR>
<%
                        }
          }
%>
                            <tr>
                                <TD><input id='hijo_nom_ApeNom' name='hijo_nom_ApeNom' type='TEXT' value="" style="WIDTH: 200px;">
                                </TD>
                                <TD nowrap><SELECT id='hijo_nom_tipDoc' name='hijo_nom_tipDoc' style="WIDTH:50px" class="select">
                                        <OPTION value="96">DNI</OPTION>
                                        <OPTION value="80">CUIL</OPTION>
                                        <OPTION value="90">LC</OPTION>
                                        <OPTION value="94">PAS</OPTION>
                                    </SELECT>&nbsp;
                                    <input type='TEXT' id="hijo_nom_numDoc" name="hijo_nom_numDoc"
                                           size='11' maxlength='11'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI (document.formNom.hijo_nom_tipDoc, this);">
                                </TD>
                                <TD><input type="text" id="hijo_nom_fechaNac" name="hijo_nom_fechaNac" style="WIDTH:70px;"
                                            size="8"  maxlength='10' onblur="ControlarFechaEdad (this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                            onkeypress="return Mascara('F',event);">
                                </TD>
                                <TD  width="60">&nbsp;</TD>
                                <TD><input type='BUTTON'  name="cmdHijo"  value='  Agregar  hijo  ' class="boton" onClick="addPersona ( 3 );"></TD>
                            </tr>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD class='subtitulo' align="left" valign="middle" height="30">Adherentes:(por cada adherente que desea incorporar haga clic en el botón "Agregar adherente")</TD>
                <TR>
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="2" cellpadding="2" align="left" class="TablasBody"
                                style='margin-left:10;'>
<%        if ( lAdher.size() > 0 ) {
                 int orden2 = 0;
                    for( int i=0; i < lAdher.size(); ++i) {
                        AseguradoPropuesta oAseg = (AseguradoPropuesta)lAdher.get(i);
                        orden2       = oAseg.getSubCertificado();
                        String tipoDoc     = oAseg.getTipoDoc();
                        String descTipoDoc = oAseg.getDescTipoDoc();
                        String numDoc      = oAseg.getNumDoc();
                        String nombre      = oAseg.getNombre();
                        String fechaNac    = (oAseg.getFechaNac() == null ? "no info" : Fecha.showFechaForm(oAseg.getFechaNac()));
%>
                            <TR>
                                <input type="hidden" id='adher_nom_orden_<%=orden2%>' name='adher_nom_orden_<%=orden2%>' value='<%=orden2%>' >
                                <TD align='left'>&nbsp;<%=nombre%></TD>
                                <TD align='center' nowrap>&nbsp;<%=descTipoDoc%>&nbsp;<%=numDoc%>&nbsp;</TD>
                                <TD align='right'><%=fechaNac%>&nbsp;</TD>
                                <TD  width="60"><input type='TEXT' id="adher_premio_anual" name="adher_premio_anual" size='8' class="inputTextNumeric"
                                           readonly value="<%= Dbl.DbltoStr(oAseg.getimpPremio(),2) %>"></TD>
                                <TD><input type='BUTTON' value='Eliminar' class="boton" onClick="delPersona (4, <%=orden2%>);"></TD>
                            </TR>
<%                  }
                 }
%>
                            <tr>
                                <TD><input id='adher_nom_ApeNom' name='adher_nom_ApeNom' type='TEXT' value="" style="WIDTH: 200px;">
                                </TD>
                                <TD nowrap><SELECT id='adher_nom_tipDoc' name='adher_nom_tipDoc' style="WIDTH:50px" class="select">
                                        <OPTION value="96">DNI</OPTION>
                                        <OPTION value="80">CUIL</OPTION>
                                        <OPTION value="90">LC</OPTION>
                                        <OPTION value="94">PAS</OPTION>
                                    </SELECT>&nbsp;
                                    <input type='TEXT' id="adher_nom_numDoc" name="adher_nom_numDoc"
                                           size='12' maxlength='11'  onkeypress="return Mascara('D',event);"
                                            class="inputTextNumeric" onchange="ControlarDNI (document.formNom.adher_nom_tipDoc, this);">
                                </TD>
                                <TD><input type="text" id="adher_nom_fechaNac" name="adher_nom_fechaNac" style="WIDTH:70px;"
                                            size="8"  maxlength='10' onblur="ControlarFechaEdad (this, validaFecha(this), '<%= (oProp.getFechaIniVigPol() == null ? "" :  Fecha.showFechaForm(oProp.getFechaIniVigPol()))%>');"
                                            onkeypress="return Mascara('F',event);">
                                </TD>
                                <TD width="60">&nbsp;</TD>
                                <TD><input type='BUTTON' value='Agregar Adherente' class="boton" onClick="addPersona(4);"></TD>
                            </tr>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD class='subtitulo' align="left" valign="middle" height="20">Total Premio anual del grupo:</TD>
                <TR>
                <tr>
                    <td>
                        <table border="0" align="left" cellpadding="3" cellspacing="3">
                            <tr>
                                <td class="text" align="left" width="140">Titular:</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80"><%= Dbl.DbltoStr(oTit.getimpPremio(),2) %></td>
                            </tr>
                            <tr>
                                <td class="text" align="left">Conyuge</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80"><%= Dbl.DbltoStr(oCony.getimpPremio(),2) %></td>
                            </tr>
                            <tr>
                                <td class="text" align="left">Hijos:</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80"><%= Dbl.DbltoStr(totalHijos,2) %></td>
                            </tr>
                            <tr>
                                <td class="text" align="left">Adherentes:</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80"><%= Dbl.DbltoStr( totalAdher ,2) %></td>
                            </tr>
                            <tr>
                                <td class="subtitulo" align="right">TOTAL PREMIO ANUAL</td>
                                <td class="subtitulo" align="left" width="10">$</td>
                                <td class="subtitulo" align="right" width="80"><%= Dbl.DbltoStr(totalGrupo,2) %></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <input type="hidden" id='prop_cantNom' name='prop_cantNom' value="<%=cantNomina%>"  >
                <TR valign="bottom" >
                    <TD width="100%" align="center">
                        <input type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdGrabar"  value="Grabar y calcular Premio"  height="20px" class="boton" onClick="Enviar('grabarVC');">
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" name="cmdEnviar"  value="Enviar Propuesta"    height="20px" class="boton" onClick="Enviar('enviarVC');">
                    </TD>
                </TR>
               </FORM>
            </TABLE>
        </td>
    </tr>
    <TR>
        <TD width='100%'>
            <jsp:include flush="true" page="/bottom.jsp"/>
        </TD>
    </TR>
</TABLE>
<script>
//document.getElementById('prop_mca_hijos').value = oFrameTit.document.getElementById ('mca_hijos_' +
//                                                  oFrameTit.document.getElementById ('cod_cob').value).value;
CloseEspere();
</script>
</body>
</html>
