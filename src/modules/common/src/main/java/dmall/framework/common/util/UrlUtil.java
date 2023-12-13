package dmall.framework.common.util;

import java.lang.reflect.Field;
import java.net.URLDecoder;
import java.net.URLEncoder;

/**
 * 이 클래스는 URL Encoding/Decoding 관련 함수를 제공합니다.
 * @author 	snw
 * @version 	1.0
 * @since 		2013.12.15
 */
public class UrlUtil {

	/**
	 * 단위 객체 Encoding
	 * @param param
	 * @param encodingType
	 * @return
	 * @throws Exception
	 */
	public static String encoder(String param, String encodingType) throws Exception {
		return URLEncoder.encode(param, encodingType);
	}


	/**
	 * Object 객체 Encoding
	 * 객체안의 String Type만 Encoding한다.
	 * @param obj
	 * @param encodingType
	 * @return
	 * @throws Exception
	 */
	public static Object encoderAll(Object obj, String encodingType) throws Exception {

		Class cls = obj.getClass();

		Field[] fieldList = cls.getDeclaredFields();

		for(Field field : fieldList){
			field.setAccessible(true);
			if(field.get(obj) != null && !"".equals(field.get(obj)) && field.getType() == String.class){

				String fieldValue = (String)field.get(obj);
				String newFieldValue = URLEncoder.encode(fieldValue, encodingType);
				field.set(obj, newFieldValue);

			}

		}

		return obj;
	}

	/**
	 * 단위 객체 Decoding
	 * @param param
	 * @param decodingType
	 * @return
	 * @throws Exception
	 */
	public static String decoder(String param, String decodingType) throws Exception {
		return URLDecoder.decode(param, decodingType);
	}

	/**
	 * Object 객체Decoding
	 * 객체안의 String Type만 Decoding한다.
	 * @param obj
	 * @param decodingType
	 * @return
	 * @throws Exception
	 */
	public static Object decoderAll(Object obj, String decodingType) throws Exception {

		Class cls = obj.getClass();

		Field[] fieldList = cls.getDeclaredFields();

		for(Field field : fieldList){
			field.setAccessible(true);
			if(field.get(obj) != null && !"".equals(field.get(obj)) && field.getType() == String.class){

				String fieldValue = (String)field.get(obj);
				String newFieldValue = URLDecoder.decode(fieldValue, decodingType);
				field.set(obj, newFieldValue);

			}

		}

		return obj;
	}
}
