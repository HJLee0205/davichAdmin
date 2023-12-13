package dmall.framework.common.exception;

import org.springframework.security.core.AuthenticationException;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : 일정시간 미사용으로 세션 만료시 발생하는 예외
 * </pre>
 */
public class SessionExpiredException extends AuthenticationException {

    private static final long serialVersionUID = 1786308901978917029L;

    public SessionExpiredException(String msg) {
        super(msg);
    }

    public SessionExpiredException(String msg, Throwable t) {
        super(msg, t);
    }
}
