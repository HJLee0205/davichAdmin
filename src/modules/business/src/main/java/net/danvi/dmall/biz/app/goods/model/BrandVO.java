package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BrandVO extends BaseModel<BrandVO> {
    private String brandNo; // 브랜드 번호
    private String brandNm; // 브랜드명
    private String brandExhbtionTypeCd; // 브랜드 진열 유형 코드
    private String dispYn; // 전시여부
    // private String brandDispTypeCd;
    private String brandImgPath; // 브랜드 이미지경로
    private String brandImgNm; // 브랜드 이미지명
    private String mouseoverImgPath; // 마우스오버용 이미지 경로
    private String mouseoverImgNm; // 마우스오버용 이미지 명
    private String listImgPath;// 목록 이미지 경로
    private String listImgNm; // 목록 이미지 명
    private String dtlImgPath;// 상세 이미지 경로
    private String dtlImgNm; // 상세 이미지 명
    private String logoImgPath;// 로고 이미지 경로
    private String logoImgNm; // 로고 이미지 명
    private String brandLogoImgPath;// 브랜드로고 이미지 경로
    private String brandLogoImgNm; // 브랜드로고 이미지 명
    // private String totalConnectAuthYn;
    // private String memberConnectAuthYn;
    private String brandGoodsCnt; // 브랜드에 상품 걸린갯수
    private String brandSalesGoodsCnt; // 브랜드에 파는 상품 걸린갯수
    private String mainDispYn; // 메인 전시 여부
    private String goodsTypeCd; //상품유형
    private String brandEnnm; //브랜드 영문명

}
