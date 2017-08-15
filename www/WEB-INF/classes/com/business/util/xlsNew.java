/*
 * xls.java
 *
 * Created on 12 de febrero de 2004, 13:35
 */

package com.business.util;
 
import java.io.IOException;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.poifs.filesystem.*;
import java.util.Hashtable;
import java.util.LinkedList;
import java.io.File.*; 
import jxl.*;
import jxl.JXLException; 
/**
 *
 * 
 * @author  rjofre
 */
public class xlsNew {
    private HSSFWorkbook wb = new HSSFWorkbook();
    private String Titulo       = "hoja1";
    private int currentRow      = 0;
    private LinkedList lHeaders = new LinkedList();
    private LinkedList lRows    = new LinkedList();    
    /** Creates a new instance of xls */
    public xlsNew() {
    }
    public HSSFWorkbook generate() {
        HSSFSheet sheet =  wb.createSheet(this.getTitulo());
        HSSFRow headerRow = sheet.createRow(currentRow++);
        String log = "Log:";
        for (int i = 0; i < this.lHeaders.size() ; i++) {            
            headerRow.createCell((short)i).setCellValue((String) this.lHeaders.get(i));
            log +=(String) this.lHeaders.get(i) + " - ";
        }    
        HSSFRow row = null;
        HSSFDataFormat df = wb.createDataFormat();
        HSSFCellStyle cs = wb.createCellStyle();
        cs.setDataFormat(df.getFormat("#,##0.00"));

        LinkedList lCols = null;
        for (int i = 0; i < this.lRows.size() ; i++) {                    
            row = sheet.createRow(currentRow++);
            lCols = (LinkedList) this.lRows.get(i);
            for (int j = 0; j < lCols.size() ; j++) {                    
                log += lCols.get(j) + " || ";
                
                HSSFCell cell = row.createCell((short)j);
                cell.setCellStyle(cs);
                if (lCols.get(j) instanceof String){
                    cell.setCellValue( ((String)lCols.get(j)));                    
                }else if (lCols.get(j) instanceof Double){
                    cell.setCellValue( ((Double)lCols.get(j)).doubleValue());
                    cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
                }else if (lCols.get(j) instanceof Integer) {
                    cell.setCellValue( ((Integer)lCols.get(j)).intValue());
                    cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
                }else{
                    cell.setCellValue((String)lCols.get(j));
                }
             //   cell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
             //   cell.setCellValue((String)lCols.get(j));
                
            }    
        }    
         return wb;
    }
    
    public void setHead(String header){
        this.lHeaders.add(header);
    }
    
    public void setRows(LinkedList row){
        this.lRows.add(row);
    }
    
    /** Getter for property Titulo.
     * @return Value of property Titulo.
     *
     */
    public java.lang.String getTitulo() {
        return Titulo;
    }
    
    /** Setter for property Titulo.
     * @param Titulo New value of property Titulo.
     *
     */
    public void setTitulo(java.lang.String Titulo) {
        this.Titulo = Titulo;
    }
 
