/*
 * Report.java
 *
 * Created on 15 de julio de 2003, 11:07
 */

package com.business.util;

import java.sql.*;
import java.util.*;
import java.io.*;
import xmlpdf.*;
import com.business.interfaces.*;
/**
 *
 * @author  rjofre
 */
public class Report {
    private final String sTagInicial [] = {"<link" ,"<table", "<span", "<block", "<style" , "<source", "<cell" }; 
    private String stitulo;
    private String sReportName;
    private String sContextPath;
    private String sformulario;
    private String sfecha;
    private String susuario;
    private String xmlData              = new String();
    private LinkedList lrsName          = new LinkedList();
    private LinkedList lrs              = new LinkedList();
    private LinkedList lrsColumnas      = new LinkedList ();
    private LinkedList lrsStyle         = new LinkedList ();
    private LinkedList lObjName         = new LinkedList ();
    private LinkedList lObjValue        = new LinkedList ();
    private LinkedList lNameCondicion   = new LinkedList ();
    private LinkedList lValueCondicion  = new LinkedList ();
    private LinkedList lFileImage       = new LinkedList ();
    private LinkedList lNameImage       = new LinkedList ();
    private String     sObjName         = new String ();
    private String     sEstiloTabla     = "";
    private String sOrientacion ="portrait"; // portrait = horizontal, landscape = vertical

//     protected static final String ENCODING = "ISO-8859-1";    
    /** Creates a new instance of Report */
    public Report() {
    }
    
    public void setOrientacion (String psOrientacion) {
        this.sOrientacion = psOrientacion;
    }
    
    public String getOrientacion() {
        return this.sOrientacion;
    }
    
    public void setTitulo(java.lang.String psTitulo) {
        this.stitulo = psTitulo;
    }
    
    public void setReportName(java.lang.String psReportName) {
        this.sReportName = psReportName;
    }

    public void setFormulario(java.lang.String psFormulario) {
        this.sformulario = psFormulario;
    }
    
    public void setFecha(java.lang.String psFecha) {
        this.sfecha = psFecha;
    }
    
    public void setUsuario(java.lang.String psUsuario) {
        this.susuario = psUsuario;
    }
    public java.lang.String getUsuario() {
       return  this.susuario;
    }

    public void setsContextPath (java.lang.String psContextPath) {
        this.sContextPath = psContextPath;
    }
    
    public void addCondicion (String sNameCond, String sTrueFalse) {
        this.lNameCondicion.add(sNameCond);
        this.lValueCondicion.add(sTrueFalse);
    }

    public void addImage (String sNameImage, String sFileImage) {
        this.lNameImage.add(sNameImage);
        this.lFileImage.add(sFileImage);
    }
    
    public void addIniTabla (String sName, String sAtributos, String sEstilo, String [] sTitulos) { 
        this.sEstiloTabla = sEstilo;
        this.xmlData += "<source-element name='" + sName + "'>";
        this.xmlData += "<table widths='"+ sAtributos + "' padding-all='2'>";
        this.xmlData += "<row>";
        
        for (int i = 0; i < sTitulos.length ; i++) {
            this.xmlData += "<cell class='" + this.sEstiloTabla + "Bold" + "'>";
            this.xmlData += depuraCaractEspeciales (sTitulos [i]);
            this.xmlData += "</cell>";
        }
        this.xmlData += "</row>";
    }

    public void addIniTabla (String sName, String sAtributos, String [] sEstilos, String [] sTitulos) { 
        this.xmlData += "<source-element name='" + sName + "'>";
        this.xmlData += "<table widths='"+ sAtributos + "' padding-all='2'>";
        this.xmlData += "<row>";
        
        for (int i = 0; i < sTitulos.length ; i++) {
            if (sTitulos [i] == null) break;
            this.xmlData += "<cell class='" + sEstilos[i] + "Bold" + "'>";
            this.xmlData += depuraCaractEspeciales (sTitulos [i]);
            this.xmlData += "</cell>";
        }
        this.xmlData += "</row>";
    }
    
