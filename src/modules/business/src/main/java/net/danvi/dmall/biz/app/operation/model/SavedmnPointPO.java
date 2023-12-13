package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : kjw
 * 설명       : 마켓포인트 지급/차감 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class SavedmnPointPO extends BaseModel<SavedmnPointPO> {
    // 주문번호
    private String ordNo;
    // 주문 상세 순번
    private long ordDtlSeq;
    // 차감 구분 코드
    private String deductGbCd;
    // 기타 사유
    private String etcReason;
    // 기타 유효기간
    private String etcValidPeriod;
    // 유효기간 코드(직접입력,제한없음,12월31일)
    private String validPeriod;
    // 구분 코드(지급, 차감)
    private String gbCd;
    // 회원 번호
    private long memberNo;
    // 마켓포인트 순번
    private long svmnSeq;
    // 마켓포인트 사용 번호
    private long useNo;
    // 포인트 순번
    private long pointSeq;
    // 처리포인트
    private String prcPoint;
    // 포인트 사용 가능 여부
    private String pointUsePsbYn;
    // 사유 코드
    private String reasonCd;
    // 유형 코드(자동,수동)
    private String typeCd;
    // 처리금액
    private String prcAmt;
    // 마켓포인트 사용 가능 여부
    private String svmnUsePsbYn;
    // 마켓포인트 사용 가능 금액
    private String svmnUsePsbAmt;
    // 주문 취소 여부
    private String ordCanselYn;
    // 마켓포인트 사유 코드
    private String svmnReasonCd;
    // ERP 주문번호(ERP에서 몰마켓포인트 사용시) [ERP판매테이블 PK조합]
    private String erpOrdNo;
    // 마켓포인트 오프라인 쿠폰전환
    private int couponNo;
    // 쿠폰종류(오프라인쿠폰:99)
    private String couponKindCd;

    private List<OrderGoodsPO> orderGoodsPO;// 상품정보
}
