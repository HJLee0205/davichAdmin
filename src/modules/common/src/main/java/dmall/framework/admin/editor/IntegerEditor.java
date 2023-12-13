package dmall.framework.admin.editor;

import java.beans.PropertyEditorSupport;

import dmall.framework.common.util.StringUtil;

public class IntegerEditor extends PropertyEditorSupport {

    private final boolean allowEmpty;

    public IntegerEditor(boolean allowEmpty) {
        this.allowEmpty = allowEmpty;
    }

    public void setAsText(String text) throws IllegalArgumentException {
        if ((this.allowEmpty) && (StringUtil.isBlank(text))) {
            setValue(null);
        } else {
            String value = text.replaceAll(",", "");
            setValue(Integer.parseInt(value));
        }
    }

    public String getAsText() {
        Integer value = (Integer) getValue();
        return ((value != null) ? String.valueOf(value) : "");
    }
}