// --------------------------------------------

// Agregado por Pino - 12/04/2007
// Detectar Navegador -
// Forma de uso:  BrowserDetect.browser  + BrowserDetect.version + BrowserDetect.OS
var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{
			string: navigator.userAgent,
			subString: "Chrome",
			identity: "Chrome"
		},
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			prop: window.opera,
			identity: "Opera",
			versionSearch: "Version"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			   string: navigator.userAgent,
			   subString: "iPhone",
			   identity: "iPhone/iPod"
	    },
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};
BrowserDetect.init();

   
    function Trim(TRIM_VALUE){
        if(TRIM_VALUE.length < 1){
          return"";
        }
        TRIM_VALUE = RTrim(TRIM_VALUE);
        TRIM_VALUE = LTrim(TRIM_VALUE);
        if(TRIM_VALUE==""){
            return "";
        }
        else{
           return TRIM_VALUE;
        }
    } //End Function

    function RTrim(VALUE){
        var w_space = String.fromCharCode(32);
        var v_length = VALUE.length;
        var strTemp = "";
        if(v_length < 0){
        return"";
        }
        var iTemp = v_length -1;

        while(iTemp > -1){
        if(VALUE.charAt(iTemp) == w_space){
        }
        else{
        strTemp = VALUE.substring(0,iTemp +1);
        break;
        }
        iTemp = iTemp-1;

        } //End While
        return strTemp;

    } //End Function

    function LTrim(VALUE){
        var w_space = String.fromCharCode(32);
        if(v_length < 1){
        return"";
        }
        var v_length = VALUE.length;
        var strTemp = "";

        var iTemp = 0;

        while(iTemp < v_length){
        if(VALUE.charAt(iTemp) == w_space){
        }
        else{
        strTemp = VALUE.substring(iTemp,v_length);
        break;
        }
        iTemp = iTemp + 1;
        } //End While
        return strTemp;
    } //End Function


    function ValidoCuit (cuit) {
        var vec= new Array(10);
        esCuit=false;
        cuit_rearmado="";
        errors = ''
        for (i=0; i < cuit.length; i++) {   
            caracter=cuit.charAt( i);
            if ( caracter.charCodeAt(0) >= 48 && caracter.charCodeAt(0) <= 57 )     {
                cuit_rearmado +=caracter;
            }
        }
        
        cuit=cuit_rearmado;
        if ( cuit.length != 11) {  // si to estan todos los digitos
            esCuit=false;
            errors = 'Cuit <11 ';
            alert( "CUIT Menor a 11 Caracteres" );
            return false;

        } else {
            x=i=dv=0;
        // Multiplico los d�gitos.
            vec[0] = cuit.charAt(  0) * 5;
            vec[1] = cuit.charAt(  1) * 4;
            vec[2] = cuit.charAt(  2) * 3;
            vec[3] = cuit.charAt(  3) * 2;
            vec[4] = cuit.charAt(  4) * 7;
            vec[5] = cuit.charAt(  5) * 6;
            vec[6] = cuit.charAt(  6) * 5;
            vec[7] = cuit.charAt(  7) * 4;
            vec[8] = cuit.charAt(  8) * 3;
            vec[9] = cuit.charAt(  9) * 2;

            // Suma cada uno de los resultado.
            for( i = 0;i<=9; i++) {
                x += vec[i];
            }
            dv = (11 - (x % 11)) % 11;
            if ( dv == cuit.charAt( 10) ) { 
                esCuit=true;
            } 
        }
        if ( !esCuit ) {
            alert( "CUIT Inválido" );
            errors = 'Cuit Invalido ';
            return false;
        }
//      document.MM_returnValue1 = (errors == '');
        return true;
    }

// funcion agregada por Pino 17/12/2003.Devuelve un entero tomado como parte 
// entera la decimal. Ej.: 12.34 -> 1234 

    function strToInteger (sNumero) {
    
    var sNumReturn = "";
    for (var i = 0; i < sNumero.length ; i++) {
       if (sNumero.charAt (i) != '.') {
            sNumReturn += sNumero.charAt(i);
       }
    }
    return parseInt ( sNumReturn , 10 );
    }

