package dmall.framework.common.exception;

import org.springframework.security.core.AuthenticationException;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : 로그인시에 비밀번호 5회이상 틀려서 캅차 인증이 필요한 경우 발생시키는 예외
 * </pre>
 */
public class LockedAccountException extends AuthenticationException {

    private static final long serialVersionUID = 6128298499642753735L;

    public LockedAccountException(String msg) {
        super(msg);
    }

    public LockedAccountException(String msg, Throwable t) {
        super(msg, t);
    }
}
