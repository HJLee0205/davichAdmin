package com.davichmall.ifapi.util;

import java.io.UnsupportedEncodingException;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.util
 * - 파일명        : StringUtil.java
 * - 작성일        : 2018. 5. 23.
 * - 작성자        : CBK
 * - 설명          : 문자열 관련 처리 UTIL Class
 * </pre>
 */
public class StringUtil {

	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 23.
	 * 작성자 : CBK
	 * 설명   : 문자열을 특정 Byte로 잘라서 반환
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 23. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public static String getMaxByteString(String str, int byteLen, String charset) throws Exception {
		if(str == null) return null;
		if(charset == null || "".equals(charset)) charset = "utf-8";
		
		try {
			
			if(str.getBytes(charset).length > byteLen) {
				String result = "";
				int totalByteLen = 0;
				
				int idx = 0;
				while(true) {
					String ch = str.substring(idx, idx+1);
					byte[] tmpByte = ch.getBytes(charset);
					if(totalByteLen + tmpByte.length > byteLen) {
						break;
					}
					totalByteLen += tmpByte.length;
					result += ch;
					idx++;
				}
				
				return result;
			} else {
				return str;
			}
			
		} catch (UnsupportedEncodingException e) {
			return getMaxByteString(str, byteLen, "utf-8");
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 12.
	 * 작성자 : CBK
	 * 설명   : 정해진 길이에 맞게 문자열 좌측에 문자삽입
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 12. CBK - 최초생성
	 * </pre>
	 *
	 * @param str
	 * @param len
	 * @param addStr
	 * @return
	 * @throws Exception
	 */
	public static String lpad(String str, int len, char addStr) throws Exception {
		String result = str;
		
		while(result.length() < len) {
			result = addStr + result;
		}
		
		return result;
	}
	public static String lpad(Integer str, int len, char addStr) throws Exception {
		return lpad(String.valueOf(str), len, addStr);
	}

	//특수문자 제거 하기
   public static String StringReplace(String str){
     return str.replaceAll("&amp;", "")
				.replaceAll("&lt;", "")
				.replaceAll("&gt;", "")
				.replaceAll("&quot;", "")
				.replaceAll("&#39;", "");
   }
}
