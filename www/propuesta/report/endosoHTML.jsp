<%@page errorPage="/error.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.Endoso"%>
<%@page import="com.business.beans.AseguradoPropuesta "%>
<%@page import="com.business.beans.UbicacionRiesgo"%>
<%@page import="com.business.beans.Clausula"%>
<%@page import="java.util.*"%>
<%@page import="java.util.LinkedList"%>
<%  

    Usuario usu = (Usuario) session.getAttribute("user"); 
    Endoso oProp  = (Endoso) request.getAttribute ("propuesta");
    LinkedList lNomina  = (LinkedList) request.getAttribute("nominas");

    UbicacionRiesgo oUbic = oProp.getoUbicacionRiesgo();
    LinkedList <Clausula> lClau = oProp.getAllClausulas();
    
    int    nroProp      = 0;
    String nroPropDesc  = "SIN ASIGNAR";
    int    codProd      = 0;
    String descProd     = "";
    int    codVig       = 0 ;
    int    codActividad = 0 ;

    String nomApe       = ""; 
    String domicilio    = "";
    String localidad    = "";
    String codigoPostal = "";    
    String documento    = ""; 
    String telefono     = "";
    String mail         = "";
    String tipoDoc      = "" ;
     
    double capMuerte    = 0.0;
    double capAsist     = 0.0; 
    double capInvalidez = 0.0; 
    double franquicia   = 0.0;
    double premio       = 0.0;
    double prima        = 0.0;

    String observacion   ="";
    int    formaPago     =0; 

    String titularTarj      = "";
    String titularCta       = "";
    String fechaVtoTarjCred = "";
    String nroTarjCred      = "";
    String sucursal         = "";
    String CBU              = "";
    int    codTarjeta       = 0;
    int    codBcoTarj       = 0;
    int    codBcoCta        = 0;    

    int    nroCot       = 0; 
    int    cantCuotas   = 0 ;
    int    numSocio     = 0; // num Tomador
    int    codEstado    = 0;

    String fechaVigDesde = (oProp.getFechaIniVigPol() == null ? "no informado" : Fecha.showFechaForm(oProp.getFechaIniVigPol()));
    String fechaVigHasta = (oProp.getFechaFinVigPol() == null ? "no informado" :
                            ( Fecha.showFechaForm(oProp.getFechaFinVigPol()).equals("01/01/1900") ? " no informado" : Fecha.showFechaForm(oProp.getFechaFinVigPol())));

    if (oProp != null) {
        if (oProp.getNumPropuesta()>0) {
            nroPropDesc = String.valueOf(oProp.getNumPropuesta());
            nroProp     = oProp.getNumPropuesta();
        }
    }

   // out.println(" rama" + oProp.getCodRama());

    codProd      = oProp.getCodProd();
    descProd     = oProp.getdescProd();
    codVig       = oProp.getCodVigencia ();
    codActividad = oProp.getCodActividad();
    
    telefono     = (oProp.getTomadorTE ()==null)?"":oProp.getTomadorTE ();
    mail         = (oProp.getTomadorEmail()==null)?"":oProp.getTomadorEmail();
    
    numSocio     = oProp.getNumTomador();
    nomApe       = oProp.getTomadorRazon();
    documento    = oProp.getTomadorNumDoc();
    tipoDoc      = oProp.getTomadorDescTipoDoc();
    domicilio    = (oProp.getTomadorDom()==null)?"":oProp.getTomadorDom();
    localidad    = (oProp.getTomadorLoc()==null)?"":oProp.getTomadorLoc();
    codigoPostal = (oProp.getTomadorCP()==null)?"":oProp.getTomadorCP();    
    nroCot       = oProp.getNumSecuCot    ();
    cantCuotas   = oProp.getCantCuotas    ();
    codEstado    = oProp.getCodEstado();
    
   
    
    // out.println("  nroCot     " + nroCot);
    // out.println("  cantCuotas " + cantCuotas);
    // out.println("  numSocio   " + numSocio);
    // out.println("  nroProp    " + nroProp);
    //out.println("  codEstado    " + codEstado);
    
    String disabled; 
    if (codEstado == 0 ) {
        disabled = "";
    } else if(codEstado==4){  
        disabled = "";
    } else {
        disabled = "disabled";
    }

    capMuerte    = oProp.getCapitalMuerte();
    capAsist     = oProp.getCapitalAsistencia ();
    capInvalidez = oProp.getCapitalInvalidez  ();
    franquicia   = oProp.getFranquicia        ();
    premio       = oProp.getImpPremio         ();
    prima        = oProp.getsubTotal          ();

    observacion   = oProp.getObservaciones(); 
    formaPago     = oProp.getCodFormaPago();

    if ( formaPago == 1 ) {
        
        if (oProp.getVencTarjCred() != null) {
            fechaVtoTarjCred = Fecha.showFechaForm(oProp.getVencTarjCred());
        }
        nroTarjCred      = oProp.getNumTarjCred();
        titularTarj      = oProp.getTitular();
        codTarjeta       = oProp.getCodTarjCred();
        codBcoTarj       = oProp.getCodBanco();
    }
    if ( formaPago == 2 || formaPago == 3 ) {
        CBU        = oProp.getCbu();
        sucursal   = oProp.getSucBanco();
        titularCta = oProp.getTitular();
        codBcoCta  = oProp.getCodBanco();
    }

    if ( formaPago == 4  ) {
        CBU        = oProp.getCbu();
    }

