<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
class plgAcymailingTagtime extends JPlugin
{
	function plgAcymailingTagtime(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('acymailing', 'tagtime');
			$this->params = new JParameter( $plugin->params );
		}
	}
	 function acymailing_getPluginType() {
	 	$onePlugin = null;
	 	$onePlugin->name = JText::_('TIME');
	 	$onePlugin->function = 'acymailingtagtime_show';
	 	$onePlugin->help = 'plugin-tagtime';
	 	return $onePlugin;
	 }
	 function acymailingtagtime_show(){
		$text = '<table class="adminlist" cellpadding="1">';
		$others = array();
		$others['{date}'] = 'DATE_FORMAT_LC';
		$others['{date:1}'] = 'DATE_FORMAT_LC1';
		$others['{date:2}'] = 'DATE_FORMAT_LC2';
		$others['{date:3}'] = 'DATE_FORMAT_LC3';
		$others['{date:4}'] = 'DATE_FORMAT_LC4';
		$k = 0;
		foreach($others as $tagname => $tag){
			$text .= '<tr style="cursor:pointer" class="row'.$k.'" onclick="setTag(\''.$tagname.'\');insertTag();" ><td>'.$tag.'</td><td>'.acymailing::getDate(time(),JText::_($tag)).'</td></tr>';
			$k = 1-$k;
		}
		$text .= '</table>';
		echo $text;
	 }
	function acymailing_replacetags(&$email){
		$match = '#{date:?([^:]*)}#Ui';
		$variables = array('subject','body','altbody');
		$found = false;
		foreach($variables as $var){
			if(empty($email->$var)) continue;
			$found = preg_match_all($match,$email->$var,$results[$var]) || $found;
			if(empty($results[$var][0])) unset($results[$var]);
		}
		if(!$found) return;
		$tags = array();
		foreach($results as $var => $allresults){
			foreach($allresults[0] as $i => $oneTag){
				if(isset($tags[$oneTag])) continue;
				$tags[$oneTag] = acymailing::getDate(time(),JText::_('DATE_FORMAT_LC'.$allresults[1][$i]));
			}
		}
		foreach(array_keys($results) as $var){
			$email->$var = str_replace(array_keys($tags),$tags,$email->$var);
		}
	}
}//endclass