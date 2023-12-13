package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 21.
 * 작성자     : dong
 * 설명       : 사은품 이미지 상세 정보 등록 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieImageDtlPO extends BaseModel<FreebieImageDtlPO> {
    // 사은품 번호
    private String freebieNo;
    // 이미지 유형
    private String freebieImgType;
    // 이미지 경로
    private String imgPath;
    // 이미지 명
    private String imgNm;
    // 이미지 넓이
    private int imgWidth;
    // 이미지 높이
    private int imgHeight;
    // 임시 이미지 파일명 (임시이미지 삭제에 필요)
    private String tempFileNm;
    // 원본 이미지 명
    private String orgImgNm;
}
