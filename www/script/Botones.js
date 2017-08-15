function SoltarIcono(elemento)
{
    elemento.style.borderBottom="buttonshadow 1px solid";
    elemento.style.borderLeft="buttonhighlight 1px solid";
    elemento.style.borderRight="buttonshadow 1px solid";
    elemento.style.borderTop="buttonhighlight 1px solid";
	window.status = elemento.Mensaje;
}
function ApretarIcono(elemento)
{
    elemento.style.borderBottom="buttonhighlight 1px solid";
    elemento.style.borderLeft="buttonshadow 1px solid";
    elemento.style.borderRight="buttonhighlight 1px solid";
    elemento.style.borderTop="buttonshadow 1px solid";
}
function LimpiarIcono(elemento)
{
    elemento.style.borderBottom="buttonface 1px solid";
    elemento.style.borderLeft="buttonface 1px solid";
    elemento.style.borderRight="buttonface 1px solid";
    elemento.style.borderTop="buttonface 1px solid";
	window.status = "";
}

function home()
{
}

function Redirect(sUrl) {
	var lRespuesta
	var bPregunto
	var sHref
        alert ("entro en Redirect");
	sHref = top.frames['central'].location;
//	sHref = window.parent.frames("central").location.href;

	switch (sUrl) {
       		case "/logout.jsp" :
               		window.parent.navigate(sUrl);
			break;
		default :
                        top.frames['central'].location=sUrl;
//			window.parent.frames("central").navigate(sUrl);
		}
}