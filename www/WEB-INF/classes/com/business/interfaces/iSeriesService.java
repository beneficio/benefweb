/*
 * MaestroInfo.java
 *
 * Created on 18 de julio de 2003, 10:53
 */

package com.business.interfaces;

import java.rmi.*; 
/**
 *
 * @author  surprogra
 */  
public interface iSeriesService extends Remote {
  // Función que envia datos al AS/400 en Forma de Trama
  public String enviarDatos(String pServidor, String pUsuario,
                            String pPassword, String pLibreria,
                            String pTipoProg, String pPrograma,
                            String pTrama) throws RemoteException;

}
