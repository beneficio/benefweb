<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
class plgAcymailingTemplate extends JPlugin
{
	var $templates;
	var $tags;
	var $templateClass = '';
	var $mailer;
	function plgAcymailingTemplate(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('acymailing', 'template');
			$this->params = new JParameter( $plugin->params );
		}
	}
	function acymailing_replaceusertagspreview(&$email,&$user){
		return $this->acymailing_replaceusertags($email,$user);
	}
	function acymailing_replaceusertags(&$email,&$user){
		if(!$email->sendHTML) return;
		$email->body = preg_replace('#<(tr|td|table)([^>]*)(style="[^"]*)background-image *: *url\(\'?([^)\']*)\'?\);?#Ui','<$1 background="$4" $2 $3',$email->body);
		$email->body = acymailing::absoluteURL($email->body);
		if(empty($email->tempid)) return;
		if(!isset($this->templates[$email->tempid])){
			$this->templates[$email->tempid] = array();
			if(empty($this->templateClass)){
				$this->templateClass = acymailing::get('class.template');
			}
			$template = $this->templateClass->get($email->tempid);
			if(empty($template->styles)) return;
			foreach($template->styles as $class => $style){
				if(preg_match('#^tag_(.*)$#',$class,$result)){
					$this->tags[$email->tempid]['#< *'.$result[1].'((?:(?!style).)*)>#Ui'] = '<'.$result[1].' style="'.$style.'" $1>';
				}else{
					$this->templates[$email->tempid]['class="'.$class.'"'] = 'style="'.$style.'"';
				}
			}
		}
		if(!empty($this->templates[$email->tempid])){
			$email->body = str_replace(array_keys($this->templates[$email->tempid]),$this->templates[$email->tempid],$email->body);
		}
		if(!empty($this->tags[$email->tempid])){
			$email->body = preg_replace(array_keys($this->tags[$email->tempid]),$this->tags[$email->tempid],$email->body);
		}
	 }//endfct
}//endclass