var pager = function(options) {

	var defaults = {
		currentPage : 1 // 현재페이지	
		,pageSize : 10 // 페이지 사이즈 (화면 출력 페이지 수)
		,maxListCount : 10 // (보여질)최대 리스트 수 (한페이지 출력될 항목 갯수)
		,startnum : 1 // 시작 글번호
		,lastnum : 10 // 마지막 글번호
		,totalCnt : 0 // 전체 글의 갯수.
		,totalPageCnt : 0 // 전체 페이지 수
		
	};
	
	this.buttonClickCallback = null;
	this.opts = $.extend({}, defaults, options);
	
};

pager.prototype = {

	"renderpager" : function(totalCnt, buttonClickCallback) {

		var _ = this;
		
		_.opts.totalCnt = totalCnt; //토탈 카운트 객체 멤버변수에 저장.
		
		var pageSize = this.opts.pageSize;
		var maxListCount = this.opts.maxListCount;
		var currentPage = this.opts.currentPage;
		
		if (totalCnt == 0) {
			return "";
		}
		
		//총페이지수 구하기 : 페이지 출력 범위 (1|2|3|4|5)
		var totalPageCnt = Math.ceil(totalCnt / maxListCount);
	
		//현재 블럭 구하기 
		var n_block = Math.ceil(currentPage / pageSize);

		//페이징의 시작페이지와 끝페이지 구하기
		var s_page = (n_block - 1) * pageSize + 1; // 현재블럭의 시작 페이지
		var e_page = n_block * pageSize; // 현재블럭의 끝 페이지

		// setup $pager to hold render
		var $pager = $('#paging'); // TODO: 페이지를 출력할 영역. (추후에 유동성있게 출력할 영역의 ID를 받게하면 될것 같음.)
		$pager.empty(); //영역에 기존에 있던 내용 제거


		//처음, 이전 버튼 추가
		$pager.append(this.renderButton('first', totalPageCnt, _.buttonClickCallback))
		      .append(this.renderButton('prev', totalPageCnt,	_.buttonClickCallback));

		//페이지 나열
		for (var j = s_page; j <= e_page; j++) {
			if (j > totalPageCnt)	break;
			
			var currentButton = $('<li >' + (j) + '</li>');
			
			//현재 페이지일경우 select 클래스 추가. 
			if (j == currentPage)	currentButton.addClass('selected');
			else currentButton.click(function() {
								_.initNum(parseInt(this.firstChild.data));
								_.buttonClickCallback(this.firstChild.data);
							});
		
			currentButton.appendTo($pager); //페이징 영역에 버튼 추가			
		}

		//다음, 마지막 버튼 추가
		$pager.append(this.renderButton('next', totalPageCnt,	_.buttonClickCallback))
			  .append(this.renderButton('last', totalPageCnt,	_.buttonClickCallback));

		return $pager;
	},
	"initNum" : function(cp) {

		this.opts.currentPage = cp;

		//시작 글번호
		this.opts.startnum = (cp - 1) * this.opts.maxListCount + 1;

		// 마지막 글번호
		var tmp = cp * this.opts.maxListCount;
		this.opts.lastnum = (tmp > this.opts.totalCnt ? this.opts.totalCnt
				: tmp);

		pageInit(this.opts.startnum,this.opts.lastnum);

	},

	"renderButton" : function(buttonLabel, totalPageCnt,
			buttonClickCallback) {
		var _ = this;
		var currentPage = this.opts.currentPage;
		//var totalPageCnt = this.opts.totalPageCnt;

		var $Button = $('<li >' + buttonLabel + '</li>');
		var destPage = 1;

		// work out destination page for required button type
		switch (buttonLabel) {
		case "first":
			destPage = 1;
			$Button.addClass('active');
			$Button.html('<a href="#none" class="strpre ico_comm">맨앞으로</a>');
			break;

		case "prev":
			destPage = currentPage - 1;
			$Button.addClass('active');
			$Button.html('<a href="#none" class="pre ico_comm">이전</a>');
			break;

		case "next":
			destPage = currentPage + 1;
			$Button.addClass('active');
			$Button.html('<a href="#none" class="nex ico_comm">다음</a>');
			break;

		case "last":
			destPage = totalPageCnt;
			$Button.addClass('active');
			$Button.html('<a href="#none" class="endnex ico_comm">맨끝으로</a>');
			break;
		}

		// disable and 'grey' out buttons if not needed.
		if (buttonLabel == "first" || buttonLabel == "prev") { //1페이지에서는 처음, 이전 버튼 안보이게 

			if(	currentPage <= 1 ){ 
			    //$Button.addClass('pgEmpty').css("display", "none") 
			    $Button.click();
			}else{
			    $Button.click(function() {	_.initNum(destPage); buttonClickCallback(); });
			
			}
		} else {
			if( currentPage >= totalPageCnt){
			    //$Button.addClass('pgEmpty').css("display", "none")
			    $Button.click();
			}
			else{
			    $Button.click(function() { _.initNum(destPage); buttonClickCallback();	});
			}
		}
		return $Button; //생성된 버튼 반환
	}
};