// funcion agregada por Pino 17/12/2003. Devuelve un String tomado como parte 
// decimal las 2 ultimas posiciones del parametro de entrada.
// Ej.: 1234 -> 12.34

    function strConPunto (sNumero) {
    
    var sNumReturn = "0"; 
    
    if (sNumero.length > 2) {
        sNumReturn = sNumero.substring(0, sNumero.length - 2) + "." +  sNumero.substring( sNumero.length - 2 ,  sNumero.length);
        
    } else {
        if (sNumero.length == 2) {
            if (sNumero.indexOf("-") == -1) {
                sNumReturn = "0." + sNumero;
            } else {
                sNumReturn = "-0.0" + sNumero.substring(1,2);
            }
        } else {
            if (sNumero.length == 1) {
                sNumReturn = "0.0" + sNumero;
            }
        }
    }
    return sNumReturn;
    }

// Eejmplos : <input onKeyPress="return Mascara('F')" onBlur=" 
// validaFecha(this)" >

function validaFecha(input)
{
	if (input.value) {
 		fecha = FormatoFecha(input.value); //Formatos.js
		if (fecha=="") {
			alert("Fecha invalida.");
			input.value=fecha;
		}
		else {
 			input.value=fecha;
		}
  	}		
 	return input.value;
 }

function validaEdadFecha(input)   
{
    if (input.value.length == 1 ||
        input.value.length == 2 ) {
        if ( input.value.indexOf ('/') == -1 &&
             input.value.indexOf ('-') == -1) {
                return input.value;
             } else {
                alert("Edad invalida.");
             }
    } else {
	if (input.value) {
 		fecha = FormatoFecha(input.value); //Formatos.js
		if (fecha=="") {
			alert("Fecha invalida.");
			input.value=fecha;
		}
		else {
 			input.value=fecha;
		}
  	}
    }
 	return input.value;
 }


//----------------------------------------------------------------------
//
//     Funci�n : FormatoFecha
// Descripci�n : Realiza la transformaci�n/validaci�n de un dato tipo
//               fecha
//  Par�metros : Cadena con la fecha a trasformar
//     Retorno : Fecha con un formato dd/mm/yyyy o una cadena vacia si
//               el formato de entrada no era correcto
//       Notas : - Admite los formatos de entrada siguientes:
//                     d/m/yy
//                     dd/mm/yy
//                     dd/mm/yyyy 
//               - En el caso de incluir solo dos d�gitos para el a�o,
//                 se interpreta como fecha del a�o 2000 los inferiores 
//                 o igual a 30.
//
//----------------------------------------------------------------------
function FormatoFecha( cFecha ) {
	
	// Comprobaci�n de tama�o

	if ( cFecha.length < 6 || cFecha.length > 10 ) { 
		return "";
	}
	
	// Buscar primer separador de la fecha
	var nSeparador1 = cFecha.indexOf( '/');
	if ( nSeparador1 > 2 )
	 {
		return "";
	 }
	if ( nSeparador1 < 1  )
	 {
		return  FormatoFechaPelada(cFecha) ;
	 }
	 
	// Obtener el d�a
	var cDia = cFecha.substring(0, nSeparador1);
	
	// Buscar el segundo separador de la fecha
	var nSeparador2 = cFecha.indexOf( '/', nSeparador1+1 );
	if ( nSeparador2 < nSeparador1+2 || nSeparador2 > nSeparador1+3 ) {
		return "";
	}
//--------------Modificaciones realizadas a la funci�n original--------------------
	//Comprueba que no hay mas separadores
	var nSeparador3 = cFecha.indexOf( '/', nSeparador2+1 );
	if ( nSeparador3 > nSeparador2 ) {
		return "";
	}
	
//----------------------------------------------------------------------------------	
	// Obtener el mes
	var cMes = cFecha.substring(nSeparador1+1, nSeparador2)
	
	// Obtener el a�o
	var cYear = cFecha.substring(nSeparador2+1, cFecha.length)

	// Normalizaci�n del a�o
	if ( cYear.length == 1 || cYear.length == 3 ) {
		return "";
	}
	if ( cYear.length == 2 ) {
		if ( parseInt( cYear ) > 29 ) {
			cYear = "19" + cYear
		} else {
			cYear = "20" + cYear
		}
	}

	// Comprobaci�n del mes
	if ( cMes < 1 || cMes >12 ) {
		return "";
	}
	
	// Comprobaci�n b�sica del d�a
	if ( cDia < 1 || cDia >31) {
		return "";
	}
	
	// Comprobaci�n del d�a en los meses con 30 d�as
	if ( (cMes==4 || cMes==6 || cMes==9 || cMes==11) && (cDia == 31 ) ) {
		return "";
	}
	
	// Comprobaci�n del mes de febrero teniendo en cuenta los bisiestos	
	if ( cMes==2 ){
		if ( cDia > 29 ) {
			return "";
		}
		if ( ( cYear / 4 == parseInt( cYear / 4 ) )  
		     && ! ( ( cYear / 100 == parseInt( cYear / 100 ) ) 
                         && ( cYear / 400 != parseInt( cYear / 400 ) ) ) ) {
			var bBisiesto = true;
		} else {
			var bBisiesto = false;
		}
		if ( ! bBisiesto && cDia==29 ) {
			return "";
		}
	}
	
	// Normalizaci�n del D�a
	if ( cDia.length == 1 ) { cDia = "0" + cDia; }
	
	// Normalizaci�n del mes
	if ( cMes.length == 1 ) { cMes = "0" + cMes; }
	
	// Retorno de la fecha normalizada
	return ( cDia + "/" + cMes + "/" + cYear );
	
}

