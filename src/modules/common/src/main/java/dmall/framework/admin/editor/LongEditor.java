package dmall.framework.admin.editor;

import java.beans.PropertyEditorSupport;

import dmall.framework.common.util.StringUtil;

public class LongEditor extends PropertyEditorSupport {

    private final boolean allowEmpty;

    public LongEditor(boolean allowEmpty) {
        this.allowEmpty = allowEmpty;
    }

    public void setAsText(String text) throws IllegalArgumentException {
        if ((this.allowEmpty) && (StringUtil.isBlank(text))) {
            setValue(null);
        } else {
            String value = text.replaceAll(",", "");
            setValue(Long.parseLong(value));
        }
    }

    public String getAsText() {
        Long value = (Long) getValue();
        return ((value != null) ? String.valueOf(value) : "");
    }
}