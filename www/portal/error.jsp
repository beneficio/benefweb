<html>
<head>
    <title>Pagina de Errores</title>
    <link rel="stylesheet" type="text/css" href="/benef/css/main.css">
    <script>
    
        function cancelPayment() {
   	       window.history.go(-1);
   	    }
        
    </script>
</head>
<body leftmargin="0" topmargin="0" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="250">
    <tr>
        <td width='100%' height='50' valign="middle" align="center" colspan='2'>
            <font color='#ff0000' size='3'><B>SE PRODUJO UN ERROR</B></font>
        </td>
    </tr>
    <tr>
        <td width='10%'>&nbsp;</td>
        <TD width="80%" valign="top" align="center" height='250'>
            <table width="100%"  cellspacing="2" cellpadding="5" border='0'  style="border-top:2pt solid #FF0000 ; border-left:1pt solid #FF0000 ;">
                <tr>
                    <td width='70' valign="top" align="center" ><img src='/benef/images/icon_error_lrg.gif' alt='Error'></td>
                    <td  valign='top' align='left' width='500'>
	                    <font color='#747474 ' size='2'>
		                    <p align='left'>
								<br><br>
			                    Por favor, si el problema persiste contactarse
			                    con su representante en Beneficio o vuelva a intertar 
			                    más tarde.<br><br>Gracias<br>
			                </p>
		                    <br>
	                    </font>     
	                    <br>
	                    <br>
                    </td>
                </tr>
                <tr>
                    <td height='50' valign="middle" align="center" colspan='2'>
                    <input type="button" onClick="cancelPayment()" name="cmdSalir" value="Volver" width="80px" height="20px" class="boton">
                    </td>
                </tr>
            </table>
        </TD>
        <td width='10%'>&nbsp;</td>
    </tr>
</table>
</body>
</html>