//----------------------------------------------------------------------
//
//     Funci�n : FormatoFechaPelada
// Descripci�n : Realiza la transformaci�n/validaci�n de un dato tipo
//               fecha sin separadores
//  Par�metros : Cadena con la fecha a trasformar
//     Retorno : Fecha con un formato ddmmyyyy o una cadena vacia si
//               el formato de entrada no era correcto
//       Notas : - Admite los formatos de entrada siguientes:
//                     ddmmyy
//                     ddmmyyyy 
//               - En el caso de incluir solo dos d�gitos para el a�o,
//                 se interpreta como fecha del a�o 2000 los inferiores 
//                 o igual a 30.
//
//----------------------------------------------------------------------
function FormatoFechaPelada( cFecha ) {
	
	// Comprobaci�n de tama�o
	
	if ( cFecha.length == 6 || cFecha.length ==8 ) { 
	
	// Buscar primer separador de la fecha
	 
	// Obtener el d�a
	var cDia = cFecha.substring(0, 2)
	// Obtener el mes
	var cMes = cFecha.substring(2, 4)
	// Obtener el a�o
	var cYear = cFecha.substring(4, cFecha.length)

	// Normalizaci�n del a�o
	if ( cYear.length == 1 || cYear.length == 3 ) {
		return "";
	}
	if ( cYear.length == 2 ) {
		if ( parseInt( cYear ) > 29 ) {
			cYear = "19" + cYear
		} else {
			cYear = "20" + cYear
		}
	}

	// Comprobaci�n del mes
	if ( cMes < 1 || cMes >12 ) {
		return "";
	}
	
	// Comprobaci�n b�sica del d�a
	if ( cDia < 1 || cDia >31) {
		return "";
	}
	
	// Comprobaci�n del d�a en los meses con 30 d�as
	if ( (cMes==4 || cMes==6 || cMes==9 || cMes==11) && (cDia == 31 ) ) {
		return "";
	}
	
	// Comprobaci�n del mes de febrero teniendo en cuenta los bisiestos	
	if ( cMes==2 ){
		if ( cDia > 29 ) {
			return "";
		}
		if ( ( cYear / 4 == parseInt( cYear / 4 ) )  
		     && ! ( ( cYear / 100 == parseInt( cYear / 100 ) ) 
                         && ( cYear / 400 != parseInt( cYear / 400 ) ) ) ) {
			var bBisiesto = true;
		} else {
			var bBisiesto = false;
		}
		if ( ! bBisiesto && cDia==29 ) {
			return "";
		}
	}
	
	// Normalizaci�n del D�a
	if ( cDia.length == 1 ) { cDia = "0" + cDia; }
	
	// Normalizaci�n del mes
	if ( cMes.length == 1 ) { cMes = "0" + cMes; }
	
	// Retorno de la fecha normalizada
	return ( cDia + "/" + cMes + "/" + cYear );
}
else
{
		return "";
	}
	
}





