package dmall.framework.common.validator;

import dmall.framework.common.constraint.NullOrLength;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * Created by dong on 2016-04-08.
 */
public class NullOrLengthValidator implements ConstraintValidator<NullOrLength, String> {

    private NullOrLength nullOrLength;

    @Override
    public void initialize(NullOrLength nullOrLength) {
        this.nullOrLength = nullOrLength;
    }

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        if (s == null || s.length() == 0) {
            return true;
        }

        s = s.trim();

        if (s.length() < nullOrLength.min() || s.length() > nullOrLength.max()) {
//            constraintValidatorContext.disableDefaultConstraintViolation();
//            constraintValidatorContext.buildConstraintViolationWithTemplate( nullOrLength.message() ).addConstraintViolation();
            return false;
        }

        return true;
    }
}
