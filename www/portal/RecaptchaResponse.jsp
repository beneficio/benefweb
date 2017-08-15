<%@ page import="net.tanesha.recaptcha.ReCaptchaImpl" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaResponse" %>
    <html>
<link rel="stylesheet" href="/benef/portal/css/main.css">
      <body>
      <%
            String remoteAddr = request.getRemoteAddr();

System.out.println ("entro en RecaptchaResponse");
System.out.println (request.getParameter("recaptcha_challenge_field") );
System.out.println (request.getParameter("recaptcha_response_field"));
System.out.println (remoteAddr);

     if (request.getParameter("recaptcha_challenge_field") == null ) {
          out.print ("&nbsp;");
    %>
          <input type="hidden" name="error" id="error" value="">
<%
      } else {
            ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
            reCaptcha.setPrivateKey("6LcIJvISAAAAAJ_wuDUld3vTjsPQcKOI_VpqywoU");

            String challenge = request.getParameter("recaptcha_challenge_field");
            String uresponse = request.getParameter("recaptcha_response_field");
            ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

            if (! reCaptchaResponse.isValid()) {
              out.print("<span class='result error'>&nbsp;&nbsp;&nbsp;Texto incorrecto, vuelva a intentar</span>");
            }
            %>

            <input type="hidden" name="error" id="error" value="<%=  reCaptchaResponse.isValid() %>">
<%
       }
      %>
      </body>
    </html>