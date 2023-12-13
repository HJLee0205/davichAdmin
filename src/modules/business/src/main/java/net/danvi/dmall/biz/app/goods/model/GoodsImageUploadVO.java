package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.util.image.ImageType;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 12.
 * 작성자     : dong
 * 설명       : 상품 임시 이미지 정보 처리용 Value Object
 * </pre>
 */
@Data
public class GoodsImageUploadVO {
    // 상품 이미지 URL
    private String imageUrl;
    // 파일 명
    private String fileName;
    // 파일 폴터 
    private String filePath;
    // 임시 파일 명
    private String tempFileName;
    // 썸네일 URL
    private String thumbUrl;
    // 이미지 유형
    private String imgType;
    // 파일 크기
    private Long fileSize;
    // 유형
    private String type;
    // 임시 파일 여부
    private Boolean temp = true;
    // 이미지 사이즈 가로
    private String imageWidth;
    // 이미지 사이즈 세로
    private String imageHeight;

    public GoodsImageUploadVO() {
    }

    /**
     * 서버에 저장된 이미지 정보로 에디터의 이미지 정보를 생성
     *
     * @param po
     */
    public GoodsImageUploadVO(CmnAtchFilePO po) {
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
