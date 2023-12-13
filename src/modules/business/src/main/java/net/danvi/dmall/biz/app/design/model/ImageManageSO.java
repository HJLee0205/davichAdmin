package net.danvi.dmall.biz.app.design.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : html edit관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class ImageManageSO extends BaseSearchVO<ImageManageSO> {
    // private String siteNo;
    // 검색전용

    private String fileNm; // 파일명
    private String orgFileNm; // 원본파일명
    private String filePath; // 파일경로
    private String baseFilePath; // 원본파일경로
    private String searchNm; // 검색명

}
