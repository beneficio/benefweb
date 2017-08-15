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

import com.business.beans.Localidad;
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

@Path("maestroService")
public class MaestroService {

    /** Creates a new instance of CotizaVC */
    public MaestroService () {
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
	@Path("/getDescLocalidad")
	@Produces(MediaType.APPLICATION_JSON)
	public String getLocalidad (
                        @QueryParam("cod_localidad") int codLocalidad ) throws SurException {

       Connection dbCon = null;
        try {
            Localidad oLoc = new Localidad ();
            oLoc.setcodLocalidad(codLocalidad);
System.out.println ("entro a maestroService con " + codLocalidad);

            dbCon = db.getConnection();
            oLoc.getDBdescLocalidad(dbCon);

System.out.println ("obtuvo la localidad  " + oLoc.getdescLocalidad());
    
            Gson gson = new GsonBuilder()
            .excludeFieldsWithoutExposeAnnotation() // esto es para que SOLO incluya las propiedades anotadas con @Expose
            .create();

            return gson.toJson(oLoc);
        } catch (Exception e) {
System.out.println ("error en maestroService  " + e.getMessage() );
            
            throw new SurException (e.getMessage());
        } finally {
             db.cerrar(dbCon);
        }
    }
}
