package com.business.util;
public class Formatos {

    public Formatos() {
   }       
    
   public static String showNumPoliza ( int pol ) {
//       StringBuilder sReturn = new StringBuilder(11);
       
//       if ( pol == 0) {
//           sReturn.append(" ");
//       } else {
//           String sPol = String.valueOf(pol);
//           sReturn.append(sPol);
//           sReturn.append(sPol.substring(0, sPol.length()-1));
//           sReturn.append("/");
//           sReturn.append(sPol.substring(sPol.length()-1));
//       }

//       return sReturn.toString() ;
         return String.valueOf(pol);
    }     
   
   public static String showParamAS400 ( String param ) {
       StringBuilder sReturn = new StringBuilder(7);
       int longMax = 7 - param.length();
       for (int i = 0; i < longMax; i++) {
            sReturn.append("0");
        }
        sReturn.append(param);

        return sReturn.toString() ;
    }     
   
   public static String showMailAS400 (String param) {
        StringBuilder sbMail = new StringBuilder (64);
        sbMail.append(param);
        
        for (int i = param.length();  i < 64; i++) {
        sbMail.append(' ');
        }

        return sbMail.toString();  
   }

   public static String formatearCeros ( String param, int longitud ) {
       StringBuilder sReturn = new StringBuilder(longitud);
       int longMax = longitud - param.length();
       for (int i = 0; i < longMax; i++) {
            sReturn.append("0");
        }
        sReturn.append(param);

        return sReturn.toString() ;
    }
   public static String lpad ( String param, String caracter, int longitud ) {
       StringBuilder sReturn = new StringBuilder(longitud);
       int longMax = longitud - param.length();
       for (int i = 0; i < longMax; i++) {
            sReturn.append(caracter);
        }
        sReturn.append(param);
    
        return sReturn.toString() ;
    }   

public static String truncate(String value, int length)   
{
  if (value != null && value.length() > length)
    value = value.substring(0, length);
  return value;
}
}    
