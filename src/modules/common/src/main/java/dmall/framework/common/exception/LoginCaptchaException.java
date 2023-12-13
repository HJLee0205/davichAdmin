package dmall.framework.common.exception;

import org.springframework.security.core.AuthenticationException;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 7. 4.
 * 작성자     : dong
 * 설명       : 캡차 코드가 맞지 않은 경우 발생시키는 예외
 * </pre>
 */
public class LoginCaptchaException extends AuthenticationException {

    private static final long serialVersionUID = -7244553940143842115L;

    public LoginCaptchaException(String msg) {
        super(msg);
    }

    public LoginCaptchaException(String msg, Throwable t) {
        super(msg, t);
    }
}
