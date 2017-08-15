<%@page contentType="text/html"%>
<%@page import="java.util.* ,com.business.beans.*, com.business.util.*, com.business.interfaces.*"%>
<%@page import="java.rmi.*"%>
<%@page import="java.util.Vector"%>
<%@page import="com.ibm.as400.access.*"%>
<%
    AS400 servidor = null;    

    int i;
    int nNumConex= 20;
//    servidor = new AS400[nNumConex];
            String pTrama =  "hola pino";
            String pServidor = "192.168.1.10";
            String pUsuario  = "PINO";
            String pPassword = "PINO";
            String pLibreria = "PINO";
            String pTipoProg = "PGM";
            String pPrograma = "PINOTXTCL";
    
//    for (i = 0; i < nNumConex; i++) {
//        servidor[i] = new AS400(pServidor, pUsuario, pPassword);
//    }

      try {  
    servidor = new AS400(pServidor, pUsuario, pPassword);

  //Authenticate the user and respond to the outcome.
   if (servidor.authenticate(pUsuario , pPassword)){
     out.println(" Usuario valido");
   } else {
     out.println(" Usuario Invalido");
   }

    out.println ("servidor: " + servidor);
        
    //crea un aleatorio para enviar la conexion
//    int nConexion = (int) (Math.random() * nNumConex);
//    String sNombre = servidor[nConexion].getSystemName();

    //System.out.println ("sNombre:" + sNombre);
    
//    sNombre = sNombre.toUpperCase();
//    if (sNombre.compareTo(pServidor) == 0) {
        String c = "/QSYS.LIB/" + pLibreria + ".LIB/" + pPrograma + "." + pTipoProg;
        
//        ProgramParameter[] parmList = new ProgramParameter[2];

//        AS400Text parm1 = new AS400Text(9); // 39999
        

 //       parmList [0] = new ProgramParameter (ProgramParameter.PASS_BY_VALUE, 
 //                               parm1.toBytes(pTrama));
//                                           parm1.toBytes(pTrama), 256);
        
/*        ProgramParameter op2 = new ProgramParameter();
        op2.setOutputDataLength(256);
        
        parmList[1] = op2;
  */      

//        byte[] quantity = new byte[2];
//        quantity[0] = 1;  quantity[1] = 44;
//        parmList[1] = new ProgramParameter(quantity, 30);

//        ProgramCall cmd = new ProgramCall(servidor , c, parmList);
        ProgramCall cmd = new ProgramCall (servidor);
        cmd.setProgram(c);

//        cmd.setThreadSafe(true);
        out.println ("cmd: " + cmd);
        
        try {
          if (cmd.run() != true) {
            // Reporte de las fallas
            System.out.println("Programa ha fallado!");
            // muestra mensajes de error
            AS400Message[] messagelist = cmd.getMessageList();
            for (int j = 0; j < messagelist.length; ++j) {
              System.out.println(messagelist[j]);
            }
          }
          else {
//            AS400Text text = new AS400Text(30);
//            out.println (text.toObject(parmList[1].getOutputData()));

out.println ("ok !!!!!!!!!!!!!!!!!!!");

//            parmList = null;
            cmd = null;
          }
        }
        catch (Exception ex) {
          out.println ("Error 1:" + ex.getMessage());
          ex.printStackTrace();
        }
      }
      catch (Exception ex1) {
        out.println ("Error 2:" + ex1.getMessage());
        ex1.printStackTrace();
      } finally {
        servidor = null;
      }
%>
