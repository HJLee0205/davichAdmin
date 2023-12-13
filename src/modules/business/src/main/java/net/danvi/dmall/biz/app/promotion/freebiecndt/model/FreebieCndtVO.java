package net.danvi.dmall.biz.app.promotion.freebiecndt.model;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieCndtVO extends BaseModel<FreebieCndtVO> {
    // 단건조회
    private int freebieEventNo;
    private String freebieEventNm;
    private String freebieEventDscrt;
    private String applyStartDttm;
    private String applyEndDttm;
    private String freebiePresentCndtCd; // 사은품 증정조건 : 01 일정금액 이상 구매 시, 02 개별상품 구매 시
    private long freebieEventAmt; // 사은품지급 충족금액
    private String useYn;

    // 목록조회
    private String rownum;
    private String freebieStatusCd;
    private String[] freebieStatusCds;
    private String freebieStatusNm;
    private Date regDttm;

    // 사은품대상 리스트
    private List<FreebieTargetVO> targetResult;

    // 사은품상품 리스트
    private List<FreebieGoodsVO> goodsResult;
}
