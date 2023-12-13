package dmall.framework.common.util;

import lombok.extern.slf4j.Slf4j;
import net.sf.ehcache.hibernate.management.impl.BeanUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.Date;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 7. 1.
 * 작성자     : dong
 * 설명       : 치환자 처리 유틸리티
 * </pre>
 */
@Slf4j
public class TextReplacerUtil {
    /** 치환자 접두어 */
    private static final String PREFIX = "#\\[";
    /** 치환자 접미어 */
    private static final String SUFFIX = "\\]";
    // #\[(([a-zA-Z]+[0-9]*)+(\.[a-zA-Z]+[0-9]*)*)\]
    /** 치환자 정규식 : #[shopName_01] 형식 */
    private static final Pattern pattern = Pattern.compile("#\\[(([a-zA-Z_]+[0-9]*)+(\\.[a-zA-Z]+[0-9]*)*)\\]");

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 파일을 읽어 스트링으로 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * 2016. 10. 17. dong - 사이트 루트 패스부터 입력한 패스를 찾아서 파일을 가져오도록 수정
     * </pre>
     *
     * @param pathName
     * @return
     * @throws IOException
     */
    public static String getSkinFileToString(String pathName) throws IOException {
        StringBuilder sb = new StringBuilder();
        String siteRootPath = SiteUtil.getSiteRootPath();
        try (
                FileInputStream fis = new FileInputStream(new File(siteRootPath + pathName));
                InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
                BufferedReader br = new BufferedReader(isr)
        ) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        } catch(Exception e) {
            log.error("파일 읽기 에러", e);
            throw e;
        }

        return sb.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 치환자를 입력받은 데이터로 치환한다.
     *          스킨에서의 이미지 경로를 위해 request를 받아서 추가적인 처리를 한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param obj
     * @param contents
     * @param request
     * @return
     * @throws Exception
     */
    public static String replace(Object obj, String contents, HttpServletRequest request) throws Exception {
        contents = contents.replaceAll("#\\[_SKIN_IMG_PATH\\]", (String) request.getAttribute("_SKIN_IMG_PATH"));

        contents = contents.replaceAll("#\\[_IMAGE_DOMAIN\\]", (String) request.getAttribute("_IMAGE_DOMAIN"));

        return replace(obj, contents);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 치환자를 입력받은 데이터로 치환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param obj
     * @param contents
     * @return
     * @throws Exception
     */
    public static String replace(Object obj, String contents) throws Exception {
        String attribute;
        String attributeKey;
        StringBuffer sb = new StringBuffer();
        if(contents!=null) {
            Matcher m = pattern.matcher(contents); // 정규식의 페턴으로 HTML의 Matcher 새성
           // 매칭된 게 있는 동안
            while (m.find()) {
                // 매칭된거의 접두어 접미어를 뺀 값을 키로 치환할 값을 구함
                /*log.debug("치환자 {} 처리", m.group());*/
                attributeKey = m.group().replaceAll(TextReplacerUtil.PREFIX, "").replaceAll(TextReplacerUtil.SUFFIX, "");
                attribute = getValue(obj, attributeKey);
                m.appendReplacement(sb, attribute);
            }
            m.appendTail(sb);
        }
        return sb.toString();
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : servletRequest 에서 key에 해당하는 Attribute의 문자열 값을 반환한다.
     *          key가 '.'으로 나누어진 경우는 '.'을 구분자로 단계별로 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param obj
     * @param key
     * @return key에 해당하는 값이 없으면 key를 그대로 반환
     */
    private static String getValue(Object obj, String key) {
        StringTokenizer tokenizer = new StringTokenizer(key, ".");
        String result = getReturnValue(tokenizer, obj);

        if (result == null) {
            return key;
        } else {
            return result;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 자바 Beans나 Map에서 값을 꺼내 반환한다.
     *          Beans의 경우는 변수명 기준이 아니라 getter 기준으로 꺼내서 반환한다.
     *          getter는 get + 토큰의 맨 첫글자를 대문자한 이름의 매소드를 호출한다.
     *           ex) siteName -> getSiteName() 호출 결과 반환
     *          Map의 경우는
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param tokenizer
     * @param obj
     *            값을 꺼낼 자바 Beans 객체
     * @return
     */
    private static String getValue(StringTokenizer tokenizer, Object obj) {
        String token;
        Object o;

        if (tokenizer.hasMoreTokens()) {
            token = tokenizer.nextToken();

            if (obj instanceof Map) {
                // 맵인 경우
                o = ((Map) obj).get(token);
            } else {
                // 자바 Beans(POJO)인 경우
                o = BeanUtils.getBeanProperty(obj, token);
            }
            if (o == null) {
                return "";
            }
            return getReturnValue(tokenizer, o);
        }

        return "";
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 입력받은 o 객체에서 값을 반환한다.
     *          o 객체가 맵이나 자바 Beans 이면 다시 값을 가져오는 메소드를 호출하고
     *          String, Long, Integer, Date 객체인 경우는 객체를 toString() 하여 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param tokenizer
     * @param o
     * @return
     */
    public static String getReturnValue(StringTokenizer tokenizer, Object o) {
        if (o instanceof String) {
            return o.toString();
        } else if (o instanceof Long) {
            return o.toString();
        } else if (o instanceof Integer) {
            return o.toString();
        } else if (o instanceof Float) {
            return o.toString();
        } else if (o instanceof Date) {
            return o.toString();
        } else {
            return getValue(tokenizer, o);
        }
    }
}
