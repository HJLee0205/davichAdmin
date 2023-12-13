package dmall.framework.admin.editor;

import java.beans.PropertyEditorSupport;

import dmall.framework.common.util.StringUtil;

/**
 * Created by dong on 2016-04-06.
 */
public class DoubleEditor extends PropertyEditorSupport {

    private final boolean allowEmpty;

    public DoubleEditor(boolean allowEmpty) {
        this.allowEmpty = allowEmpty;
    }

    public void setAsText(String text) throws IllegalArgumentException {
        if ((this.allowEmpty) && (StringUtil.isBlank(text))) {
            setValue(null);
        } else {
            String value = text.replaceAll(",", "");
            setValue(Double.parseDouble(value));
        }
    }

    public String getAsText() {
        Double value = (Double) getValue();
        return ((value != null) ? String.valueOf(value) : "");
    }
}