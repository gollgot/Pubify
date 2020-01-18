( function( $ ) {
	$( document ).ready(function() {

		// Menu
		$('#side-menu li.has-sub>a').on('click', function(){
			$(this).removeAttr('href');
			var element = $(this).parent('li');
			if (element.hasClass('open')) {
				element.removeClass('open');
				element.find('li').removeClass('open');
				element.find('ul').slideUp();
			}
			else {
				element.addClass('open');
				element.children('ul').slideDown();
				element.siblings('li').children('ul').slideUp();
				element.siblings('li').removeClass('open');
				element.siblings('li').find('li').removeClass('open');
				element.siblings('li').find('ul').slideUp();
			}
		});

		// Add one more product (customerOrders.create / supplyOrder.create)
		$(".btn-add-product").click(function(){
			var lastProduct = $(".product").last();
			$(".product").first().clone().insertAfter(lastProduct);
		});

	});
} )( jQuery );
