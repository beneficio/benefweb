<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
jimport('joomla.plugin.plugin');
class plgUserAcymailing extends JPlugin{
	function plgUserAcymailing(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('user', 'acymailing');
			$this->params = new JParameter( $plugin->params );
		}
    }
	function onBeforeStoreUser($user, $isnew){
		$this->oldUser = $user;
		return true;
	}
	function onAfterStoreUser($user, $isnew, $success, $msg){
		if($success===false) return false;
		if(!include_once(rtrim(JPATH_ADMINISTRATOR,DS).DS.'components'.DS.'com_acymailing'.DS.'helpers'.DS.'helper.php')) return true;
		$joomUser = null;
		$joomUser->email = trim(strip_tags($user['email']));
		if(!empty($user['name'])) $joomUser->name = trim(strip_tags($user['name']));
		if(empty($user['block'])) $joomUser->confirmed = 1;
		$joomUser->enabled = 1 - (int)$user['block'];
		$joomUser->userid = $user['id'];
		$userClass = acymailing::get('class.subscriber');
		if(!$isnew AND !empty($this->oldUser['email']) AND $user['email'] != $this->oldUser['email']){
			$joomUser->subid = $userClass->subid($this->oldUser['email']);
		}
		$userClass->checkVisitor = false;
		$userClass->sendConf = false;
		$subid = $userClass->save($joomUser);
		if($isnew){
			$listsToSubscribe = $this->params->get('lists','all');
			$currentSubscription = $userClass->getSubscriptionStatus($subid);
			$config = acymailing::config();
			$listsClass = acymailing::get('class.list');
			$allLists = $listsClass->getLists('listid');
			if(acymailing::level(1)){
				$allLists = $listsClass->onlyCurrentLanguage($allLists);
			}
			$listsArray = array();
			if(strpos($listsToSubscribe,',') OR is_numeric($listsToSubscribe)){
				$listsArrayParam = explode(',',$listsToSubscribe);
				foreach($allLists as $oneList){
					if($oneList->published AND in_array($oneList->listid,$listsArrayParam)){$listsArray[] = $oneList->listid;}
				}
			}elseif(strtolower($listsToSubscribe) == 'all'){
				foreach($allLists as $oneList){
					if($oneList->published){$listsArray[] = $oneList->listid;}
				}
			}
			$statusAdd = (empty($joomUser->confirmed) AND $config->get('require_confirmation',false)) ? 2 : 1;
			if(!empty($listsArray)){
				foreach($listsArray as $idOneList){
					if(!isset($currentSubscription[$idOneList])){
						$addlists[$statusAdd][] = $idOneList;
					}
				}
			}
			if(!empty($addlists)) {
				$listsubClass = acymailing::get('class.listsub');
				$listsubClass->addSubscription($subid,$addlists);
			}
		}else{
			if(!empty($this->oldUser['block']) AND !empty($joomUser->confirmed)){
				$userClass->confirmSubscription($subid);
			}
		}
		return true;
	}
	function onAfterDeleteUser($user, $success, $msg){
		if($success===false) return false;
		if(!include_once(rtrim(JPATH_ADMINISTRATOR,DS).DS.'components'.DS.'com_acymailing'.DS.'helpers'.DS.'helper.php')) return true;
		$userClass = acymailing::get('class.subscriber');
		$subid = $userClass->subid($user['email']);
		if(!empty($subid)){
			$userClass->delete($subid);
		}
		return true;
	}
}
