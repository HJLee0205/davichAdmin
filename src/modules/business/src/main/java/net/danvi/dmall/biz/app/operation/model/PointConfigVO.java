package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 포인트 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PointConfigVO extends BaseModel<PointConfigVO> {
    // 포인트 지급 여부
    private String pointPvdYn;
    // 포인트 절사 기준 코드
    private String pointTruncStndrdCd;
    // (일반) 구매 후기 별 포인트
    private String buyEplgWritePoint;
    // (프리미엄) 구매 후기 별 포인트
    private String buyEplgWritePmPoint;
    // 포인트 적립 유효 기간
    private String pointAccuValidPeriod;
}
