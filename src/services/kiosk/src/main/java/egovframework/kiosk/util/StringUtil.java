package egovframework.kiosk.util;

import javax.servlet.http.HttpServletRequest;

public class StringUtil {
	
	public static String stringInstar(String str){
		if(str.length() == 2){
			str = str.substring(0,1) + "*";
		}else if(str.length() == 3){
			str = str.substring(0,1) + "*" + str.substring(2,3);
		}else if(str.length() > 3){
			String tmp = "";
			for(int j=0; j<(str.length()-2); j++) tmp = tmp + "*";
			str = str.substring(0,1) + tmp + str.substring(str.length()-1,str.length());
		}
		
		return str;
	}    
	
    /**
     * 파일 업로드
     * @param request
     * @param String
     * @param int
     * @return com.oreilly.servlet.MultipartRequest
     */
    public static com.oreilly.servlet.MultipartRequest uploadFile(HttpServletRequest request, String realPath, int sizeLimit){
				
		com.oreilly.servlet.MultipartRequest multi = null;

		try{			
			multi = new  com.oreilly.servlet.MultipartRequest(request, realPath, sizeLimit, "utf-8", new DateTimeFileRenamePolicy());
		}catch(Exception e){
			e.printStackTrace();
		}

		return multi;
	}
}
