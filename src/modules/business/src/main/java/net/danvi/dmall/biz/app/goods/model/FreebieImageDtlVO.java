package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 25.
 * 작성자     : dong
 * 설명       : 사은품 이미지 상세 정보 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieImageDtlVO {
    // 사은품 번호
    private long freebieNo;
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
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
    // 원본 이미지 명
    private String orgImgNm;
}
