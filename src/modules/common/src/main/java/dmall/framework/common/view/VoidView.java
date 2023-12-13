package dmall.framework.common.view;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.view.AbstractView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * File VIEW
 * @author 	snw
 * @since 	2013.07.30
 */
@Slf4j
public class VoidView extends AbstractView {

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model
		, HttpServletRequest request
		, HttpServletResponse response) throws Exception {
	}
}
