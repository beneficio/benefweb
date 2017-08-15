    function AbrirPopUp (sUrl , W , H ) {

        var winModalWindow;
        
            LeftPosition = (screen.width) ? (screen.width - W) / 2 : 0;
            TopPosition = (screen.height) ? (screen.height- H) / 2 : 0;
            if (! document.all) {
                window.top.captureEvents (Event.CLICK|Event.FOCUS);
                window.top.onfocus=HandleFocus (winModalWindow);
                winModalWindow= window.open (sUrl, "ModalChild", "dependent=yes , screenX=" + LeftPosition + ",screenY=" + TopPosition + ",width=" + W + ",height=" + H + ",scrollbars=yes");
            }  else {
                winModalWindow= window.open (sUrl, "ModalChild", "dependent=yes , left=" + LeftPosition + ",top=" + TopPosition + ",width=" + W + ",height=" + H + ",scrollbars=yes");
            }
            return true;
    }      

    function HandleFocus (winModalWindow) {
        if (winModalWindow) {
            if (!winModalWindow.closed) {
                winModalWindow.focus ();
            } else {
                window.top.releaseEvents (Event.CLICK|Event.FOCUS);
            }
        }
        return true;
    }
