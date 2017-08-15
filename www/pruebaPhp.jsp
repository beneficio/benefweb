<%@page contentType="text/html" errorPage="/error.jsp" %>
<%@include file="/include/no-cache.jsp"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.net.*"%>
<%@page import="com.business.db.*"%>
<%@page import="com.business.util.*"%>

<% // String sCommand = "SNDMSG MSG('la prueba del comando anduvo bien') TOUSR(ADRIAN)";
    try {
        phpDC.realPath (getServletConfig().getServletContext ().getRealPath("/propiedades/config.xml"));
 //     URLConnection urlConnection = phpDC.getConnection( phpDC.getPrograma() +  "\nSecion=04\nNumSin=300001");

        Connection dbCon = null;

        if (Param.getRealPath () == null) {
            Param.realPath (phpDC.getRealPath());
        }

       db.realPath (phpDC.getRealPath());
       dbCon = db.getConnection();


        URLConnection urlConnection = phpDC.getConnection( "PROGRAMA=" + phpDC.getPrograma(dbCon, "PHP_NUEVA_PRELIQ") +  "\r\nPRODUC=8002131844\r\nCOMNET=B\r\nQUENET=\r\nFECVTO=20131231\r\n");

        out.println (urlConnection.toString());


        BufferedReader inStream =  phpDC.sendRequest(urlConnection);

        out.println ("paso 1");
        // - For debugging purposes only!


        StringBuilder buffer = new StringBuilder();
        String linea;
        while((linea = inStream.readLine() ) != null) {

            buffer.append(linea);

            out.println (linea);
        }


//        String respuesta = phpDC.getResponse(urlConnection);

//        out.println ("Respuesta: " + respuesta);

 /*       URL url;
        URLConnection urlConnection;

        String body = "?cualdcrc=" +  URLEncoder.encode("dcrc.prueba", "UTF-8") +
                      "&cont_archivo=" +  URLEncoder.encode("PROGRAMA=divcen/bin/RUNDC VEOSINXX\nSecion=04\nNumSin=300001", "UTF-8");

// Create connection
        url = new URL("http://192.168.2.171/rundc.php" + body);
        urlConnection = url.openConnection();
        ((HttpURLConnection)urlConnection).setRequestMethod("POST");
        urlConnection.setDoInput(true);
        urlConnection.setDoOutput(true);
        urlConnection.setUseCaches(false);
        urlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        urlConnection.setRequestProperty("Content-Length", ""+ body.length());
        urlConnection.setConnectTimeout(60000);
        
// Create I/O streams
        DataOutputStream outStream = new DataOutputStream(urlConnection.getOutputStream());

        BufferedReader  inStream = new BufferedReader
                (new InputStreamReader( urlConnection.getInputStream ()));


// Send request
        outStream.writeBytes(body);
        outStream.flush();
        outStream.close();

        // Get Response
        // - For debugging purposes only!
        String buffer;
        while((buffer = inStream.readLine() ) != null) {
            String [] param = buffer.split("=");
            out.println (param[0] == null ? null : param[0]);
           out.println (param[1] == null ? null : param[1] );
        }

        // Close I/O streams
        inStream.close();
        outStream.close();
 *
 * */
    }
    catch(Exception ex) {
        System.out.println("Exception cought:\n"+ ex.toString());
    }
%>