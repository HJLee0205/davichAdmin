msg = null;
var agent = navigator.userAgent.toLowerCase();
if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
  alert("인터넷 익스플로러는 음성지원버젼이 작동하지 않습니다. 크롬이나 다른브라우저로 실행하세요.");
  window.history.back();
}
else {
  msg = new SpeechSynthesisUtterance();
}
function ttsTest(name, seq_no, phoneNum){ 
	msg = new SpeechSynthesisUtterance();
	msg.lang = 'ko-KR';
	msg.rate = $("#speed").val(); // 0.1 ~ 10  1.2
    msg.pitch = 0.8; // 0 ~ 2   0.8
    msg.text= null;
    soundName = "";
    seq_no_list = "";
    for (var i = 0; i < name.length; i++) {
		soundName += name[i]+" "
	}
    
    phoneNum = String(phoneNum).slice(-4);
    if(soundName == ""){
    	 msg.text = getHangul(seq_no)+"번 고객님  안경이 완성되어 안경찾는 곳으로 와주시기 바랍니다.";
    }else if(seq_no == ""){
    	 msg.text = soundName+" 고객님  안경이 완성되어 안경찾는 곳으로 와주시기 바랍니다.";
    }else{
    	 msg.text = soundName+" 고객님  안경이 완성되어 안경찾는 곳으로 와주시기 바랍니다.";
    }
   
   	speechSynthesis.speak(msg); 
   	msg.onstart = function(event) {
   		alarmPopup(maskingName(name), seq_no, phoneNum);
   	}
    msg.onend = function(event) {
   		$("#alarmPopup").html("");
   	  } 
    msg.onerror = function(event) {
        console.log('An error has occurred with the speech synthesis: ' + event.error);
      }
}

function tts_01(name, seq_no, phoneNum, book_yn){ 
	console.log("tts_01 도착");
	var tts = "1";
	msg = new SpeechSynthesisUtterance();
	msg.lang = 'ko-KR';
	msg.rate = $("#speed").val(); // 0.1 ~ 10  1.2
    msg.pitch = 0.8; // 0 ~ 2   0.8
    msg.text= null;
    soundName = "";
    seq_no_list = "";
    for (var i = 0; i < name.length; i++) {
		soundName += name[i]+" "
	}
   
    phoneNum = String(phoneNum).slice(-4);
    
    var text = "";
    if(book_yn == "Y"){
    	text = name + " 예약 고객님, 접수 되었습니다.";
    }else{
    	text = getHangul(seq_no) + "번 고객님, 접수 되었습니다.";
    }
	msg.text = text;
    
   	speechSynthesis.speak(msg); 
   	msg.onstart = function(event) {
   		alarmPopup(maskingName(name), seq_no, phoneNum ,tts, book_yn);
   	}
    msg.onend = function(event) {
   		$("#alarmPopup").html("");
   	  } 
    msg.onerror = function(event) {
        console.log('An error has occurred with the speech synthesis: ' + event.error);
      }
}

function tts_02(name, seq_no, phoneNum){ 
	var tts = "2";
	msg = new SpeechSynthesisUtterance();
	msg.lang = 'ko-KR';
	msg.rate = $("#speed").val(); // 0.1 ~ 10  1.2
    msg.pitch = 0.8; // 0 ~ 2   0.8
    msg.text= null;
    soundName = "";
    seq_no_list = "";
    for (var i = 0; i < name.length; i++) {
		soundName += name[i]+" "
	}
    for (var i = 0; i < seq_no.length; i++) {
    	seq_no_list += seq_no[i]+" "
	}
    phoneNum = String(phoneNum).slice(-4);
    if(soundName == ""){
    	msg.text = getHangul(seq_no)+ "번  고객님께서는 상담테이블로 와주세요.";
   }else if(seq_no == ""){
	    msg.text = soundName+" 고객님께서는 상담테이블로 와주세요.";
   }else{
	    msg.text = getHangul(seq_no)+ "번 "+soundName+" 고객님께서는 상담테이블로 와주세요.";
   }
   	speechSynthesis.speak(msg); 
   	msg.onstart = function(event) {
   		alarmPopup(maskingName(name), seq_no, phoneNum ,tts);
   	}
    msg.onend = function(event) {
   		$("#alarmPopup").html("");
   	  } 
    msg.onerror = function(event) {
        console.log('An error has occurred with the speech synthesis: ' + event.error);
      }
}