//----------------------------------------------------------------------
//
//     Funci�n : FormatoFec
// Descripci�n : Realiza la transformaci�n/validaci�n de un dato tipo
//               fecha
//  Par�metros : Cadena con la fecha a trasformar
//     Retorno : Fecha con un formato yyyy,mm,dd o una cadena vacia si
//               el formato de entrada no era correcto
//       Notas : - Admite los formatos de entrada siguientes:
//                     d/m/yy
//                     dd/mm/yy
//                     dd/mm/yyyy 
//               - En el caso de incluir solo dos d�gitos para el a�o,
//                 se interpreta como fecha del a�o 2000 los inferiores 
//                 o igual a 30.
//		 - Es igual que la anterior pero devuelve la fecha separada por "/" y en otro orden	
//----------------------------------------------------------------------
function FormatoFec( cFecha ) {

	// Comprobaci�n de tama�o
	if ( cFecha.length < 6 || cFecha.length > 10 ) { 
		return "";
	}
	
	// Buscar primer separador de la fecha
	var nSeparador1 = cFecha.indexOf ('/');
	if ( nSeparador1 < 1 || nSeparador1 > 2 ) {
		return "";
	}
	
	// Obtener el d�a
	var cDia = cFecha.substring(0, nSeparador1);
	
	// Buscar el segundo separador de la fecha
	var nSeparador2 = cFecha.indexOf( '/', nSeparador1+1 );
	if ( nSeparador2 < nSeparador1+2 || nSeparador2 > nSeparador1+3 ) {
		return "";
	}
	
	// Obtener el mes
	var cMes = cFecha.substring(nSeparador1+1, nSeparador2);
	
	// Obtener el a�o
	var cYear = cFecha.substring(nSeparador2+1, cFecha.length);

	// Normalizaci�n del a�o
	if ( cYear.length == 1 || cYear.length == 3 ) {
		return "";
	}
	if ( cYear.length == 2 ) {
		if ( parseInt( cYear ) > 29 ) {
			cYear = "19" + cYear;
		} else {
			cYear = "20" + cYear;
		}
	}

	// Comprobaci�n del mes
	if ( cMes < 1 || cMes >12 ) {
		return "";
	}
	
	// Comprobaci�n b�sica del d�a
	if ( cDia < 1 || cDia >31) {
		return "";
	}
	
	// Comprobaci�n del d�a en los meses con 30 d�as
	if ( (cMes==4 || cMes==6 || cMes==9 || cMes==11) && (cDia == 31 ) ) {
		return "";
	}
	
	// Comprobaci�n del mes de febrero teniendo en cuenta los bisiestos	
	if ( cMes==2 ){
		if ( cDia > 29 ) {
			return "";
		}
		if ( ( cYear / 4 == parseInt( cYear / 4 ) )  
		     && ! ( ( cYear / 100 == parseInt( cYear / 100 ) ) 
                         && ( cYear / 400 != parseInt( cYear / 400 ) ) ) ) {
			var bBisiesto = true;
		} else {
			var bBisiesto = false;
		}
		if ( ! bBisiesto && cDia==29 ) {
			return "";
		}
	}
	
	// Normalizaci�n del D�a
	if ( cDia.length == 1 ) { cDia = "0" + cDia; }
	
	// Normalizaci�n del mes
	if ( cMes.length == 1 ) { cMes = "0" + cMes; }
	
	// Retorno de la fecha normalizada

	return ( cYear + "/" + cMes + "/" + cDia );
	
}

