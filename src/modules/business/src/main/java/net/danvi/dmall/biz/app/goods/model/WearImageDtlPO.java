package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 이미지 상세 정보 등록 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class WearImageDtlPO extends BaseModel<WearImageDtlPO> {
    // 상품 번호
    private String goodsNo;
    // 착용샷 이미지 세트 번호
    private Long wearImgsetNo;
    // 대표이미지 세트 여부
    private String dlgtImgYn;
    // 착용샷 이미지 유형
    private String wearImgType;
    // 이미지 경로
    private String imgPath;
    // 이미지 명
    private String imgNm;
    // 이미지 넓이
    private int imgWidth;
    // 이미지 높이
    private int imgHeight;
    // 이미지 사이즈
    private int imgSize;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
    // 임시 이미지 파일명 (임시이미지 삭제에 필요)
    private String tempFileNm;
    // 이미지 URL
    private String imgUrl;
    // 썸네일 URL
    private String thumbUrl;



}
