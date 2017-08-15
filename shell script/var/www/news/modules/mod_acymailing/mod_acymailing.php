<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
if(!include_once(rtrim(JPATH_ADMINISTRATOR,DS).DS.'components'.DS.'com_acymailing'.DS.'helpers'.DS.'helper.php')){
	echo 'This module can not work without the AcyMailing Component';
	return;
};
$formName = acymailing::initModule();
switch($params->get('redirectmode','0')){
  case 1 :
    $redirectUrl = acymailing::completeLink('lists',false,true);
    $redirectUrlUnsub = $redirectUrl;
    break;
  case 2 :
    $redirectUrl = $params->get('redirectlink');
    $redirectUrlUnsub = $params->get('redirectlinkunsub');
    break;
  default :
	$redirectUrl = (empty($_SERVER['HTTPS']) ? 'http://' : 'https://').$_SERVER["HTTP_HOST"].$_SERVER["REQUEST_URI"];
	$redirectUrlUnsub = $redirectUrl;
}
$userClass = acymailing::get('class.subscriber');
$connectedUser =& JFactory::getUser();
if(!empty($connectedUser->email)){
	$_SESSION['acymailing']['user'] = $userClass->get($connectedUser->email);
}
$visibleLists = $params->get('lists','None');
$hiddenLists = $params->get('hiddenlists','All');
$visibleListsArray = array();
$hiddenListsArray = array();
$listsClass = acymailing::get('class.list');
if(empty($_SESSION['acymailing']['user']->subid)){
	$allLists = $listsClass->getLists('listid');
}else{
	$allLists = $userClass->getSubscription($_SESSION['acymailing']['user']->subid,'listid');
}
if(acymailing::level(1)){
	$allLists = $listsClass->onlyCurrentLanguage($allLists);
}
if(acymailing::level(3)){
	$my = JFactory::getUser();
	foreach($allLists as $listid => $oneList){
		if(!$allLists[$listid]->published) continue;
		if($oneList->access_sub == 'all') continue;
		if($oneList->access_sub == 'none' OR empty($my->id) OR empty($my->gid)){
			$allLists[$listid]->published = false;
			continue;
		}
		if(!in_array($my->gid,explode(',',$oneList->access_sub))){
			$allLists[$listid]->published = false;
			continue;
		}
	}
}
if(strpos($visibleLists,',') OR is_numeric($visibleLists)){
	$allvisiblelists = explode(',',$visibleLists);
	foreach($allLists as $oneList){
		if($oneList->published AND in_array($oneList->listid,$allvisiblelists)) $visibleListsArray[] = $oneList->listid;
	}
}elseif(strtolower($visibleLists) == 'all'){
	foreach($allLists as $oneList){
		if($oneList->published){$visibleListsArray[] = $oneList->listid;}
	}
}
if(strpos($hiddenLists,',') OR is_numeric($hiddenLists)){
	$allhiddenlists = explode(',',$hiddenLists);
	foreach($allLists as $oneList){
		if($oneList->published AND in_array($oneList->listid,$allhiddenlists)) $hiddenListsArray[] = $oneList->listid;
	}
}elseif(strtolower($hiddenLists) == 'all'){
	$visibleListsArray = array();
	foreach($allLists as $oneList){
		if(!empty($oneList->published)){$hiddenListsArray[] = $oneList->listid;}
	}
}
if(!empty($visibleListsArray) AND !empty($hiddenListsArray)){
	$visibleListsArray =  array_diff($visibleListsArray, $hiddenListsArray);
}
$visibleLists = $params->get('dropdown',0) ? '' : implode(',',$visibleListsArray);
$hiddenLists = implode(',',$hiddenListsArray);
$checkedLists = $params->get('listschecked','All');
if(strtolower($checkedLists) == 'all'){ $checkedListsArray = $visibleListsArray;}
elseif(strpos($checkedLists,',') OR is_numeric($checkedLists)){ $checkedListsArray = explode(',',$checkedLists);}
else{ $checkedListsArray = array();}
$nameCaption = $params->get('nametext',JText::_('NAMECAPTION'));
$emailCaption = $params->get('emailtext',JText::_('EMAILCAPTION'));
$displayOutside = $params->get('displayfields',0);
$displayInline = ($params->get('displaymode','vertical') == 'vertical') ? false : true;
$config = acymailing::config();
if($params->get('effect') != 'normal'){
	$mootoolsButton = $params->get('mootoolsbutton','');
	if(empty($mootoolsButton)) $mootoolsButton = JText::_('SUBSCRIBE');
	$mootoolsIntro = $params->get('mootoolsintro','');
	$doc =& JFactory::getDocument();
	if($params->get('effect') == 'mootools-slide'){
		JHTML::script('mootools.js', ACYMAILING_LIVE .'media/system/js/');
		$js = "<!--
				window.addEvent('domready', function(){
					var mySlide = new Fx.Slide('acymailing_fulldiv_$formName');
					mySlide.hide();
					$('acymailing_togglemodule_$formName').addEvent('click', function(e){
						e = new Event(e);
						mySlide.toggle();
						e.stop();
					});
				});
				//-->";
		$doc->addScriptDeclaration( $js );
	}else{
		JHTML::_('behavior.modal');
	}
}
if($params->get('overlay',0)){
	JHTML::_('behavior.tooltip');
}
require(JModuleHelper::getLayoutPath('mod_acymailing'));
