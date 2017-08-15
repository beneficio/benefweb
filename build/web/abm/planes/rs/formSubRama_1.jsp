<%@page import="java.sql.*, java.util.*,com.business.beans.*"%>
<% 
int    iCodRama    = (request.getParameter("cod_rama")     == null ? 0 : Integer.parseInt(request.getParameter("cod_rama"))); 
int    iCodSubRama = (request.getParameter("cod_sub_rama") == null ? 0 : Integer.parseInt(request.getParameter("cod_sub_rama"))); 
String abm         = (request.getParameter("abm")==null)?"CONSULTA":request.getParameter("abm"); 

// System.out.println(" \n entro a rs codRama    --> " + iCodRama);
// System.out.println(" entro a rs codSubRama --> " + iCodSubRama);
// System.out.println(" entro a rs abm --> " + abm);

String disabled = "" ;
if (abm.equals("CONSULTA")) {
    disabled = "disabled" ;
}


%>
<SCRIPT>
    function changeSubRama() {
        var cod_sub_rama = document.formSubRama.cod_subrama.options[ document.formSubRama.cod_subrama.selectedIndex ].value;        
        window.parent.DoChangeSubRama(cod_sub_rama);
    }

</SCRIPT>
<html>
<head>
<LINK rel="stylesheet" type="text/css" href="/css/main.css">
</head>
<body>

<FORM name="formSubRama" id="formSubRama"  method="POST">

<SELECT name="cod_subrama" id="cod_subrama"   <%=disabled%>
        style=' font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        font-weight: normal;
	        text-decoration: none;
                width:250;height:18' ONCHANGE='changeSubRama();' >

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

</body>
</html>

