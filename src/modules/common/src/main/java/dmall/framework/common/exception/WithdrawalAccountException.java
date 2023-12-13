package dmall.framework.common.exception;

import org.springframework.security.core.AuthenticationException;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : 탈퇴회원 로그인 시도시 발생하는 예외
 * </pre>
 */
public class WithdrawalAccountException extends AuthenticationException {

    private static final long serialVersionUID = -6683615195635887242L;

    public WithdrawalAccountException(String msg) {
        super(msg);
    }

    public WithdrawalAccountException(String msg, Throwable t) {
        super(msg, t);
    }
}
