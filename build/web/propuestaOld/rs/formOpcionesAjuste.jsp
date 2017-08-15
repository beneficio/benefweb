<%@page contentType="text/html" errorPage="/error.jsp"%>
<%@include file="/include/no-cache.jsp"%>    
<%@page import="com.business.util.*"%>
<%@page import="com.business.beans.ConsultaMaestros"%>
<%@page import="com.business.beans.Tablas"%>
<%@page import="com.business.beans.HtmlBuilder"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.beans.OpcionAjuste"%>
<%@page import="java.util.LinkedList"%>

<%  
    Usuario usu = (Usuario) session.getAttribute("user");     
    HtmlBuilder ohtml = new HtmlBuilder();

   int codRama      = (request.getParameter("cod_rama")     == null ? -1 : Integer.parseInt (request.getParameter("cod_rama"))); 
   int codSubRama   = (request.getParameter("cod_sub_rama") == null ? -1 : Integer.parseInt (request.getParameter("cod_sub_rama"))); 
   int codOpcion    = (request.getParameter("cod_opcion")   == null ? -1 : Integer.parseInt (request.getParameter("cod_opcion"))); 
   int codProd      = (request.getParameter("cod_prod")     == null ? 0  : Integer.parseInt (request.getParameter("cod_prod"))); 
   String origen    = (request.getParameter("origen")       == null ? "PROD" : request.getParameter("origen") ); 
   
   LinkedList  lTabla   = new LinkedList ();
   LinkedList lOpciones = new LinkedList (); 
   Tablas      oTabla   = new Tablas ();

%>
<head>
<LINK rel="stylesheet" type="text/css" href="<%= Param.getAplicacion()%>css/main.css">
<script type="text/javascript" language="JavaScript" src="<%= Param.getAplicacion()%>script/formatos.js"></script>
<script language="javascript">
    function DoChangeOpciones () {
        opcion     = document.formOpcion.cod_opcion.options[ document.formOpcion.cod_opcion.selectedIndex ].value; 
        document.getElementById ('cod_ambito').value = document.getElementById ('hidden_amb' + opcion ).value;

        window.parent.DoChangeOpciones ();
    }
</script>
</head>
<body >
<FORM name="formOpcion" id="formOpcion"  method="POST">
    <INPUT type="hidden" name="cod_ambito" id="cod_ambito" value='0'> 
    <SELECT name="cod_opcion" id="cod_opcion" style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size:11px;font-weight:normal;text-decoration: none; width:350px; height:28px;"
    ONCHANGE="javascript:DoChangeOpciones();" onkeydown="javascript:DoChangeOpciones();" onkeyup="javascript:DoChangeOpciones();">

<% 
   try {
        String sMens = ""; 
        lOpciones = oTabla.getOpcionesAjuste (codRama, codSubRama, codProd, origen);
        if (lOpciones.size () == 0) {
            if (codProd == 0 && origen.equals ("PROD"))  {
                sMens = "Debe seleccionar un productor";
            } else if (codSubRama == -1) {
                        sMens = "Debe seleccionar una subrama";
                    } else if (codOpcion == -1) {
                                sMens = "Lista de opcionales"; 
                            } else { sMens = "No existen opcionales"; }
%>
              <option value="-1"><%= sMens %></option>
<%      } else {
  %>
              <option value="-1">Opciones especiales de la subrama</option>
<%           for (int i =0; i < lOpciones.size (); i++) {
                OpcionAjuste oOpcion = (OpcionAjuste) lOpciones.get(i);
     %>
              <option value="<%= oOpcion.getcodOpcion()%>" <%= (oOpcion.getcodOpcion () == codOpcion ? "selected" : " ")%> ><%= oOpcion.getdescripcion()%></option>
<%
            }
        }        
    } catch (Exception e) { 
        response.sendRedirect("/error.jsp");
    }
%>
     </SELECT>
            <input type="hidden" name="hidden_amb-1" id="hidden_amb-1" value="-1">  
<%
             for (int ii =0; ii < lOpciones.size (); ii++) {
                OpcionAjuste oOpcion = (OpcionAjuste) lOpciones.get(ii);
     %>
            <input type="hidden" name="hidden_amb<%= oOpcion.getcodOpcion()%>" id="hidden_amb<%= oOpcion.getcodOpcion()%>" value="<%= oOpcion.getcodAmbito()%>">  

<%
            }
%>

</FORM>
</body>