    public void addIniTabla (String sName) { 
        this.xmlData += "<source-element name='" + sName + "'>";
    }

    public void addIniTabla (String sName, String sAttribute, String sEstiloTabla)  { 
        this.xmlData += "<source-element name='" + sName + "'>";
        this.xmlData += "<table widths='" + sAttribute + "' class='" + sEstiloTabla + "'>";
    }
    
    public void addElementsTabla (String [] sElements, String [] sEstilos) {
        this.xmlData += "<row>";
        
        String fila = new String ();
        
        for (int i = 0; i < sElements.length ; i++) {
            if (sElements [i] == null) break;
            this.xmlData += "<cell class='" + sEstilos [i] + "'>";
            this.xmlData += this.depurarEntidades(depuraCaractEspeciales (sElements [i]));
            this.xmlData += "</cell>";

//            fila += "<cell class='" + sEstilos [i] + "'>";
//            fila += depuraCaractEspeciales (sElements [i]);
//            fila += "</cell>";
            
//  System.out.println ("elemento de la tabla " + xmlData);
        }
        
        this.xmlData += "</row>";
    }
    
    public void addFinTabla () {
        this.xmlData += "</source-element>";
    }

    public void addFinTabla (String sNameTable) {

// el parametro sNameTable no se usa pero es necesario para sobrecargar el metodo.         
// este fin de tabla se complementa con el addIniTabla que genera el tag <table>        
        this.xmlData += "</table>";
        this.xmlData += "</source-element>";
    }
    
    public void addIniAtributoDinanico (String sName) { 
        this.xmlData += "<source-element name='" + sName + "'>";
    }
    
    public void addElemAtributoDinanico (String sElement) {
  
        this.xmlData += "<merge source-element-name='" + sElement +"'/>";
    }
    
    public void addFinAtributoDinanico () {
        this.xmlData += "</source-element>";
    }
    
    public void addRs(ResultSet poRs,String psRsName) {
       this.lrs.add(poRs);          
       this.lrsName.add(psRsName);          
       this.lrsColumnas.add (new LinkedList());
       this.lrsStyle.add (new String ());
    }
    
    public void addRs(ResultSet poRs,String psRsName, LinkedList plColumnas) {
       this.lrs.add(poRs);          
       this.lrsName.add(psRsName);          
       this.lrsColumnas.add (plColumnas);
       this.lrsStyle.add (new String ());
    }

    public void addRs(ResultSet poRs,String psRsName, LinkedList plColumnas, String [] plStyle) {
       this.lrs.add(poRs);          
       this.lrsName.add(psRsName);          
       this.lrsColumnas.add (plColumnas);
       this.lrsStyle.add (plStyle);
    }
    
    public void addlObj(String psObjName, String psObjValue) {
       this.lObjValue.add ( depurarEntidades(depuraCaractEspeciales(psObjValue == null ? "" : psObjValue)));
       this.lObjName.add  (psObjName);          
    }

    public void addlObj(InterReport plObj, String psObjName) {
        
       for (int i = 0; i < plObj.getlAtributeName().size(); i++) {
            this.xmlData += "<source-element name='" + psObjName + "_" + (String) plObj.getlAtributeName().get(i) + "'>";
            this.xmlData += depurarEntidades(depuraCaractEspeciales(((String) plObj.getlAtributeValor().get(i)) == null ? " " : ((String) plObj.getlAtributeValor().get(i))));
            this.xmlData += "  </source-element>";
       }
    }

    public void addFileSource (String psFName, String psFTitulo) {
       
       try {
           BufferedReader fr = new BufferedReader (new FileReader (psFName));           
           String sFila = "";
           this.xmlData += "<source-element name='" + psFTitulo  + "'>";           
           while ( (sFila = fr.readLine()) != null) {
//                this.xmlData += this.depuraCaractEspeciales(sFila); 
               
                this.xmlData += this.depurarEntidades(sFila);
           }
           this.xmlData += "  </source-element>";

       } catch (FileNotFoundException fe)  { 
           new SurException ("el template no existe " + fe.getMessage());
       } catch (IOException ioe)  { 
           new SurException ("Error en la lectura del template " + ioe.getMessage());
       }
       
       }

