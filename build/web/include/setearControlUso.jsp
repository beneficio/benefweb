<%
if ( request.getParameter ("procedencia") != null) {
   getServletConfig().getServletContext().getRequestDispatcher("servlet/setAccess?opcion=ADDPROC").include(request,response);
}
%>
