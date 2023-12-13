package dmall.framework.common.exception;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 24.
 * 작성자     : dong
 * 설명       : 성인인증 필요 상품인 경우에 발생시키는 예외
 * </pre>
 */
public class AdultOnlyException extends RuntimeException {

    private static final long serialVersionUID = 1778524191685411021L;

    private String returnUrl;

    public AdultOnlyException(String returnUrl) {
        super("성인상품입니다.");
        this.returnUrl = returnUrl;
    }

    public AdultOnlyException(String msg, Throwable t) {
        super(msg, t);
    }

    public String getReturnUrl() {
        return returnUrl;
    }
}
