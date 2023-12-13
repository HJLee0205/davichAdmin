package net.danvi.dmall.biz.ifapi.cmmn;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn
 * - 파일명        : ExceptLog.java
 * - 작성일        : 2018. 7. 3.
 * - 작성자        : CBK
 * - 설명          : 로그 저장시 제외할 field에 설정
 * </pre>
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface ExceptLog {
	/**
	 * false인 경우 값이 없을때만, true인 경우 값 존재 여부에 관계없이 로그에서 제외
	 */
	boolean force() default false;
}
