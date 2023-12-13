package dmall.framework.common.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 쿠키 관련 유틸리티
 * </pre>
 */
@Slf4j
public class CookieUtil {

    /**
     * Object를 쿠키로 생성
     *
     * @param obj
     * @return
     * @throws Exception
     */
    // public static void setCookies(Object obj) throws Exception {
    // HttpServletResponse response = HttpUtils.getHttpServletResponse();
    // Cookie cookie = null;
    // String fieldName = null;
    // String fieldValue = null;
    //
    // log.debug(">>>>>>>>>>>>>obj=" + obj.getClass().getName());
    // log.debug(">>>>>>>>>>>>>obj=" + obj.toString());
    //
    // Class<?> cls = obj.getClass();
    // Field[] fieldList = cls.getDeclaredFields();
    //
    // for (Field field : fieldList) {
    // fieldName = field.getName();
    // fieldValue = "";
    // field.setAccessible(true);
    //
    // log.debug(">>>>>>>>>CookieUtil Cookie=" + fieldName + ", " +
    // field.getType() + "," + fieldValue);
    // if (!CommonConstants.SESSION_ID_OBJECT_NAME.equals(fieldName)) {
    //
    // if (field.get(obj) != null) {
    // fieldValue = field.get(obj).toString();
    // log.debug(">>>>>>>>>CookieUtil setCookie=" + fieldName + ", " +
    // field.getType() + "," + fieldValue);
    // fieldValue = CryptoUtil.encryptDES(fieldValue);
    // }
    //
    // cookie = new Cookie(fieldName, fieldValue);
    // cookie.setMaxAge(-1);
    // cookie.setPath("/");
    //
    // response.addCookie(cookie);
    // }
    // }
    // }

    /**
     * 쿠키를 지정된 Object에 저장한다.
     * 쿠키명과 Object의 Field명이 같아야 한다.
     * Object의 필드 타입은 String, Integer만 가능
     *
     * @param obj
     * @return
     * @throws Exception
     */
    // public static void setCookiesToObject(Object obj) throws Exception {
    // HttpServletRequest request = HttpUtils.getHttpServletRequest();
    // Cookie[] cookies = request.getCookies();
    //
    // String cookieName = null;
    // String cookieValue = null;
    // String fieldName = null;
    // Class<?> fieldType = null;
    //
    // if (obj != null) {
    // Class<?> cls = obj.getClass();
    // Field[] fieldList = cls.getDeclaredFields();
    //
    // if (cookies != null && cookies.length > 0) {
    //
    // for (Cookie cookie : cookies) {
    // cookieName = cookie.getName();
    // cookieValue = cookie.getValue();
    //
    // log.debug(">>>>>>>>>>>>>>>>CookieUtil getCookie=" + cookie.getName() +
    // "=" + cookie.getValue());
    //
    // for (Field field : fieldList) {
    // fieldName = field.getName();
    // fieldType = field.getType();
    //
    // field.setAccessible(true);
    // // 쿠키명과 Object의 필드명이 같을 경우
    // if (cookieName.equals(fieldName)) {
    //
    // if (cookieValue != null && !"".equals(cookieValue)) {
    // cookieValue = CryptoUtil.decryptDES(cookieValue);
    //
    // // Object 필드의 타입이 Integer
    // if (fieldType == Integer.class) {
    // field.set(obj, Integer.valueOf(cookieValue));
    // // Object 필드의 타입이 String
    // } else if (fieldType == String.class) {
    // field.set(obj, cookieValue);
    // }
    // } else {
    // field.set(obj, null);
    // }
    //
    // } else if
    // (CommonConstants.SESSION_ID_COOKIE_NAME.equals(cookieName.toUpperCase())
    // && CommonConstants.SESSION_ID_OBJECT_NAME.equals(fieldName)) {
    // field.set(obj, cookieValue);
    // }
    // }
    // }
    //
    // }
    // log.debug(">>>>>>>>>>>>>>>>CookieUtil getCookie=" + obj.toString());
    // }
    // }

    /**
     * 쿠키 세션 삭제
     * JSESSIONID는 초기화 하지 않음
     *
     * @param request
     * @param response
     * @throws Exception
     */
    public static void removeCookies(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 삭제");
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

        Cookie[] cookies = request.getCookies();

        removeCookie(response, cookies);
    }

