package ar.com.beneficio.utilities;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;

import com.business.beans.MercadoPago;
import com.business.beans.PersonaPoliza;

import ar.com.beneficio.mvc.json.EndosoPayment;

public class MailSender {

	private static Logger log = Logger.getLogger(MailSender.class);

	/**
	 * 
	 * Metodo encargado de enviar mail
	 * 
	 * @param smtpHost
	 * @param from
	 * @param to
	 * @param copyTo
	 * @param blindCopyTo
	 * @param subject
	 * @param messageText
	 * @return
	 * @throws Exception
	 */
	public boolean sendMessage(String smtpHost, String from, List<String> to,
			List<String> copyTo, String blindCopyTo, String subject,
			MercadoPago mp, List<EndosoPayment> endosoList) throws Exception {

		log.info("--> sendMessage BEGIN");

		boolean isSendOk = true;

		try {
			Properties props = System.getProperties();
			props.put("mail.smtp.host", smtpHost);
			Session session = Session.getDefaultInstance(props, null);
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(from));
			message.setSubject(subject);

			if(to != null) {
				for (Iterator<String> itTo = to.iterator(); itTo.hasNext();) {
					message.addRecipient(Message.RecipientType.TO, new InternetAddress((String) itTo.next()));
				}
			}

			if (copyTo != null) {
				for (Iterator<String> itCopyTo = copyTo.iterator(); itCopyTo.hasNext();) {
					message.addRecipient(Message.RecipientType.CC, new InternetAddress((String) itCopyTo.next()));
				}
			}

			MimeBodyPart bodyTemplate = new MimeBodyPart();
			String templateHTML = null;

			StringBuffer sb = new StringBuffer();
			String templateName = "/tca-mail-template.html";
			InputStream in = MailSender.class.getResourceAsStream(templateName);

			BufferedReader entrada = new BufferedReader(new InputStreamReader(in));
			String line = entrada.readLine();
			while (line != null) {
				sb.append(line);
				line = entrada.readLine();
			}

			// Replacing values on html template
			
			templateHTML = sb.toString();
			
			PersonaPoliza tomador = mp.getoTomador();
			
			templateHTML = templateHTML.replaceAll("%rama%", mp.getdescRama());
			templateHTML = templateHTML.replaceAll("%poliza%", String.valueOf(mp.getnumPoliza()));
			templateHTML = templateHTML.replaceAll("%tomador%", tomador.getrazonSocial());
			
			if(tomador.gettipoDoc() == "80") {
				templateHTML = templateHTML.replaceAll("%cuit%", tomador.getcuit());
			}else{
				templateHTML = templateHTML.replaceAll("%cuit%", tomador.getnumDoc());
			}
			
			for (int i = 0; i < endosoList.size(); i++) {
				templateHTML = templateHTML.replaceAll("%show%"+i, "block");
				templateHTML = templateHTML.replaceAll("%rama%"+i, String.valueOf(endosoList.get(i).getRamaCode()));
				templateHTML = templateHTML.replaceAll("%poliza%"+i, String.valueOf(endosoList.get(i).getNroPoliza()));
				templateHTML = templateHTML.replaceAll("%endoso%"+i, String.valueOf(endosoList.get(i).getNroEndoso()));
				templateHTML = templateHTML.replaceAll("%vigencia%"+i, endosoList.get(i).getVigencia());
				templateHTML = templateHTML.replaceAll("%premio%"+i, endosoList.get(i).getPremio());
				templateHTML = templateHTML.replaceAll("%saldo%"+i, String.valueOf(endosoList.get(i).getImporteEndoso()));
			}
			
			bodyTemplate.setText(templateHTML, "UTF-8", "html");
			
			BodyPart adjuntoLogo = new MimeBodyPart();
			URL resourceLienzo = this.getClass().getResource("/images/bnf_web_logo.png");
			DataHandler al = new DataHandler(resourceLienzo);
			adjuntoLogo.setDataHandler(al);
			adjuntoLogo.setFileName("bnf_web_logo.png");
			MimeMultipart mimeMultipart = new MimeMultipart();
			
			mimeMultipart.addBodyPart(bodyTemplate);
			mimeMultipart.addBodyPart(adjuntoLogo);
			message.setContent(mimeMultipart);
			Transport.send(message);

			log.info("--> sendMessage END");
		} catch (Exception e) {
			log.error("*** ERROR sendMessage ***", e);
			e.printStackTrace();
			isSendOk = false;
		}
		return isSendOk;
	}

}