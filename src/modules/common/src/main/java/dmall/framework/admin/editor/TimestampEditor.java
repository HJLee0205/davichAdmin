package dmall.framework.admin.editor;

import java.beans.PropertyEditorSupport;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.StringUtil;

public class TimestampEditor extends PropertyEditorSupport {

    private final boolean allowEmpty;

    public TimestampEditor(boolean allowEmpty) {
        this.allowEmpty = allowEmpty;
    }

    public void setAsText(String text) throws IllegalArgumentException {
        if ((this.allowEmpty) && (StringUtil.isBlank(text))) {
            setValue(null);
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);

            if (text.length() == 10) {
                sdf.applyPattern("yyyy-MM-dd");
            } else if (text.length() == 19) {
                if (!DateUtil.isTime(text.substring(11))) {
                    throw new IllegalArgumentException("Date Error");
                }
            } else {
                throw new IllegalArgumentException("Date Error");
            }

            try {
                Date date = sdf.parse(text);
                setValue(new Timestamp(date.getTime()));
            } catch (ParseException e) {
                throw new IllegalArgumentException("Date Error", e);
            }
        }
    }

    public String getAsText() {
        Timestamp value = (Timestamp) getValue();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
        return ((value != null) ? sdf.format(value) : "");
    }
}