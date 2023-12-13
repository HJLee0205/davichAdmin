package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 카테고리 선택 정보 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsCtgPO extends BaseModel<GoodsCtgPO> {
    // 상품 번호
    private String goodsNo;
    // 카테고리 번호
    private String ctgNo;
    // 대표 카테고리 여부
    private String dlgtCtgYn;
    // 노출 여부
    private String expsYn;
    // 노출 우선 순위
    private String expsPriorRank;
    // 삭제 여부
    private String delYn;
    // 등록 FLAG
    private String registFlag;
    // 카테고리 경로 (화면표시용)
    private String ctgDisplayNm;
    // 상품 복사시 복사원본 상품번호
    private String targetGoodsNo;
    // 상품 복사시 복사생성 상품번호
    private String newGoodsNo;
    // 카테고리 명 1
    private String ctgNm1;
    // 카테고리 명 2
    private String ctgNm2;
    // 카테고리 명 3
    private String ctgNm3;
    // 카테고리 명 4
    private String ctgNm4;
}
