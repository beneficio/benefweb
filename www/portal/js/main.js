$(document).ready(function() {

if(!Modernizr.input.placeholder){

	$('[placeholder]').focus(function() {
	  var input = $(this);
	  if (input.val() == input.attr('placeholder')) {
		input.val('');
		input.removeClass('placeholder');
	  }
	}).blur(function() {
	  var input = $(this);
	  if (input.val() == '' || input.val() == input.attr('placeholder')) {
		input.addClass('placeholder');
		input.val(input.attr('placeholder'));
	  }
	}).blur();
	$('[placeholder]').parents('form').submit(function() {
	  $(this).find('[placeholder]').each(function() {
		var input = $(this);
		if (input.val() == input.attr('placeholder')) {
		  input.val('');
		}
	  })
	});
 }

  if (!("autofocus" in document.createElement("input"))) {
      $(".name-surname").focus();
	  $(".usr input").focus();
    }

	//On mouse over those thumbnail
	$('.producto_wrap').hover(function() {

		//Display the caption
		$(this).find('div.producto_caption').stop(false,true).fadeIn(200);
	},
	function() {
		//Hide the caption
		$(this).find('div.producto_caption').stop(false,true).fadeOut(200);
	});

});

function generateTabs(element) {
    jQuery(function($) {
        $("."+element+" .tab[id^=tab_menu]").click(function() {
            var currentDiv=$(this);
            $("."+element+" .tab[id^=tab_menu]").removeClass("selected");
            currentDiv.addClass("selected");
            var index=currentDiv.attr("id").split("tab_menu_")[1];
            $("."+element+"-container .tabcontent").css('display','none');
            $("."+element+"-container #"+element+"_tab_content_"+index).fadeIn();
        });
    });
}

generateTabs('divTabs');

$(function() {
	$('#top-bt').click(function() {
		$('body,html').animate({scrollTop:0},500);
		return false;
	});
});


$(function() { /* Get the window's width, and check whether it is narrower than 480 pixels */ var windowWidth = $(window).width(); if (windowWidth <= 480) {  /* Clone our navigation */ var mainNavigation = $('nav.main-navigation').clone();  /* Replace unordered list with a "select" element to be populated with options, and create a variable to select our new empty option menu */ $('nav.main-navigation').html('<select class="menu"></select>'); var selectMenu = $('select.menu');  /* Navigate our nav clone for information needed to populate options */ $(mainNavigation).children('ul').children('li').each(function() {  /* Get top-level link and text */ var href = $(this).children('a').attr('href'); var text = $(this).children('a').text();  /* Append this option to our "select" */ $(selectMenu).append('<option value="'+href+'">'+text+'</option>');  /* Check for "children" and navigate for more options if they exist */ if ($(this).children('ul').length > 0) { $(this).children('ul').children('li').each(function() {  /* Get child-level link and text */ var href2 = $(this).children('a').attr('href'); var text2 = $(this).children('a').text();  /* Append this option to our "select" */ $(selectMenu).append('<option value="'+href2+'">--- '+text2+'</option>'); }); } }); }  /* When our select menu is changed, change the window location to match the value of the selected option. */ $(selectMenu).change(function() { location = this.options[this.selectedIndex].value; }); });

$(document).ready(function () {
	$("a#1").click(function () {
		 $("p.company").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
	$("a#2").click(function () {
		 $(".desplega#d1").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});

	$("a#3").click(function () {
		 $(".desplega#d2").slideToggle("fast");
		 $(this).toggleClass("down");
		 return false;
	});
});

;