//----------------------------------------------------------------------
//
//     Funci�n : FormatoSinDecimales
// Descripci�n : Transforma cualquier n�mero a su expresi�n sin 
//               decimales
//  Par�metros : Cadena con en n�mero a tranformar
//     Retorno : N�mero sin decimales o una cadena vacia si no es 
//               posible la trasnformaci�n
//       Notas : - Entiende el "." como el caracter de separaci�n 
//                 decimal.
//               - Si el n�mero tiene separadores de millar, estos son 
//                 ignorados.
//               - Si el n�mero contiene los simbolos "-" o "+" al 
//                 principio de la cadena, son respetados.
//
//----------------------------------------------------------------------
function FormatoSinDecimales( cNumero ) {

	// Realiza la comprobaci�n b�sica de caracteres
	cNumero = FormatoSoloNumericos( cNumero );
	cNumero = FormatoConSigno( cNumero );
	// Eliminamos posibles decimales
	if ( -1 != ( nPosicionComa = cNumero.indexOf(".") ) ) {
		cNumero = cNumero.substring( 0, nPosicionComa );
	}
	return cNumero;
}

//----------------------------------------------------------------------
//
//     Funci�n : FormatoConDecimales
// Descripci�n : Normaliza el uso de decimales
//  Par�metros : Cadena con en n�mero a tranformar
//               N�mero de decimales a respetar
//     Retorno : N�mero con decimales o una cadena vacia si no es 
//               posible la trasnformaci�n
//       Notas : - Entiende la "." como el caracter de separaci�n 
//                 decimal.
//               - Si el n�mero tiene separadores de millar, estos son 
//                 ignorados.
//               - Si el n�mero contiene los simbolos "-" o "+" al 
//                 principio de la cadena, son respetados.
//	Version: 1.1
//     Historia: Si no es num�rico devuelve cadena vac�a, antes devolv�a
//		 un cero seguido de los decimales marcados
//
//----------------------------------------------------------------------
function FormatoConDecimales( cNumero, nDecimales ) {
	// Realiza la comprobaci�n b�sica de caracteres
	//cNumero = FormatoSoloNumericos( cNumero );
	//cNumero = FormatoConSigno( cNumero );

	if (cNumero==""){
		return cNumero;
	}
	else{
		// Obtiene la posici�n de los decimales
		var nPosicionComa = cNumero.indexOf(".");
		if ( -1 == nPosicionComa  ) {
			nPosicionComa = cNumero.length;
		}
	
		// Parte Entera
		var cEntero;
		if ( nPosicionComa > 0 ) {
			cEntero = cNumero.substring( 0 , nPosicionComa );
		} else {
			cEntero = "0";
		}
		
		// Parte Decimal
		var cDecimal;
		if ( nPosicionComa < cNumero.length-1 ) {
			cDecimal = cNumero.substring( nPosicionComa+1 );	
		} else {
			cDecimal = "";
		}
		cDecimal = FormatoSinSigno( FormatoSinMillares( cDecimal ) )
		while ( cDecimal.indexOf( "." ) != -1 ) {
			cDecimal = cDecimal.replace( ".","" )
		}
		
		// Rellenar o truncar la parte decimal
		if ( cDecimal.length > nDecimales ) {
			cDecimal = cDecimal.substring( 0, nDecimales );
		} else { 
			while ( cDecimal.length < nDecimales ) {
				cDecimal += "0";
			}
		}
		
		if (nDecimales == 0)
		{
			return (cEntero);
		}	
		else
		{
			return (cEntero+"."+cDecimal);	
		}	
	}
}



