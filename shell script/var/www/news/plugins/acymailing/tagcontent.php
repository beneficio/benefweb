<?php
/**
 * @copyright	Copyright (C) 2009 ACYBA SARL - All rights reserved.
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL
 */
defined('_JEXEC') or die('Restricted access');
?>
<?php
class plgAcymailingTagcontent extends JPlugin
{
	function plgAcymailingTagcontent(&$subject, $config){
		parent::__construct($subject, $config);
		if(!isset($this->params)){
			$plugin =& JPluginHelper::getPlugin('acymailing', 'tagcontent');
			$this->params = new JParameter( $plugin->params );
		}
    }
	 function acymailing_getPluginType() {
	 	$onePlugin = null;
	 	$onePlugin->name = JText::_('JOOMLA_CONTENT');
	 	$onePlugin->function = 'acymailingtagcontent_show';
	 	$onePlugin->help = 'plugin-tagcontent';
	 	return $onePlugin;
	 }
	 function acymailingtagcontent_show(){
		$app =& JFactory::getApplication();
		$pageInfo = null;
		$paramBase = ACYMAILING_COMPONENT.'.tagcontent';
		$pageInfo->filter->order->value = $app->getUserStateFromRequest( $paramBase.".filter_order", 'filter_order',	'a.id','cmd' );
		$pageInfo->filter->order->dir	= $app->getUserStateFromRequest( $paramBase.".filter_order_Dir", 'filter_order_Dir',	'desc',	'word' );
		$pageInfo->search = $app->getUserStateFromRequest( $paramBase.".search", 'search', '', 'string' );
		$pageInfo->search = JString::strtolower( $pageInfo->search );
		$pageInfo->filter_cat = $app->getUserStateFromRequest( $paramBase.".filter_cat", 'filter_cat','','int' );
		$pageInfo->contenttype = $app->getUserStateFromRequest( $paramBase.".contenttype", 'contenttype','|type:intro','string' );
		$pageInfo->author = $app->getUserStateFromRequest( $paramBase.".author", 'author','','string' );
		$pageInfo->titlelink = $app->getUserStateFromRequest( $paramBase.".titlelink", 'titlelink','|link','string' );
		$pageInfo->lang = $app->getUserStateFromRequest( $paramBase.".lang", 'lang','','string' );
		$pageInfo->limit->value = $app->getUserStateFromRequest( $paramBase.'.list_limit', 'limit', $app->getCfg('list_limit'), 'int' );
		$pageInfo->limit->start = $app->getUserStateFromRequest( $paramBase.'.limitstart', 'limitstart', 0, 'int' );
		$database =& JFactory::getDBO();
		$searchFields = array('a.id','a.title','a.alias','a.created_by','b.name','b.username');
		if(!empty($pageInfo->search)){
			$searchVal = '\'%'.$database->getEscaped($pageInfo->search,true).'%\'';
			$filters[] = implode(" LIKE $searchVal OR ",$searchFields)." LIKE $searchVal";
		}
		if(!empty($pageInfo->filter_cat)){
			$filters[] = "a.catid = ".$pageInfo->filter_cat;
		}
		if($this->params->get('displayart','all') == 'onlypub'){
			$filters[] = "a.state = 1";
		}
		$whereQuery = '';
		if(!empty($filters)){
			$whereQuery = ' WHERE ('.implode(') AND (',$filters).')';
		}
		$query = 'SELECT SQL_CALC_FOUND_ROWS a.id,a.title,a.alias,a.catid,a.sectionid,b.name,b.username,a.created_by FROM '.acymailing::table('content',false).' as a';
		$query .=' LEFT JOIN `#__users` AS b ON b.id = a.created_by';
		if(!empty($whereQuery)) $query.= $whereQuery;
		if(!empty($pageInfo->filter->order->value)){
			$query .= ' ORDER BY '.$pageInfo->filter->order->value.' '.$pageInfo->filter->order->dir;
		}
		$database->setQuery($query,$pageInfo->limit->start,$pageInfo->limit->value);
		$rows = $database->loadObjectList();
		if(!empty($pageInfo->search)){
			$rows = acymailing::search($pageInfo->search,$rows);
		}
		$database->setQuery('SELECT FOUND_ROWS()');
		$pageInfo->elements->total = $database->loadResult();
		$pageInfo->elements->page = count($rows);
		jimport('joomla.html.pagination');
		$pagination = new JPagination( $pageInfo->elements->total, $pageInfo->limit->start, $pageInfo->limit->value );
	?>
		<script language="javascript" type="text/javascript">
		<!--
			var selectedContents = new Array();
			function applyContent(contentid,rowClass){
				if(selectedContents[contentid]){
					window.document.getElementById('content'+contentid).className = rowClass;
					delete selectedContents[contentid];
				}else{
					window.document.getElementById('content'+contentid).className = 'selectedrow';
					selectedContents[contentid] = 'content';
				}
				updateTag();
			}
			function updateTag(){
				var tag = '';
				var otherinfo = '';
				for(var i=0; i < document.adminForm.contenttype.length; i++){
				   if (document.adminForm.contenttype[i].checked){ otherinfo += document.adminForm.contenttype[i].value; }
				}
				for(var i=0; i < document.adminForm.titlelink.length; i++){
				   if (document.adminForm.titlelink[i].checked){ otherinfo += document.adminForm.titlelink[i].value; }
				}
				for(var i=0; i < document.adminForm.author.length; i++){
				   if (document.adminForm.author[i].checked){ otherinfo += document.adminForm.author[i].value; }
				}
				if(window.document.getElementById('jflang')  && window.document.getElementById('jflang').value != ''){
					otherinfo += '|lang:';
					otherinfo += window.document.getElementById('jflang').value;
				}
				for(var i in selectedContents){
					if(selectedContents[i] == 'content'){
						tag = tag + '{joomlacontent:'+i+otherinfo+'}<br/>';
					}
				}
				setTag(tag);
			}
		//-->
		</script>
		<table width="100%" class="adminform">
			<tr>
				<td>
					<?php echo JText::_('DISPLAY');?>
				</td>
				<td>
				<?php $contentType = acymailing::get('type.content'); echo $contentType->display('contenttype',$pageInfo->contenttype);?>
				</td>
				<td>
				</td>
				<td>
				<?php $jflanguages = acymailing::get('type.jflanguages');
						$jflanguages->onclick = 'onchange="updateTag();"';
						echo $jflanguages->display('lang',$pageInfo->lang); ?>
				</td>
			</tr>
			<tr>
				<td>
				<?php echo JText::_('CLICKABLE_TITLE'); ?>
				 </td>
				 <td>
				 	<?php $titlelinkType = acymailing::get('type.titlelink'); echo $titlelinkType->display('titlelink',$pageInfo->titlelink);?>
				</td>
				<td>
				<?php echo JText::_('AUTHOR_NAME'); ?>
				 </td>
				 <td>
				 	<?php $authorname = acymailing::get('type.authorname'); echo $authorname->display('author',$pageInfo->author);?>
				</td>
			</tr>
		</table>
		<table>
			<tr>
				<td width="100%">
					<?php echo JText::_( 'JOOMEXT_FILTER' ); ?>:
					<input type="text" name="search" id="acymailingsearch" value="<?php echo $pageInfo->search;?>" class="text_area" onchange="document.adminForm.submit();" />
					<button onclick="this.form.submit();"><?php echo JText::_( 'JOOMEXT_GO' ); ?></button>
					<button onclick="document.getElementById('acymailingsearch').value='';this.form.submit();"><?php echo JText::_( 'JOOMEXT_RESET' ); ?></button>
				</td>
				<td nowrap="nowrap">
					<?php $articleType = acymailing::get('type.articlescat'); echo $articleType->display('filter_cat',$pageInfo->filter_cat);?>
				</td>
			</tr>
		</table>
		<table class="adminlist" cellpadding="1" width="100%">
			<thead>
				<tr>
					<th class="title">
						<?php echo JHTML::_('grid.sort', JText::_( 'TITLE'), 'a.title', $pageInfo->filter->order->dir,$pageInfo->filter->order->value ); ?>
					</th>
					<th class="title">
						<?php echo JHTML::_('grid.sort', JText::_( 'AUTHOR'), 'b.name', $pageInfo->filter->order->dir,$pageInfo->filter->order->value ); ?>
					</th>
					<th class="title titleid">
						<?php echo JHTML::_('grid.sort',   JText::_( 'ID' ), 'a.id', $pageInfo->filter->order->dir, $pageInfo->filter->order->value ); ?>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td colspan="5">
						<?php echo $pagination->getListFooter(); ?>
						<?php echo $pagination->getResultsCounter(); ?>
					</td>
				</tr>
			</tfoot>
			<tbody>
				<?php
					$k = 0;
					for($i = 0,$a = count($rows);$i<$a;$i++){
						$row =& $rows[$i];
				?>
					<tr id="content<?php echo $row->id?>" class="<?php echo "row$k"; ?>" onclick="applyContent(<?php echo $row->id.",'row$k'"?>);" style="cursor:pointer;">
						<td>
						<?php
							$text = '<b>'.JText::_('ALIAS',true).': </b>'.$row->alias;
							echo acymailing::tooltip($text, $row->title, '', $row->title);
						?>
						</td>
						<td>
						<?php
							if(!empty($row->name)){
								$text = '<b>'.JText::_('NAME',true).' : </b>'.$row->name;
								$text .= '<br/><b>'.JText::_('USERNAME',true).' : </b>'.$row->username;
								$text .= '<br/><b>'.JText::_('ID',true).' : </b>'.$row->created_by;
								echo acymailing::tooltip($text, $row->name, '', $row->name);
							}
						?>
						</td>
						<td align="center">
							<?php echo $row->id; ?>
						</td>
					</tr>
				<?php
						$k = 1-$k;
					}
				?>
			</tbody>
		</table>
		<input type="hidden" name="boxchecked" value="0" />
		<input type="hidden" name="filter_order" value="<?php echo $pageInfo->filter->order->value; ?>" />
		<input type="hidden" name="filter_order_Dir" value="<?php echo $pageInfo->filter->order->dir; ?>" />
	<?php
	 }
	 function acymailing_replacetags(&$email){
		$match = '#{joomlacontent:(.*)}#Ui';
		$variables = array('body','altbody');
		$found = false;
		foreach($variables as $var){
			if(empty($email->$var)) continue;
			$found = preg_match_all($match,$email->$var,$results[$var]) || $found;
			if(empty($results[$var][0])) unset($results[$var]);
		}
		if(!$found) return;
		require_once JPATH_SITE.DS.'components'.DS.'com_content'.DS.'helpers'.DS.'route.php';
		$this->mailerHelper = acymailing::get('helper.mailer');
		$htmlreplace = array();
		$textreplace = array();
		foreach($results as $var => $allresults){
			foreach($allresults[0] as $i => $oneTag){
				if(isset($htmlreplace[$oneTag])) continue;
				$article = $this->_replaceContent($allresults,$i);
				$htmlreplace[$oneTag] = $article->html;
				$textreplace[$oneTag] = $article->text;
			}
		}
		$email->body = str_replace(array_keys($htmlreplace),$htmlreplace,$email->body);
		$email->altbody = str_replace(array_keys($textreplace),$textreplace,$email->altbody);
	 }
	 function _replaceContent(&$results,$i){
		$arguments = explode('|',$results[1][$i]);
		$tag = null;
		$tag->id = (int) $arguments[0];
		for($i=1,$a=count($arguments);$i<$a;$i++){
			$args = explode(':',$arguments[$i]);
			if(isset($args[1])){
				$tag->$args[0] = $args[1];
			}else{
				$tag->$args[0] = true;
			}
		}
		$query = 'SELECT a.*,b.name as authorname, c.alias as catalias, s.alias as secalias FROM '.acymailing::table('content',false).' as a ';
		$query .= 'LEFT JOIN '.acymailing::table('users',false).' as b ON a.created_by = b.id ';
		$query .= ' LEFT JOIN '.acymailing::table('categories',false).' AS c ON c.id = a.catid ';
		$query .= ' LEFT JOIN '.acymailing::table('sections',false).' AS s ON s.id = a.sectionid ';
		$query .= 'WHERE a.id = '.$tag->id.' LIMIT 1';
		$db =& JFactory::getDBO();
		$db->setQuery($query);
		$article = $db->loadObject();
		$result = null;
		$result->text = '';
		$result->html = '';
		if(empty($article)){
			$app =& JFactory::getApplication();
			if($app->isAdmin()){
				$app->enqueueMessage('The article "'.$tag->id.'" could not be loaded','notice');
			}
			return $result;
		}
		if(!empty($tag->lang)){
			$langid = (int) substr($tag->lang,strpos($tag->lang,',')+1);
			if(!empty($langid)){
				$query = "SELECT reference_field, value FROM `#__jf_content` WHERE `published` = 1 AND `reference_table` = 'content' AND `language_id` = $langid AND `reference_id` = ".$tag->id;
				$db->setQuery($query);
				$translations = $db->loadObjectList();
				if(!empty($translations)){
					foreach($translations as $oneTranslation){
						if(!empty($oneTranslation->value)){
							$translatedfield =  $oneTranslation->reference_field;
							$article->$translatedfield = $oneTranslation->value;
						}
					}
				}
			}
		}
		$completeId = $article->id;
		$completeCat = $article->catid;
		$completeSec = $article->sectionid;
		if(!empty($article->alias)) $completeId.=':'.$article->alias;
		if(!empty($article->catalias)) $completeCat .= ':'.$article->catalias;
		if(!empty($article->secalias)) $completeSec .= ':'.$article->secalias;
		$link = ACYMAILING_LIVE.ContentHelperRoute::getArticleRoute($completeId,$completeCat,$completeSec);
		if(!empty($tag->lang)) $link.= (strpos($link,'?') ? '&' : '?') . 'lang='.$tag->lang;
		$styleTitle = '';
		$styleTitleEnd = '';
		if($tag->type != "title"){
			$styleTitle = '<h2 class="acymailing_title">';
			$styleTitleEnd = '</h2>';
		}
		if(!empty($tag->link)){
			$result->html .= '<a style="text-decoration:none;" href="'.$link.'" name="content-'.$article->id.'" target="_blank" >'.$styleTitle.$article->title.$styleTitleEnd.'</a>';
			$result->text .= strtoupper($article->title).' ( '.$link.' )';
		}else{
			$result->html .= $styleTitle.$article->title.$styleTitleEnd;
			$result->text .= strtoupper($article->title);
		}
		if(!empty($tag->author)){
			$authorName = empty($article->created_by_alias) ? $article->authorname : $article->created_by_alias;
			$result->html .= $authorName.'<br/>';
			$result->text .= "\n".$authorName;
		}
		if($tag->type != "title"){
			if($tag->type == "intro"){
				$forceReadMore = false;
				$wordwrap = $this->params->get('wordwrap',0);
				if(!empty($wordwrap)){
					$newintrotext = strip_tags($article->introtext,'<br><img>');
					$numChar = strlen($newintrotext);
	           		if($numChar > $wordwrap){
	           			$stop = strlen($newintrotext);
             			for($i=$wordwrap;$i<$numChar;$i++){
             				if($newintrotext[$i] == " "){
             					$stop = $i;
             					$forceReadMore = true;
             					break;
             				}
             			}
             			$article->introtext = substr($newintrotext,0,$stop).'...';
         			}
         		}
			}
			$result->html .= $article->introtext;
			$result->text .= "\n".$this->mailerHelper->textVersion($article->introtext);
			if($tag->type == "full"){
				if(!empty($article->fulltext)){
					$result->html .= '<br/>'.$article->fulltext;
					$result->text .= "\n".$this->mailerHelper->textVersion($article->fulltext);
				}
			}elseif($tag->type == "intro"){
				if(!empty($article->fulltext) OR $forceReadMore){
					$result->html .= '<a style="text-decoration:none;" target="_blank" href="'.$link.'"><span class="acymailing_readmore">'.JText::_('JOOMEXT_READ_MORE').'</span></a>';
					$result->text .= "\n".JText::_('JOOMEXT_READ_MORE').'( '.$link.' )';
				}
			}
			$result->html = '<div class="acymailing_content">'.$result->html.'</div>';
			$result->text .= "\n"."\n";
		}
		if(file_exists(ACYMAILING_TEMPLATE.'plugins'.DS.'tagcontent_html.php')){
			ob_start();
			require(ACYMAILING_TEMPLATE.'plugins'.DS.'tagcontent_html.php');
			$result->html = ob_get_clean();
		}
		if(file_exists(ACYMAILING_TEMPLATE.'plugins'.DS.'tagcontent_text.php')){
			ob_start();
			require(ACYMAILING_TEMPLATE.'plugins'.DS.'tagcontent_text.php');
			$result->text = ob_get_clean();
		}
		return $result;
	}
}//endclass