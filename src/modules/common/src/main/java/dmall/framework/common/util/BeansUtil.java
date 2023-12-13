package dmall.framework.common.util;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtilsBean;
import org.apache.commons.beanutils.Converter;
import org.apache.commons.beanutils.converters.DateConverter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class BeansUtil {
    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : calssType에 해당하는 클래스를 가진 스프링 빈즈를 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     *
     * @param calssType
     * @return
     */
    public static <T> T getBean(Class<T> calssType) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
                .getRequest();
        ServletContext context = request.getSession().getServletContext();
        WebApplicationContext wContext = WebApplicationContextUtils.getWebApplicationContext(context);
        return wContext.getBean(calssType);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : beanName에 해당하는 이름을 가진 스프링 빈즈를 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     *
     * @param beanName
     * @return
     */
    public static Object getBean(String beanName) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
                .getRequest();
        ServletContext context = request.getSession().getServletContext();
        WebApplicationContext wContext = WebApplicationContextUtils.getWebApplicationContext(context);
        return wContext.getBean(beanName);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : KNG
     * 설명   : 소스 빈객체를 타켓 클래스의 New 인스턴스에 복사해 리턴한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. KNG - 최초생성
     * </pre>
     *
     * @param source
     * @param tclass
     * @return
     * @throws BeansException
     * @throws IllegalAccessException
     * @throws InstantiationException
     */
    public static <S, T> T copyProperties(S source, T targer, Class<T> tclass)
            throws BeansException, InstantiationException, IllegalAccessException {
        if (targer == null) {
            targer = tclass.newInstance();
        }
        java.util.Date defaultValue = null;
        Converter converter = new DateConverter(defaultValue);
        BeanUtilsBean beanUtilsBean = BeanUtilsBean.getInstance();
        beanUtilsBean.getConvertUtils().register(converter, java.util.Date.class); // Date형 에러발생 처리
        BeanUtils.copyProperties(source, targer);

        return targer;
    }
}
