package dmall.framework.common.model;

import lombok.Data;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.util.image.ImageType;

/**
 * Created by dong on 2016-05-23.
 */
@Data
public class EditorImageVO {

    private String imageUrl;
    private String fileName;
    private String tempFileName;
    private String thumbUrl;
    private Long fileSize;
    private Boolean temp = true;

    public EditorImageVO() {
    }

    /**
     * 서버에 저장된 이미지 정보로 에디터의 이미지 정보를 생성
     *
     * @param po
     */
    public EditorImageVO(CmnAtchFilePO po) {
        this.fileSize = po.getFileSize();
        this.fileName = po.getOrgFileNm();
        this.tempFileName = po.getFilePath() + "_" + po.getFileNm();
        this.temp = false;

        if (po.getImageType() == ImageType.EDITOR_IMAGE) {
            this.imageUrl = UploadConstants.IMAGE_EDITOR_URL + po.getFilePath() + "_" + po.getFileNm();
            this.thumbUrl = UploadConstants.IMAGE_EDITOR_URL + po.getFilePath() + "_" + po.getFileNm()
                    + CommonConstants.IMAGE_THUMBNAIL_PREFIX;
        }
    }
}
