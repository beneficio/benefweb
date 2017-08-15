/*
 * Fecha.java
 *
 * Created on 24 de julio de 2003, 13:14
 */

package com.business.util;

import java.util.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.text.DateFormat;

/**
 *
 * @author  Gisela Cabot
 *
 */

public class Fecha {
    
    final static SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    private static String fechaJDBC= "";
    private static String fechaSQL="";
    
    /** Creates a new instance of Fecha */
    public Fecha() {
    }
    
    public static java.util.Date strToDate (String fecha) {

    try {
            return (fecha == null ? null : sdf.parse(fecha));
            
        } catch (Exception e){
            return new java.util.Date ();
        }
    }

    
    public static java.util.Date strToDate (String fecha, String formato) {
        
        try {
            SimpleDateFormat sd = new SimpleDateFormat(formato);                    
            return sd.parse(fecha);
            
        } catch (Exception e){
            return new java.util.Date ();
        }
    }

    public  static String toString(java.util.Date currentDate) {
      SimpleDateFormat formatter = new SimpleDateFormat ("dd/MM/yyyy");
      String dateString = formatter.format(currentDate);
       return  dateString;
    }
 
    public static java.util.Date formatFecha(Date pfecha) throws SurException {
        fechaJDBC = pfecha.toString();
        String yyyy= fechaJDBC.substring(0,4);
        String MM= fechaJDBC.substring(5,7);
        String dd= fechaJDBC.substring(8,10);
        fechaSQL = dd + "/" + MM + "/" + yyyy;
        
        try {
           java.util.Date nuevaFecha = sdf.parse(fechaSQL);
           return nuevaFecha;   
        } catch (ParseException pe) {
            throw new SurException ("Error al parsear la fecha [Fecha.formatFecha()] " + pe.getMessage()); 
        }
    }  
    
    public static String getFechaHoraActual () throws SurException {
       try {
            Date oTime = new Date();
            GregorianCalendar gc = new GregorianCalendar();
            gc.setTime(oTime);
            String AM_PM = gc.get(Calendar.AM_PM) == 1 ? "PM" : "AM";
            String fechaActual = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) +1) + "/" + gc.get(Calendar.YEAR) + " " + gc.get(Calendar.HOUR) + ":" + gc.get(Calendar.MINUTE) + ":" + gc.get(Calendar.SECOND) + " " + AM_PM;
            return fechaActual;
       } catch (Exception e) {
            throw new SurException ("Error al traer una nueva fecha [Fecha.getFechaHoraActual()] " + e.getMessage()); 
       }
    }
    
    public static String getFechaActual() throws SurException {
       try {
            Date oTime = new Date();
            GregorianCalendar gc = new GregorianCalendar();
            gc.setTime(oTime);
            String fechaActual = Formatos.lpad(String.valueOf(gc.get(Calendar.DAY_OF_MONTH)),"0",2) + "/" + Formatos.lpad(String.valueOf(gc.get(Calendar.MONTH)+1),"0",2) + "/" + gc.get(Calendar.YEAR);
            return fechaActual;
       } catch (Exception e) {
            throw new SurException ("Error al traer una nueva fecha [Fecha.getFechaActual()] " + e.getMessage()); 
       }
    }
    
     public static String getFechaFinVigencia() throws SurException {
       try {
            Date oTime = new Date();
            GregorianCalendar gc = new GregorianCalendar();
            gc.setTime(oTime);
            String fechaHasta="";
            
            if ( (gc.get(Calendar.MONTH)+1 ) == 12 ) {
                int YEAR = gc.get(Calendar.YEAR) +1;
               String MONTH = "01";
                fechaHasta = gc.get(Calendar.DAY_OF_MONTH) + "/" + MONTH + "/" + YEAR;
            } else {
                fechaHasta = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH) +2) + "/" + gc.get(Calendar.YEAR);
            }
            return fechaHasta; 
       } catch (Exception e) {
            throw new SurException ("Error al traer la fecha de fin de vigencia [Fecha.getFechaFinVigencia()] " + e.getMessage()); 
       }
    }

 public static String getFechaFinVigencia(Date oTime , int iCantMeses)
