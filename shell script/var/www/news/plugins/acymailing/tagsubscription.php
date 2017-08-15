<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
class plgAcymailingTagsubscription extends JPlugin
{
	function plgAcymailingTagsubscription(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('acymailing', 'tagsubscription');
			$this->params = new JParameter( $plugin->params );
		}
	}
	 function acymailing_getPluginType() {
	 	$onePlugin = null;
	 	$onePlugin->name = JText::_('SUBSCRIPTION');
	 	$onePlugin->function = 'acymailingtagsubscription_show';
	 	$onePlugin->help = 'plugin-tagsubscription';
	 	return $onePlugin;
	 }
	 function acymailingtagsubscription_show(){
		$others = array();
		$others['unsubscribe'] = array('name'=> JText::_('UNSUBSCRIBE_LINK'),'default'=>JText::_('UNSUBSCRIBE',true));
		$others['modify'] = array('name'=> JText::_('MODIFY_SUBSCRIPTION_LINK'), 'default'=>JText::_('MODIFY_SUBSCRIPTION',true));
		$others['confirm'] = array('name'=> JText::_('CONFIRM_SUBSCRIPTION_LINK'), 'default'=>JText::_('CONFIRM_SUBSCRIPTION',true));
?>
		<script language="javascript" type="text/javascript">
		<!--
			var selectedTag = '';
			function changeTag(tagName){
				selectedTag = tagName;
				defaultText = new Array();
<?php
				$k = 0;
				foreach($others as $tagname => $tag){
					echo "document.getElementById('tr_$tagname').className = 'row$k';";
					echo "defaultText['$tagname'] = '".$tag['default']."';";
				}
				$k = 1-$k;
?>
				document.getElementById('tr_'+tagName).className = 'selectedrow';
				document.adminForm.tagtext.value = defaultText[tagName];
				setSubscriptionTag();
			}
			function setSubscriptionTag(){
				setTag('{'+selectedTag+'}'+document.adminForm.tagtext.value+'{/'+selectedTag+'}');
			}
		//-->
		</script>
<?php
		$text = JText::_('TEXT').' : <input name="tagtext" size="100px" onchange="setSubscriptionTag();"><br/><br/>';
		$text .= '<table class="adminlist" cellpadding="1">';
		$k = 0;
		foreach($others as $tagname => $tag){
			$text .= '<tr style="cursor:pointer" class="row'.$k.'" onclick="changeTag(\''.$tagname.'\');" id="tr_'.$tagname.'" ><td>'.$tag['name'].'</td></tr>';
			$k = 1-$k;
		}
		$text .= '</table>';
		echo $text;
	 }
	function acymailing_replaceusertagspreview(&$email,&$user){
		return $this->acymailing_replaceusertags($email,$user);
	}
	function acymailing_replaceusertags(&$email,&$user){
		$match = '#{(modify|confirm|unsubscribe)}(.*){/(modify|confirm|unsubscribe)}#Ui';
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
				$tags[$oneTag] = $this->replaceSubscriptionTag($allresults,$i,$user,$email);
			}
		}
		foreach(array_keys($results) as $var){
			$email->$var = str_replace(array_keys($tags),$tags,$email->$var);
		}
	}
	function replaceSubscriptionTag(&$allresults,$i,&$user,&$email){
		if(empty($user->subid)){
			return '';
		}
		if(empty($user->key)){
			$user->key = md5(substr($user->email,0,strpos($user->email,'@')).time());
			$db = JFactory::getDBO();
			$db->setQuery('UPDATE '.acymailing::table('subscriber').' SET `key`= '.$db->Quote($user->key).' WHERE subid = '.(int) $user->subid.' LIMIT 1');
			$db->query();
		}
		$config = acymailing::config();
		$itemId = $config->get('itemid',0);
		$item = empty($itemId) ? '' : '&Itemid='.$itemId;
		if($allresults[1][$i] == 'confirm'){ //confirm your subscription link
			$myLink = acymailing::frontendLink('index.php?option=com_acymailing&gtask=user&task=confirm&subid='.$user->subid.'&key='.$user->key.$item);
			if(empty($allresults[2][$i])) $allresults[2][$i] = $myLink;
			return '<a target="_blank" href="'.$myLink.'">'.$allresults[2][$i].'</a>';
		}elseif($allresults[1][$i] == 'modify'){ //modify your subscription link
			$myLink = acymailing::frontendLink('index.php?option=com_acymailing&gtask=user&task=modify&subid='.$user->subid.'&key='.$user->key.$item);
			if(empty($allresults[2][$i])) $allresults[2][$i] = $myLink;
			return '<a style="text-decoration:none;" target="_blank" href="'.$myLink.'"><span class="acymailing_unsub">'.$allresults[2][$i].'</span></a>';
		}//unsubscribe link
		$myLink = acymailing::frontendLink('index.php?option=com_acymailing&gtask=user&task=unsub&mailid='.$email->mailid.'&subid='.$user->subid.'&key='.$user->key.$item);
		if(empty($allresults[2][$i])) $allresults[2][$i] = $myLink;
		return '<a style="text-decoration:none;" target="_blank" href="'.$myLink.'"><span class="acymailing_unsub">'.$allresults[2][$i].'</span></a>';
	}
}//endclass