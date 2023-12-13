package dmall.framework.common.exception;

import org.springframework.validation.Errors;

/**
 * Created by dong on 2016-04-01.
 */
public class JsonValidationException extends RuntimeException {
    private static final long serialVersionUID = -8485622542504420359L;
    private Errors errors;

    public JsonValidationException(Errors errors) {
        super();
        this.errors = errors;
    }

    public JsonValidationException(String message, Errors errors) {
        super(message);
        this.errors = errors;
    }

    public Errors getErros() {
        return errors;
    }
}
