package net.danvi.dmall.biz.app.promotion.timedeal.model;

import dmall.framework.common.model.EditorBaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 타임딜 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TimeDealVO extends EditorBaseVO<TimeDealVO> {
    // 단건조회
    private int prmtNo;
    private String prmtNm;
    private String applyStartDttm;
    private String applyEndDttm;
    private int prmtDcValue; // 할인률
    private int applySeq; // 적용 순서
    private String useYn; // 사용여부
    private String applyAlwaysYn;
    // 목록조회
    private String rownum;
    private String sortNum;
    private String pagingNum;
    private String[] prmtStatusCds; // 타임딜 상태코드
    private String prmtStatusNm; // 타임딜 상태명
    // 타임딜대상
    private List<TimeDealTargetVO> goodsList;
    private String goodsNo; // 상품번호
    private String goodsNm; // 상품명
    private String brandNo; // 브랜드 번호
    private String brandNm; // 브랜드 명
    private String supplyPrice; // 공급가
    private String salePrice; // 판매가
    private String ctgNm; // 카테고리 명
    private String goodsImg02; // 상품 이미지
    private String sellerNm; // 판매자 명
    private String stockQtt; // 재고
    private String goodsSaleStatusNm; // 재고
    private String erpItmCode; // 다비젼 상품 코드
    //추가
    private String regDate;
}
