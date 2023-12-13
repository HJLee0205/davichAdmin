package store.com.cmm.exception;

public class CustomException extends RuntimeException {

    private static final long serialVersionUID = 4177284524081223334L;
    private String exCode = null;
    private Object[] args = null;

    private Throwable cause;

    public CustomException(String exCode) {
        this.exCode = exCode;
    }

    public CustomException(String exCode, Object[] objects, Throwable e) {
        this.exCode = exCode;
    }

    public CustomException(String exCode, Object[] args) {
        this.exCode = exCode;
        this.args = args;
    }

    public CustomException(String exCode, Throwable cause) {
        this.exCode = exCode;
        this.cause = cause;
    }

    public CustomException(String exCode, Object[] args, Exception exception) {
        this.exCode = exCode;
        this.cause = exception;
        this.args = args;
    }

    public String getExCode() {
        return this.exCode;
    }

    public Throwable getCause() {
        return cause;
    }

    public Object[] getArgs() {
        return args;
    }
}