//----------------------------------------------------------------------
//
//     Funci�n : FormatoConSigno
// Descripci�n : Comprueba la posici�n del signo "+"/"-" de un n�mero y
//               deja s�lo el que aparezca al principio de la expresi�n
//  Par�metros : Cadena con en n�mero a tranformar
//     Retorno : N�mero con el signo s�lo al inicio de la cadena o una
//               cadena vacia si hubo errores.
//       Notas : No realiza otro tipo de comprobaciones
//
//----------------------------------------------------------------------
function FormatoConSigno( cNumero ) {

	// Realiza la comprobaci�n b�sica de caracteres
	cNumero = FormatoSoloNumericos( cNumero );

	// Eliminamos cualquier signo posterior al primer caracter
	while( cNumero.indexOf( "+", 1 )  != -1 || cNumero.indexOf( "-", 1 ) != -1 ) {
		cNumero = cNumero.substring(0,1) + cNumero.substring(1).replace( "+", "" ).replace( "-", "" );
	}
	return cNumero
}


//----------------------------------------------------------------------
//
//     Funci�n : FormatoSinSigno
// Descripci�n : Elimina cualquier signo "+"/"-" de un n�mero 
//  Par�metros : Cadena con en n�mero a tranformar
//     Retorno : N�mero con el signo s�lo al inicio de la cadena o una
//               cadena vacia si hubo errores.
//       Notas : No realiza otro tipo de comprobaciones
//
//----------------------------------------------------------------------
function FormatoSinSigno( cNumero ) {

	// Realiza la comprobaci�n b�sica de caracteres
	cNumero = FormatoSoloNumericos( cNumero );

	//----------------------------
	// Eliminamos cualquier signo 
	//----------------------------
	while( cNumero.indexOf( "+", 0 )  != -1 || cNumero.indexOf( "-", 0 ) != -1 ) {
		cNumero = cNumero.replace( "+", "" ).replace( "-", "" );
	}
	return cNumero
}

//----------------------------------------------------------------------
//
//     Funci�n : FormatoSinMillares
// Descripci�n : Elimina los separadores de millar
//  Par�metros : Cadena con en n�mero a tranformar
//     Retorno : N�mero sin separadores o una cadena vacia si hubo 
//               errores.
//       Notas : Considera el caracter "." como el separador de millar
//               No realiza otro tipo de comprobaciones
//
//----------------------------------------------------------------------
function FormatoSinMillares( cNumero ) {

	// Realiza la comprobaci�n b�sica de caracteres
	
	cNumero = FormatoSoloNumericos( cNumero );
	
	

	// Quitamos los puntos
	while( cNumero.indexOf( "," ) != -1 ) {
		cNumero = cNumero.replace( ",", "" );
	}
	return (cNumero);
}

//----------------------------------------------------------------------
//
//     Funci�n : FormatoConMillares
// Descripci�n : Incluye separadores de millar
//  Par�metros : Cadena con en n�mero a tranformar
//     Retorno : N�mero con separadores o una cadena vacia si hubo 
//               errores.
//       Notas : Considera el caracter "." como el separador de millar
//               No realiza otro tipo de comprobaciones
//
//----------------------------------------------------------------------
function FormatoConMillares( cNumero ) {

// Primero se eliminan los millares 
// (incluye una comprobaci�n b�sica de formato)

	cNumero = FormatoSinMillares( cNumero );


// Si el primer caracter es el signo, se ignora
	var cSigno;
	if ( cNumero.charAt(0) == "+" || cNumero.charAt(0) == "-" ) {
		cSigno = cNumero.charAt(0);
		cNumero = cNumero.substring( 1 );
	} else {
		cSigno = "";
	}
	
// Se elimina la parte decimal
	var cDecimal;

	if ( -1 != cNumero.indexOf(".")  ) {
		cDecimal = cNumero.substring( cNumero.indexOf(".") );
		cNumero = cNumero.substring( 0, cNumero.indexOf(".") );

	} 
	else {
		cDecimal = "";
	}

//--------Modificaciones de la funci�n original-----------------
//------Eliminamos los ceros a la izquierda para evitar que al introducir 
//------00000000 devuelva 0,000,000,



var indice;
indice = 0;
 for (i=0 ; i < cNumero.length -1 ;i++)
  {
	if (cNumero.charAt(i) == "0")
	{
		indice = indice + 1;
	} 
	else if(cNumero.charAt(i) == "1" ||
			cNumero.charAt(i) == "2" ||
			cNumero.charAt(i) == "3" ||
			cNumero.charAt(i) == "4" ||
			cNumero.charAt(i) == "5" ||
			cNumero.charAt(i) == "6" ||
			cNumero.charAt(i) == "7" ||
			cNumero.charAt(i) == "8" ||
			cNumero.charAt(i) == "9")
		{
		break;
		}
  }
  
 
    cNumero = cNumero.substring(indice)


	// Situamos los separadores
	var cValorNuevo = "";
	while ( cNumero.length > 3 )
	 { 
		cValorNuevo = "," + cNumero.substring( cNumero.length-3, cNumero.length ) + cValorNuevo;
		cNumero = cNumero.substring( 0, cNumero.length-3 );
	 }


	return (cSigno + cNumero + cValorNuevo + cDecimal);


}


