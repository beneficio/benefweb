<%@page contentType="text/html" errorPage="error.jsp"%>
<%@page import="com.business.beans.Usuario"%>
<%@page import="com.business.util.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.sql.*"%>

<% Usuario usu = (Usuario) session.getAttribute("user"); 
   String pathNominas = "/benef/files/nominas/";
   String pathManuales  = "/benef/files/manuales/";

  String path      = (String)request.getParameter("path") ; 
  String sNumProp  = request.getParameter("num_propuesta") ;

  out.println( " <BR> nroPropuesta" + sNumProp);
  out.println( " <BR>  path" + path);
%>
<html>
<head><title>JSP Page</title></head>
<body>

<TABLE border='1'>
    <TR>
        <TD>
            Presione (1)
            <A class="link" target='_blank' href='C:\benefweb\www\files\manuales\nominaBenef.xls'>            
            <B>haga click aqui </B>(PATH ABSOLUTO = C:\benefweb\www\files\manuales\nominaBenef.xls )
            </A>  
        </TD>
    </TR>
    <TR>
        <TD>
            Presione (2)
            <A class="link" target='_blank'  href="http://<%=request.getHeader("host")%>/benef/files/manuales/nominaBenef.xls">
            <B>haga click aqui </B>(PATH RELATIVO ="http://<%=request.getHeader("host")%>/benef/files/manuales/nominaBenef.xls" )
            </A>  
        </TD>    
    </TR>

    <TR>
        <TD>
            <%
              int numPropuesta = 33; 
            %>
            <FORM id='fromPropuesta' METHOD="POST" ACTION="upload.jsp?num_propuesta=<%=numPropuesta%>" ENCTYPE="multipart/form-data">                  
                <TABLE border="0" cellpadding="0" cellspacing="4" width="100%" >                                     
                    <TR>
                        <TD align="right"> Guarar Archivo de Nominas  </TD>                    
                        <TD>                            
                            <INPUT type="FILE"   name= "FILE1"   id="FILE1" SIZE="50">   
                           <INPUT type="submit" name="Enviar" value="Enviar Nominas"> 
                        </TD>                     
                    </TR>

                </TABLE>
            </FORM>
        </TD>
    </TR>


<%

    if (path !=null && !path.equals("") ) {
         
         LinkedList nameCol = new LinkedList();    
         nameCol.add(0,"APELLIDO");
         nameCol.add(1,"NOMBRE");
         nameCol.add(2,"TIPO");
         nameCol.add(3,"DOCUM");
         nameCol.add(4,"F_NACIM");
         int iCantCol = nameCol.size();

         LinkedList typeCol = new LinkedList();    
         typeCol.add(0,"TYPE_STRING");
         typeCol.add(1,"TYPE_STRING");
         typeCol.add(2,"TYPE_STRING");
         typeCol.add(3,"TYPE_NUMERIC");
         typeCol.add(4,"TYPE_DATE");
         
         LinkedList hFila = xls.getInfoByXls(typeCol,nameCol,path,1);
         int iColSize  = nameCol.size();
         /*
         for (int i = 0; i < iColSize ; i++) {
             (String)nameCol.get(i)
         } */

         
         int iFilaSize = hFila.size();
         int iOrden = 0 ;
         %>

<TABLE border='1'>
<%
        for ( int i=1 ; i< iFilaSize ; i++ ) {
            Hashtable has =(Hashtable)hFila.get(i); 
            iOrden ++ ;  
%>
    <TR>
        <TD><%=iOrden%></TD>        
        
        <TD><%=((String)has.get("APELLIDO")==null)?"":(String)has.get("APELLIDO")%> 
            <%=((String)has.get("NOMBRE")==null)?"":(String)has.get("NOMBRE")%> 
        </TD>
        <TD><%=((String)has.get("TIPO")==null)?"":(String)has.get("TIPO")%></TD>
        <TD><%=((String)has.get("DOCUM")==null)?"":(String)has.get("DOCUM")%></TD>
        <TD><%=((String)has.get("F_NACIM")==null)?"":(String)has.get("F_NACIM")%></TD>

    </TR>
<%
        }
%>
        <%--
        <% for (int j = 0; j < iColSize ; j++) {       %>
 
        <TD>  
            <%=(String)has.get(  nameCol.get(j))!=null)?(String)has.get(nameCol.get(j)):""  )%>
        </TD>        
            
                

                
         <%
                }

                 /*
                 if ( typeCol.get(j).equals("TYPE_DATE")) {
                       out.println( (" <BR>" + (String)has.get(nameCol.get(j))!=null)?(String)has.get(nameCol.get(j)):""  );     
                 } else {     
                       out.println( (" <BR>" +(String)has.get(nameCol.get(j))!=null)?(String)has.get(nameCol.get(j)):"" );     
                 } 
                 */ 
            }
        } %>
        --%>
 

</TABLE>
<%
    }
%>


</TABLE>

</body>
</html>
