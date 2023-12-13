package dmall.framework.common.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;
import java.util.stream.Collectors;

import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.MappingVO;
import org.apache.commons.beanutils.PropertyUtils;

import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 2.
 * 작성자     : KNG
 * 설명       : Bean 클래스의 get, set 메소드를 이용하여 값을 변환해 주는 유틸
 * </pre>
 */
@Slf4j
public class ConverterUtil {

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : KNG
     * 설명   : Bean 객체의 값을 변환처리하여 복사하는 함수
     *          소스객체에서 => 타겟객체로 get,set 메소드를 이용해 값을 변환 복사해 주는 함수
     *      예) convertRuleData[][](이중array형태변환규칙데이터)
     *          {{변환키, 부모값, 자식값, 부모기본값, 자식기본값}}
     *          변환키를 이용해 부모값<=>자식값을 변환flag를 기준으로 원본값과 비교하여 변환처리 한다.
     *          이때 변환 값을 찾지 못하면 기본값으로 셋팅한다.
     *      {
     *          // PG실서비스여부
     *          { "RealServiceYn", "Y", "service", "N", "test" }, // true => service
     *          { "RealServiceYn", "N", "test", "N", "test" }, // false => test
     *          // 결제수단코드
     *          { "PaymentWayCd", "23", "SC0010", "", "" }, // 23 신용카드 => SC0010 신용카드
     *          { "PaymentWayCd", "21", "SC0030", "", "" }, // 21 실시간계좌이체 => SC0030 계좌이체
     *          { "PaymentWayCd", "22", "SC0040", "", "" }, // 22 가상계좌 => SC0040 무통장
     *          { "PaymentWayCd", "24", "SC0060", "", "" }, // 24 휴대폰결제 => SC0060 휴대폰
     *          { "PaymentWayCd", "25", "SC0070", "", "" }, // 25 유선전화 => SC0070 유선전화 (KT)
     *          { "PaymentWayCd", "26", "SC0090", "", "" }, // 26 OK캐쉬백 => SC0090 OK캐쉬백
     *          { "PaymentWayCd", "27", "SC0111", "", "" }, // 27 문화상품권 => SC0111 문화상품권
     *          { "PaymentWayCd", "28", "SC0112", "", "" }, // 28 게임문화상품권 => SC0112 게임문화상품권
     *          { "PaymentWayCd", "29", "SC0113", "", "" }, // 29 도서문화상품권 => SC0113 도서문화상품권
     *          { "PaymentWayCd", "30", "SC0220", "", "" } // 30 모바일T머니 => SC0220 모바일T머니
     *      }
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 30. KNG - 최초생성
     * </pre>
     *
     * @param source(소스클래스)
     * @param sourceMethod(소스메소드)
     * @param target(타겟클래스)
     * @param targetMethod(타겟메소드)
     * @param convertKey(변환키)
     * @param convertParentTochildFlag(변환방향flag=>true:부모->자식,false:자식->부모)
     * @param convertRuleData[][](이중array형태변환규칙데이터)
     * @throws SecurityException
     * @throws NoSuchMethodException
     * @throws InvocationTargetException
     * @throws IllegalArgumentException
     * @throws IllegalAccessException
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static <S, T> void converter(S source, Object sourceMethod, T target, Object targetMethod, Object convertKey,
            Boolean convertParentTochildFlag, Object convertRuleData[][]) throws NoSuchMethodException,
            SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        Class<S> srcClass = (Class<S>) source.getClass();
        Object srcObject = source;
        Method srcMethod;

        Class<T> tarClass = (Class<T>) target.getClass();
        Object tarObject = target;
        Method tartMethod;
        Class[] tarMethodParamClass = new Class[1];
        Object[] tarMethodParamObject = new Object[1];

        // 소스get => 타켓set 처리
        srcMethod = srcClass.getMethod("get" + sourceMethod);
        tarMethodParamObject[0] = srcMethod.invoke(srcObject);
        // 값이 null이 아닌 경우만 처리함
        if (tarMethodParamObject[0] != null) {
            if (convertKey != null) {
                // Boolean 형태 TRUE 값일경우
                // URL의 http://id1.test.com => http://id1 이부분을 넣어야 하는 URL 형태의 경우
                if (convertKey instanceof Boolean && ((Boolean) convertKey).booleanValue()) {
                    tarMethodParamObject[0] = "http://" + SiteUtil.getSiteId() + "." + tarMethodParamObject[0];
                }
                // 일반 String 형태의 변환키일 경우
                else {
                    tarMethodParamObject[0] = getConvertParam(convertKey, tarMethodParamObject[0],
                            convertParentTochildFlag, convertRuleData);
                }
            }
            tarMethodParamClass[0] = tarMethodParamObject[0].getClass();
            tartMethod = tarClass.getMethod("set" + targetMethod, tarMethodParamClass);
            tartMethod.invoke(tarObject, tarMethodParamObject);
            log.debug(" =>> [ ConverterUtil.converter ] : " + "set" + targetMethod.toString() + "("
                    + tarMethodParamClass[0].getName() + " [" + tarMethodParamObject[0].toString() + "])");
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : KNG
     * 설명   : 변환규칙에 따라 값을 변환 처리하는 함수
     *      예) convertRuleData[][](이중array형태변환규칙데이터)
     *          {{변환키, 부모값, 자식값, 부모기본값, 자식기본값}}
     *          변환키를 이용해 부모값<=>자식값을 변환방향flag를 기준으로 변환대상값과 비교하여 변환처리 한다.
     *          1. 변환키를 찾지 못하면 변환대상값을 그대로 돌려준다.
     *          2. 변환키는 찾았으나 변환결과값을 찾지 못하면 변환방향flag에 따라 부모기본값 또는 자식기본값을 돌려준다.
     *      {
     *          // PG실서비스여부
     *          { "RealServiceYn", "Y", "service", "N", "test" }, // true => service
     *          { "RealServiceYn", "N", "test", "N", "test" }, // false => test
     *          // 결제수단코드
     *          { "PaymentWayCd", "23", "SC0010", "", "" }, // 23 신용카드 => SC0010 신용카드
     *          { "PaymentWayCd", "21", "SC0030", "", "" }, // 21 실시간계좌이체 => SC0030 계좌이체
     *          { "PaymentWayCd", "22", "SC0040", "", "" }, // 22 가상계좌 => SC0040 무통장
     *          { "PaymentWayCd", "24", "SC0060", "", "" }, // 24 휴대폰결제 => SC0060 휴대폰
     *          { "PaymentWayCd", "25", "SC0070", "", "" }, // 25 유선전화 => SC0070 유선전화 (KT)
     *          { "PaymentWayCd", "26", "SC0090", "", "" }, // 26 OK캐쉬백 => SC0090 OK캐쉬백
     *          { "PaymentWayCd", "27", "SC0111", "", "" }, // 27 문화상품권 => SC0111 문화상품권
     *          { "PaymentWayCd", "28", "SC0112", "", "" }, // 28 게임문화상품권 => SC0112 게임문화상품권
     *          { "PaymentWayCd", "29", "SC0113", "", "" }, // 29 도서문화상품권 => SC0113 도서문화상품권
     *          { "PaymentWayCd", "30", "SC0220", "", "" } // 30 모바일T머니 => SC0220 모바일T머니
     *      }
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 30. KNG - 최초생성
     * </pre>
     *
     * @param convertKey(변환키)
     * @param convertValue(변환대상값)
     * @param convertParentTochildFlag(변환방향flag=>true:부모->자식,false:자식->부모)
     * @param convertRuleData[][](이중array형태변환규칙데이터)
     * @return
     */
    public static Object getConvertParam(Object convertKey, Object convertValue, Boolean convertParentTochildFlag,
            Object convertRuleData[][]) {
        Object result = null;
        // convertParam => 변환파라메터 {{부모파라메터, 부모값, 자식값, 부모기본값, 자식기본값}}
        if (convertKey != null && convertValue != null) {
            for (int i = 0; i < convertRuleData.length; i++) {
                // 부모 => 자식으로 변환
                if (convertParentTochildFlag) {
                    // 변환파라메터 = convertParam 의 Key가 같을때
                    if (convertKey.equals(convertRuleData[i][0])) {
                        // 변환입력값 = convertParam의 원본값과 같을때
                        if (convertValue.equals(convertRuleData[i][1])) {
                            result = convertRuleData[i][2];
                            break;
                        }
                        // 일치되지 않으면 기본값으로 변환 셋팅
                        else {
                            result = convertRuleData[i][4];
                        }
                    }
                }
                // 자식 => 부모로 변환
                else if (!convertParentTochildFlag) {
                    // 변환파라메터 = convertParam 의 Key가 같을때
                    if (convertKey.equals(convertRuleData[i][0])) {
                        // 변환입력값 = convertParam의 원본값과 같을때
                        if (convertValue.equals(convertRuleData[i][2])) {
                            result = convertRuleData[i][1];
                            break;
                        }
                        // 일치되지 않으면 기본값으로 변환 셋팅
                        else {
                            result = convertRuleData[i][3];
                        }
                    }
                }
            }
        }

        // 변환파라메터와 일치되는 값이 없을 경우 입력값을 그대로 넘겨준다. (즉 변환하지 않을 경우 처리대상)
        if (result == null) result = convertValue;
        log.debug(" =>>=>> [ ConverterUtil.getConvertParam(" + convertParentTochildFlag + ") ] : " + "convertKey="
                + convertKey.toString() + ",convertValue=" + convertValue.toString() + " => result="
                + result.toString());
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : KNG
     * 설명   : map의 value을 bean에 넣어주는 메소드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. KNG - 최초생성
     * </pre>
     *
     * @param map
     * @param bean
     * @param tclass
     * @throws InstantiationException
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     */
    @SuppressWarnings({ "unchecked" })
    public static <T> T mapToBean(Map<String, Object> map, T bean, boolean returnNew)
            throws Exception {
        T result = bean;
        Class<T> clazz = (Class<T>) result.getClass();
        String key = null;
        String keyMap = null;
        Object value = null;
        Object argvalue = null;
        Class[] tarMethodParamClass = new Class[1];
        Object[] tarMethodParamObject = new Object[1];
        if (returnNew) {
            result = (T) result.getClass().newInstance();
        }
        if (result == null || map == null || map.isEmpty()) {
            return result;
        }

        try {
            for (Entry<String, Object> entry : map.entrySet()) {
                key = entry.getKey();
                value = entry.getValue();

                if (value == null) {
                    continue;
                }
                // 첫글자 대문자로 변환
                if (key.length() == 1) {
                    keyMap = String.valueOf(key.charAt(0)).toUpperCase();
                } else {
                    keyMap = String.valueOf(key.charAt(0)).toUpperCase() + key.substring(1, key.length());
                }
                for (Method m : clazz.getDeclaredMethods()) {
                    if (m.getName().equals("set" + keyMap)) {
                        argvalue = value;
                        if ("Boolean".equals(m.getParameterTypes()[0].getSimpleName())) {
                            argvalue = new Boolean(value.toString());
                        }
                        if ("Long".equals(m.getParameterTypes()[0].getSimpleName())) {
                            argvalue = new Long(value.toString());
                        }
                        m.invoke(result, argvalue);
                    }
                }
            }
        } catch (Exception e) {
            log.debug("ConverterUtil.mapToBean 처리시 에러 ", e);
        }
        return result;

    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : KNG
     * 설명   : bean의 value을 map에 넣어주는 메소드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. KNG - 최초생성
     * </pre>
     *
     * @param bean
     * @param properties
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     * @throws NoSuchMethodException
     */
    @SuppressWarnings("unchecked")
    public static <T> Map<String, Object> beanToMap(T bean, Map<String, Object> properties, boolean returnNew)
            throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
        Map<String, Object> result = properties;
        if (returnNew) {
            result = new HashMap<String, Object>();
        }

        if (bean == null || properties == null || properties.isEmpty()) {
            return result;
        }

        Map<String, Object> newMap = PropertyUtils.describe(bean);
        newMap.remove("class");
        result.putAll(properties);
        result.putAll(newMap);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : KNG
     * 설명   : map의 value을 map에 넣어주는 메소드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. KNG - 최초생성
     * </pre>
     *
     * @param source
     * @param target
     */
    public static Map<String, Object> mapToMap(Map<String, Object> source, Map<String, Object> target,
            boolean returnNew) {
        Map<String, Object> result = null;
        if (returnNew) {
            result = new HashMap<String, Object>();
        } else {
            result = target;
        }

        if (source == null && target == null) {
            // 빈값
        } else if (source == null && target != null) {
            result.putAll(target);
        } else if (source != null && target == null) {
            result.putAll(source);
        } else if (source != null && target != null) {
            result.putAll(target);
            result.putAll(source);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : KNG
     * 설명   : source map과 target map의 합집합을 만드는 메소드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. KNG - 최초생성
     * </pre>
     *
     * @param source
     * @param target
     */
    public static Map<String, Object> mapUnionMap(Map<String, Object> source, Map<String, Object> target,
            boolean returnNew) {
        Map<String, Object> result;

        if ((source == null || source.isEmpty()) && (target == null || target.isEmpty())) {
            result = target;
            if (returnNew) {
                result = new HashMap<String, Object>();
            }
            return result;
        } else if (source == null || source.isEmpty()) {
            result = target;
            if (returnNew) {
                result = new HashMap<String, Object>(target);
            }
            return result;
        } else if (target == null || target.isEmpty()) {
            result = source;
            if (returnNew) {
                result = new HashMap<String, Object>(source);
            }
            return result;
        }

        result = target;
        if (returnNew) {
            result = new HashMap<String, Object>(target);
        }

        Iterator<String> keys = source.keySet().iterator();
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = source.get(key);
            if ((!result.containsKey(key)) && (!result.containsValue(value))) {
                result.put(key, value);
            }
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : KNG
     * 설명   : source map과 target map의 교집합을 만드는 메소드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. KNG - 최초생성
     * </pre>
     *
     * @param source
     * @param target
     */
    public static Map<String, Object> mapInterMap(Map<String, Object> source, Map<String, Object> target) {
        Map<String, Object> result;
        if (source == null || source.isEmpty() || target == null || target.isEmpty()) {
            result = new HashMap<String, Object>();
            return result;
        }
        result = new HashMap<String, Object>(source);
        result.entrySet().retainAll(target.entrySet());
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : KNG
     * 설명   : source map에서 target map을 뺀 차집합을 만드는 메소드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. KNG - 최초생성
     * </pre>
     *
     * @param source
     * @param target
     */
    public static Map<String, Object> mapDiffMap(Map<String, Object> source, Map<String, Object> target,
            boolean returnNew) {
        Map<String, Object> result;
        if ((source == null || source.isEmpty()) && (target == null || target.isEmpty())) {
            result = source;
            if (returnNew) {
                result = new HashMap<String, Object>(source);
            }
            return result;
        } else if (source == null || source.isEmpty()) {
            result = source;
            if (returnNew) {
                result = new HashMap<String, Object>(source);
            }
            return result;
        } else if (target == null || target.isEmpty()) {
            result = source;
            if (returnNew) {
                result = new HashMap<String, Object>(source);
            }
            return result;
        }

        result = source;
        if (returnNew) {
            result = new HashMap<String, Object>(source);
        }
        result.entrySet().removeAll(target.entrySet());
        return result;
    }

    public static String getMappingValue(String method, String type, String sourceErpCode, String source) {
        String result = "";
        if(type.equals(MapperConstants.GLASS_BRAND_MAPPING)) {
            if(method.equals(MapperConstants.MAPPING_METHOD_ERP_CODE)) {
                if(StringUtil.isNotEmpty(sourceErpCode)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.GLASS_BRAND_MAP.entrySet()) {
                        if (entry.getKey().equals(sourceErpCode)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            } else if(method.equals(MapperConstants.MAPPING_METHOD_VALUE)) {
                if(StringUtil.isNotEmpty(source)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.GLASS_BRAND_MAP.entrySet()) {
                        if (entry.getValue().getItemNmEng().equals(source)
                                || entry.getValue().getItemNmKo().equals(source)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            }
        } else if(type.equals(MapperConstants.CONTACT_BRAND_MAPPING)) {
            if(method.equals(MapperConstants.MAPPING_METHOD_ERP_CODE)) {
                if(StringUtil.isNotEmpty(sourceErpCode)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.CONTACT_BRAND_MAP.entrySet()) {
                        if (entry.getKey().equals(sourceErpCode)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            } else if(method.equals(MapperConstants.MAPPING_METHOD_VALUE)) {
                if(StringUtil.isNotEmpty(source)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.CONTACT_BRAND_MAP.entrySet()) {
                        if (entry.getValue().getItemNmEng().equals(source)
                                || entry.getValue().getItemNmKo().equals(source)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            }
        } else if (type.equals(MapperConstants.CONTACT_COLOR_MAPPING)) {
            if(method.equals(MapperConstants.MAPPING_METHOD_ERP_CODE)) {
                if(StringUtil.isNotEmpty(sourceErpCode)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.CONTACT_COLOR_MAP.entrySet()) {
                        if (entry.getKey().equals(sourceErpCode)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            } else if(method.equals(MapperConstants.MAPPING_METHOD_VALUE)) {
                if(StringUtil.isNotEmpty(source)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.CONTACT_COLOR_MAP.entrySet()) {
                        if (/*entry.getValue().getItemNmEng().equals(source)
                                || */entry.getValue().getItemNmKo().equals(source)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            }
        } else if (type.equals(MapperConstants.CONTACT_PERIOD_MAPPING)) {
            if(method.equals(MapperConstants.MAPPING_METHOD_ERP_CODE)) {
                if(StringUtil.isNotEmpty(sourceErpCode)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.CONTACT_PERIOD_MAP.entrySet()) {
                        if (entry.getKey().equals(sourceErpCode)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            } else if(method.equals(MapperConstants.MAPPING_METHOD_VALUE)) {
                if(StringUtil.isNotEmpty(source)) {
                    for (Map.Entry<String, MappingVO> entry : MapperConstants.CONTACT_PERIOD_MAP.entrySet()) {
                        if (/*entry.getValue().getItemNmEng().equals(source)
                                || */entry.getValue().getItemNmKo().equals(source)) {
                            result = entry.getValue().getTargetItemNm();
                            break;
                        }
                    }
                }
            }
        }
        return result;
    }
}
