package dmall.framework.common.util;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;


/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : Http 요청/응담에 관한 유틸리티 클래스
 * </pre>
 */
public class HttpUtil {

    private static final Logger log = LoggerFactory.getLogger(HttpUtil.class);

    private static RequestAttributes getRequestAttribute() {
        return RequestContextHolder.getRequestAttributes();
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : HttpServletRequest 객체를 반환한다.
     *          경우에 따라 컨트롤러나 서비스가 아니면 못가져오는 경우도 있으므로 사용을 지양할것
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @return HttpServletRequest 객체
     */
    public static HttpServletRequest getHttpServletRequest() {
        RequestAttributes requestAttributes = getRequestAttribute();

        if (requestAttributes != null) {
            return ((ServletRequestAttributes) requestAttributes).getRequest();
        } else {
            return null;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : HttpServletResponse 객체를 반환한다.
     *          경우에 따라 컨트롤러나 서비스가 아니면 못가져오는 경우도 있으므로 사용을 지양할것
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @return HttpServletResponse 객체
     */
    public static HttpServletResponse getHttpServletResponse() {
        RequestAttributes requestAttributes = getRequestAttribute();

        if (requestAttributes != null) {
            return ((ServletRequestAttributes) requestAttributes).getResponse();
        } else {
            return null;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : ajax 요청인지 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @return ajax 요청이면 true
     */
    public static boolean isAjax(HttpServletRequest request) {

        if ("XMLHttpRequest".equals(request.getHeader("x-requested-with"))) {
            return true;
        }

        return false;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 클라이언트의 IP 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @return 아이피 문자열
     */
    public static String getClientIp(HttpServletRequest request) {
        String clientIp = request.getHeader("HTTP_X_FORWARDED_FOR");

        if (StringUtils.isBlank(clientIp) || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getHeader("ns-client-ip");
        }

        if (StringUtils.isBlank(clientIp) || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getHeader("Proxy-Client-IP");
        }

        if (StringUtils.isBlank(clientIp) || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getRemoteAddr();
        }

        if (StringUtils.isBlank(clientIp) || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getHeader("X-Forwarded-For");
        }

        if (StringUtils.isBlank(clientIp) || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getHeader("WL-Proxy-Client-IP");
        }

        if (StringUtils.isBlank(clientIp) || "unknown".equalsIgnoreCase(clientIp)) {
            clientIp = request.getHeader("HTTP_CLIENT_IP");
        }
        return clientIp;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 요청이 관리자 페이지 여부를 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param request
     *            HttpServletRequest 객체
     * @return 아이피 문자열
     */
    public static boolean isAdminPage(HttpServletRequest request) {
        if (request.getRequestURI().startsWith("/admin/")) {
            return true;
        } else {
            return false;
        }
    }

    public static String getJsonByRestTemplate(String url) {

        RestTemplate template = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        MediaType mediaType = MediaType.APPLICATION_FORM_URLENCODED;
        headers.setContentType(mediaType);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        ResponseEntity<String> responseEntity = template.exchange(url, HttpMethod.GET, entity, String.class);
        String result = responseEntity.getBody();

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : dong
     * 설명   : 스프링 RestTemplate를 이용하여 원격지의 XML를 읽어 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. dong - 최초생성
     * </pre>
     *
     * @param url
     * @return
     */
    public static String getXmlByRestTemplate(String url) {
        RestTemplate template = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        MediaType mediaType = MediaType.APPLICATION_XML;
        headers.setContentType(mediaType);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        ResponseEntity<String> responseEntity = template.exchange(url, HttpMethod.GET, entity, String.class);
        String result = responseEntity.getBody();

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : dong
     * 설명   : 스프링 RestTemplate를 이용하여 원격지의 XML를 charset으로 읽어 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param charset
     * @return
     */
    public static String getXmlByRestTemplate(String url, Charset charset) {
        RestTemplate template = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        MediaType mediaType = new MediaType("application", "xml", charset);
        headers.setContentType(mediaType);
        List<Charset> charsetList = new ArrayList<>();
        charsetList.add(charset);
        headers.setAcceptCharset(charsetList);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        template.getMessageConverters().add(0, new StringHttpMessageConverter(charset));
        ResponseEntity<String> responseEntity = template.exchange(url, HttpMethod.GET, entity, String.class);
        String result = responseEntity.getBody();

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : dong
     * 설명   : 스프링 RestTemplate를 이용하여 원격지의 text를 읽어 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. dong - 최초생성
     * </pre>
     *
     * @param url
     * @return
     */
    public static String getTextByRestTemplate(String url) {
        RestTemplate template = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        MediaType mediaType = MediaType.TEXT_XML;
        headers.setContentType(mediaType);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        ResponseEntity<String> responseEntity = template.exchange(url, HttpMethod.GET, entity, String.class);
        String result = responseEntity.getBody();

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 9.
     * 작성자 : dong
     * 설명   : 스프링 RestTemplate를 이용하여 원격지의 텍스트를 charset으로 읽어 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 9. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param charset
     * @return
     */
    public static String getTextByRestTemplate(String url, Charset charset) {
        RestTemplate template = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        MediaType mediaType = new MediaType("text", "xml", charset);
        headers.setContentType(mediaType);
        List<Charset> charsetList = new ArrayList<>();
        charsetList.add(charset);
        headers.setAcceptCharset(charsetList);

        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);
        template.getMessageConverters().add(0, new StringHttpMessageConverter(charset));
        ResponseEntity<String> responseEntity = template.exchange(url, HttpMethod.GET, entity, String.class);
        String result = responseEntity.getBody();

        return result;
    }
    
    private static final String [] LOCAL_IP = 
        { "192.168.18.109", 
          "192.168.18.110"
        };
    
    public static boolean isLocalServer() {
        boolean flag = false;
        String Ip = getServerIp();
        if(StringUtil.isEmpty(Ip)) {
            return flag;
        }

        for (String s : LOCAL_IP) {
            if (Ip.equals(s)) {
                flag = true;
            }
        }
        
        log.debug("현재 서버 IP address : " + Ip + "는 로컬 서버" + ((flag)?"입니다." : "가 아닙니다." ));
        return flag;
    }
    
    public static String getServerIp() {
        InetAddress ip;
        String ipAddr = "";
        try {
          ip = InetAddress.getLocalHost();
          //log.debug("현재 서버 IP address : " + ip.getHostAddress());
          ipAddr = ip.getHostAddress();
        } catch (UnknownHostException e) {
            log.debug("서버IP를 알수 없는 예외가 발생하였습니다.");
        }
        return ipAddr;
    }
}
