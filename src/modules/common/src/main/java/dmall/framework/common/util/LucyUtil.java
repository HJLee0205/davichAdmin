package dmall.framework.common.util;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

import com.navercorp.lucy.security.xss.servletfilter.XssEscapeFilter;

import lombok.extern.slf4j.Slf4j;

/**
 * Created by dong on 2016-10-22.
 */
@Slf4j
public class LucyUtil {

    public static Map<String, List<String>> exceptMap;
	static {
		exceptMap = new HashMap<String, List<String>>();

		exceptMap.put("/front/member/update-password", Arrays.asList("nowPw", "newPw"));
		exceptMap.put("/m/front/member/update-password", Arrays.asList("nowPw", "newPw"));
		exceptMap.put("/front/member/member-insert", Arrays.asList("pw"));
		exceptMap.put("/m/front/member/member-insert", Arrays.asList("pw"));
		exceptMap.put("/front/member/member-update", Arrays.asList("pw"));
		exceptMap.put("/m/front/member/member-update", Arrays.asList("pw"));
		exceptMap.put("/admin/member/manage/member-info-update", Arrays.asList("pw"));
	}

    /**
     * <pre>
     * 작성일 : 2016. 10. 22.
     * 작성자 : dong
     * 설명   : 네이버 LUCY 필터를 이용하여 입력받은 URL과 객체로 객체의 String 객체를 필터링
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 22. dong - 최초생성
     * </pre>
     *
     * @param url
     * @param object
     */
    public static void filter(String url, Object object) {
        XssEscapeFilter filter = XssEscapeFilter.getInstance();
        Class<? extends Object> cls = object.getClass();
        String filteredValue;

        for (Field field : cls.getDeclaredFields()) {

            try {
                field.setAccessible(true);
                if(field.get(object) instanceof String){
                    filteredValue = filter.doFilter(url, field.getName(), (String) field.get(object));
                    filteredValue = StringUtil.replaceAll(filteredValue, "&amp;lt;", "&lt;");
                    filteredValue = StringUtil.replaceAll(filteredValue, "&amp;gt;", "&gt;");
                     if(exceptMap.containsKey(url) && exceptMap.get(url).contains(field.getName())) {
                    	// 필터 적용 안함.
                    } else {
                    	filteredValue = StringUtil.replaceAll(filteredValue, "$", "&#36;");
                    }

                    field.set(object, filteredValue);
                }
            } catch (Exception e) {
                log.error("루시 필터 적용 오류", e);
            }
        }

//        log.debug("Filtered Object : {}", ToStringBuilder.reflectionToString(object, ToStringStyle.MULTI_LINE_STYLE));
    }
}
