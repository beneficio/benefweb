/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.business.servicios;

import com.business.beans.Poliza;
import java.lang.reflect.Modifier;
import javax.ws.rs.GET;
import javax.ws.rs.Path;      
import javax.ws.rs.PathParam;  
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.Expose;

import com.business.beans.TipoEndoso;
import com.business.beans.Tablas;
import com.business.beans.Endoso;
import com.business.util.*;
import com.business.db.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.LinkedList;


/**      
 * REST Web Service
 *
 * @author relisii
 */
     
@Path("endosoService")
public class EndosoService {

    /** Creates a new instance of CotizaVC */
    public EndosoService () {
    }

    /**
     * Retrieves representation of an instance of com.business.servicios.CotizaVC
     * @return an instance of java.lang.String
     */
    @GET
    @Produces("application/xml")
    public String getXml() {
        //TODO return proper representation object
        throw new UnsupportedOperationException();
    }

    /**
     * PUT method for updating or creating an instance of CotizaVC
     * @param content representation for the resource
     * @return an HTTP response with content of the updated or created resource.
     */

	@GET
	@Path("/validaPol")
	@Produces(MediaType.APPLICATION_JSON)
	public String RecotizarVC (
                        @QueryParam("cod_rama") int codRama,
			@QueryParam("num_poliza") int numPoliza,
                        @QueryParam("endoso") int endoso,
                        @QueryParam("userid") String userid) throws SurException {

       Connection dbCon = null;
        try {
            Endoso oProp = new Endoso ();

            oProp.setNumPoliza( numPoliza);
            oProp.setCodRama  ( codRama);
            oProp.settipoEndoso(endoso);
            
            dbCon = db.getConnection();
            oProp.getDBVerificarPoliza (dbCon, userid);

            Poliza oPol = new Poliza ();
            if (oProp.getCodError() < 0 ) {
                oPol.setiNumError(-100);
                oPol.setsMensError(oProp.getDescError());
            } else {
                oPol.setcodRama(codRama);
                oPol.setnumPoliza(numPoliza);
                oPol.getDB(dbCon);
            }
            
    
           Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(oPol);
        } catch (Exception e) {
            throw new SurException (e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }


        // utilizado en la sopala 1  del Cotizador AP
    	@GET
	@Path("/getAllEndosos")
	@Produces(MediaType.APPLICATION_JSON)
	public String opciones (
                        @QueryParam("cod_rama") int iCodRama,
			@QueryParam("cod_sub_rama") int iCodSubRama,
                        @QueryParam("cod_producto") int iCodProducto,
                        @QueryParam("cod_prod") int iCodProd,
                        @QueryParam("userid") String sUser) throws SurException {


        try {
   
System.out.println ("ingreso al EndosoService");

            Tablas  oTabla = new Tablas ();
            LinkedList<TipoEndoso> lTP = new LinkedList(); 
            
            if (iCodRama == 0) { 
                TipoEndoso oTP = new TipoEndoso(-1, "Seleccione la p&oacute;liza a endosar" );
                lTP.add(oTP);
            } else {
                lTP = oTabla.getAllTiposEndoso (iCodRama, iCodSubRama, iCodProducto, iCodProd, sUser);
            }    
     
            if (lTP.size () == 0) {
                TipoEndoso oTP = new TipoEndoso(0, "No existen endosos habilitados para la p&oacute;liza seleccionada" );
                lTP.add(oTP);
            }

            Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();
            return gson.toJson(lTP);

            } catch (SurException se ) {
                throw new SurException (se.getMessage());
            }
	}

}