%>
<HTML> 
<head><title>ImpresiÃ³n de propuesta</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<SCRIPT type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>

<SCRIPT type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>

    function Trim(TRIM_VALUE){
        if(TRIM_VALUE.length < 1){
          return"";
        }
        TRIM_VALUE = RTrim(TRIM_VALUE);
        TRIM_VALUE = LTrim(TRIM_VALUE);
        if(TRIM_VALUE==""){
            return "";
        }
        else{
           return TRIM_VALUE;
        }
    } //End Function

    function RTrim(VALUE){
        var w_space = String.fromCharCode(32);
        var v_length = VALUE.length;
        var strTemp = "";
        if(v_length < 0){
        return"";
        }
        var iTemp = v_length -1;

        while(iTemp > -1){
        if(VALUE.charAt(iTemp) == w_space){
        }
        else{
        strTemp = VALUE.substring(0,iTemp +1);
        break;
        }
        iTemp = iTemp-1;

        } //End While
        return strTemp;

    } //End Function

    function LTrim(VALUE){
        var w_space = String.fromCharCode(32);
        if(v_length < 1){
        return"";
        }
        var v_length = VALUE.length;
        var strTemp = "";

        var iTemp = 0;

        while(iTemp < v_length){
        if(VALUE.charAt(iTemp) == w_space){
        }
        else{
        strTemp = VALUE.substring(iTemp,v_length);
        break;
        }
        iTemp = iTemp + 1;
        } //End While
        return strTemp;
    } //End Function



    function Salir () {
           window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }


    function HabilitarDiv(divName) {
          
        // for(i=1; i<=2; i++) 
        for(i=1; i<=3; i++) 
            document.getElementById('div_' + i).style.visibility = 'hidden';
	  
        if (divName ==1 ) {
            document.getElementById('div_1').style.visibility = 'visible';
        }
 
        if ((divName ==2) || (divName ==3)) {
            document.getElementById('div_2').style.visibility = 'visible';
        }

        if (divName ==4 ) {
            document.getElementById('div_3').style.visibility = 'visible';
        }


    }

</script>
<body leftmargin=0 topmargin=0 style="margin-top: 0; margin-right: 0; margin-left: 0; margin-bottom: 0; padding-bottom: 0; padding-left: 0; padding-right: 0; padding-top: 0; top: 0; vertical-align: top;">
    <TABLE align="center" width='95%' border='1' cellpadding='0' cellspacing='6' >
        <TR>
            <td width='100%' height='60'>
                <table border='0' cellpadding='2' cellspacing='0' width='100%'>
                    <tr>
                        <td width='10%' valign="top" align="right"><img src="<%= Param.getAplicacion()%>images/logos/logo_beneficio_new.jpg" border='0'></td>
                        <td width='90%' valign="top" align="center" class="titulo">PROPUESTA DE ENDOSO</td>
                    </tr>
                </table>
            </td>
        </tr>
