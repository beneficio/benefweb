//----------------------------------------------------------------------
//
//     Funci�n : add_dias
// Descripci�n : Suma dias a una fecha
//  Par�metros : sFecha Cadena con la fecha (dd/mm/aaaa)
//               ndias  Numero de dias a sumar.
//     Retorno : Fecha con un formato dd/mm/yyyy con los dias sumados
//----------------------------------------------------------------------

function add_dias(sFecha,ndias){
   
   
      if (sFecha && ndias){
      var sFecha_inicial = sFecha.value;
      //Convierto en  objeto Date el estrin ingresado dd/mm/aaaa
      var Fecha_Inicial = new Date(sFecha_inicial.substring(6,10),sFecha_inicial.substring(3,5),sFecha_inicial.substring(0,2));
      //Sumo  los Dias necesarios
      Fecha_Inicial.setTime(Fecha_Inicial.getTime() +  24 * 60 * 60 * 1000 * ndias);
      var sdia  = Fecha_Inicial.getDate().toString();
	  var imes	= Fecha_Inicial.getMonth();
	  var ianio	= Fecha_Inicial.getFullYear();
	  if (imes == 0) {
			imes = 12;
			ianio-- ;
	  }	  		
	  var smes  = imes.toString()
	  var sanio = ianio.toString ();
      var sFecha_Final = (sdia.length == 1 ? "0" :"" ) + sdia + "/" + (smes.length == 1 ? "0" :"" ) +smes + "/" + sanio;
      return sFecha_Final;
   }
   return "";
}

//----------------------------------------------------------------------
//
//     Funci�n : dateDiff
// Descripci�n : Diferencia entre dos fechas
//  Par�metros : per  Periodos "y"=anio, "m"=mes, "d"=dia, "h"=horas, "n"=minutos
//               d1  Primer fecha del tipo Date
//               d2  Segunda fecha del tipo Date
//     Retorno : cantidad de periodos
//----------------------------------------------------------------------

function dateDiff(per,d1,d2) {
   var d = (d2.getTime()-d1.getTime())/1000
   switch(per) {
      case "y": d/=12
      case "m": d*=12*7/365.25
      case "w": d/=7
      case "d": d/=24
      case "h": d/=60
      case "n": d/=60
   }
   return Math.floor(d);
}

//calcular la edad de una persona 
//recibe la fecha como un string en formato espa�ol 
//devuelve un entero con la edad. 
//Devuelve false en caso de que la fecha sea incorrecta o mayor que el dia actual 

function calcular_edad (fecha, desde ){ 
 //calculo la fecha de hoy 
    var array_fecha_hoy = desde.split("/"); 
    if (array_fecha_hoy.length!=3) 
       return false; 

    //compruebo que los ano, mes, dia son correctos 
    var ano1 = parseInt(array_fecha_hoy[2]); 
    if (isNaN (ano1)) 
       return false; 
    var mes1 = parseInt(array_fecha_hoy[1]) - 1;
    if (isNaN (mes1)) 
       return false; 
    var dia1 = parseInt(array_fecha_hoy[0]) - 1;
    if (isNaN (dia1)) 
       return false; 
 
   hoy = new Date(ano1, mes1, dia1 );

//calculo la fecha que recibo 
//La descompongo en un array 
    var array_fecha = fecha.split("/"); 
    //si el array no tiene tres partes, la fecha es incorrecta 
    if (array_fecha.length!=3) 
       return false; 

    //compruebo que los ano, mes, dia son correctos 
    var ano = parseInt(array_fecha[2]); 
    if (isNaN(ano)) 
       return false; 

    var mes = parseInt(array_fecha[1]);
    if (isNaN(mes)) 
       return false; 

    var dia = parseInt(array_fecha[0]);
    if (isNaN(dia)) 
       return false; 

    //si el año de la fecha que recibo solo tiene 2 cifras hay que cambiarlo a 4
    if ( ano <= 99) 
       ano += 1900; 

    //resto los años de las dos fechas
    edad= hoy.getFullYear() - ano - 1; //-1 porque no se si ha cumplido a�os ya este a�o

    //si resto los meses y me da menor que 0 entonces no ha cumplido a�os. Si da mayor si ha cumplido 
    if ( hoy.getMonth()  - mes < 0) { 
       return edad; 
    }
    if (hoy.getMonth()  - mes > 0) {
       return edad + 1; 
    }
    //entonces es que eran iguales. miro los dias 
    //si resto los dias y me da menor que 0 entonces no ha cumplido a�os. Si da mayor o igual si ha cumplido

    if ( hoy.getUTCDate() - dia >= 0) 
       return edad + 1; 

    return edad; 
}

function getFechaActual () {
    var mydate=new Date();
    var year=mydate.getYear();
    if (year < 1000)
        year+=1900;
    
    var day=mydate.getDay();
    var month=mydate.getMonth()+1;
    if (month<10)
        month="0"+month;
    var daym=mydate.getDate();
    if (daym<10)
        daym="0"+daym;

    return daym+"/"+month+"/"+year;
}