/* === snb === */
$(function() {
	//$(".snb_2depth").hide();
	$("#snb li a").click(function(){		
		var except = $(this).next(".snb_2depth");
		if($(this).hasClass("active")){ 
			$(this).removeClass("active");
		}else{
			$(this).addClass("active");
		}		
		$(this).next(".snb_2depth").slideToggle();
			//$(".snb_2depth").not(except).slideUp();
			$("#snb li a").not(this).removeClass("active");
		});
	});

/* === tab === */
$(function () {
	/*$(".tab_content").hide();
	$(".tab_content:first").show();

	$("ul.tabs li").click(function () {
		$("ul.tabs li").removeClass("active");
		$(this).addClass("active");
		$(".tab_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});*/
});

$(function () {
	$(".tab02_content").hide();
	$(".tab02_content:first").show();

	$("ul.tabs02 li").click(function () {
		$("ul.tabs02 li").removeClass("active");
		$(this).addClass("active");
		$(".tab02_content").hide()
		var activeTab = $(this).attr("rel");
		$("#" + activeTab).fadeIn()
	});
});

/* === fileup === */
$(document).ready(function(){
  var fileTarget = $('.filebox .upload-hidden');
  fileTarget.on('change', function(){  // 
    if(window.FileReader){  // modern browser
      var filename = $(this)[0].files[0].name;
    } 
    else {  // old IE
      var filename = $(this).val().split('/').pop().split('\\').pop();  // only file name
    }
    
    // file upload
    // $(this).siblings('.upload-name').val(filename);
  });
}); 

