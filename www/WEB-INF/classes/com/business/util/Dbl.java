package com.business.util;
import java.text.*;
public  class Dbl {

   public Dbl() {
   }

   public static String DbltoStr( double n, int d ) {
/*       String mascara = "#0";
       if (d > 0 ) {
           mascara = mascara + ",";
           for (int i=0;i<d;i++){
               mascara = mascara + "0";
           }
       }

        DecimalFormat df = new DecimalFormat(mascara);
        DecimalFormatSymbols dfs = df.getDecimalFormatSymbols();
        dfs.setDecimalSeparator('.');
        dfs.setGroupingSeparator(',');
        df.setDecimalFormatSymbols(dfs);
        df.setMaximumFractionDigits(d);
        df.setMinimumFractionDigits(d);
        String sReturn = df.format(n);
        return sReturn ;
 *
 */

       String mascara = "#.##";

        DecimalFormat df = new DecimalFormat(mascara);
        DecimalFormatSymbols dfs = df.getDecimalFormatSymbols();
        dfs.setDecimalSeparator('.');
        dfs.setGroupingSeparator(',');
        df.setDecimalFormatSymbols(dfs);
        df.setMaximumFractionDigits(d);
        df.setMinimumFractionDigits(d);
        String sReturn = df.format(n);
        return sReturn ;
    }

   public static String DbltoStrPadRight( double n, int d , int len) {
      String s = DbltoStr(  n, d );
      if ( s.length() > len ) return s.substring(0,len);
      else if ( s.length() < len )
         return "                               ".substring(0,len  - s.length()) + s;
      else return s;
    }

   public static String DbltoStrZ( double n, int d ) {
       String mascara = "#.##";
       if (d > 0 ) {
           mascara = mascara + ",";
           for (int i=0;i<d;i++){
               mascara = mascara + "0";
           }
       }

        DecimalFormat df = new DecimalFormat(mascara);
        DecimalFormatSymbols dfs = df.getDecimalFormatSymbols();
        dfs.setDecimalSeparator('.');
        dfs.setGroupingSeparator(',');
        df.setDecimalFormatSymbols(dfs);
        df.setMaximumFractionDigits(d);
        df.setMinimumFractionDigits(d);
        String sReturn = df.format(n);
        return (n==0? "&nbsp;":sReturn) ;
    }

    public static double StrtoDbl( String n ) {
   /*    String sValue = new String();
       for (int i=0; i < n.length();i++){
           if (!String.valueOf(n.charAt(i)).equals(",")){
               sValue += String.valueOf(n.charAt(i));
           }
       }
       double dReturn = 0;
       if (sValue.length()>0){
        dReturn = Double.parseDouble(sValue);
       }
       return dReturn ;
    *
    */
        return Double.parseDouble(n);
    }
}