    // ---->>>>> SUP
   /*
     * Obtener informaci�n de un xls.
     *
     */
    public static LinkedList getXls(LinkedList pColType, LinkedList pColNameFileds, String pPath, int pPage) throws Exception 
    {
        //Workbook workbook = Workbook.getWorkbook(new File("myfile.xls"));
        POIFSFileSystem fs = new POIFSFileSystem(new java.io.FileInputStream(pPath));
        HSSFWorkbook    wb = new HSSFWorkbook(fs);            
        HSSFSheet    sheet = wb.getSheetAt(pPage);
        LinkedList hFila   = new LinkedList();       
        
        int lastRowNum     = sheet.getLastRowNum();
        int iCantCol       = pColNameFileds.size();
        for (int iFila =0; iFila  < lastRowNum ; iFila++) {
         Hashtable hCol = new Hashtable();   
          for (int iCol =0; iCol  < iCantCol ; iCol++) {
             HSSFRow   row  = sheet.getRow(iFila);
             if  (row!=null ) {
              HSSFCell  cell  = row.getCell((short)iCol);
              if (cell != null ) {
                                if (((String)pColType.get(iCol)).equals("TYPE_STRING") ) {
                                    hCol.put(pColNameFileds.get(iCol),cell.getStringCellValue());

                                } else if (((String)pColType.get(iCol)).equals("TYPE_DATE") ) {
                                   java.util.Date date = cell.getDateCellValue() ;
                                   String fecha = com.business.util.Fecha.toString(date);
                                   hCol.put(pColNameFileds.get(iCol),fecha);
                                } else if (((String)pColType.get(iCol)).equals("TYPE_NUMERIC") ) {                                 
                                   hCol.put(pColNameFileds.get(iCol), cell.getNumericCellValue());
                                }
                        } // else null cell 
             }
              hFila.add(iFila, hCol);
          }
        }
        return hFila;
    }
    public static LinkedList getInfoByXlsOlds1 (LinkedList pTypes, LinkedList pNameFields , String pPath , int pPage) 
    throws Exception {
        try {
            POIFSFileSystem fs = new POIFSFileSystem(new java.io.FileInputStream(pPath));
            HSSFWorkbook    wb = new HSSFWorkbook(fs);            

             HSSFSheet    sheet = wb.getSheetAt(pPage);
//HSSFSheet    sheet = wb.getSheetAt(1);
            int lastRowNum     = sheet.getLastRowNum();
            lastRowNum++;       // sumo 1 porque toma uno menos
            
            int iCantCol       = pNameFields.size();

            LinkedList hFila   = new LinkedList();       
            
            for (int iFila =0; iFila  < lastRowNum ; iFila++) {
                Hashtable hCol = new Hashtable();
                for (int iCol =0; iCol  < iCantCol ; iCol++) {
                    HSSFRow   row  = sheet.getRow(iFila);
                    if  (row!=null ) {
                        HSSFCell  cell  = row.getCell((short)iCol);

                        System.out.println ("iCol" + iCol + "  (String)pTypes.get(iCol)" + (String)pTypes.get(iCol));
                        System.out.println ("pNameFields.get(iCol),cell.getStringCellValue() " + (String)pNameFields.get(iCol));

                        if (cell != null ) {
                                if (((String)pTypes.get(iCol)).equals("TYPE_STRING") ) {
                                    hCol.put(pNameFields.get(iCol),cell.getStringCellValue());

                                } else if (((String)pTypes.get(iCol)).equals("TYPE_DATE") ) {
                                   java.util.Date date = cell.getDateCellValue() ;
                                   String fecha = com.business.util.Fecha.toString(date);
                                   hCol.put(pNameFields.get(iCol),fecha);
                                } else if (((String)pTypes.get(iCol)).equals("TYPE_NUMERIC") ) {
                                   String mascara = "###0";
                                   String sVal  = cell.getStringCellValue();
                                   if (sVal.indexOf(",") > 0) {
                                       mascara =  "###0,00";
                                   } else if (sVal.indexOf(".") > 0) {
                                       mascara = "###0.00";
                                   }

                                   double numero = cell.getNumericCellValue();

                                   java.text.DecimalFormat df = new java.text.DecimalFormat(mascara);
                                   df.setMaximumFractionDigits(2);
                                   df.setMinimumFractionDigits(0);
                                   String numeroStr = df.format(numero);
                                   hCol.put(pNameFields.get(iCol), numeroStr);
                                }
                        } // else null cell

                    } // else null row

                } // for columna
                hFila.add(iFila, hCol);

            } // For Fila                
            return hFila;            
            
            
            
        } catch (Exception e) {
            throw new Exception("Error " + e.getMessage());
        } finally {
        }      
    }                   
    // ----<<<<< SUP
    public static LinkedList getInfoByXlsOlds (LinkedList pTypes, LinkedList pNameFields , String pPath , int pPage, String pTitulos)
    throws Exception {
        try {
            POIFSFileSystem fs = new POIFSFileSystem(new java.io.FileInputStream(pPath));
            HSSFWorkbook    wb = new HSSFWorkbook(fs);

             HSSFSheet    sheet = wb.getSheetAt(pPage);
//HSSFSheet    sheet = wb.getSheetAt(1);
            int lastRowNum     = sheet.getLastRowNum();
            lastRowNum++;       // sumo 1 porque toma uno menos

            int iCantCol       = pNameFields.size();

            LinkedList hFila   = new LinkedList();

            int inicio = (pTitulos.equals("S") ? 1 : 0);

            for (int iFila = inicio; iFila  < lastRowNum ; iFila++) {
                Hashtable hCol = new Hashtable();
                for (int iCol =0; iCol  < iCantCol ; iCol++) {
                    HSSFRow   row  = sheet.getRow(iFila);
                    if  (row!=null ) {
                        HSSFCell  cell  = row.getCell((short)iCol);
//                        System.out.println ("iCol" + iCol + "  (String)pTypes.get(iCol)" + (String)pTypes.get(iCol));
//                        System.out.println ("pNameFields.get(iCol),cell.getStringCellValue() " + (String)pNameFields.get(iCol));

                        if (cell != null ) {
                            try {
                                if (((String)pTypes.get(iCol)).equals("TYPE_STRING") ) {
                                    //hCol.put(pNameFields.get(iCol), (cell.getCellType() == cell.CELL_TYPE_NUMERIC ? cell.getNumericCellValue() : cell.getStringCellValue()) );
                                    hCol.put(pNameFields.get(iCol), cell.getStringCellValue());
//                                    System.out.println ("paso 00");
                                } else if (((String)pTypes.get(iCol)).equals("TYPE_DATE") ) 
                                       { java.util.Date date = cell.getDateCellValue() ;
                                         String fecha = com.business.util.Fecha.toString(date);
                                         hCol.put(pNameFields.get(iCol),fecha);
                                        } else if (((String)pTypes.get(iCol)).equals("TYPE_NUMERIC") ) {
                                                  String mascara = "###0";
                                                  double numero = cell.getNumericCellValue();
                                                  String sVal  = String.valueOf(numero);
                                                  
                                                  if (sVal.indexOf(",") > 0) {
                                                     mascara =  "###0,00";
                                                  } else if (sVal.indexOf(".") > 0) {
                                                    mascara = "###0.00";
                                                        }
                                                    java.text.DecimalFormat df = new java.text.DecimalFormat(mascara);
                                                    df.setMaximumFractionDigits(2);
                                                    df.setMinimumFractionDigits(0);
                                                    String numeroStr = df.format(numero);
                                                    hCol.put(pNameFields.get(iCol), numeroStr);
                                                    }
                                } catch ( Exception e) {
                                    throw  new SurException("error" + cell.getErrorCellValue());
                                }
                                }
                    } // else null row

                } // for columna
                hFila.add(pTitulos.equals("S") ? iFila - 1 : iFila, hCol);
            } // For Fila
            return hFila;
        } catch (Exception e) {
            throw new Exception("Error " + e.getMessage());
        } finally {
        }
    }

}