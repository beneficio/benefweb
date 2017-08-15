<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<!--  AcyMailing Module powered by http://www.acyba.com -->
<!--  version <?php echo $config->get('level'); echo ' : '.$config->get('version'); ?> -->
<div class="acymailing_module">
<?php
	$style = array();
	if($params->get('effect','normal') != 'normal'){
		if(!empty($mootoolsIntro)) echo '<p class="acymailing_mootoolsintro">'.$mootoolsIntro.'</p>'; ?>
		<div class="acymailing_mootoolsbutton">
			<?php
			 if($params->get('effect') == 'mootools-slide'){
			 	$link = 'class="acymailing_togglemodule"';
			 }else{
			 	$link = "rel=\"{handler: 'adopt', adopt:'".$formName."', size: {x: ".$params->get('boxwidth',200).", y: ".$params->get('boxheight',150)."}}\" class=\"modal acymailing_togglemodule\"";
			 	$style[] = 'display:none';
			 }
			?>
			<p><a <?php echo $link; ?> id="acymailing_togglemodule_<?php echo $formName; ?>" href="#subscribe"><?php echo $mootoolsButton ?></a></p>
	<?php } ?>
	<?php if($params->get('textalign','none') != 'none') $style[] .= 'text-align:'.$params->get('textalign');
	$styleString = empty($style) ? '' : 'style="'.implode(';',$style).'"';
	?>
	<div class="acymailing_fulldiv" id="acymailing_fulldiv_<?php echo $formName; ?>" <?php echo $styleString; ?> >
		<form id="<?php echo $formName; ?>" action="<?php echo JRoute::_('index.php?option='.ACYMAILING_COMPONENT); ?>" method="post" name="<?php echo $formName ?>">
		<div class="acymailing_module_form">
			<?php $introText = $params->get('introtext'); if(!empty($introText)) echo '<span class="acymailing_introtext">'.$introText.'</span>';?>
			<?php if(!empty($visibleListsArray)){
				if($params->get('dropdown',0)){?>
					<select name="subscription[1]">
						<?php foreach($visibleListsArray as $myListId){?>
						<option value="<?php echo $myListId ?>"><?php echo $allLists[$myListId]->name; ?></option>
						<?php } ?>
					</select>
				<?php }else{?>
			<table class="acymailing_lists">
				<?php foreach($visibleListsArray as $myListId){
					$check = in_array($myListId,$checkedListsArray) ? 'checked="checked"' : '';
					if($params->get('checkmode',0) == '0' AND !empty($_SESSION['acymailing']['user']->email)){
						if(empty($allLists[$myListId])){$check = '';}
						else{
							$check = $allLists[$myListId]->status == '-1' ? '' : $check;
						}
					}
					?>
					<tr>
						<td>
							<input type="checkbox" class="acymailing_checkbox" name="subscription[]" <?php echo $check; ?> value="<?php echo $myListId; ?>"/>
						</td>
						<td>
						<?php
						$joomItem = $config->get('itemid',0);
						$addItem = empty($joomItem) ? '' : '&Itemid='.$joomItem;
						$archivelink = acymailing::completeLink('archive&listid='.$allLists[$myListId]->listid.':'.$allLists[$myListId]->alias.$addItem);
						if($params->get('overlay',0)){
							if(!$params->get('link',1) OR !$allLists[$myListId]->visible) $archivelink = '';
							echo acymailing::tooltip($allLists[$myListId]->description,$allLists[$myListId]->name,'',$allLists[$myListId]->name,$archivelink);
						}else{
							if($params->get('link',1) AND $allLists[$myListId]->visible){
								echo '<a href="'.$archivelink.'">';
							}
							echo $allLists[$myListId]->name;
							if($params->get('link',1) AND $allLists[$myListId]->visible){
								echo '</a>';
							}
						}
						?>
						</td>
					</tr>
				<?php }?>
			</table>
			<?php }//endif dropdown
				}//endif visiblelists ?>
			<table class="acymailing_form">
				<tr>
					<?php if($params->get('showname',1)){
						if($displayOutside) echo '<td><label for="user_name_'.$formName.'">'.$nameCaption.'</label></td>'; ?>
						<td>
						<?php if(!empty($_SESSION['acymailing']['user']->userid)){
							echo $_SESSION['acymailing']['user']->name;
						}else{ ?>
							<input id="user_name_<?php echo $formName; ?>" <?php if(!$displayOutside){ ?> onfocus="if(this.value == '<?php echo $nameCaption;?>') this.value = '';" onblur="if(this.value=='') this.value='<?php echo $nameCaption?>';"<?php } ?> class="inputbox" type="text" name="user[name]" size="<?php echo $params->get('fieldsize',15)?>" value="<?php if(!empty($_SESSION['acymailing']['user']->name)){ echo $_SESSION['acymailing']['user']->name; }elseif(!$displayOutside) echo $nameCaption; ?>"/>
						<?php } ?>
						</td>
						<?php if(!$displayInline) echo '</tr><tr>';
					}?>
					<?php if($displayOutside) echo '<td><label for="user_email_'.$formName.'">'.$emailCaption.'</label></td>'; ?>
					<td>
					<?php if(!empty($_SESSION['acymailing']['user']->userid)){
							echo $_SESSION['acymailing']['user']->email;
						}else{ ?>
						<input id="user_email_<?php echo $formName; ?>" <?php if(!$displayOutside){ ?> onfocus="if(this.value == '<?php echo $emailCaption;?>') this.value = '';" onblur="if(this.value=='') this.value='<?php echo $emailCaption?>';"<?php } ?> class="inputbox" type="text" name="user[email]" size="<?php echo $params->get('fieldsize',15)?>" value="<?php if(!empty($_SESSION['acymailing']['user']->email)){ echo $_SESSION['acymailing']['user']->email; }elseif(!$displayOutside) echo $emailCaption; ?>"/>
					<?php } ?>
					</td>
					<?php if(!$displayInline) echo '</tr><tr>';?>
					<?php if($params->get('showhtml',false)){
						echo '<td ';
						if($displayOutside AND !$displayInline) echo 'colspan="2"';
						echo '>'.JText::_('RECEIVE').JHTML::_('select.booleanlist', "user[html]" ,'',isset($_SESSION['acymailing']['user']->html) ? $_SESSION['acymailing']['user']->html : 1,JText::_('HTML'),JText::_('JOOMEXT_TEXT'),'user_html_'.$formName).'</td>';
						if(!$displayInline) echo '</tr><tr>';
					}?>
				<?php //TERMS AND CONDITIONS
				 if($params->get('showterms',false)){
					$termsIdContent = $params->get('termscontent',0);
					if(empty($termsIdContent)){
						$link = JText::_('JOOMEXT_TERMS');
					}else{
						$url = JRoute::_('index.php?option=com_content&view=article&tmpl=component&id='.$termsIdContent);
						if($params->get('showtermspopup',1) == 1){
							JHTML::_('behavior.modal');
							$link = '<a class="modal" title="'.JText::_('JOOMEXT_TERMS',true).'"  href="'.$url.'" rel="{handler: \'iframe\', size: {x: 650, y: 375}}">'.JText::_('JOOMEXT_TERMS').'</a>';
						}else{
							$link = '<a title="'.JText::_('JOOMEXT_TERMS',true).'"  href="'.$url.'" target="_blank">'.JText::_('JOOMEXT_TERMS').'</a>';
						}
					}
					?>
					<td <?php if($displayOutside AND !$displayInline) echo 'colspan="2"'; ?> >
					<input id="mailingdata_terms_<?php echo $formName; ?>" class="inputbox" type="checkbox" name="terms"/> <?php echo $link;?>
					</td>
					<?php if(!$displayInline) echo '</tr><tr>';
					} ?>
					<td <?php if($displayOutside AND !$displayInline) echo 'colspan="2"'; ?> >
						<?php if($params->get('showsubscribe',true)){?>
						<input class="button" type="submit" value="<?php echo $params->get('subscribetext',JText::_('SUBSCRIBECAPTION')); ?>" name="Submit" onclick="return submitacymailingform('optin','<?php echo $formName;?>')"/>
						<?php }if($params->get('showunsubscribe',false)){?>
						<input class="button" type="button" value="<?php echo $params->get('unsubscribetext',JText::_('UNSUBSCRIBECAPTION')); ?>" name="Submit" onclick="return submitacymailingform('optout','<?php echo $formName;?>')"/>
						<?php } ?>
					</td>
				</tr>
			</table>
			<?php $postText = $params->get('finaltext'); if(!empty($postText)) echo '<span class="acymailing_finaltext">'.$postText.'</span>';?>
			<input type="hidden" name="gtask" value="sub"/>
			<input type="hidden" name="task" value="notask"/>
			<input type="hidden" name="redirect" value="<?php echo urlencode($redirectUrl); ?>"/>
			<input type="hidden" name="redirectunsub" value="<?php echo urlencode($redirectUrlUnsub); ?>"/>
			<input type="hidden" name="option" value="<?php echo ACYMAILING_COMPONENT ?>"/>
			<input type="hidden" name="visiblelists" value="<?php echo $visibleLists;?>"/>
			<input type="hidden" name="hiddenlists" value="<?php echo $hiddenLists;?>"/>
			<?php $myItemId = $config->get('itemid',0); if(empty($myItemId)){ global $Itemid; $myItemId = $Itemid;} if(!empty($myItemId)){ ?><input type="hidden" name="Itemid" value="<?php echo $myItemId;?>"/><?php } ?>
			</div>
		</form>
	</div>
	<?php if($params->get('effect','normal') != 'normal') echo '</div>'; ?>
</div>
<!--  AcyMailing Module powered by http://www.acyba.com -->