package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 22.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BrandSO extends BaseSearchVO<BrandSO> {
    private Long brandNo; // 브랜드번호
    private String brandNm; // 브랜드명
    private String brandExhbtionTypeCd; // 브랜드 진열 유형 코드
    private String dispYn; // 전시여부
    // private String brandDispTypeCd;
    private String brandImgPath; // 브랜드 이미지 경로
    private String brandImgNm; // 브랜드 이미지 명
    private String mouseoverImgPath; // 마우스 오버 이미지 경로
    private String mouseoverImgNm; // 마우스오버 이미지 명
    private String listImgPath;// 목록 이미지 경로
    private String listImgNm; // 목록 이미지 명
    private String dtlImgPath;// 상세 이미지 경로
    private String dtlImgNm; // 상세 이미지 명
    private String logoImgPath;// 로고 이미지 경로
    private String logoImgNm; // 로고 이미지 명
    // private String totalConnectAuthYn;
    // private String memberConnectAuthYn;
    private String mainDispYn; // 메인 전시 여부
    private String goodsTypeCd; //상품유형
    private String brandEnnm; //브랜드 영문명
}