    public void addFileSource (String psFName, String psFTitulo, int iIndice) {
       
       try {
           BufferedReader fr = new BufferedReader (new FileReader (psFName));           
           String sFila = "";
           this.xmlData += "<source-element name='" + psFTitulo  + "'>";           
           while ( (sFila = fr.readLine()) != null) {
               sFila = sFila.replaceAll("XXXX", String.valueOf (iIndice));
               this.xmlData += this.depurarEntidades(sFila);
           }
           this.xmlData += "  </source-element>";

       } catch (FileNotFoundException fe)  { 
           new SurException ("el template no existe " + fe.getMessage());
       } catch (IOException ioe)  { 
           new SurException ("Error en la lectura del template " + ioe.getMessage());
       }
       }

    public String getsContextPath() {
        return this.sContextPath;
    }

    public String getReportName () {
        return this.sReportName;
    }
    
    public void setxmlData (String pxmlData) {
        this.xmlData = pxmlData;
    }
    
    
    public String getXmlData() throws SQLException {
        String sXMLDataFinal = "";
     try {
        this.getMetaData();

        if (this.lrs.size () != 0) {
            for (int i=0;i<this.lrs.size();i++){
                ResultSet oRs           = (ResultSet) this.lrs.get(i);
                String osRsName         = (String) this.lrsName.get(i);
                LinkedList lColumnas    = (LinkedList) this.lrsColumnas.get(i);
                String  lStyle []       = (String []) this.lrsStyle.get(i);
                
                this.RstoXml(oRs,osRsName, lColumnas, lStyle);
                oRs.close ();
            }
        }             
        
        if (this.lObjValue.size () != 0) {
           this.ObjtoXml();
        }             
        
        sXMLDataFinal = "<data>";             
        
        if (this.lNameCondicion.size() > 0) {
            sXMLDataFinal += "<conditions>";
            for (int i = 0; i < this.lNameCondicion.size(); i++) {
                sXMLDataFinal += "<condition name='" + this.lNameCondicion.get(i) + "' value='" + this.lValueCondicion.get(i) + "'/>";
            }
            sXMLDataFinal += "</conditions>";
            
        }
        
        sXMLDataFinal += this.xmlData + "</data>";
        
     } catch (SQLException se ) {
         throw new SurException ("error en la clase Report " + se.getMessage());
     } catch (Exception e) {
         throw new SurException ("error en la clase Report " + e.getMessage());
     } finally {
        if (this.lrs.size () != 0) {
            for (int i=0 ; i < this.lrs.size(); i++){
                ResultSet oRs   = (ResultSet) this.lrs.get(i);
                oRs.close ();
            }
        }             
         return sXMLDataFinal;
     }
        
    }

    void getMetaData(){

        this.xmlData += "<source-element name='imagenes'>";
        for (int i=0; i < this.lFileImage.size(); i++) {
//            this.xmlData += "<image file-name='"+ this.sContextPath + this.lFileImage.get(i) +"' image-name='"+ this.lNameImage.get(i) +"'/>";
              this.xmlData += "<image file-name='"+ this.lFileImage.get(i) +"' image-name='"+ this.lNameImage.get(i) +"'/>";
        }
        
        this.xmlData += "</source-element>";

        this.xmlData += "<source-element name='titulo'>";
        this.xmlData +=    this.stitulo;
        this.xmlData += "</source-element>";
        this.xmlData += "<source-element name='formulario'>";
        this.xmlData +=    this.sformulario;
        this.xmlData += "</source-element>";
        this.xmlData += "<source-element name='fecha'>";
        this.xmlData +=    this.sfecha;
        this.xmlData += "</source-element>";
        this.xmlData += "<source-element name='usuario'>";
        this.xmlData +=    this.susuario;
        this.xmlData += "</source-element>";
        this.xmlData += "<source-element name='contextPath'>";
        this.xmlData +=    this.sContextPath;
        this.xmlData += "</source-element>";
    }
    