<%      if (codProd == 1 || codProd == 2 || codProd == 3 || codProd == 31038) {
    %>
        <tr>
            <td height="40" valign="middle" align="left" class="titulo" style="color:red;">PROPUESTA NO VALIDA - ESTO ES UNA DEMOSTRACION</STRONG></td>
        </tr>
<%      }
    %>
        <TR>
            <TD align="center" valign="top" width='100%'>
                 <TABLE border='0' width='100%'> 
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>               
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos Generales</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <td align="left" class="text" width="140"  >Propuesta NÂº:</td>
                                    <TD align="left" class='text'><b><%=oProp.getBoca() %>&nbsp;-&nbsp;<%=nroPropDesc%></b></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Tipo de endoso:</TD>
                                    <TD align="left" class='text'><b><%= (oProp.getdescTipoEndoso() == null ? "Actualizacion de Nomina": oProp.getdescTipoEndoso()) %></b></TD>
                                </TR>
                                <TR> 
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >Rama:&nbsp;</TD>
                                    <TD align="left"  class="text"><b><%= oProp.getDescRama() %></b></td>
                                </TR>
                                <TR> 
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left"  class="text" valign="top" >P&oacute;liza:&nbsp;</TD>
                                    <TD align="left"  class="text"><b><%= Formatos.showNumPoliza(oProp.getNumPoliza()) %></b></td>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Productor:</TD>
                                    <TD align="left" class='text'><%=descProd%>&nbsp;Cod&nbsp;:&nbsp;<%=codProd%></TD>
                                </TR>                          
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Fecha de env&iacute;o:</TD>
                                    <TD align="left" class='text'><%= (oProp.getFechaEnvioProd () == null ? "no enviado" : Fecha.showFechaForm(oProp.getFechaEnvioProd ())) %>&nbsp;,&nbsp;<%= oProp.getHoraEnvioProd () %>&nbsp;hs.</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Vigencia del endoso:</TD>
                                    <TD align="left" class='text'><%= fechaVigDesde %>&nbsp;al&nbsp;<%= fechaVigHasta %></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>         
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Datos del Tomador</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='140' nowrap>Nombre y Apellido:</TD>
                                    <TD align="left" class='text'><%=nomApe%></TD>
                                </TR>
                                <TR> 
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'><%= tipoDoc %>:</TD>
                                    <TD align="left" class='text'><%=documento%></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Condici&oacute;n&nbsp;IVA:</TD>
                                    <TD align="left" class='text'><%= oProp.getTomadorDescCondIva() %></TD>                   
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Tel&eacute;fono:</TD>
                                    <TD align="left" class='text'><%= (oProp.getTomadorTE() == null ? "" : oProp.getTomadorTE()) %></TD>                   
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Domicilio:</TD>
                                    <TD align="left" class='text'><%=domicilio%></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Localidad:</TD>
                                    <TD align="left" class='text'><%=localidad%></TD>
                                </TR>
                                <TR>                   
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                    <TD align="left" class='text'><%=codigoPostal%></TD>
                                </TR>   
                                <TR> 
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Provincia:</TD>
                                    <TD align="left" class='text'><%= oProp.getTomadorDescProv () %></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
<%      if (oUbic != null ) {
    %>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Ubicaci&oacute;n de Riesgo </TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='140' nowrap>Domicilio:</TD>
                                    <TD align="left" class='text'><%= oUbic.getdomicilio() %></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Localidad:</TD>
                                    <TD align="left" class='text'><%= oUbic.getlocalidad() %></TD>
                                </TR>
                                <TR>                   
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>C&oacute;digo&nbsp;Postal:</TD>
                                    <TD align="left" class='text'><%= oUbic.getcodPostal() %></TD>
                                </TR>   
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Provincia:</TD>
                                    <TD align="left" class='text'><%= oUbic.getdescProvincia() %></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
<%      }
        if (oProp.gettipoEndoso() == 1304)  { // actualizacion de comisiones
    %>
                    <TR>
                        <TD>
                            <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Condiciones comerciales</TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='140' nowrap>Porc. comisi&oacute;n Productor:</TD>
                                    <TD align="left" class='text'><%= oProp.getporcGDA() %></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text' width='140' nowrap>Porc. comisi&oacute;n Organizador:</TD>
                                    <TD align="left" class='text'><%= oProp.getporcComisionOrg()%></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Subsecci&oacute;n:</TD>
                                    <TD align="left" class='text'><%= oProp.getsubSeccion() %></TD>
                                </TR>
                                <TR>
                                    <td width='10'>&nbsp;</td>
                                    <TD align="left" class='text'>Base de C&aacute;lculo:</TD>
                                    <TD align="left" class='text'><%= (oProp.getbaseCalculoComisiones().equals("O") ? "PREMIO" : "PRIMA") %></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
<%
        }

        if (observacion != null &&  ! observacion.equals ("") ) {
    %>
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD align="left" class='text'>Observaci&oacute;n :</TD>                                
                            </TR>
                            <TR>                           
                                <TD width="100%" class='text'><B><%=observacion%></B></TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
<%      }
    %>
