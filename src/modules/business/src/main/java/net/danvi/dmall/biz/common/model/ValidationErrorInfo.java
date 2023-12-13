package net.danvi.dmall.biz.common.model;

import lombok.Data;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

/**
 * Created by dong on 2016-04-01.
 */
@Data
public class ValidationErrorInfo {
    private String name;
    private String message;

    public ValidationErrorInfo(){}

    public ValidationErrorInfo(ObjectError oe) {
        this.name = ((FieldError)oe).getField();
    }
}
