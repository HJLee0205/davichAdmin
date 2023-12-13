package dmall.framework.common.view;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tika.Tika;
import org.springframework.web.servlet.view.AbstractView;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.util.FileUtil;

/**
 * File VIEW
 *
 * @author snw
 * @since 2013.07.30
 */
@Slf4j
public class ImageView extends AbstractView {

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        FileViewParam fileView = (FileViewParam) model.get(CommonConstants.FILE_PARAM_NAME);

        File file = new File(fileView.getFilePath());

        log.debug("=====================================================");
        log.debug("= FilePath : {}", fileView.getFilePath());
        log.debug("= file.exists() : {}", file.exists());
        log.debug("=====================================================");

        if(file.exists()){
            String mimeType = null;
            try {
                Tika tika = new Tika();
                mimeType = tika.detect(file);
            } catch (Exception e) {
                log.debug("tika 오류. mimeType을 판별하지 못함 [{}]", mimeType);
            }
            response.setContentType(mimeType);
            log.debug("mimeType:{}", mimeType);
            if (mimeType == null) {
                response.setContentType("image/png");
            }
            if(mimeType.equals("image/x-ms-bmp")){
                response.setContentType("image/bmp");
            }

            log.debug("contentType:{}", response.getContentType());

            FileUtil.writeFileToResponse(response, file);

            response.flushBuffer();
        }

    }
}
