package egovframework.kiosk.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.commons.beanutils.DynaProperty;
import org.springframework.stereotype.Component;

import egovframework.cmmn.ResultModel;
import egovframework.rte.fdl.property.EgovPropertyService;
import net.sf.ezmorph.bean.MorphDynaBean;
import net.sf.json.JSONObject;

@Component
public class InterfaceUtil {
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
    public static String baseUrl;
    
    @PostConstruct
    public void init() {
    	baseUrl = propertiesService.getString("interfaceURL");
    }
	
	public static Map<String, Object> send(String interfaceId, Map<String, Object> param) throws Exception {
		String uri = "/" + interfaceId;
		
		HttpURLConnection connection = null;
		OutputStream os = null;
		BufferedReader reader = null;
		try {
			URL url = new URL(baseUrl + uri);
			
			connection = (HttpURLConnection) url.openConnection();
			
			// 기본 설정
			// post방식 전송
			connection.setRequestMethod("POST");
			// 서버로 데이터 전송 가능 하도록..
			connection.setDoOutput(true);
			// 서버에서 데이터 받아올 수 있도록..
			connection.setDoInput(true);
			// 캐시 사용인가?
			connection.setUseCaches(false);
			connection.setDefaultUseCaches(false);
			
			// 파라미터 생성
			String reqParam = getHttpParam(param, "");
			
			// 파라미터 전송
			os = connection.getOutputStream();
			os.write(reqParam.getBytes("utf-8"));
			os.flush();
			os.close();
			
			// 응답 데이터
			reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
			StringBuffer sb = new StringBuffer();
			String line = null;
			while((line = reader.readLine()) != null) {
				sb.append(line).append("\r\n");
			}

			return jsonToMap(sb.toString());
			
		} catch(Exception ex) {
			throw ex;
		} finally {
			if(connection != null) 
				connection.disconnect();
			if(os != null) {
				try {os.close();} catch(Exception ex) {}
			}
			if(reader != null) {
				try {reader.close();} catch(Exception ex) {}
			}
		}
		
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 30.
	 * 작성자 : CBK
	 * 설명   : send와 동일하지만, 결과를 ResultModel로 반환
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 30. CBK - 최초생성
	 * </pre>
	 *
	 * @param interfaceId
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public static ResultModel<Map<String, Object>> send2(String interfaceId, Map<String, Object> param) throws Exception {
		Map<String, Object> ifResult = send(interfaceId, param);
		ResultModel<Map<String, Object>> result = new ResultModel<>();
		if("1".equals(ifResult.get("result"))) {
			result.setSuccess(true);
			result.setData(ifResult);
		} else {
			result.setSuccess(false);
			result.setMessage(ifResult.get("message").toString());
		}
		
		return result;
	}
	
	// 테스트용 메소드
	public static String test(Map<String, Object> param) throws Exception {
		return getHttpParam(param, "");
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : Map 형태의 데이터를 http 파라미터 형태로 변경
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param map
	 * @param keyPrefix
	 * @return
	 * @throws Exception
	 */
	private static String getHttpParam(Map<?, ?> map, String keyPrefix) throws Exception {
		if(map == null || map.keySet().isEmpty()) return "";
		String result = "";
		
		Iterator<?> keyset = map.keySet().iterator();
		while(keyset.hasNext()) {
			String key = keyset.next().toString();
			Object value = map.get(key);
			if(value == null) continue;
			
			if(value instanceof List<?>) {
				List<?> list = (List<?>) map.get(key);
				result += getHttpParam((List<?>) list, keyPrefix != null && !"".equals(keyPrefix) ? keyPrefix + "." + key : key);
				
			} else {

				result += "&";
				if(keyPrefix != null && !"".equals(keyPrefix)) {
					result += keyPrefix + ".";
				}
				result += key;
				result += "=";
				result += URLEncoder.encode(value.toString(), "UTF-8");
			}
		}
		
		return result;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : List 형태의 데이터를 http 파라미터 형태로 변경
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param list
	 * @param keyPrefix
	 * @return
	 * @throws Exception
	 */
	private static String getHttpParam(List<?> list, String keyPrefix) throws Exception {
		if(list == null || list.isEmpty()) return "";

		String result = "";
		
		int idx = 0;
		for(Object o : list) {
			if(o instanceof List<?>) {
				result += getHttpParam((List<?>) o, keyPrefix + "[" + idx + "]");
			} else if(o instanceof Map<?, ?>) {
				result += getHttpParam((Map<?, ?>) o, keyPrefix + "[" + idx + "]");
			} else {
				result += getHttpParam(o, keyPrefix + "[" + idx + "]");
			}
			idx++;
		}
		
		
		return result;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : List도 Map도 아닌 형태의 데이터를 http 파라미터 형태로 변경
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param o
	 * @param keyPrefix
	 * @return
	 * @throws Exception
	 */
	private static String getHttpParam(Object o, String keyPrefix) throws Exception {
		if(o == null) return "";
		String result = "";
		
		result += "&";
		result += keyPrefix;
		result += "=";
		result += URLEncoder.encode(o.toString(), "UTF-8");
		
		return result;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : Json 문자열을 Map 형태로 변환
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param object Json형태의 문자열(String)
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({"rawtypes", "unchecked"})
	private static Map<String, Object> jsonToMap(Object object) throws Exception {

		MorphDynaBean bean = null;
		if(object instanceof String) {
			bean = (MorphDynaBean) JSONObject.toBean(JSONObject.fromObject(object));
		} else if(object instanceof MorphDynaBean) {
			bean = (MorphDynaBean) object;
		} else {
			throw new Exception("invalid parameter");
		}
		
		Map<String, Object> resultMap = new HashMap<>();
		DynaProperty[] dynaProps = bean.getDynaClass().getDynaProperties();
		for(DynaProperty dynaProp : dynaProps) {
			Object obj = bean.get(dynaProp.getName());
			if(obj instanceof List<?>) {
				if(obj != null && ((List) obj).size() > 0 && ((List) obj).get(0) instanceof String) {
					List<String> strList = new ArrayList<>();
					for(Object str : (List) obj) {
						strList.add(str.toString());
						resultMap.put(dynaProp.getName(), strList);
					}
				} else {
					List<MorphDynaBean> list = (List) obj;
					List<Map<String, Object>> mapList = new ArrayList<>();
					for(MorphDynaBean subBean : list) {
						mapList.add(jsonToMap(subBean));
					}
					resultMap.put(dynaProp.getName(), mapList);
				}
			} else {
				resultMap.put(dynaProp.getName(), obj);
			}
		}
		return resultMap;
	}
}
