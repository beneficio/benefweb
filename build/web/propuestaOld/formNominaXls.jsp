<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Hashtable"%>
<%@taglib uri="/tld/menu.tld" prefix="menu" %>   
<%  

    Usuario usu = (Usuario) session.getAttribute("user"); 
    HtmlBuilder ohtml = new HtmlBuilder();
    Tablas     oTabla = new Tablas ();
    LinkedList lTabla = new LinkedList ();

    Propuesta oProp  = (Propuesta) request.getAttribute ("propuesta");

    int    codProceso   = oProp.getCodProceso();
    String codBoca      = oProp.getBoca();
    int    numPropuesta = oProp.getNumPropuesta();
    int    cantVidas    = oProp.getCantVidas() ;

    //System.out.println(" codProceso   " + codProceso);
    //System.out.println(" codBoca   " + codBoca);
    //System.out.println(" numPropuesta " + numPropuesta);
    //System.out.println(" cantVidas   " + cantVidas);
    
    int    cantNom   = 0 ;
    int cantNomXls   = 0;
    int cantError = 0;
    LinkedList hFila   = new LinkedList();
    LinkedList nameCol = new LinkedList();
    LinkedList typeCol = new LinkedList();
    LinkedList hFilaError = new LinkedList();

    if (request.getAttribute("hFilaError") != null ) {        
        hFilaError   = (LinkedList)request.getAttribute("hFilaError") ;
        cantError = hFilaError.size();
    }
    if (request.getAttribute("hFila") != null ) {
        hFila   = (LinkedList)request.getAttribute("hFila") ;
        cantNomXls = hFila.size();    
        nameCol = (LinkedList)request.getAttribute("nameCol") ;
        typeCol = (LinkedList)request.getAttribute("typeCol") ;
    }

%>
<HTML> 
<head><title>JSP Page</title></head>
<link rel=stylesheet type="text/css" href="<%=Param.getAplicacion()%>css/estilos.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script type="" language="JavaScript" src="<%= Param.getAplicacion()%>script/popUp.js"></script>
<script language='javascript'>

    function Validar () {        
        var cant = document.formNomXls.nomXls_cantNom.value ;

        // tomo desde 1 porque el 0 es el titulo 

        for (i=1;i<=cant;i++){                           
         
           if (Trim(document.getElementById('nomXls_ApeNom_'+i).value) == "" ) {
               alert (" Debe informar el apellido y el nombre");                              
               return document.getElementById('nomXls_ApeNom_'+i).focus();
           } 

           if (document.getElementById('nomXls_tipDoc_'+i).value == "-1") {
               alert (" Debe informar el tipo de documento");               
               return document.getElementById('nomXls_tipDoc_'+i).focus();
           }

        if (document.getElementById('prop_cod_rama').value == "21" &&
            document.getElementById('nomXls_tipDoc_'+i).value != "80" ) {
               alert ("Tipo de documento inválido, debe informar CUIL");
               return document.getElementById('nomXls_tipDoc_'+i).focus();
            }

        if  ( !ControlarDNI ( document.getElementById('nomXls_tipDoc_'+i),
                              Trim(document.getElementById('nomXls_numDoc_'+i)) ) ) {
            return false;
        }
           if (Trim(document.getElementById('nomXls_numDoc_'+i).value) == "") {
               alert (" Debe informar el numero de documento");               
               return document.getElementById('nomXls_numDoc_'+i).focus();
           }

           if (document.getElementById('nomXls_fechaNac_'+i).value == "") {
               alert (" Debe informar la fecha de nacimiento");               
               return document.getElementById('nomXls_fechaNac_'+i).focus();
           }           

       } 
       return true;  
    } 

    function ControlarDNI ( dniTipo, dniNum ) {

        if ( dniTipo.value == '80') {
            if ( ! ValidoCuit (dniNum.value)) {
                alert (" CUIL inválido !");
                dniNum.focus ();
                return false;
            }
        } else {
            if (dniNum.value.length < 7 ||
                dniNum.value.length > 8) {
                alert ("Documento inválido !");
                document.formNom.prop_nom_numDoc.focus ();
                return false;
            }
        }

        return true;
    }
    function Volver () {

        var cant = document.formNomXls.nomXls_cantNom.value ;
        if  ( cant > 0 ) {
            if (confirm("Desea grabar las nominas antes de salir ?  ")) {
                if ( Validar() ) {                            
                    desbloquea();
                    document.formNomXls.submit(); 
                }
            } else {
                window.history.back();
            }
        } else {
            window.history.back();
        }
        
    }

    function Grabar () {
        if (confirm("Esta usted seguro que desea grabar las nominas ?  ")) {
            //if ( Validar() ) {                            
                desbloquea();
                document.formNomXls.submit(); 
            //}
        } 
    }

    function desbloquea(){
        document.formNomXls.nomXls_propuesta.disabled = false;          
        var cant = document.formNomXls.nomXls_cantNom.value ;
        for (i=1;i<=cant;i++){
            document.getElementById('nomXls_orden_'+i).disabled = false;       
            document.getElementById('nomXls_ApeNom_'+i).disabled = false;    
            document.getElementById('nomXls_tipDoc_'+i).disabled = false;  
            document.getElementById('nomXls_numDoc_'+i).disabled = false;  
            document.getElementById('nomXls_fechaNac_'+i).disabled = false;          
        }                
    }

    function Salir () {
        window.location.replace("<%= Param.getAplicacion()%>index.jsp");
    }