throws SurException {
       try {
            GregorianCalendar gc = new GregorianCalendar();
            gc.setTime(oTime);
            String fechaHasta="";

            int dia  = gc.get(Calendar.DAY_OF_MONTH);
            int mes  = gc.get(Calendar.MONTH);
            int anio = gc.get(Calendar.YEAR);

            if ( (mes + 1) +  iCantMeses <= 12  ){
                mes = (mes + 1) + iCantMeses ;
            } else {
                mes  = (mes +  1) + iCantMeses ;
                while ( mes > 12 ) {
                    mes  = mes - 12 ;
                    anio = anio + 1;
               }
            }
            fechaHasta = dia + "/" + mes + "/" + anio;

            return fechaHasta;
       } catch (Exception e) {
            throw new SurException ("Error al traer la fecha de fin de vigencia [Fecha.getFechaFinVigencia()] " + e.getMessage());
       }

    }
     
      public static String getFechaComVigencia() throws SurException {
       try {
            Date oTime = new Date();
            GregorianCalendar gc = new GregorianCalendar();
            gc.setTime(oTime);
            String fechaDesde="";
            
            if ( (gc.get(Calendar.MONTH) ) == 0 ) {
                int MONTH = gc.get(Calendar.MONTH) + 1;
                fechaDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + MONTH + "/" + gc.get(Calendar.YEAR);
            } else {
                fechaDesde = gc.get(Calendar.DAY_OF_MONTH) + "/" + (gc.get(Calendar.MONTH)) + "/" + gc.get(Calendar.YEAR);
            }
            return fechaDesde;
       } catch (Exception e) {
            throw new SurException ("Error al traer la fecha de fin de vigencia [Fecha.getFechaFinVigencia()] " + e.getMessage()); 
       }
    }

    public static String showFechaForm(java.sql.Date pfecha) {
            return sdf.format(pfecha);
    }

    public static String showFechaForm(java.util.Date pfecha) {
            return sdf.format(pfecha);
    }
   
    public static java.sql.Date convertFecha(java.util.Date jdbcDate) throws SurException {
      try {
          SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd"); 
          java.sql.Date f_sql =  java.sql.Date.valueOf(sd.format(jdbcDate));

          return f_sql;
      } catch (Exception e) {     
             throw new SurException ("Error al traer una nueva fecha [Fecha.convertFecha()] " + e.getMessage()); 
      }
    } 

    public static java.sql.Timestamp convertTimestamp(java.util.Date jdbcDate) throws SurException {
      try {
//          SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd"); 
          SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");
          
          java.sql.Timestamp f_sql= java.sql.Timestamp.valueOf(sd.format(jdbcDate));
          return f_sql;
      } catch (Exception e) {     
             throw new SurException ("Error al traer una nueva fecha [Fecha.convertFecha()] " + e.getMessage()); 
      }
    } 
    
      public static String addDias (int param) throws SurException {
       try {
            java.util.Date oTime = new java.util.Date ();
            GregorianCalendar gc = new GregorianCalendar();
            gc.setTime(oTime);
            Calendar c = new GregorianCalendar(gc.get(Calendar.YEAR), gc.get(Calendar.MONTH), gc.get(Calendar.DAY_OF_MONTH)); 
           
            c.add(Calendar.DAY_OF_MONTH, param); 
           
            return sdf.format(c.getTime());
       } catch (Exception e) {
            throw new SurException ("Error al traer la fecha de fin de vigencia [Fecha.getFechaFinVigencia()] " + e.getMessage()); 
       }
    }

    public static java.util.Date add (java.util.Date param,int dias ) {

        try {
            Calendar fechaCarta2 = Calendar.getInstance();
            fechaCarta2.setTime(param);
            fechaCarta2.add(Calendar.DAY_OF_MONTH, dias);

            return fechaCarta2.getTime();
        } catch (Exception e){
            return new java.util.Date ();
        }
    }

 public static Integer calcularEdad(Date fecha){
     
    Calendar fechaNacimiento = Calendar.getInstance();    
    fechaNacimiento.setTime(fecha);

        //Se crea un objeto con la fecha actual
        Calendar fechaActual = Calendar.getInstance();    
        //Se restan la fecha actual y la fecha de nacimiento
        int año = fechaActual.get(Calendar.YEAR)- fechaNacimiento.get(Calendar.YEAR);
        int mes =fechaActual.get(Calendar.MONTH)- fechaNacimiento.get(Calendar.MONTH);
        int dia = fechaActual.get(Calendar.DATE)- fechaNacimiento.get(Calendar.DATE);
        //Se ajusta el año dependiendo el mes y el día
        if(mes<0 || (mes==0 && dia<0)){
            año--;
        }
        //Regresa la edad en base a la fecha de nacimiento
        return año;
    }    
}
