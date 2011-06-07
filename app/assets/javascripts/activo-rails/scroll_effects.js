// Scroll effect for anchors
jQuery(function( $ )
{
	$('a').click(function() {
	   if ($(this).attr('class') == 'anchor') {
		   $.scrollTo(this.hash, 500);
		   $(this.hash).find('span.message').text(this.href);
		   return false;
	   }
	});
});
