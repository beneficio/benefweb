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

               
public class UploadServlet extends HttpServlet {
private ServletConfig config;   
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
        
System.out.println ("UploadServlet.upload " + usu.getusuario() );
        SmartUpload mySmartUpload = new SmartUpload();        
        // Initialization
        mySmartUpload.initialize(this.getServletConfig(), request, response); 
        // Only allow txt or htm files
        mySmartUpload.setAllowedFilesList("pdf,jpg,jpge,bmp,jpeg,zip,PDF,JPG,JPGE,JPEG,BMP,ZIP");

        // DeniedFilesList can also be used :
        mySmartUpload.setDeniedFilesList("exe,bat,jsp,tif");

        // Deny physical path
        mySmartUpload.setForcePhysicalPath(false);

        // Only allow files smaller than 50000 bytes
        // 2 MB
        mySmartUpload.setMaxFileSize(2097152);
    
        // Upload	
        try {  
            mySmartUpload.upload();
        } catch (java.lang.SecurityException se) {
            if (se.getMessage().startsWith("The extension of the file is not allowed to be uploaded")) {
                sMensaje =  "ARCHIVO NO PERMITIDO, LAS EXTENSIONES PERMITIDAS SON  pdf, jpg, jpeg, bmp";
            } else if ( se.getMessage().startsWith("Size exceeded for this file")) {
                sMensaje = "ARCHIVO DEMASIADO GRANDE, NO DEBERIA SUPERAR LOS 2 MB";
            } else {
                sMensaje = se.getMessage();
                
            }
            exito = false;
        }

        numPropuesta = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_propuesta"));
        codRama      = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("cod_rama"));
        numPoliza    = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_poliza"));
        certificado  = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("certificado"));
        subCertificado =  Integer.parseInt ( mySmartUpload.getRequest().getParameter ("sub_certificado"));
        tipoDocumento= Integer.parseInt ( mySmartUpload.getRequest().getParameter ("select_documento"));
        codProd      = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("cod_prod"));
        numSini      = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_sini"));
        numTomador   = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_tomador"));
        numOrden     = Integer.parseInt ( mySmartUpload.getRequest().getParameter ("num_orden"));
        
        System.out.println ( sMensaje);
        // Save the files with their original names in a virtual path of the web server
        //Request requestSmart = mySmartUpload.getRequest();
  
        if ( exito == true) {

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
            
            com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);

            if (!myFile.isMissing()) {
            // Save it only if this file exists
                String sFile = numPropuesta + "_" + codRama + "_" + numPoliza + "_" + 
                        certificado + "_" + subCertificado + "_" + codProd + "_" + numSini + "_" + numTomador;
                if (numOrden > 0) {
                    sFile = sFile + "(" + numOrden + ")";
                }
                
                String nameFileRelativo = "/files/doc/";

                File oFile = new  File (request.getServletContext().getRealPath(nameFileRelativo) + "/" + sFile + "." + myFile.getFileExt());

                nameFileRelativo = nameFileRelativo + sFile + "." + myFile.getFileExt();
                sFile = sFile + "." + myFile.getFileExt();
                
System.out.println (" oFile " + oFile.getName());
/*                
                if (oFile.exists()) {
                    
                    for (int i=1; i < 1000; i++) {
                        oFile = new  File (request.getServletContext().getRealPath(nameFileRelativo) + "/" + sFile + "(" + i + ")." + myFile.getFileExt());
                        if ( ! oFile.exists()) {
                            nameFileRelativo = nameFileRelativo + sFile + "(" + i + ")." + myFile.getFileExt();
                            sFile = sFile + "(" + i + ")." + myFile.getFileExt();
                            break;
                        } else {
                            System.out.println ("existe file --> " + i + " - " + oFile.getName());
                        }
                    }
                } else {
                    nameFileRelativo = nameFileRelativo + sFile + "." + myFile.getFileExt();
                    sFile = sFile + "." + myFile.getFileExt();
                } 
*/
                // Save the files with its original names in a virtual path of the web server       
                myFile.saveAs (nameFileRelativo , mySmartUpload.SAVE_VIRTUAL);

                oDoc.setnomArchivo(sFile);
                
                dbCon = db.getConnection();
                oDoc.setDB(dbCon);
                if (oDoc.getCodError() < 0 ) {
                    exito = false;
                    sMensaje =  oDoc.getDescError();
                }
                
            } else {
                    exito = false;
                    sMensaje = "Problema en la carga del archivo ";
            }
           
        }
        
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