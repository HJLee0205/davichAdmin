package net.danvi.dmall.biz.app.operation.model;

import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       : 포인트 정보 설정 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PointConfigPO extends BaseModel<PointConfigPO> {
    // 포인트 지급 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String pointPvdYn;
    // 포인트 절사 기준 코드
    private String pointTruncStndrdCd;
    // (일반) 구매후기 별 포인트
    private String buyEplgWritePoint;
    // (프리미엄) 구매후기 별 포인트
    private String buyEplgWritePmPoint;
    // 포인트 적립 유효기간
    private String pointAccuValidPeriod;

}