function alarmPopup(name, seq, num ,tts ,book_yn){ 
	 var text = "";
	 if(tts == "1"){
		 //예약고객의 경우
		 if(book_yn == "Y"){
			 text = "<span class=\'test\' style=\'font-weight:bold;color:blue;\'>"+ name +"</span><span> 예약 고객님 </span></br>"+
		       "<span>접수가 되었습니다.</span>"; 
		 }else{
			 text = "<span class=\'test\' style=\'font-weight:bold;color:blue;\'>"+ seq +"번 </span><span>고객님 </span></br>"+
		       "<span>접수가 되었습니다.</span>"; 
		 }
	 }else if(tts == "2"){
		 if(seq == null){
				text =  " <span class=\'test\'>"+ name +" 고객님께서는</span>"+
				"<span>상담테이블로 와주시면 감사하겠습니다.</span>";		
		}else if(name == null){
				text =  " <span class=\'test\'>"+ seq +"번 고객님께서는</span>"+
				"<span>상담테이블로 와주시면 감사하겠습니다.</span>";
		} else{
				text =  " <span  class=\'test\'>"+seq+"번<span style=\'font-weight:bold;color:blue;\'> "+ name +" 고객님 "+num+"</span></span></br>"+
				"<span>상담테이블로 와주시면 감사하겠습니다.</span>";	
		}
	 }else{
		 if(seq == null){
				text =  " <span class=\'test\'>"+ name +" 고객님</span>"+
				"<span style='color:blue; font-size:48px; font-weight:bold;'> 안경이 완성되어</span> </br>"+
				"<span>안경찾는 곳으로 와주시기 바랍니다.</span>";		
		}else if(name == null){
			text =  " <span class=\'test\'>"+ seq +"번 고객님</span>"+
			"<span style='color:blue; font-size:48px; font-weight:bold;'> 안경이 완성되어</span> </br>"+
			"<span>안경찾는 곳으로 와주시기 바랍니다</span>";	
		}else{
				text =  " <span class=\'test\'>"+seq+"번 "+ name +" 고객님 "+num+" </span>"+
				"<span style='color:blue; font-size:48px; font-weight:bold;'> 안경이 완성되어</span> </br>"+
				"<span>안경찾는 곳으로 와주시기 바랍니다.</span>";	
		}
	 }
	 var html2 = "<div style=\'background:rgb(255, 230, 153); padding:10px; font-size:45px;\' >"+
	    			text+
	    		 "</div>";
	 $("#alarmPopup").html(html2); 
}
String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}
function getHangul(num) {
    var numberic = ["","일","이","삼","사","오","육","칠","팔","구"];
    var numunit = ["","","십","백","천","만","십만","백만","천만","억","십억","백억","천억"];
    var str = "", tmp = "";
 
    var splited = [];
    for(var i = 0; i < String(num).length; i ++) {
        splited.push(String(num).substring(i, i+1));
    }
 
    for(var i = 0, x = String(num).length; x > 0; -- x, ++ i) {
        tmp = numberic[splited[i]];
        if(tmp) {
            if(x > 4 && numberic[splited[i + 1]]) {
                tmp += numunit[x].substring(0, 1);
            } else {
                tmp += numunit[x];
            }
        }
        str += tmp;
    }
    str = str.replaceAll("일십","십").replaceAll("일백","백").replaceAll("일천","천");
 	
    return str;
};


function getHangul2(num) {
    var numberic = ["공","일","이","삼","사","오","육","칠","팔","구"];
    var numunit = ["","","십","백","천","만","십만","백만","천만","억","십억","백억","천억"];
    var str = "", tmp = "";
    var splited = [];
    for(var i = 0; i < String(num).length; i ++) {
        splited.push(String(num).substring(i, i+1));
    }
    for(var i = 0, x = String(num).length; x > 0; -- x, ++ i) {
        tmp = numberic[splited[i]];
        str += tmp+",";
    }
    return str;
};

function getTimeHangul(num) {
    var str = "";
	if(num = "0000"){
		str = "공공";
    }else if(num = "0100"){
    	str = "한";
    }else if(num = "0200"){
    	str = "두";
    }else if(num = "0300"){
    	str = "세";
    }else if(num = "0400"){
    	str = "네";
    }else if(num = "0500"){
    	str = "다섯";
    }else if(num = "0600"){
    	str = "여섯";
    }else if(num = "0700"){
    	str = "일곱";
    }else if(num = "0800"){
    	str = "여덟";
    }else if(num = "0900"){
    	str = "아홉";
    }else if(num = "1000"){
    	str = "열";
    }else if(num = "1100"){
    	str = "열한";
    }else if(num = "1200"){
    	str = "열두";
    }else if(num = "1300"){
    	str = "십삼";
    }else if(num = "1400"){
    	str = "십사";
    }else if(num = "1500"){
    	str = "십오";
    }else if(num = "1600"){
    	str = "십육";
    }else if(num = "1700"){
    	str = "십칠";
    }else if(num = "1800"){
    	str = "십팔";
    }else if(num = "1900"){
    	str = "십구";
    }else if(num = "2000"){
    	str = "이십";
    }else if(num = "2100"){
    	str = "이십일";
    }else if(num = "2200"){
    	str = "이십이";
    }else if(num = "2300"){
    	str = "이십삼";
    }
    return str;
};

function ttsTest2(){ 
	msg = new SpeechSynthesisUtterance();
	msg.lang = 'ko-KR';
    msg.rate = $("#speed").val(); // 0.1 ~ 10  1.2
    msg.pitch = 0.8; // 0 ~ 2   0.8
    msg.text= null;
    msg.text = getHangul(9337)+ "번 다비치 고객님께서는 상담테이블로 와주세요";
    speechSynthesis.speak(msg);
    alarmPopup(maskingName('다비치'),9337,'0001');
    msg.onend = function(event) {
   		$("#alarmPopup").html("");
   	  } 
}

function ttsList(){
	$.ajax({
		type : "POST",
		url : "/kiosk/selectStrBookingListTestComplete.do",    	
		data : {
			store_no : $('#store_no').val(),
			login_id : $('#login_id').val()
		},
		dataType : "xml",
		success : function(result) {
			_this.flag = false;
			var name = "";
			var seq_no = "";
			var phoneNum = "";
			$("tot_row",result).each(function(){
				if($("tts",this).text() == "1"){
					tts_01($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text(),$("book_yn",this).text());
				}else if($("tts",this).text() == "2"){
					tts_02($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text());
				}else{
					ttsTest($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text());
				}
				
			})
		},
		error : function(result, status, err) {
		}
	});



}