//----------------------------------------------------------------------
//
//     Funci�n : FormatoSoloNumericos
// Descripci�n : Comprobaci�n b�sica de que todos los caracteres de la
//               cadena son s�lo uno de estos "0123456789+-.,"
//  Par�metros : Cadena con en n�mero a tranformar
//     Retorno : N�mero con el signo s�lo al inicio de la cadena o una
//               cadena vacia si hubo errores.
//       Notas : -
//
//----------------------------------------------------------------------
function FormatoSoloNumericos( cNumero ) {

	// Comprueba que s�lo se hayan introducido n�meros
	for ( nPos = 0; nPos < cNumero.length; nPos++ ) {
		var cCaracter = cNumero.charAt( nPos )
		if ( isNaN( parseInt( cCaracter ) ) 
		     && cCaracter != "-"
		     && cCaracter != "+"
		     && cCaracter != "."
		     && cCaracter != "," ) {
			return "";
		}
	}
	return cNumero;
}

//----------------------------------------------------------------------
//    Programa : mascara.js
// Descripci�n : Permite definir una m�nima validaci�n de formato en
//               los campos de entrada
//     Versi�n : 1.01 - Se incopora la opci�n F para fechas
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//
//     Funci�n : Mascara
// Descripci�n : Realiza la validaci�n/transformaci�n de un campo de
//               entrada
//  Par�metros : *  Cadena que indica el tipo de validaci�n o 
//                  transformaci�n que desamos seg�n los siguientes
//                  indicadores:
//                   N Admite s�lo expresiones Num�ricas
//                   D Admite s�lo D�gitos (no admite puntos, espacios
//                     o s�mbolos matem�ticos)
//		     P Porcentajes	
//                   A Admite s�lo caracteres Alfanum�ricos (sin
//                     espacios o s�mbolos de puntuaci�n)
//                   L Admite s�lo Letras (sin espacios o s�mbolos 
//                     de puntuaci�n)
//                   M Convierte la entrada a May�sculas
//                   m Convierte la entrada a min�sculas
//                   S Convierte la entrada a su correspondiente sin 
//                     s�mbolos diacr�ticos, excepto en el caso de
//                     la e�e (��)
//                   F S�lo admite digitos y los caracteres "/" y "-"
//                     se utiliza para fechas
//					 X Admite numeros y ","	
//					 Z Admite letras y espacios en blanco	
//					 E Sexo Solo M Y F
//     Ejemplo : <input type="text" onkeypress="Mascara('MS')">
//       Notas : * En el caso de pasar N y D o A y L s�lo tendr� 
//                 efecto al �ltimo de los valores pasados en el
//                 par�metro
//               * Los valores A, L, M, m, S pueden combinarse
//               * Los valores A, L, M, m, S son incompatibles 
//                 con N, D y F
//
//----------------------------------------------------------------------
function Mascara ( cTipo,evt ){
  var nkeyCode;
  
   if (document.all) {
         nkeyCode = evt.keyCode;
   }else if (evt) {
        nkeyCode = evt.which;
   }

  if (nkeyCode) {
      
    if (nkeyCode == 8) {
        return true;
    }

  for ( nCont = 0; nCont < cTipo.length; nCont++ ) {
    switch ( cTipo.charAt( nCont ) ) {
    case "N":
      if ( isNaN( parseInt( String.fromCharCode( nkeyCode ) ) )
           && String.fromCharCode( nkeyCode ) != "-"
           && String.fromCharCode( nkeyCode ) != "+"
           && String.fromCharCode( nkeyCode ) != ".") {
//           && String.fromCharCode( nkeyCode ) != "," ) {
        return false;
      }
      break;
    case "D":
      if ( isNaN( parseInt( String.fromCharCode( nkeyCode ) ) ) ) {
        return false;
      }
      break;
   case "X":
      if ( isNaN( parseInt( String.fromCharCode( nkeyCode ) ) )
           && String.fromCharCode( nkeyCode ) != "."
           && String.fromCharCode( nkeyCode ) != "-" ) {
        return false;
      }
      break;
	  
   case "P":
      if ( isNaN( parseInt( String.fromCharCode( nkeyCode ) ) )
           && String.fromCharCode( nkeyCode ) != "." ) {
        return false;
      }
      break;
 
    case "F":
      if ( isNaN( parseInt( String.fromCharCode( nkeyCode ) ) )
           && String.fromCharCode( nkeyCode ) != "/"
	           && String.fromCharCode( nkeyCode ) != "-" ) {
        return false;
      }
      break;
    }
  }
  }
 return true;
}
//----------------------------------------------------------------------
//
//     Funcion : formateaCotBis
// Descripci�n : Igual que formateaCot pero recibe un campo de texto como par�metro
//  Par�metros : input. campo de texto
//		         n. n� decimales
//----------------------------------------------------------------------