<% if ( lClau != null && lClau.size() > 0  )  { %>    
                <tr>
                    <td>
                        <TABLE border='0' align='left' class="fondoForm" style='margin-top:10;margin-bottom:10;' width='100%'>                                       
                                <TR>
                                    <TD  colspan='3' height="30px" valign="middle" align="left" class='titulo'>Cl&aacute;usulas de No Repetici&oacute;n/Subrogaci&oacute;n</TD>
                                </TR>
                                <TR>
                                    <td width='15'>&nbsp;</td>
                                    <TD align="left" class='text' valign="top" width='150' nowrap>Cl&aacute;usulas:</TD>                                
                                    <TD align="left" class='text' >
                                        <input type="CHECKBOX" value='<%= oProp.getclaNoRepeticion () %>'  <%= (oProp.getclaNoRepeticion ().equals ("S") ? "checked" : " ") %> readonly>&nbsp;Cl&aacute;usula de No Repetici&oacute;n<br>
                                        <input type="CHECKBOX" value='<%= oProp.getclaSubrogacion () %>'  <%= (oProp.getclaSubrogacion ().equals ("S") ? "checked" : " ") %> readonly>&nbsp;Cl&aacute;usula de Subrogaci&oacute;n
                                    </TD>                                
                                </TR>
                                <TR>
                                    <td >&nbsp;</td>
                                    <TD align="left" class='text' valign="top"nowrap>Lista de Empresas:</TD>                                
                                    <TD class='text'  align="left">&nbsp;&nbsp;&nbsp;&nbsp;Cuit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Empresa</TD>                                
                                </TR>                            
<% 
                        for (int i = 1;i <= oProp.getAllClausulas().size() ;i++) {
                            Clausula oCla = (Clausula) oProp.getAllClausulas().get(i - 1);
                            
    %>
                                <TR>
                                    <TD colspan="2">&nbsp;</TD>
                                    <TD align="left" class='text' >
                                        <input type="text" value="<%= oCla.getcuitEmpresa() %>" size='12' maxlength='12'  class="inputTextNumeric" readonly>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="text" value="<%= oCla.getdescEmpresa() %>" size='50' maxlength='50' readonly>
                                     </TD>                                
                                </TR>
<%                      }
     %>
     
                           </TABLE>
                        </TD>
                    </TR>             
     
<%                    }
        if (lNomina != null && lNomina.size () > 0) { 
%>                
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='100%'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD height="30px" valign="middle" align="left" class='titulo'>N&oacute;mina</TD>
                            </TR>
                            <TR>
                                <td width='100%'>
                                    <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" style='margin-top:10;margin-bottom:10;margin-left:10;margin-right:10;'>
                                        <thead>
                                            <th nowrap width="200px">Nombre y Apellido</th>
                                            <th nowrap width="100px">Documento</th>
                                            <th width="80px">Fecha Nac.</TH>
                                            <th width="40px">&nbsp;</TH>
                                        </thead>
                    <%
                                    for( int i=0; i < lNomina.size(); ++i) {
                                        AseguradoPropuesta oAseg = (AseguradoPropuesta)lNomina.get(i);
                    %>
                                        <TR>                                  
                                            <TD align='left'>&nbsp;<%= oAseg.getNombre() %></TD>
                                            <TD align='left'><%= oAseg.getDescTipoDoc() %>&nbsp;<%= oAseg.getNumDoc()%>&nbsp;</TD>
                                            <TD align='center'><%= (oAseg.getFechaNac() == null ? "no informado" : Fecha.showFechaForm(oAseg.getFechaNac())) %>&nbsp;</TD>
                                            <TD align='center'><span style="color:<%=(oAseg.getEstado().equals ("A") ? "green" : "red")%>;"><%= (oAseg.getEstado().equals ("A") ? "ALTA" : "BAJA") %>&nbsp;</span></TD>
                                        </TR>
                    <%
                                    }
                    %>
                                    </TABLE>		
                                </TD>
                            </TR>
                        </table>
                    </td>
                </tr>
<%
    } 
%>
                <TR>
                    <TD height="30px" valign="middle" align="left" class='text'>
                        En cumplimiento de lo dispuesto por la Disposici&oacute;n 10/08, Beneficio SA pone en conocimiento que:<br/> 
                        "Art&iacute;culo 1&deg; - El titular de los datos personales tiene la facultad de ejercer el derecho de acceso a los mismos en forma gratuita a intervalos no inferiores a seis meses salvo que se acredite 
                        un inter&eacute;s leg&iacute;timo al efecto conforme lo establecido en el art&iacute;culo 14, inciso 3 de la Ley N&deg; 25.326".
                    </TD>
                </TR>
    
          </TABLE>
</body>
</html>