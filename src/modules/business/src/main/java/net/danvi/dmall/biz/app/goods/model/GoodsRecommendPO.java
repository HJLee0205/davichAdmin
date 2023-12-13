package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;

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
public class GoodsRecommendPO extends BaseModel<GoodsRecommendPO> {
    // 상품 번호
    private String goodsNo;
    // 추천 타입
    private String recType;
    // 사용 여부
    private String useYn;
    // 등록 일자
    private String regDate;
    // 수정 일자
    private String updDate;
    // 등록자 번호
    private Long regrNo;
    // 사용자 번호
    private Long updrNo;
    // 상품 번호 목록
    private ArrayList<String> insRecommendGoodsNoList;
    // 상품 번호 목록
    private int insCnt;
    // 이전 정렬 순서
    private String orgSortSeq;
    // 이전 상품 번호
    private String orgGoodsNo;
    // 변경할 정렬 순서
    private String sortSeq;
    // 상품군
    private String goodsTypeCd;
    // 삭제 상품 번호
    private String[] delList;
}