</script>
<body leftMargin="20" topMargin="5" marginheight="0" marginwidth="0">
<menu:renderMenuFromDB  aplicacion="1" userLogon="<%= usu.getusuario()%>" />
<TABLE cellSpacing="0" cellPadding="0" width="720" align="left" border="0">
    <TR>
        <TD valign="top" align="center">
            <jsp:include flush="true" page="/top.jsp"/>
        </TD>
    </TR>     
    
    <TR>
        <TD align="center" valign="top" width='100%'>                    
            <TABLE border='0'>             
                <FORM method="post" action="<%= Param.getAplicacion()%>servlet/PropuestaServlet" name='formNomXls' id='formNomXls'>                
                <INPUT type="hidden" name="opcion"         id="opcion"           value='grabaNominaXls' >                       
                <INPUT type="hidden" name="nomXls_proceso"   id="nomXls_proceso"     value="<%=codProceso%>"  >             
                <INPUT type="hidden" name="nomXls_codBoca"   id="nomXls_codBoca"     value="<%=codBoca%>"  >             
                <INPUT type="hidden" name="prop_cantVidas" id="prop_cantVidas"   value="<%=cantVidas%>"  >
                <INPUT type="hidden" name="prop_cod_rama" id="prop_cod_rama"   value="<%= oProp.getCodRama() %>"  >
                
                <TR>
                    <TD>
                        <TABLE border='0' align='left' class="fondoForm" width='650'style='margin-top:10;margin-bottom:10;'>                                                                   
                            <TR>
                                <TD align="left" class='titulo'>Propuesta Nº:                                
                                    <INPUT type="text" name="nomXls_propuesta" id="nomXls_propuesta"  size="10" maxleng="20" value="<%=numPropuesta%>"  disabled >
                                </TD>
                            </TR>                        
                            <TR>
                                <TD  colspan='4' valign="middle" align="left" class='titulo'>Confirmaci&oacute;n de n&oacute;mina de asegurados.</TD>
                            </TR>
                        </TABLE>		
                    </TD>
                </TR>
