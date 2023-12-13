package dmall.framework.common.annotation;

import dmall.framework.common.util.CryptoUtil;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 4. 26.
 * 작성자     : dong
 * 설명       : 암호화 된 필드를 나타내는 어노테이션
 * </pre>
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Encrypt {
    String type() default CryptoUtil.CHIPER;

    String algorithm() default CryptoUtil.CHIPER_AES;
}
