/**
 * 왼쪽 공백 제거
 * @param str : 문자열
 */
function lTrim(str){
   	var whitespace = new String(" \t\n\r");
  	var s = new String(str);
   	if (whitespace.indexOf(s.charAt(0)) != -1) {
      	var j=0, i = s.length;
      	while (j < i && whitespace.indexOf(s.charAt(j)) != -1)
         	j++;
      	s = s.substring(j, i);
   	}
   	return s;
}

/**
 * 오른쪽 공백 제거
 * @param str : 문자열
 */
function rTrim(str){
   	var whitespace = new String(" \t\n\r");
   	var s = new String(str);
   	if (whitespace.indexOf(s.charAt(s.length-1)) != -1) {
      	var i = s.length - 1;       // Get length of string
      	while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
         	i--;
      	s = s.substring(0, i+1);
   	}
   	return s;
}

/**
 * 공백 제거
 * @param str : 문자열
 */
function trim(str) {
	return rTrim(lTrim(str));
}

//숫자
function isNumber(v_num){
	var expNum	= /^[0-9]+$/;	
	if(!expNum.test(v_num)){
		return false;
	}else{
		return true;
	}
}

function isNumberChk(obj){
	if(trim(obj.value).length > 0){
		if(isNumber(obj.value) == false){
			alert("숫자를 입력하세요.");
			obj.value = "";
			obj.focus();
		}
	}
}

/* 전화번호에 '-' 삽입*/
function insertTelHyphen(callPhone){	
	var callPhoneLength = callPhone.length;
	var callConfirm = callPhone.substring(0,3);
	var callTypeCheck = "";
	var callTel1 = "";
	var callTel2 = "";
	var callTel3 = "";
	
	var returnPone = "";
	
	if(callConfirm == "010" || callConfirm == "011" || callConfirm == "016" || callConfirm == "017" || callConfirm == "018" || callConfirm == "019" ){
	    callTypeCheck = "M";
	}else{
	    callTypeCheck = "H";
	}

	if(callPhoneLength < 9){
		returnPone = callPhone;
	}else if(callPhoneLength == 9){
	    if(callTypeCheck == "H"){
	    	callTel1 = callPhone.substring(0,2);
	    	callTel2 = callPhone.substring(2,6);
	    	callTel3 = callPhone.substring(6,10);
	    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	    }
	}else if(callPhoneLength == 10){
	    if( (callPhone.substring(0,2) == "02") && callTypeCheck == "H" ){
	    	callTel1 = callPhone.substring(0,2);
	    	callTel2 = callPhone.substring(2,6);
	    	callTel3 = callPhone.substring(6,10);
	    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	    }else{
	        if(callTypeCheck == "H"){
	        	callTel1 = callPhone.substring(0,3);
	        	callTel2 = callPhone.substring(3,6);
	        	callTel3 = callPhone.substring(6,10);
		    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	        }else if(callTypeCheck == "M"){
	        	callTel1 = callPhone.substring(0,3);
	        	callTel2 = callPhone.substring(3,6);
	        	callTel3 = callPhone.substring(6,10);
		    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	        }
	    }
	}else if(callPhoneLength == 11){
	    if(callTypeCheck == "H"){
	    	callTel1 = callPhone.substring(0,3);
	    	callTel2 = callPhone.substring(3,7);
	    	callTel3 = callPhone.substring(7,11);
	    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	    }else if(callTypeCheck == "M"){
	    	callTel1 = callPhone.substring(0,3);
	    	callTel2 = callPhone.substring(3,7);
	    	callTel3 = callPhone.substring(7,11);
	    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	    }
	}else if(callPhoneLength == 12){
	    if(callTypeCheck == "H"){
	    	callTel1 = callPhone.substring(0,4);
	    	callTel2 = callPhone.substring(4,8);
	    	callTel3 = callPhone.substring(7,12);
	    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	    }else if(callTypeCheck == "M"){
	    	callTel1 = callPhone.substring(0,4);
	    	callTel2 = callPhone.substring(4,8);
	    	callTel3 = callPhone.substring(8,12);
	    	returnPone = callTel1 + "-" + callTel2 + "-" + callTel3;
	    }
	}else{
		returnPone = callPhone;
	}
	
	return returnPone;
}

function maskingName(strName) {
	if(strName.length > 2) {
		var originName = strName.split('');
	    originName.forEach(function(name, i) {
	      if (i === 0 || i === originName.length - 1) return;
	      originName[i] = '*';
	    });
	    var joinName = originName.join();
	    return joinName.replace(/,/g, '');
	 }else{
	    var pattern = /.$/; // 정규식
	    return strName.replace(pattern, '*');
	 }
};