<%   
if (cantError==0) {

    int iFilaSize = 0;  

    if ( cantNomXls > 0 ) {
             int iColSize  = nameCol.size();
             iFilaSize = iFilaSize = hFila.size();             
             cantNom = iFilaSize -1 ; // -1 por el titulo que biene del excel 
             System.out.println("\n\n size " + iFilaSize);
%>
                
                <TR>
                    <TD>
                        <TABLE  border="0" cellspacing="0" cellpadding="0" align="center" class="TablasBody" width='650'style='margin-top:10;margin-bottom:10;'>
                            <THEAD>
                                <th width="50px">Orden</TH>
                                <th width="200px">Apellido y Nombre</TH>
                                <th width="150px">Tipo</TH>                                                            
                                <th width="140px">Documento</TH>                                                            
                                <th width="80px">Fecha Nac.</TH>                                                                                                                                           
                            </THEAD>
<%           int iOrden = 0 ;
             String tipDoc = "";
             for ( int i=1 ; i< iFilaSize ; i++ ) {
                 Hashtable has =(Hashtable)hFila.get(i); 
                 iOrden ++ ;                                 
                 tipDoc = ((String)has.get("TIPO")==null)?"":(String)has.get("TIPO") ;
    %>
                            <TR>                                
                                <TD> <INPUT id='nomXls_orden_<%=i%>'  name='nomXls_orden_<%=i%>'  type='TEXT' value='<%=iOrden%>' style="WIDTH: 50px;" disabled></TD>                         
                                <TD> <INPUT id='nomXls_ApeNom_<%=i%>' name='nomXls_ApeNom_<%=i%>' type='TEXT' value='<%=((String)has.get("NOMBRE")==null)?"":(String)has.get("NOMBRE")%> <%=((String)has.get("APELLIDO")==null)?"":(String)has.get("APELLIDO")%>' style="WIDTH: 200px;" disabled></TD>                                                         
                                <%--
                                <TD><%=((String)has.get("TIPO")==null)?"":((String)has.get("TIPO")).trim().toUpperCase()%></TD>
                                --%>
                           <TD>                                    
                                <SELECT id='nomXls_tipDoc_<%=i%>' name='nomXls_tipDoc_<%=i%>' style="WIDTH: 150px"  class="select" disabled>
                                    <option value='-1' >Seleccione documento</option>
                                    <option value='80' <%= (tipDoc.equals("CUIL") ? "selected" : "" )%>>CUIL</option>
<%                              if (oProp.getCodRama() != 21) {
    %>
                                    <option value='96' <%= (tipDoc.equals("DNI") ? "selected" : "" )%>>DNI</option>
<%                              }
    %>
                                </SELECT>	
                            </TD>                                
                                <TD> <INPUT type='TEXT' id='nomXls_numDoc_<%=i%>'   name='nomXls_numDoc_<%=i%>'   style="WIDTH: 140px;" value='<%=((String)has.get("DOCUM")==null)?"":(String)has.get("DOCUM")%>'  size='12' maxlength='12' onkeypress="return Mascara('D',event);" class="inputTextNumeric" disabled></TD>                         
                                <TD> <INPUT type="text" id='nomXls_fechaNac_<%=i%>' name='nomXls_fechaNac_<%=i%>' style="WIDTH: 80px;"  size="8"  maxlength='10' onblur="validaFecha(this);" onkeypress="return Mascara('F',event);" value='<%=((String)has.get("F_NACIM")==null)?"":(String)has.get("F_NACIM")%>' disabled> </TD>
                            </TR>              
<%
            } // while   
%>    
                        </TABLE>
<%
    }

} else { // si cant errores > 0
    %>
                <TR valign="bottom" >
                    <TD width="100%" align="center">
                        <TABLE border='0' align='left' class="" width='650'style='margin-top:10;margin-bottom:10;'>                                       
                            <THEAD>                                
                                <TH align="left"  colspan='2'>Estimado, la nómina que usted a ingresado no puede
                                                  ser procesada porque se detectaron los siguientes
                                                  errores. Por favor , verifique el archivo y vuelva a
                                                  intentarlo. 
                                </TH>                                
                            </THEAD>
                                  
<%
    for ( int i=0 ; i< cantError ; i++ ) {
       // out.println("error" + (String) hFilaError.get(i));
%>
                            <TR>
                                <TD align="center" ><%=i+1%></TD>
                               
                                <TD align="left">&nbsp;-&nbsp;&nbsp;&nbsp;<%=(String) hFilaError.get(i)%> </TD>
                            </TR>


<% } %>

                        </TABLE>		
                    </TD>
<%
}
%>
                    </TD>
                </TR>       


             
                <INPUT type="hidden" id='nomXls_cantNom' name='nomXls_cantNom' value="<%=cantNom%>"  >             
                </FORM> 

                <TR valign="bottom" >
                    <TD width="100%" align="center">
                        <TABLE border='0' align='left' class="" width='650'style='margin-top:10;margin-bottom:10;'>                                       
                            <TR>
                                <TD align="center">
                                    <INPUT type="button" name="cmdVolver"  value="Volver"  height="20px" class="boton" onClick="Volver();">
                                    &nbsp;&nbsp; 
                                    <%--                                               
                                    <INPUT type="button" name="cmdSalir"  value="Salir"  height="20px" class="boton" onClick="Salir ();">
                                    &nbsp;&nbsp;                                                
                                    --%>
                                    <% if (cantNom > 0) { %>
                                    <INPUT type="button" name="cmdGrabar"  value="Confirmar Nominas"  height="20px" class="boton" onClick="Grabar();">        
                                    <% } %>
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

CloseEspere();
</script>
</body>
</html>
