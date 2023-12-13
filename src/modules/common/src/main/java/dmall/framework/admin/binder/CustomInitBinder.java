package dmall.framework.admin.binder;

import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.InitBinder;

import dmall.framework.admin.editor.DoubleEditor;
import dmall.framework.admin.editor.IntegerEditor;
import dmall.framework.admin.editor.LongEditor;
import dmall.framework.admin.editor.TimestampEditor;

//import java.sql.Timestamp;
import java.util.Date;

@ControllerAdvice
public class CustomInitBinder {

	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.registerCustomEditor(Date.class, new TimestampEditor(true));
//		binder.registerCustomEditor(Timestamp.class, new TimestampEditor(true));
		binder.registerCustomEditor(Integer.class, new IntegerEditor(true));
		binder.registerCustomEditor(Long.class, new LongEditor(true));
		binder.registerCustomEditor(Double.class, new DoubleEditor(true));
	}

}