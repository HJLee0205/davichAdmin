package net.danvi.dmall.biz.app.promotion.freebiecndt.model;

import net.danvi.dmall.biz.system.validation.InsertGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieCndtPO extends BaseModel<FreebieCndtPO> {
    private int freebieEventNo;
    private String freebieEventNm;
    private String freebieEventDscrt;
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String applyStartDttm;
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String applyEndDttm;
    private int freebieEventAmt; // 사은품지급 충족금액
    private String freebiePresentCndtCd; // 사은품 증정조건 : 01 일정금액 이상 구매 시, 02 개별상품 구매 시
    private String freebiePresentCndtCdOrigin; // 수정 전 시점에서, 사은품 증정조건
    private String goodsNo; // 사은품 대상
    private String[] goodsNoArr;
    private String freebieNo; // 사은품 상품
    private String[] freebieNoArr;
    private String useYn;

    private String from; // 시작 일
    private String fromHour; // 시작 시
    private String fromMinute; // 시작 분
    private String to; // 종료 일
    private String toHoure; // 종료 시
    private String toMinute; // 종료 분

    // 2016.09.05 현재 사용안함. 일주일 후 삭제 예정
    // private String freebieStatusCd; // 사은품이벤트 상태
}
