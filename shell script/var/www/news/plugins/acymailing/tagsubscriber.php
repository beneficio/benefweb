<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
class plgAcymailingTagsubscriber extends JPlugin
{
	function plgAcymailingTagsubscriber(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('acymailing', 'tagsubscriber');
			$this->params = new JParameter( $plugin->params );
		}
    }
	 function acymailing_getPluginType() {
	 	$onePlugin = null;
	 	$onePlugin->name = JText::_('Subscriber');
	 	$onePlugin->function = 'acymailingtagsubscriber_show';
	 	$onePlugin->help = 'plugin-tagsubscriber';
	 	return $onePlugin;
	 }
	 function acymailingtagsubscriber_show(){
	 	$descriptions['subid'] = JText::_('ID of the subscriber');
	 	$descriptions['email'] = JText::_('Email of the subscriber');
	 	$descriptions['name'] = JText::_('Name of the subscriber');
	 	$descriptions['userid'] = JText::_('ID of the subscriber in the Joomla User table');
	 	$descriptions['ip'] = JText::_('IP of the subscriber when he opted in');
	 	$descriptions['created'] = JText::_('Creation date of the subscriber');
		$text = '<table class="adminlist" cellpadding="1">';
		$db =& JFactory::getDBO();
		$tableInfos = $db->getTableFields(acymailing::table('subscriber'));
		$others = array();
		$others['{subtag:name|part:first}'] = array('name'=> JText::_('First part of the subscriber name'), 'desc'=>JText::_('First part of the subscriber name (the first part of the subscriber "John Doe" is "John")'));
		$others['{subtag:name|part:last}'] = array('name'=> JText::_('Last part of the subscriber name'), 'desc'=>JText::_('Last part of the subscriber name (the last part of the subscriber "John Doe" is "Doe")'));
		$k = 0;
		$fields = reset($tableInfos);
		foreach($fields as $fieldname => $oneField){
			if(!isset($descriptions[$fieldname]) AND $oneField != 'varchar') continue;
			$type = '';
			if($fieldname == 'created') $type = '|type:time';
			$text .= '<tr style="cursor:pointer" class="row'.$k.'" onclick="setTag(\'{subtag:'.$fieldname.$type.'}\');insertTag();" ><td>'.$fieldname.'</td><td>'.@$descriptions[$fieldname].'</td></tr>';
			$k = 1-$k;
		}
		foreach($others as $tagname => $tag){
			$text .= '<tr style="cursor:pointer" class="row'.$k.'" onclick="setTag(\''.$tagname.'\');insertTag();" ><td>'.$tag['name'].'</td><td>'.$tag['desc'].'</td></tr>';
			$k = 1-$k;
		}
		$text .= '</table>';
		echo $text;
	 }
	function acymailing_replaceusertagspreview(&$email,&$user){
		return $this->acymailing_replaceusertags($email,$user);
	}
	function acymailing_replaceusertags(&$email,&$user){
		$match = '#{subtag:(.*)}#Ui';
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
				$tags[$oneTag] = $this->replaceSubTag($allresults,$i,$user);
			}
		}
		foreach(array_keys($results) as $var){
			$email->$var = str_replace(array_keys($tags),$tags,$email->$var);
		}
	}
	function replaceSubTag(&$allresults,$i,&$user){
		$arguments = explode('|',$allresults[1][$i]);
		$field = $arguments[0];
		unset($arguments[0]);
		$mytag = null;
		$mytag->default = $this->params->get('default_'.$field,'');
		if(!empty($arguments)){
			foreach($arguments as $onearg){
				$args = explode(':',$onearg);
				if(isset($args[1])){
					$mytag->$args[0] = $args[1];
				}else{
					$mytag->$args[0] = 1;
				}
			}
		}
		$replaceme = isset($user->$field) ? $user->$field : $mytag->default;
		if(!empty($mytag->part)){
			$parts = explode(' ',$replaceme);
			if($mytag->part == 'last'){
				$replaceme = count($parts)>1 ? end($parts) : '';
			}else{
				$replaceme = reset($parts);
			}
		}
		if(!empty($mytag->type)){
			if($mytag->type == 'date'){
				$replaceme = acymailing::getDate(strtotime($replaceme));
			}elseif($mytag->type == 'time'){
				$replaceme = acymailing::getDate($replaceme);
			}
		}
		return $replaceme;
	}
}//endclass