function formateaCotBIS(input,n)
{
input.value = formateaCot(input.value,n)
}

//----------------------------------------------------------------------
//
//     Funcion : formateaCot
// Descripci�n : Da formato decimal y con millares
//  Par�metros : valor. cadena de texto a la que se dar� formato
//		         n. Numero de decimales en el formato del texto
//     Retorno : cadena de texto con formato decimal y millares
//----------------------------------------------------------------------

function formateaCot(valor,n)
{
cadenaMillar = FormatoConMillares(valor);
cadena = FormatoConDecimales(cadenaMillar,n) ;
return cadena;
}

//----------------------------------------------------------------------
//
//     Funcion : formateaCotSinMillares (idem que formateaCot pero sin 
//               division de millares
// Descripci�n : Da formato decimal y con millares
//  Par�metros : valor. cadena de texto a la que se dar� formato
//		         n. Numero de decimales en el formato del texto
//     Retorno : cadena de texto con formato decimal y millares
//----------------------------------------------------------------------

function formateaCotSinMillares(valor,n)
{
 cadenaMillar = FormatoSinMillares(valor);
 cadena = FormatoConDecimales(cadenaMillar,n) ;
return cadena;
}

function validarCBU (cbu) {
   var VEC1 = new Array(7, 1, 3, 9, 7, 1, 3);
   var VEC2 = new Array(3, 9, 7, 1, 3, 9, 7, 1, 3, 9, 7, 1, 3);
   var valido = false;
     
   bloque1 = cbu.substring(0, 7);
   digitoValidador1 = cbu.substring(7, 8);
   bloque2 = cbu.substring(8, 21);
   digitoValidador2 = cbu.substring(21);

   var acum = 0;
   for (i = 0; i < 7; i++) {
      acum += bloque1.substring(i, i + 1) * VEC1[i];
   }

   strAcum = (acum + '');

   var digitoVCalculado1 = 10 - strAcum.substring(strAcum.length - 1);
   if (digitoVCalculado1 == 10) digitoVCalculado1 = 0;

   valido = (digitoVCalculado1 == digitoValidador1);

   acum = 0;

   for (i = 0; i < 13; i++) {
      acum += bloque2.substring(i, i + 1) * VEC2[i];
   }
   strAcum = (acum + '');

   var digitoVCalculado2 = 10 - strAcum.substring(strAcum.length - 1);
   if (digitoVCalculado2 == 10) digitoVCalculado2 = 0;
   valido = (digitoVCalculado2 == digitoValidador2) && valido;
       
   return valido;
}
