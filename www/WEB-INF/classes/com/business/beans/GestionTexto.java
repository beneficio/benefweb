//Title Bean Gestion Texto

package com.business.beans;
import java.util.LinkedList;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;  
import java.sql.CallableStatement;

import com.business.db.*;
import com.business.util.*;
     
public class GestionTexto{
  
 private int     codTexto    		= 0   ;
 private String  texto       		= ""  ;
 private String  usuario 		= ""  ;	
 private String  mcaDefault  		= ""  ; 
 private String  remitente   		= ""  ;
 private String  firma 		 	= ""  ;
 private int	 codError	 	= 0   ;
 private String  strMensajeError  	= ""  ;
 private int    codTemplate             = 0;
 private String titulo                  = "";
 private String userMail                = "";
 private String passMail                = "";
 private String CCO                     = "";

public GestionTexto(){

} 
//Definicion de metodos Setter

public void  setCodError    ( int param  ){ this.codError = param;}
public void  setMensajeError(String param){ this.strMensajeError = param;}
public void  setUsuario     (String param){ this.usuario = param;}
public void  setCodTexto    (int param   ){ this.codTexto = param;}
public void  setTexto       (String param){ this.texto = param;}
public void  setMcaDeFault  (String param){ this.mcaDefault = param;}
public void  setRemitente   (String param){ this.remitente  = param;}
public void  setFirma       (String param){ this.firma      = param;}
public void  setCodTemplate (int param   ){ this.codTemplate = param;}
public void  settitulo      (String param){ this.titulo      = param;}
public void  setuserMail    (String param){ this.userMail    = param;}
public void  setpassMail    (String param){ this.passMail    = param;}
public void  setCCO         (String param){ this.CCO    = param;}

// Definicion de metos  getter
public  String 	   getFirma	    (){ return this.firma;}
public  int 	   getCodError	    (){ return this.codError;}
public  String	   getMensajeError  (){ return this.strMensajeError;} 
public  String     getUsuario       (){ return this.usuario;}
public  String     getRemitente     (){ return this.remitente;} 
public  String     getMcaDefault    (){ return this.mcaDefault;}
public  String     getTexto         (){ return this.texto;}
public  int        getCodTexto      (){ return this.codTexto;}
public  int        getCodTemplate   (){ return this.codTemplate;}
public  String     gettitulo        (){ return this.titulo;}
public  String     getuserMail      (){ return this.userMail;}
public  String     getpassMail      (){ return this.passMail;}
public  String     getCCO           (){ return this.CCO;}

  public LinkedList getDBTextos ( Connection dbCon) throws SurException {
        LinkedList lTexto = new LinkedList();
        CallableStatement  cons = null;
        ResultSet rs = null;               
        boolean bExiste = false;        
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_ALL_GESTION_TEXTOS(?, ?)"));
            int position = 0;						            
            cons.registerOutParameter(++position, java.sql.Types.OTHER);
            cons.setString (++position, this.getUsuario());
            cons.setInt    (++position, this.getCodTemplate());
                       
            cons.execute();            
            
            rs = (ResultSet) cons.getObject(1);			
            if (rs != null) {
                while (rs.next() ) {
		    GestionTexto oTexto = new GestionTexto();
                    bExiste     = true;
                    oTexto.setCodTexto  (rs.getInt("COD_TEXTO"));
		    oTexto.setTexto     (rs.getString("TEXTO"));
		    oTexto.setUsuario   (rs.getString("USUARIO"));
		    oTexto.setMcaDeFault(rs.getString("MCA_DEFAULT"));
		    oTexto.setRemitente	(rs.getString("REMITENTE"));
                    oTexto.setFirma     (rs.getString("FIRMA"));
                    oTexto.settitulo    (rs.getString("TITULO"));
		    lTexto.add          (oTexto);
	 	}	
                if (! bExiste) {
                   setCodError (-100);
                   setMensajeError ("NO EXISTE TEXTO GESTION");
                }
                rs.close();
            }
            cons.close ();
            
        } catch (SQLException se) {
              setCodError (-1);
              setMensajeError (se.getMessage());
        }catch (Exception e) {
                setCodError (-1);
                setMensajeError (e.getMessage());
        } finally {
             try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close (); 
						
             } catch (SQLException see) {
                throw new SurException (see.getMessage());
             }
                return lTexto;
        }
    }
 
  public void getDB ( Connection dbCon) throws SurException {
        ResultSet rs = null;
        CallableStatement  cons = null;
        boolean bExiste = false;
       try {
            dbCon.setAutoCommit(false);
            cons = dbCon.prepareCall(db.getSettingCall("CO_GET_GESTION_TEXTO(?)"));
            cons.registerOutParameter(1, java.sql.Types.OTHER);
            cons.setInt (2, this.getCodTexto());

            cons.execute();

            rs = (ResultSet) cons.getObject(1);
            if (rs != null) {
                while (rs.next() ) {
                    bExiste     = true;
                    this.setCodTexto  (rs.getInt("COD_TEXTO"));
		    this.setTexto     (rs.getString("TEXTO"));
		    this.setUsuario   (rs.getString("USUARIO"));
		    this.setMcaDeFault(rs.getString("MCA_DEFAULT"));
		    this.setRemitente	(rs.getString("REMITENTE"));
                    this.setFirma       (rs.getString("FIRMA"));
                    this.settitulo      (rs.getString("TITULO"));
                    this.setCCO         (rs.getString ("CCO"));
                    this.setCodTemplate (rs.getInt ("COD_TEMPLATE"));
                    this.setpassMail    (rs.getString ("PASSWORD"));
                    this.setuserMail    (rs.getString ("USER_MAIL"));
	 	}
                if (! bExiste) {
                   setCodError (-100);
                   setMensajeError ("NO EXISTE TEXTO GESTION");
                }
                rs.close();
            }
            cons.close ();

        } catch (SQLException se) {
              setCodError (-1);
              setMensajeError (se.getMessage());
              throw new SurException("Error Texto Gestion [getDB]" + se.getMessage());
        }catch (Exception e) {
                setCodError (-1);
                setMensajeError (e.getMessage());
        	throw new SurException("Error Texto Gestion [getDB]" + e.getMessage());
        } finally {
             try {
                if (rs != null) rs.close ();
                if (cons != null) cons.close ();

             } catch (SQLException see) {
                throw new SurException (see.getMessage());
             }
        }
    }

}
