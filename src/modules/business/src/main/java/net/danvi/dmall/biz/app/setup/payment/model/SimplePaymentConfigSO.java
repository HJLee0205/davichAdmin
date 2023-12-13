package net.danvi.dmall.biz.app.setup.payment.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 20.
 * 작성자     : dong
 * 설명       : 간편연동 설정 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SimplePaymentConfigSO extends BaseModel<SimplePaymentConfigSO> {
    // 간편결제 PG 코드
    private String simpPgCd;
}