    void RstoXml(ResultSet poRs, String psRsName , LinkedList plColumnas,String [] plStyle) throws SQLException {
        ResultSetMetaData md = (ResultSetMetaData) poRs.getMetaData();
        int count = md.getColumnCount();

        this.xmlData += "<source-element name='" + psRsName + "'>";
        while (poRs.next()){
            this.xmlData +=   "<row>";
            String sValorColumna = "";
            if (plColumnas.size () == 0) {
               for (int i=1; i<=count;i++) {
                   if (poRs.getObject(md.getColumnName(i)) == null) {
                       sValorColumna = " ";
                   } else {
                       if (poRs.getObject(md.getColumnName(i)).getClass().getName().equals("java.sql.Timestamp")) {
                          sValorColumna = Fecha.showFechaForm(poRs.getDate(md.getColumnName(i)));
                       } else {
                           if (md.getColumnTypeName(i).equals("NUMBER")) {
                              sValorColumna = Dbl.DbltoStr(poRs.getDouble(md.getColumnName(i)),md.getScale(i));
                           } else {
                              sValorColumna = String.valueOf (poRs.getObject(md.getColumnName(i)));
                           }
                       }
                   }
                   
                   this.xmlData +=   "<cell class='" +  plStyle [i] + "'>";
                   this.xmlData +=   depuraCaractEspeciales(sValorColumna.trim());
                   this.xmlData +=   "</cell>";
               }
            } else {
                   for (int j=0 ; j < plColumnas.size () ; j++) {
                      String sNameColumna = (String) plColumnas.get(j);
                      for (int i=1; i<=count;i++) {
                           if (md.getColumnName(i).equals(sNameColumna)){
                               if (poRs.getObject(md.getColumnName(i)) == null) {
                                   sValorColumna = " ";
                               } else {
                                   if (poRs.getObject(md.getColumnName(i)).getClass().getName().equals("java.sql.Timestamp")) {
                                      sValorColumna = Fecha.showFechaForm(poRs.getDate(md.getColumnName(i)));
                                   } else {
                                       if (md.getColumnTypeName(i).equals("NUMBER")) {
                                          sValorColumna = Dbl.DbltoStr(poRs.getDouble(md.getColumnName(i)),md.getScale(i));
                                       } else {
                                          sValorColumna = String.valueOf (poRs.getObject(md.getColumnName(i)));
                                       }
                                   }
                               }
                            }    
                       }    
                       this.xmlData +=   "<cell class='" +  plStyle [j] + "'>";
                       this.xmlData +=   depuraCaractEspeciales(sValorColumna.trim());
                       this.xmlData +=   "</cell>";
                   }
                }    
            this.xmlData +=   "</row>";
        }

        this.xmlData += "  </source-element>";
    }    

    void ObjtoXml() throws SQLException {
    
        for (int i = 0; i < lObjValue.size(); i++) {
                this.xmlData += "<source-element name='" + this.lObjName.get(i) + "'>";
                this.xmlData += this.lObjValue.get(i);
                this.xmlData += "  </source-element>";
            }
    }
    
    private String depurarEntidades (String psFila) {
// reemplaza blanco        
        
       psFila = psFila.replaceAll("&nbsp;","&#160;");
        
// reemplaza acentos  
        
        psFila = psFila.replaceAll("&aacute;","&#225;");
        psFila = psFila.replaceAll("&eacute;","&#233;");
        psFila = psFila.replaceAll("&iacute;","&#237;");
        psFila = psFila.replaceAll("&oacute;","&#243;");
        psFila = psFila.replaceAll("&uacute;","&#250;");
        psFila = psFila.replaceAll("&ntilde;","&#241;");
        psFila = psFila.replaceAll("&Ntilde;","&#209;");        
        psFila = psFila.replaceAll("&Aacute;","&#193;");
        psFila = psFila.replaceAll("&Eacute;","&#201;");
        psFila = psFila.replaceAll("&Iacute;","&#205;");
        psFila = psFila.replaceAll("&Oacute;","&#211;");
        psFila = psFila.replaceAll("&Uacute;","&#218;");
        
        return psFila;
    }
    
