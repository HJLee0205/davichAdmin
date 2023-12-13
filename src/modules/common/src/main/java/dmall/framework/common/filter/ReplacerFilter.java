package dmall.framework.common.filter;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.StringUtil;
import dmall.framework.common.util.TextReplacerUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       : 치환자 처리 필터
 * </pre>
 */
@Slf4j
public abstract class ReplacerFilter implements Filter {

    /** 치환자 접두어 */
    private final String PREFIX = "#\\[";
    /** 치환자 접미어 */
    private final String SUFFIX = "\\]";
    // #\[(([a-zA-Z]+[0-9]*)+(\.[a-zA-Z]+[0-9]*)*)\]
    /** 치환자 정규식 : #[shopName_01] 형식 */
    private final Pattern pattern = Pattern.compile("#\\[(([a-zA-Z_]+[0-9]*)+(\\.[a-zA-Z]+[0-9]*)*)\\]");

    private Map<String, String> replacerMap;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    protected abstract boolean isExcludedUrlPattern(ServletRequest servletRequest);

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {

        if (servletRequest instanceof HttpServletRequest) {
            String contentType = servletResponse.getContentType();
            if (HttpUtil.isAjax((HttpServletRequest) servletRequest)) {
                filterChain.doFilter(servletRequest, servletResponse);
            } else {
                if(((HttpServletRequest) servletRequest).getHeader("user-agent").contains("MSIE 8.0")) {
                    if (contentType != null && contentType.startsWith("text/plain")) {
                        // IE8은 ajax 결과를 text/plain 으로 반환함
                        filterChain.doFilter(servletRequest, servletResponse);
                        return;
                    }
                }

                if(contentType != null && contentType.startsWith("image/")) {
                    // 결과가 이미지인경우
                    filterChain.doFilter(servletRequest, servletResponse);
                    return;
                }

                if(isExcludedUrlPattern(servletRequest)) {
                    // 예외 URL인 경우
                    filterChain.doFilter(servletRequest, servletResponse);
                    return;
                }

                if(contentType != null && contentType.equals("text/html")) {
                    ServletResponse replacerWrapper = new ReplacerWrapper((HttpServletResponse) servletResponse);

                    try {
                            filterChain.doFilter(servletRequest, replacerWrapper);

                            if (replacerWrapper instanceof ReplacerWrapper) {
                                String responseText = replacerWrapper.toString();
                                servletResponse.getWriter().write(replace(servletRequest, responseText));
                            }

                    } catch (UnsupportedOperationException e) {
                        log.error(e.getMessage(), e);
                    } catch (Exception e) {
                        log.error(e.getMessage(), e);
                    }
                } else {
                    filterChain.doFilter(servletRequest, servletResponse);
                }
            }
        } else {
            filterChain.doFilter(servletRequest, servletResponse);
        }
    }

