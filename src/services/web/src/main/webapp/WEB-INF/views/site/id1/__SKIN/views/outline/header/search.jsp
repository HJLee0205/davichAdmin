<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
<script>
$(document).ready(function() {

    var url = window.location.pathname;
    // 메인페이지 placeholder 처리 & 상품상세 바로 가기 처리..
    if (url.indexOf('front/main-view') > 0) {
        $('#searchText').attr("placeholder", "${site_info.defaultSrchWord}");
    }

    $("#btn_search").click(function() {
        if($('#searchText').attr("placeholder")!=""){
        	 if($('#searchText').val().indexOf("쿠폰") != -1) {
        		    Dmall.FormUtil.submit("/front/coupon/coupon-zone");
        		     return false;
        	        }
    	    Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+encodeURIComponent($('#searchText').attr("placeholder")));

    	}else{
    	    if($("#searchText").val()!=""){
           	 if($('#searchText').val().indexOf("쿠폰") != -1) {
    	    		    Dmall.FormUtil.submit("/front/coupon/coupon-zone");
    	    		     return false;
    	    	        }
    	   //     Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+$("#searchText").val());
    	        Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+encodeURIComponent($("#searchText").val()));
    	    }else{
    	        Dmall.LayerUtil.alert("입력된 검색어가 없습니다. 검색어를 입력하세요.", "알림");
                return false;
    	    }
    	}
    })

    $(document).on("click","#akc > li",function(){
        Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+encodeURIComponent($(this).text()));
    });

    $(document).on("click",".hot_word_view > a",function(){
        Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+encodeURIComponent($(this).find('span').text()));
    });

    $("#sugUseBtn").click(function(){
    	var sugUse = getCookie("sugUse");
    	if(sugUse != "N"){
    		//setCookie("sugUse","N",0);
    		document.cookie = "sugUse=N; path=/;"
    		$("#akc").css("display","none");
    	}else{
    		document.cookie = "sugUse=; path=/;"
    	}
    });
});
</script>
<!--- search --->
<div id="search">
    <label for="searchText" class="blind">검색하기</label>
    <input type="text" id="searchText" onkeydown="if(event.keyCode == 13){$('#searchText').attr('placeholder', '');$('#btn_search').click();}" value="" placeholder="">
    <button type="button" id="btn_search" class="btn_search" title="검색하기"></button>
    <div id ="akc"  style="display:none;">
		<div class="btm_setting">
			<a href="#">검색어저장 끄기</a>
			<a href="#" id="sugUseBtn">자동완성끄기</a>
		</div>
	</div>
</div>
<!---// search --->
<script>

