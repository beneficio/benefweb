<%@page contentType="text/html" errorPage="error.jsp"%> 
<%@page import="java.sql.*, java.util.*,com.business.beans.*"%>
<% 
int    iCodRama    = (request.getParameter("cod_rama")     == null ? 0 : Integer.parseInt(request.getParameter("cod_rama"))); 
int    iCodSubRama = (request.getParameter("cod_sub_rama") == null ? 0 : Integer.parseInt(request.getParameter("cod_sub_rama"))); 
String abm         = (request.getParameter("abm")==null)?"CONSULTA":request.getParameter("abm"); 
String disabled = "" ;
//if ( ! abm.equals("ALTA")) {
//    disabled = "disabled" ;
//}
%>
<html>
<head>
<LINK rel="stylesheet" type="text/css" href="/css/estilos.css">
<SCRIPT>
    function changeSubRama() {
        var cod_sub_rama = document.formSubRama.cod_subrama.options[ document.formSubRama.cod_subrama.selectedIndex ].value;        
        window.parent.DoChangeSubRama(cod_sub_rama);
    }
</SCRIPT>
</head>
<body >
<table border='0' cellpadding='0' cellspacing='0'>
    <tr>
        <td>
<FORM name="formSubRama" id="formSubRama" method="POST">
<SELECT name="cod_subrama" id="cod_subrama" <%=disabled%> class="select" ONCHANGE='changeSubRama();' style="width: 500px;">
              <option value="0">Debe seleccionar una sub Rama</option>
<%
   try {
       Tablas oTabla = new Tablas();
       HtmlBuilder ohtml= new HtmlBuilder();
           LinkedList  lTabla = oTabla.getSubRamas(iCodRama);
           out.println(ohtml.armarSelectTAG(lTabla,iCodSubRama));
    } catch (Exception e) { 
        System.out.println("Error en prueba Combos Sub Rama " + e.getMessage());
        response.sendRedirect("/error.jsp");
    }
%>
</SELECT>
</FORM>
        </td>
    </tr>
</table>
</body>
</html>

