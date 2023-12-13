package dmall.framework.common.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

public class GenericUtil{

	private static String default_date_format = "yyMMdd";
	private static Integer default_random_length = 7;
	
	/**
	 * ID 생성 (문자+날자(yyMMdd)+임의수(7))
	 * @param gbn : 구분 문자
	 * @return
	 */
	public static String genericId(String gbn){
		return genericId(gbn, default_date_format,  default_random_length);
	}

	/**
	 * ID 생성 (문자+임의수)
	 * @param gbn : 구분 문자
	 * @param randomLength : 임의숫자 자리수
	 * @return
	 */
	public static String genericId(String gbn, int randomLength){
		return genericId(gbn, null,  randomLength);
	}

	/**
	 * ID 생성 (문자+날짜+임의수(7))
	 * @param dateFormat : 날짜형식
	 * @param gbn : 구분 문자
	 * @return
	 */
	public static String genericId(String gbn, String dateFormat){
		return genericId(gbn, dateFormat,  default_random_length);
	}
	
	/**
	 * ID 생성 (문자+날짜+임의수)
	 * @param dateFormat : 날짜형식
	 * @param gbn : 구분 문자
	 * @param randomLength : 임의숫자 자리수
	 * @return
	 */
	public static String genericId(String gbn, String dateFormat, int randomLength){
		String newId = null;
		
		newId = gbn;

		if(dateFormat != null){
			DateFormat df = new SimpleDateFormat(dateFormat);
	
			Calendar calendar;
			calendar = Calendar.getInstance();
			String currentDay = df.format(calendar.getTime());
	
			newId += currentDay;
		}
		
		newId += generateNum(randomLength);
		
		return newId;
	}
	
	/**
	 *  ID 생성 (임의수)
	 * @param randomLength
	 * @return
	 */
	public static Integer genericId(int randomLength){
		Integer newId = null;
		
		newId = Integer.valueOf(generateNum(randomLength));
		
		return newId;
	}
	
	/**
	 * 지정한 길이의 랜덤한 숫자 생성
	 * @param length : 길이
	 * @return
	 */
	public static String generateNum(int length){

		String newRanNum = "";
		Random r = new Random();
		r.setSeed(new Date().getTime());

		while(newRanNum.length() < length) {
			newRanNum += r.nextInt(10);
		}
		
		return newRanNum;
	}

	
}
