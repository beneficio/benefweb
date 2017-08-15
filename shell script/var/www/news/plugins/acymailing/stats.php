<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
class plgAcymailingStats extends JPlugin
{
	function plgAcymailingStats(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('acymailing', 'stats');
			$this->params = new JParameter( $plugin->params );
		}
    }
	function acymailing_replaceusertagspreview(&$email,&$user){
		$widthsize = $this->params->get('width',50);
		$heightsize = $this->params->get('height',1);
		$width = empty($widthsize) ? '' : ' width="'.$widthsize.'" ';
		$height = empty($heightsize) ? '' : ' height="'.$heightsize.'" ';
		$statPicture = '<img alt="" src="'.ACYMAILING_LIVE.$this->params->get('picture','components/com_acymailing/images/statpicture.png').'"  border="0" '.$height.$width.'/>';
		$email->body = str_replace(array('{statpicture}','{nostatpicture}'),array($statPicture,''),$email->body);
		if(!empty($email->altbody)){
			$email->altbody = str_replace(array('{statpicture}','{nostatpicture}'),'',$email->altbody);
		}
		return;
	}
	function acymailing_replaceusertags(&$email,&$user){
		if(!$email->sendHTML){
			$email->body = str_replace(array('{statpicture}','{nostatpicture}'),'',$email->body);
			return;
		}
		if(empty($user->subid)){
			return $this->acymailing_replaceusertagspreview($email,$user);
		}
		if(!empty($email->altbody)){
			$email->altbody = str_replace(array('{statpicture}','{nostatpicture}'),'',$email->altbody);
		}
		if(strpos($email->body,'{nostatpicture}')){
			$email->body = str_replace('{nostatpicture}','',$email->body);
			return;
		}

		$widthsize = $this->params->get('width',50);
		$heightsize = $this->params->get('height',1);
		$width = empty($widthsize) ? '' : ' width="'.$widthsize.'" ';
		$height = empty($heightsize) ? '' : ' height="'.$heightsize.'" ';
		$statPicture = '<img alt="" src="'.acymailing::frontendLink('index.php?option=com_acymailing&gtask=stats&mailid='.$email->mailid.'&subid='.$user->subid).'"  border="0" '.$height.$width.'/>';
		if(strpos($email->body,'{statpicture}')) $email->body = str_replace('{statpicture}',$statPicture,$email->body);
		else $email->body .= $statPicture;
	 }//endfct
	 function acymailing_getstatpicture(){
	 	return $this->params->get('picture','components/com_acymailing/images/statpicture.png');
	 }
}//endclass