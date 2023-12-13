package com.davichmall.ifapi.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.davichmall.ifapi.cmmn.constant.Constants;

@Component
public class SendUtil {

	@Value("${mall.server.url1}")
	String mallBaseUrl1;
	
	@Value("${mall.server.url2}")
	String mallBaseUrl2;
	
	@Value("${erp.server.url1}")
	String erpBaseUrl1;
	
	@Value("${erp.server.url2}")
	String erpBaseUrl2;
	
	@Value("${server.type}")
	String serverType;

	// mall interface server 2대중에 한쪽으로 요청. 실패시 다른 쪽으로 다시 시도. 둘다 실패면 오류.
	// 위 처리를 위한 변수들
	String mallBaseUrl;
	String erpBaseUrl;
	int tryCnt = 0;
	
	public String send(Object param, String ifId) throws Exception {
		
		if(erpBaseUrl == null) erpBaseUrl = erpBaseUrl1;
		if(mallBaseUrl == null) mallBaseUrl = mallBaseUrl1;
		
		String baseUrl = Constants.SERVER_TYPE.SERVER_TYPE_MALL.equals(serverType) ? erpBaseUrl : mallBaseUrl;
		String uri = "/" + ifId;
		
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
			// timeout 설정
			connection.setConnectTimeout(5000);
			
			String normalReqParam = toReqParam(param);
			String encReqParam = "encParam=" + URLEncoder.encode(IFCryptoUtil.encryptAES(normalReqParam), "UTF-8") + "&fromIF=true";
			
			// 파라미터 전송
			os = connection.getOutputStream();
			os.write(encReqParam.getBytes("utf-8"));
			os.flush();
			os.close();
			
			// 응답 데이터
			reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
			StringBuffer sb = new StringBuffer();
			String line = null;
			while((line = reader.readLine()) != null) {
				sb.append(line).append("\r\n");
			}

			String encRes = sb.toString();
			String decRes = IFCryptoUtil.decryptAES(encRes);
			
			// 시도 횟수 초기화
			tryCnt = 0;
			
			return decRes;

		} catch(ConnectException ce) {
			if(tryCnt == 0) {
				// 처음 실패한 경우 
				// 시도 횟수 설정. url변경 후 재시도
				tryCnt = 1;
				if(Constants.SERVER_TYPE.SERVER_TYPE_MALL.equals(serverType)) {
					if(erpBaseUrl.equals(erpBaseUrl1)) erpBaseUrl = erpBaseUrl2;
					else erpBaseUrl = erpBaseUrl1;
				} else {
					if(mallBaseUrl.equals(mallBaseUrl1)) mallBaseUrl = mallBaseUrl2;
					else mallBaseUrl = mallBaseUrl1;
				}
				return this.send(param, ifId);
			} else {
				// 두번째 실패한 경우(양쪽 서버 모두 안되는 경우)
				// 시도 횟수 초기화 하고 예외 던짐.
				tryCnt = 0;
				throw ce;
			}
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
	 * object형태의 데이터를 http req 형태의 문자열로 반환 (ex-a=1&b=2&c=3...)
	 * @param map
	 * @return
	 */
	public String toReqParam(Object o) throws Exception {
		return toReqParam(o, "");
	}
	private String toReqParam(Object o, String keyPrefix) throws Exception {
		if(o == null) return "";
		String result = "";
		
		if(o instanceof String) {
			result += "&";
			result += keyPrefix;
			result += "=";
			result += URLEncoder.encode(o.toString(), "UTF-8");
		} else {
			
			Method[] methods = o.getClass().getMethods();
			for(Method method : methods) {
				if("getClass".equals(method.getName())) continue;
				if(method.getName().startsWith("get")) {
					String key = method.getName().replaceFirst("get", "");
					key = key.substring(0, 1).toLowerCase() + key.substring(1);
					Object value = method.invoke(o);
					
					Class c = method.getReturnType();
					
					if(c.getSimpleName().contains("List")) {
						if(value != null && ((List) value).size() > 0) {
							result += toReqParam((List) value, keyPrefix != null && !"".equals(keyPrefix) ? keyPrefix + "." + key : key);
						}
					} else {
						result += "&";
						if(keyPrefix != null && !"".equals(keyPrefix)) {
							result += keyPrefix + ".";
						}
						result += key;
						result += "=";
						result += value == null ? "" : URLEncoder.encode(value.toString(),"UTF-8");
					}
				}
			}
		}
		return result;
	}
	
	/**
	 * list형태의 데이터를 http req 형태의 문자열로 반환
	 * @param list
	 * @return
	 */
	private String toReqParam(List<Object> list, String keyPrefix) throws Exception {
		String result = "";
		
		int idx = 0;
		for(Object obj : list) {
			result += toReqParam(obj, keyPrefix + "[" + idx + "]");
			idx++;
		}
		
		return result;
	}
}