    @Override
    public void destroy() {

    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 16.
     * 작성자 : dong
     * 설명   : 렌더링된 HTML의 치환자를 처리한다.
     *          치환자는 replacerMapping.xml 파일에 정의된 값을 Request 에서 꺼낸 값으로 치환된다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 16. dong - 최초생성
     * </pre>
     *
     * @param servletRequest
     * @param responseText
     * @return
     * @throws IOException
     */
    private String replace(ServletRequest servletRequest, String responseText) throws Exception {
        replacerMap = getReplacerMap();
        String attribute;
        String attributeKey;

        Matcher m = pattern.matcher(responseText); // 정규식의 페턴으로 HTML의 Matcher 새성
        StringBuffer sb = new StringBuffer();
        // 매칭된 게 있는 동안
        while (m.find()) {
            // 매칭된거의 접두어 접미어를 뺀 값을 키로 치환할 값을 구함
            log.debug("치환자 {} 처리", m.group());

            attributeKey = replacerMap != null ? replacerMap.get(m.group()) : m.group().replaceAll(PREFIX, "").replaceAll(SUFFIX, "");

            if(replacerMap != null && attributeKey == null) {
                attributeKey = m.group().replaceAll(PREFIX, "").replaceAll(SUFFIX, "");
            }

            if(attributeKey != null) {
                attribute = getValue(servletRequest, attributeKey);
                if(attribute == null) {
                    continue;
                }
                m.appendReplacement(sb, attribute);
            }
        }
        m.appendTail(sb);

        return sb.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 16.
     * 작성자 : dong
     * 설명   : servletRequest 에서 key에 해당하는 Attribute의 문자열 값을 반환한다.
     *          key가 '.'으로 나누어진 경우는 '.'을 구분자로 단계별로 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 16. dong - 최초생성
     * </pre>
     *
     * @param servletRequest
     * @param key
     * @return key에 해당하는 값이 없으면 null 반환
     */
    private String getValue(ServletRequest servletRequest, String key) {
        StringTokenizer tokenizer = new StringTokenizer(key, ".");
        String token;
        Object o;

        // key에 '.'이 없는 경우는 바로 꺼내서 반환한다.
        if (tokenizer.countTokens() == 1) {
            Object obj = servletRequest.getAttribute(key);
            return obj == null ? null : String.valueOf(obj);
        }

        // key 에 '.'이 있는 경우는 '.'으로 구분한 토큰으로 단계적으로 꺼내서 반환한다.
        if (tokenizer.hasMoreTokens()) {
            token = tokenizer.nextToken();
            o = servletRequest.getAttribute(token);

            if (o == null) {
                return null;
            }

            return StringUtil.nvl(TextReplacerUtil.getReturnValue(tokenizer, o), key);
        }

        return null;
    }

//    /**
//     * <pre>
//     * 작성일 : 2016. 6. 16.
//     * 작성자 : dong
//     * 설명   : Map 계열 객체에서 값을 꺼내 반환한다.
//     *
//     * 수정내역(수정일 수정자 - 수정내용)
//     * -------------------------------------------------------------------------
//     * 2016. 6. 16. dong - 최초생성
//     * </pre>
//     *
//     * @param tokenizer
//     * @param m
//     *            값을 꺼낼 맵 객체
//     * @return
//     */
//    private String getMapValue(StringTokenizer tokenizer, Map<?, ?> m) {
//        String token;
//        Object o;
//
//        if (tokenizer.hasMoreTokens()) {
//            token = tokenizer.nextToken();
//            o = m.get(token);
//
//            if (o == null) {
//                return "";
//            }
//
//            return getReturnValue(tokenizer, o);
//        }
//
//        return "";
//    }
//
//    /**
//     * <pre>
//     * 작성일 : 2016. 6. 16.
//     * 작성자 : dong
//     * 설명   : 자바 Beans에서 값을 꺼내 반환한다.
//     *          이때 변수명 기준이 아니라 getter 기준으로 꺼내서 반환한다.
//     *          getter는 get + 토큰의 맨 첫글자를 대문자한 이름의 매소드를 호출한다.
//     *          ex) siteName -> getSiteName() 호출 결과 반환
//     *
//     * 수정내역(수정일 수정자 - 수정내용)
//     * -------------------------------------------------------------------------
//     * 2016. 6. 16. dong - 최초생성
//     * </pre>
//     *
//     * @param tokenizer
//     * @param obj
//     *            값을 꺼낼 자바 Beans 객체
//     * @return
//     */
//    private String getBeanValue(StringTokenizer tokenizer, Object obj) {
//        Class<? extends Object> cls = obj.getClass();
//        String token;
//        Object o;
//        Method m;
//
//        if (tokenizer.hasMoreTokens()) {
//            token = tokenizer.nextToken();
//            token = "get" + token.substring(0, 1).toUpperCase() + token.substring(1);
//            try {
//                m = cls.getMethod(token);
//            } catch (NoSuchMethodException e) {
//                log.error("", e);
//                return "";
//            }
//
//            try {
//                o = m.invoke(obj);
//
//                if (o == null) {
//                    return "";
//                }
//
//                return getReturnValue(tokenizer, o);
//
//            } catch (IllegalAccessException e) {
//
//                return "";
//            } catch (InvocationTargetException e) {
//
//                return "";
//            }
//        }
//
//        return "";
//    }
//
//    /**
//     * <pre>
//     * 작성일 : 2016. 6. 16.
//     * 작성자 : dong
//     * 설명   : 입력받은 o 객체에서 값을 반환한다.
//     *          o 객체가 맵이나 자바 Beans 이면 다시 값을 가져오는 메소드를 호출하고
//     *          String, Long, Integer, Date 객체인 경우는 객체를 toString() 하여 반환
//     *
//     * 수정내역(수정일 수정자 - 수정내용)
//     * -------------------------------------------------------------------------
//     * 2016. 6. 16. dong - 최초생성
//     * </pre>
//     *
//     * @param tokenizer
//     * @param o
//     * @return
//     */
//    private String getReturnValue(StringTokenizer tokenizer, Object o) {
//        if (o instanceof Map) {
//            return getMapValue(tokenizer, (Map<?, ?>) o);
//        } else if (o instanceof String) {
//            return o.toString();
//        } else if (o instanceof Long) {
//            return o.toString();
//        } else if (o instanceof Integer) {
//            return o.toString();
//        } else if (o instanceof Date) {
//            return o.toString();
//        } else {
//            return getBeanValue(tokenizer, o);
//        }
//    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 27.
     * 작성자 : dong
     * 설명   : 치환자맵을 반환한다.
     *          상속받은 클래스가 구현해야함
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 27. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    protected abstract Map<String, String> getReplacerMap() throws Exception;
}
