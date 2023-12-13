package dmall.framework.common.view;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.view.AbstractView;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.util.FileUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.net.URLEncoder;
import java.util.Map;

/**
 * File VIEW
 * @author 	snw
 * @since 	2013.07.30
 */
@Slf4j
public class FileView extends AbstractView {

	public FileView() {
		setContentType("application/download; charset=utf-8");
	}

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,	HttpServletRequest request, HttpServletResponse response) throws Exception {

		FileViewParam fileView = (FileViewParam)model.get(CommonConstants.FILE_PARAM_NAME);

		String fileName = fileView.getFileName();
		File file = new File(fileView.getFilePath().replaceAll("[/\\\\]{2,}", "/"));

		log.debug(">>>>FileView Name="+fileView.getFileName());
		log.debug(">>>>FileView Path="+fileView.getFilePath());
		log.debug("file exist : {}", file.exists());

		response.setContentType(getContentType());
		response.setContentLength((int) file.length());

		fileName = URLEncoder.encode(fileName, "utf-8");
		fileName = fileName.replaceAll("\\+", " ");

		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");

		FileUtil.writeFileToResponse(response, file);
	}

}
