package net.danvi.dmall.biz.ifapi.util;

import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.Map;

public class TransUtil {

	public static void mapToObj(Map<String, Object> map, Object obj) throws Exception {
		
		Iterator<String> keyIter = map.keySet().iterator();
		while(keyIter.hasNext()) {
			String key = keyIter.next();
			Method setMethod = findSetMethodByFieldName(obj, key);
			if(setMethod != null) {
				setMethod.invoke(obj, map.get(key));
			}
		}
	}
	private static Method findSetMethodByFieldName(Object obj, String fieldName) throws Exception {

		Method[] methods = obj.getClass().getMethods();
		String methodName = "set" + fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
		for(Method method : methods) {
			if(methodName.equals(method.getName())) {
				return method;
			}
		}
		return null;
	}
}
