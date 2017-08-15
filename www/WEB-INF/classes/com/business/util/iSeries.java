/*
 * iSeries.java
 *
 * Created on 30 de marzo de 2006, 15:34
 */

package com.business.util;

import com.business.interfaces.iSeriesService;
import java.rmi.*;
import java.util.Vector;
import com.ibm.as400.access.*;

/**
 *
 * @author  EDGO
 */
public class iSeries   implements iSeriesService {
  
    static private AS400 servidor[];
    private ProgramCall cmd;
  
    private String sServidor= "192.168.1.10";
    private String sUsuario= "PINO";
    private String sPassword= "PINO";
    private int nNumConex= 20; // verivicar este valor
  /**
   * Método que envia una Cadena de Datos al Programa Manejador Devuelve
   * una cadena con el resultado
   *
   * @param pServidor Nombre del Servidor iSeries
   * @param pUsuario Uusario Atorizado
   * @param pPassword Clave de Accesso
   * @param pLibreria Nombre de la Libreria o Biblioteca
   * @param pTipoProg Tipo de Programa Nativo iSeires
   * @param pPrograma Nombre del Programa
   * @param pTrama Cadena de Caracteres
   * @throws RemoteException
   * @return String
   */
  public String enviarDatos(String pServidor, String pUsuario,
                            String pPassword, String pLibreria,
                            String pTipoProg, String pPrograma,
                            String pTrama) throws RemoteException {

    String sRpta = "";
    int nConexion;
    if (servidor == null) {
      creaConexion();
    }
    //crea un aleatorio para enviar la conexion
    nConexion = (int) (Math.random() * nNumConex);
    String sNombre = servidor[nConexion].getSystemName();

    System.out.println ("sNombre:" + sNombre);
    
    sNombre = sNombre.toUpperCase();
    if (sNombre.compareTo(pServidor) == 0) {
      try {
        String c = "/QSYS.LIB/" + pLibreria + ".LIB/" + pPrograma + "." + pTipoProg;
        ProgramParameter[] parmList = new ProgramParameter[1];
//        AS400Text parm1 = new AS400Text(39999);
                AS400Text parm1 = new AS400Text(256);
        parmList[0] = new ProgramParameter(ProgramParameter.PASS_BY_REFERENCE,
//                                           parm1.toBytes(pTrama), 39999);
                                           parm1.toBytes(pTrama), 256);        

        ProgramCall cmd = new ProgramCall(servidor[nConexion], c, parmList);
        
        try {
          if (cmd.run() != true) {
            // Reporte de las fallas
            System.out.println("Programa ha fallado!");
            // muestra mensajes de error
            AS400Message[] messagelist = cmd.getMessageList();
            for (int i = 0; i < messagelist.length; ++i) {
              System.out.println(messagelist[i]);
            }
          }
          else {
//            AS400Text text = new AS400Text(39999);
            AS400Text text = new AS400Text(256);              
            sRpta = ((String) text.toObject(parmList[0].getOutputData())).trim();
            pTrama = sRpta;
            parmList = null;
            cmd = null;
          }
        }
        catch (Exception ex) {
          sRpta = "Error:" + ex.getMessage();
          ex.printStackTrace();
        }
      }
      catch (Exception ex1) {
        sRpta = "Error:" + ex1.getMessage();
        ex1.printStackTrace();
      }
    }
    return sRpta;
  }

  private void creaConexion() {
    int i;
    servidor = new AS400[nNumConex];
    
    for (i = 0; i < nNumConex; i++) {
        servidor[i] = new AS400(sServidor, sUsuario, sPassword);
    }
  }
}