$(function(){
	<c:if test="${server ne 'local'}">
	var url = "/front/totalsearch/api/rankings";
	var tempSplit;
	Dmall.AjaxUtil.getJSON(url, "", function(result) {
		var rankings = "";
		// var time = JSON.stringify(result.data.time);
		// time = time.replace(/\"/gi, "");
		var tempRankings = JSON.stringify(result.data.rankings);
		var eachRankings = tempRankings.split('],[');
		console.log("OG : " + eachRankings);
		for(var i = 0; i < eachRankings.length; i++){
			eachRankings[i] = eachRankings[i].replace(/\]/g, "");
			eachRankings[i] = eachRankings[i].replace(/\[/g, "");
			eachRankings[i] = eachRankings[i].replace(/\"/g, '');
			tempSplit = eachRankings[i].split(',');

			if(i == 0 || i == 1 || i == 2){
				rankings += '<a href="#" class="hot_list"><em class = "top">'+ (i+1) +'</em><span>'+ tempSplit[0] +'</span>'
				if(tempSplit[1].charAt(0) == '-' && tempSplit[1].length >= 2){
					rankings += '<i class="hot_down">하락</i></a>'
				}else if(tempSplit[1] == '-'){
					rankings += '<i class="hot_same">동률</i></a>'
				}else{
					rankings += '<i class="hot_up">상승</i></a>'
				}
			}else{
				rankings += '<a href="#" class="hot_list"><em>'+ (i+1) +'</em><span>'+ tempSplit[0] +'</span>'
				if(tempSplit[1].charAt(0) == '-' && tempSplit[1].length >= 2){
					rankings += '<i class="hot_down">하락</i></a>'
				}else if(tempSplit[1] == '-'){
					rankings += '<i class="hot_same">동률</i></a>'
				}else{
					rankings += '<i class="hot_up">상승</i></a>'
				}
			}
		}
		// rankings += "<div class='hot_btm'>"+ time +"</div>"
		$(".hot_word_view").append(rankings);

		var hotWord = eachRankings[0].split(',');

		$(".hot_word span").eq(0).html(hotWord[0]);
		$(".hot_word em").eq(0).html(1);

		var i = 0;

		setInterval(function() {
			i++;
			hotWord = eachRankings[i].split(',');

			$(".hot_word span").eq(0).html(hotWord[0]);
			$(".hot_word em").eq(0).html(i+1);

			if(i >= (eachRankings.length - 1)){
				i = -1;
			}
		}, 5000);
	});
	</c:if>
});

$(function() {
	var timer;
	var chacker = false;
	$("#searchText").on("keyup", function() {
		if(!chacker){
			var sugUse = getCookie("sugUse");
			if(sugUse != "N"){
				var searchWord = $('#searchText').val();
				if(searchWord != null && searchWord != ""){
					chacker = true;
					$("#akc > li").remove();
					var encodeWord = encodeURI(searchWord);
		    		var url = "/front/totalsearch/api/suggestCompletion";
		    		var param = { seed : encodeWord};
					Dmall.AjaxUtil.getJSON(url, param, function(result) {
						var test = result.data.strResult;
						/* console.log("test : " + test); */
						var test22 = JSON.parse(test);
						/* console.log("test22.suggestions : " + test22.suggestions); */
						var test44 =  test22.suggestions;

						console.log("test44 : " + test44.length);

						var tempSugges = JSON.stringify(test44);
						tempSugges = tempSugges.replace(/\]/g, "");
						tempSugges = tempSugges.replace(/\[/g, "");
						tempSugges = tempSugges.replace(/"/g, "");

						var jbSplit = tempSugges.split(',');
						/* console.log(jbSplit.length);
						console.log(jbSplit); */

						var akc = "";

						if(jbSplit.length > 0) {
							for (var i=0; i < jbSplit.length; i++ ) {
								akc += "<li style='cursor:pointer;'>"+jbSplit[i]+"</li>";
							}
							$("#akc").prepend(akc);
			        		$("#akc").css("display","block");

			        		if(!jbSplit[0]){
								$("#akc").css("display","none");
							}
						} else {
							$("#akc").css("display","none");
						}
						chacker = false;
					});
				}else{
					$("#akc").css("display","none");
					console.log("no result");
				}
			}
		}






		/*
		if(timer){
			clearTimeout(timer);
		}

		var sugUse = getCookie("sugUse");
		if(sugUse != "N"){
			var searchWord = $('#searchText').val();
			if(searchWord != null && searchWord != ""){
				timer = setTimeout(function(){
					$("#akc > li").remove();
					var encodeWord = encodeURI(searchWord);
		    		var url = "/front/totalsearch/api/suggestCompletion";
		    		var param = { seed : encodeWord};
					Dmall.AjaxUtil.getJSON(url, param, function(result) {
					var test = result.data.strResult;
					console.log("test : " + test);
					var test22 = JSON.parse(test);
					console.log("test22.suggestions : " + test22.suggestions);
					var test44 =  test22.suggestions;

					console.log("test44 : " + test44.length);

					var tempSugges = JSON.stringify(test44);
					tempSugges = tempSugges.replace(/\]/g, "");
					tempSugges = tempSugges.replace(/\[/g, "");
					tempSugges = tempSugges.replace(/"/g, "");

					var jbSplit = tempSugges.split(',');
					console.log(jbSplit.length);
					console.log(jbSplit);

					var akc = "";

					if(jbSplit.length > 0) {
						for (var i=0; i < jbSplit.length; i++ ) {
							akc += "<li style='cursor:pointer;'>"+jbSplit[i]+"</li>";
						}
						$("#akc").prepend(akc);
		        		$("#akc").css("display","block");

		        		if(!jbSplit[0]){
							$("#akc").css("display","none");
						}
					} else {
						$("#akc").css("display","none");
					}
					});
				},500)
			}else{
				$("#akc").css("display","none");
				console.log("no result");
			}
		}
		*/
	    return false;
	});
});
</script>