    /**
     * 쿠키 세션 삭제
     * JSESSIONID는 초기화 하지 않음
     *
     * @param response
     * @throws Exception
     */
    // public static void removeCookies(HttpServletResponse response) throws
    // Exception {
    // log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // log.debug("쿠키 삭제");
    // log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    // HttpServletRequest request = HttpUtil.getHttpServletRequest();
    // Cookie[] cookies = request.getCookies();
    //
    // removeCookie(response, cookies);
    // }

    private static void removeCookie(HttpServletResponse response, Cookie[] cookies) {
        for (Cookie cookie : cookies) {
            if (!CommonConstants.SESSION_ID_COOKIE_NAME.equals(cookie.getName().toUpperCase())) {
                removeCookie(response, cookie);
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 이름에 해당하는 쿠키를 삭제한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @param response
     *            HttpServletResponse 객체
     * @param cookieName
     *            삭제할 쿠키 명
     */
    public static void removeCookie(HttpServletRequest request, HttpServletResponse response, String cookieName) {
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 삭제");
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

        Cookie[] cookies = request.getCookies();
        if (cookies == null) return;

        for (Cookie cookie : cookies) {
            if (cookie.getName().equals(cookieName.toUpperCase())) {
                removeCookie(response, cookie);
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 쿠키를 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param response
     *            HttpServletResponse 객체
     * @param cookie
     *            삭제할 Cookie 객체
     */
    private static void removeCookie(HttpServletResponse response, Cookie cookie) {
        cookie.setPath("/");
        cookie.setMaxAge(0);
        cookie.setDomain(getDomain());
        response.addCookie(cookie);
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 이름에 해당하는 쿠키를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @param cookieName
     *            삭제할 쿠키 명
     * @return
     */
    public static Cookie getCookieByName(HttpServletRequest request, String cookieName) {
/*        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 조회(키) : {}", cookieName);*/

        Cookie[] cookies = request.getCookies();
        Cookie resultCookie = null;

        if (cookies == null) return resultCookie;

        for (Cookie cookie : cookies) {
            if (cookieName.equals(cookie.getName())) {
                resultCookie = cookie;
                break;
            }
        }

        if (resultCookie != null) {
//            log.debug("쿠키 조회(값) : {}", resultCookie.getValue());
        }
//        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        return resultCookie;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 07.
     * 작성자 : dong
     * 설명   : 이름에 해당하는 쿠키를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 07. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @param cookieName
     *            리턴할 쿠키 명
     * @return
     */
    public static String getCookie(HttpServletRequest request, String cookieName) {
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 조회(키) : {}", cookieName);

        Cookie[] cookies = request.getCookies();
        String resultCookie = null;

        if (cookies == null) return resultCookie;

        for (Cookie cookie : cookies) {
            if (cookieName.equals(cookie.getName())) {
                resultCookie = cookie.getValue();
                break;
            }
        }

        if (resultCookie != null) {
            // log.debug("쿠키 조회(값) : {}", resultCookie.getValue());
            log.debug("쿠키 조회(값) : {}", resultCookie);
        }
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        return resultCookie;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @param cookieName
     *            반환할 쿠키 명
     * @return 쿠키 값을 복호화한 쿠키
     * @throws Exception
     */
    public static Cookie getDecodedCookieByName(HttpServletRequest request, String cookieName) throws Exception {
        Cookie cookie = getCookieByName(request, cookieName);
        if (cookie != null) {
            String decodedValue = CryptoUtil.decryptAES(cookie.getValue());
            cookie.setValue(decodedValue);
/*            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            log.debug("복화화 쿠키 값 : {}", decodedValue);
            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");*/
        }

        return cookie;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 입력받은 이름의 쿠키를 꺼내어 그 값을 문자열로 반환한다. 
     *          콘트롤러, 서비스 이외에서 사용시 주의
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param cookieName
     *            반환할 쿠키 이름
     * @return 쿠키값의 문자열
     * @throws Exception
     */
    public static String getCookiesAsString(String cookieName) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        Cookie[] cookies = request.getCookies();

        String name;
        String value;

        if (cookies != null && cookies.length > 0) {

            for (Cookie cookie : cookies) {
                name = cookie.getName();
                value = cookie.getValue();

                log.debug("CookieUtil getCookiesAsString : {}= {}", cookie.getName(), cookie.getValue());

                if (cookieName.equals(name)) {
                    return value;
                }
            }
        }

        return null;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 쿠키 생성 후 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param response
     *            HttpServletResponse 객체
     * @param cookieName
     *            쿠키 명
     * @param cookieValue
     *            쿠키 값
     */
    public static void addCookie(HttpServletResponse response, String cookieName, String cookieValue) {
        addCookie(response, cookieName, cookieValue, -1);
    }

    public static void addCookie(HttpServletResponse response, String cookieName, String cookieValue, int maxAge) {
/*        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 추가 {}:{}:{}", cookieName, cookieValue, maxAge);
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");*/

        Cookie cookie = new Cookie(cookieName, cookieValue);
        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        cookie.setDomain(getDomain());
        response.addCookie(cookie);
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 쿠키 생성 후 추가
     *          콘트롤러, 서비스 이외에서 사용시 주의
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param cookieName
     *            쿠키 명
     * @param cookieValue
     *            쿠키 값
     */
    public static void addCookie(String cookieName, String cookieValue) {
        HttpServletResponse response = HttpUtil.getHttpServletResponse();

        if (response != null) {
            addCookie(response, cookieName, cookieValue);
        } else {
            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            log.debug("response is null");
            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 암호화한 쿠키 생성 후 추가
     *          콘트롤러, 서비스 이외에서 사용시 주의
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param cookieName
     * @param cookieValue
     * @throws Exception
     */
    public static void addEncodedCookie(String cookieName, String cookieValue) throws Exception {
        addEncodedCookie(cookieName, cookieValue, -1);
    }

    public static void addEncodedCookie(String cookieName, String cookieValue, int maxAge) throws Exception {
        HttpServletResponse response = HttpUtil.getHttpServletResponse();

        if (response != null) {
            addCookie(response, cookieName, CryptoUtil.encryptAES(cookieValue), maxAge);
        } else {
            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            log.debug("response is null");
            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 쿠키의 유무 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @param cookieName
     *            쿠키 명
     * @return
     */
    public static boolean existCookie(HttpServletRequest request, String cookieName) {
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 {}의 유무", cookieName);

        Cookie[] cookies = request.getCookies();
        boolean result = false;

        if (cookies == null) return false;

        for (Cookie cookie : cookies) {
            if (cookieName.equals(cookie.getName())) {
                result = true;
            }
        }

        log.debug("{}", result);
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 쿠키 생성 후 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param cookieName
     *            쿠키 명
     * @param cookieValue
     *            쿠키 값
     * @return
     */
    public static Cookie createCookie(String cookieName, String cookieValue) {
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        log.debug("쿠키 생성 {}:{}", cookieName, cookieValue);
        log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

        Cookie cookie = new Cookie(cookieName, cookieValue);
        cookie.setMaxAge(-1);
        cookie.setPath("/");
        cookie.setDomain(getDomain());
        return cookie;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 암호화한 쿠키 생성 후 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param cookieName
     *            쿠키 명
     * @param cookieValue
     *            쿠키 값
     * @return
     */
    public static Cookie createEncodedCookie(String cookieName, String cookieValue) {
        return createEncodedCookie(cookieName, cookieValue, -1);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 암호화한 쿠키 생성 후 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param cookieName
     *            쿠키 명
     * @param cookieValue
     *            쿠키 값
     * @param maxAge
     *            쿠키 유효시간(초단위)
     * @return
     */
    public static Cookie createEncodedCookie(String cookieName, String cookieValue, int maxAge) {
        Cookie cookie = null;
        try {
            cookie = createCookie(cookieName, CryptoUtil.encryptAES(cookieValue));
        } catch (Exception e) {
            log.error("암호화 쿠키 생성 오류.", e);
        }

        if(cookie == null) {
            throw new RuntimeException("쿠키생성 오류");
        }

        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        cookie.setDomain(getDomain());

        return cookie;
    }

    private static String getDomain() {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        String domain = request.getServerName();

        if (domain.startsWith("www")) {
            domain = domain.substring(4);
        } else if (domain.startsWith("m")) {
            domain = domain.substring(1);
        } else {
            //ghjo tomcat 8.5이사에서 .(dot)으로 시작하는 쿠키를 생성 할수 없도록 변경됨(RFC 6265 Cookie Process 정책)
            //domain = "." + domain;
            domain = domain;
        }

        return domain;
    }

}
