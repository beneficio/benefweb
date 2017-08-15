/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
       
package servlets;
import com.business.beans.Documentacion;
import com.business.beans.Usuario;
import com.business.db.db;
import com.business.util.SurException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import javax.servlet.ServletConfig;
import com.jspsmart.upload.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.io.*;
import java.util.List;
import java.util.Iterator;

               
public class FileUploadServlet extends HttpServlet {
private ServletConfig config;   
private static final String UPLOAD_DIRECTORY = "/files/doc";
private static final int THRESHOLD_SIZE     = 512 * 1024;  // 512kb
private static final int MAX_FILE_SIZE      = 1024 * 1024 * 2; // 2MB
private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 3; // 3MB
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    final public void init(ServletConfig config)
      throws ServletException{
        super.init(config);
        this.config = config;
    }    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        try {

            if (request.getContentType() != null && 
                    request.getContentType().toLowerCase().contains("multipart/form-data") == true ) {
                upload (request, response);
            } else if (request.getParameter("opcion") != null && request.getParameter("opcion").equals("delFile")) {
                deleteFile (request, response);
            }
            
        } catch (SurException se) {            
            goToJSPError(request,response, se);
        } catch (Exception e) {            
            goToJSPError(request,response, e);
        }
    }    

    protected void deleteFile  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException, SQLException, SmartUploadException {
        Connection dbCon = null;
        String sMensaje = "archivo eliminado exitosamente";
        boolean exito  = true;
        int numPropuesta = 0;
        int codRama      = 0;
        int numPoliza    = 0;
        int certificado  = 0;
        int subCertificado = 0;
        int tipoDocumento= 0;
        int codProd      = 0;
        int numSini      = 0;
        int numTomador   = 0;
        Documentacion oDoc = new Documentacion();
        try {
        Usuario usu = (Usuario) request.getSession().getAttribute("user");

System.out.println ("UploadServlet.deleteFile " + usu.getusuario() );

        int numDocumento = Integer.parseInt (request.getParameter("num_documento"));
        numPropuesta = Integer.parseInt (request.getParameter ("num_propuesta"));
        codRama      = Integer.parseInt (request.getParameter ("cod_rama"));
        numPoliza    = Integer.parseInt (request.getParameter ("num_poliza"));
        certificado  = Integer.parseInt (request.getParameter ("certificado"));
        subCertificado =  Integer.parseInt (request.getParameter ("sub_certificado"));
        tipoDocumento= Integer.parseInt (request.getParameter ("tipo_documento"));
        codProd      = Integer.parseInt (request.getParameter ("cod_prod"));
        numSini      = Integer.parseInt (request.getParameter ("num_sini"));
        numTomador   = Integer.parseInt (request.getParameter ("num_tomador"));
        
        dbCon = db.getConnection();
        oDoc.setnumDocumento(numDocumento);
        oDoc.setmcaBaja("X");
        oDoc.setUserid(usu.getusuario());
        oDoc.setDB(dbCon);
    
        } catch (Exception e) {
            exito =false;
            sMensaje = e.getMessage();
        } finally {
            db.cerrar(dbCon);
            request.setAttribute("mensaje", sMensaje );
            request.setAttribute("estado", ( exito == true ? "OK" : "ERROR") );
            doForward (request, response, "/propuesta/rs/formUpload.jsp?" +
                    "num_propuesta=" + numPropuesta  + "&cod_rama=" + codRama + 
                    "&num_poliza=" +  numPoliza + "&certificado=" +  certificado + 
                    "&sub_certificado=" + subCertificado + "&tipo_documento=" + tipoDocumento + 
                    "&cod_prod=" + codProd + "&num_sini=" + numSini + "&num_tomador=" + numTomador);
        }        
    }

    protected void upload  (HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, SurException, SQLException, SmartUploadException {
        Connection dbCon = null;
        String sMensaje = "La carga fue exitosa";
        boolean exito  = true;
        int numPropuesta = 0;
        int codRama      = 0;
        int numPoliza    = 0;
        int certificado  = 0;
        int subCertificado = 0;
        int tipoDocumento= 0;
        int codProd      = 0;
        int numSini      = 0;
        int numTomador   = 0;
        int numOrden     = 0;
        
        try {
        Usuario usu = (Usuario) request.getSession().getAttribute("user");

    System.out.println ("entro en upload ");
        
        // configures upload settings
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(THRESHOLD_SIZE);
        factory.setRepository(new File(UPLOAD_DIRECTORY));

    System.out.println ("paso 1 ");
        
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);

    System.out.println ("paso 2 ");
        
        List formItems = upload.parseRequest(request);

        Iterator iter1 = formItems.iterator();
        
    System.out.println ("paso 3 ");
        
        while (iter1.hasNext()) {
            FileItem item = (FileItem) iter1.next();
            if (item.isFormField()) {
                String name = item.getFieldName();
                String value = item.getString();
                
    System.out.println ("iter1 " + name + "  : " + value);
                
                if (name.equals("num_propuesta")) {
                    numPropuesta = Integer.parseInt (value);
                } else if (name.equals("cod_rama")) {
                    codRama      = Integer.parseInt (value);
                } else if (name.equals("num_poliza")) {
                    numPoliza    = Integer.parseInt (value);
                } else if (name.equals("certificado")) {
                    certificado      = Integer.parseInt (value);
                } else if (name.equals("sub_certificado")) {
                    subCertificado   = Integer.parseInt (value);
                } else if (name.equals("select_documento")) {
                    tipoDocumento    = Integer.parseInt (value);
                } else if (name.equals("cod_prod")) {
                    codProd          = Integer.parseInt (value);
                } else if (name.equals("num_sini")) {
                    numSini          = Integer.parseInt (value);
                } else if (name.equals("num_tomador")) {
                    numTomador       = Integer.parseInt (value);
                } else if (name.equals("num_orden")) {
                    numOrden         = Integer.parseInt (value);
                } 
            }
        }

        String sFile = numPropuesta + "_" + codRama + "_" + numPoliza + "_" + 
                certificado + "_" + subCertificado + "_" + codProd + "_" + numSini + "_" + numTomador;
        if (numOrden > 0) {
            sFile = sFile + "(" + numOrden + ")";
        }

    System.out.println ("sFile --> " + sFile );
        
        String uploadPath = getServletContext().getRealPath("")
            + File.separator + UPLOAD_DIRECTORY;
       
        Iterator iter = formItems.iterator();

        // iterates over form's fields
        while (iter.hasNext()) {
            FileItem item = (FileItem) iter.next();
            // processes only fields that are not form fields
            if (!item.isFormField()) {
                
    System.out.println ("entro en iter " + item.getName());
                
                String fileName = new File(item.getName()).getName();
                
    System.out.println ("fileName " + fileName);
    
                String extension = "";
                int index = fileName.lastIndexOf('.');
                if (index != -1) {
                        extension = fileName.substring(index + 1);
                }                

                sFile = sFile + "." + extension;

    System.out.println ("sFile " + sFile);
                
                String filePath = uploadPath + File.separator + sFile;
    System.out.println ("filePath " + filePath);
                
                File storeFile = new File(filePath);

                // saves the file on disk
                item.write(storeFile);
                
System.out.println (" grabo");
                    
            } 
        }
        
        
        Documentacion oDoc = new Documentacion();
        oDoc.setCodProd(codProd);
        oDoc.setCodRama(codRama);
        oDoc.setNumPoliza(numPoliza);
        oDoc.setNumPropuesta(numPropuesta);
        oDoc.setNumSiniestro(numSini);
        oDoc.setNumTomador(numTomador);
        oDoc.setUserid(usu.getusuario());
        oDoc.setcertificado(certificado);
        oDoc.setsubCertificado(subCertificado);
        oDoc.settipoDocumento(tipoDocumento);
        
        oDoc.setnomArchivo(sFile);

        dbCon = db.getConnection();
        oDoc.setDB(dbCon);
        if (oDoc.getCodError() < 0 ) {
            exito = false;
            sMensaje =  oDoc.getDescError();
        }
        
System.out.println (" grabo Documentacion");
        
        } catch (Exception e) {
            exito = false;
            sMensaje = e.getMessage();
        } finally {
            db.cerrar(dbCon);
            
    System.out.println ("en el finally --> " + sMensaje);
    
            request.setAttribute("mensaje", sMensaje );
            request.setAttribute("estado", ( exito == true ? "OK" : "ERROR") );
            doForward (request, response, "/propuesta/rs/formUpload.jsp?" +
                    "num_propuesta=" + numPropuesta  + "&cod_rama=" + codRama + 
                    "&num_poliza=" +  numPoliza + "&certificado=" +  certificado + 
                    "&sub_certificado=" + subCertificado + "&tipo_documento=" + tipoDocumento + 
                    "&cod_prod=" + codProd + "&num_sini=" + numSini + "&num_tomador=" + numTomador + 
                    "&num_orden=" + numOrden);
        }        
    }

    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }    

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }

    public void doForward(HttpServletRequest request, HttpServletResponse response,
        String nextPage) throws ServletException, IOException {
        try {
      		getServletConfig().getServletContext().getRequestDispatcher(nextPage).forward(request,response);
	} catch (IOException ioe) {
                goToJSPError (request,response, ioe);
	} catch (ServletException se) {
                goToJSPError (request,response, se);
	} catch (Exception e) {
                goToJSPError (request,response, e);
	}  // try		

    } // doForward
    
    public void goToJSPError (HttpServletRequest request, HttpServletResponse response, Throwable t)
     throws ServletException, IOException {
	try {
        request.setAttribute("javax.servlet.jsp.jspException", t);
		getServletConfig().getServletContext().getRequestDispatcher("/error.jsp").forward(request,response);
	} catch (IOException ioe) {
		System.out.println("LoginServlet IOException Forwarding Request: " + ioe);
	} catch (ServletException se) {
		System.out.println("LoginServlet ServletException Forwarding Request: " + se);
	} // try

    } // doForward
}