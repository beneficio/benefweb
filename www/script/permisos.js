function ValidarAcceso (operacion, estado, tipoUser) {
var ok = false;

    if (operacion == "CONFIRMAR" && (estado == 2 || estado == 5 ) && tipoUser == 0) {
        ok = true;
    }

    if (operacion == "MODIF" && ( estado == 1 || estado == 4 ) && tipoUser > 0) {
        ok = true;
    }
    
    if (operacion == "MODIF" && ( estado == 2 ||  estado == 3 || estado == 5 || estado == 6  || estado == 7) && tipoUser == 0 ) {
        ok = true;
    }

    if (operacion == "RECHAZAR" && ( estado == 2 || estado == 5 ) && tipoUser == 0 ) {
        ok = true;
    }

    if (operacion == "ENVIAR" && ( estado == 1 || estado == 4 ) && tipoUser > 0 ) {
        ok = true;
    }

    if (operacion == "ENVIAR" && ( estado == 2 || estado == 5 ) && tipoUser == 0 ) {
        ok = true;
    }

    if (operacion == "BORRAR" && ( estado == 1 || estado == 4 ) && tipoUser > 0) {
        ok = true;
    }
    
    if (operacion == "BORRAR" && (estado == 1 || estado == 2 || estado == 3 || estado == 4 || estado == 5 || estado == 7 ) && tipoUser == 0 ) {
        ok = true;
    }

    if (operacion == "CONVERTIR" &&  (estado == 2 || estado == 3 || estado == 5 || estado == 6)  && tipoUser == 0 ) {
        ok = true;
    }

    if (operacion == "MODPOL" &&  (estado == 7)  && tipoUser == 0 ) {
        ok = true;
    }

    return ok;
}
