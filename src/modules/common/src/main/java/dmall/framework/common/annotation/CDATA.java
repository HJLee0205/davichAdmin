package dmall.framework.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : XML 변환시 CDATA 처리를 위한 어노테이션
 * </pre>
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface CDATA {
}