    private String depuraCaractEspeciales (String psFila) {

// reemplazo caracteres por sus respectivos codigos


        psFila = psFila.replaceAll ("Ã¡", "á");
        psFila = psFila.replace("Ã©", "é");
        psFila = psFila.replace("Ã*", "í");
        psFila = psFila.replace("Ã³", "ó");
        psFila = psFila.replace("Ãº", "ú");
        psFila = psFila.replace("Ã", "Á");
        psFila = psFila.replace("Ã‰", "É");
        psFila = psFila.replace("Ã", "Í");
        psFila = psFila.replace("Ã“", "Ó");
        psFila = psFila.replace("Ãš", "Ú");
        psFila = psFila.replace("Ã±", "ñ");
        psFila = psFila.replace("Ã‘", "Ñ");
        psFila = psFila.replace("&", "&amp;");
        psFila = psFila.replace("'", "&apos;");
        psFila = psFila.replace("\"", "&quot;");
        psFila = psFila.replace("<", "&lt;");
        psFila = psFila.replace(">", "&gt;");

       String psFilaNew = psFila;


       /*
           for (int k = 0; k < psFila.length(); k++) {
                byte newByte = psFila.getBytes()[k];
                int iCodigo = Integer.parseInt (this.byteToHex(newByte), 16); 
                
                if ( iCodigo == 60 || iCodigo == 62 || iCodigo == 34 ||
                     iCodigo == 38 || iCodigo > 128 ) {
                    if (iCodigo == 60 || iCodigo == 62) {
                        boolean bEsCodigo = false;
                        for (int i = 0; i < this.sTagInicial.length; i++) {
                            if (psFila.startsWith(this.sTagInicial [i])) {
                                bEsCodigo = true;
                                break;
                            }
                        }
                        if (! bEsCodigo) {
                            psFilaNew += "&#" + String.valueOf (iCodigo) + ";"; 
                        } else {
                            psFilaNew += String.valueOf (psFila.charAt(k));
                        }
                    } else {
                        psFilaNew += "&#" + String.valueOf (iCodigo) + ";"; 
                    }
                } else { 
                    psFilaNew += String.valueOf (psFila.charAt(k));
                }
           }  
*/
        return psFilaNew;
 }   

     static public String byteToHex(byte b) {
      // Returns hex String representation of byte b
      char hexDigit[] = {
         '0', '1', '2', '3', '4', '5', '6', '7',
         '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
      };
      char[] array = { hexDigit[(b >> 4) & 0x0f], hexDigit[b & 0x0f] };
      return new String(array);
   }

    public void getFilePDF ( String nombre) throws SurException {
       FileOutputStream fos = null;
       try {

            InputStream stream      = new FileInputStream (this.getReportName());
            StringBuffer streamData = new StringBuffer  (this.getXmlData  ());

             PDFDocument doc = new PDFDocument();

            doc.setAttributeTranslation( "$orientation" , this.getOrientacion());

            ByteArrayOutputStream outStream = new ByteArrayOutputStream();

            doc.generate( stream, outStream, streamData );

//System.out.println ("despues de doc.generate" + outStream.size());

            fos = new FileOutputStream (new File(nombre));

            // Put data in your baos

            outStream.writeTo(fos);
            outStream.close();

       } catch (IOException ioe)  {
           System.out.println ("Error en escritura" + ioe.getMessage());
           throw new SurException ("Error en escritura" + ioe.getMessage());
       } catch (Exception e)  {
           System.out.println ("Error en general " + e.getMessage());
           throw new SurException ("Error en general " + e.getMessage());
       } 
       }
}
