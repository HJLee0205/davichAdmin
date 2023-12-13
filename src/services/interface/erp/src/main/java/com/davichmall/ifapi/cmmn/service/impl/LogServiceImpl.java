package com.davichmall.ifapi.cmmn.service.impl;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.ExceptLog;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.cmmn.dao.LogDAO;
import com.davichmall.ifapi.cmmn.service.LogService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.service.impl
 * - 파일명        : LogServiceImpl.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 인터페이스 로그 처리를 위한 Service
 * </pre>
 */
@Service("logService")
public class LogServiceImpl implements LogService {

	@Resource(name="logDao")
	LogDAO logDao;
	
	/**
	 * 인터페이스 처리 로그 등록
	 */
	@Override
	public void writeInterfaceLog(String ifId, Object reqParam, BaseResDTO resParam) {
		try {
			String reqParamStr = getObjToStrWithCheckExcept(reqParam);
			String resParamStr = getObjToStrWithCheckExcept(resParam);
			
			logDao.insertInterfaceLog(ifId, reqParamStr, resParamStr, null);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 인터페이스 처리 로그 등록
	 */
	@Override
	public void writeInterfaceLog(String ifId, Object reqParam, String resParam, Class<? extends BaseResDTO>  resDtoClass) {
		try {
			String reqParamStr = getObjToStrWithCheckExcept(reqParam);
			String resParamStr = getObjToStrWithCheckExcept(JSONObject.toBean(JSONObject.fromObject(resParam), resDtoClass));
			
			logDao.insertInterfaceLog(ifId, reqParamStr, resParamStr, null);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 인터페이스 처리 실패 로그 등록
	 */
	@Override
	public void writeInterfaceLog(String ifId, Object reqParam, BaseResDTO resParam, CustomException ce) {
		try {
			String reqParamStr = getObjToStrWithCheckExcept(reqParam);
			String resParamStr = getObjToStrWithCheckExcept(resParam);
			String errMsg = ce.getOrigException() == null ? ce.getMessage() : ce.getOrigException().getMessage();
			
			logDao.insertInterfaceLog(ifId, reqParamStr, resParamStr, errMsg);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 3.
	 * 작성자 : CBK
	 * 설명   : DTO의 필드에서 ExceptLog Annotation이 설정되어 있는 경우, 로그에서 제외 (force가 false인 경우 값이 없을때만 제외)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 3. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	private String getObjToStrWithCheckExcept(Object param) throws Exception {
		JSONObject jsonObj = JSONObject.fromObject(param);
		
		Field[] superFields = {};
		if(param.getClass().getSuperclass() != null) {
			superFields = param.getClass().getSuperclass().getDeclaredFields();
		}
		Field[] currFields = param.getClass().getDeclaredFields();
		Field[] fields = new Field[superFields.length + currFields.length];
		
		List<Class<?>> innerClasses = Arrays.asList(param.getClass().getDeclaredClasses());

		System.arraycopy(superFields, 0, fields, 0, superFields.length);
		System.arraycopy(currFields, 0, fields, superFields.length, currFields.length);
		
		for(Field field : fields) {
			ExceptLog except = field.getAnnotation(ExceptLog.class);
			if(except != null) {
				if(except.force()) {
					jsonObj.remove(field.getName());
				} else {
					Object value = jsonObj.get(field.getName());
					if(value == null || "".equals(value)) {
						jsonObj.remove(field.getName());
					}
				}
			}
			
			if(field.getType().equals(List.class)) {
				ParameterizedType listType = (ParameterizedType) field.getGenericType();
				Class<?> listGenericType = (Class<?>) listType.getActualTypeArguments()[0];
				if(innerClasses.contains(listGenericType)) {
					Field[] subFields = listGenericType.getDeclaredFields();
					for(Field subField : subFields) {
						ExceptLog subExcept = subField.getAnnotation(ExceptLog.class);
						if(subExcept != null) {
							JSONArray jsonArray = jsonObj.getJSONArray(field.getName());
							for(int i=0; i<jsonArray.size(); i++) {
								JSONObject subObj = jsonArray.getJSONObject(i);
								if(subExcept.force()) {
									subObj.remove(subField.getName());
								} else {
									Object value = subObj.get(subField.getName());
									if(value == null || "".equals(value)) {
										subObj.remove(subField.getName());
									}
								}
							}
							
						}
					}
				}
			}
		}
		
		return jsonObj.toString();
	}

}
