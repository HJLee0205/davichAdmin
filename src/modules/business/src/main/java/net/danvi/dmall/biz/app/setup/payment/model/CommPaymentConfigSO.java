package net.danvi.dmall.biz.app.setup.payment.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 15.
 * 작성자     : dong
 * 설명       : PG연동 설정 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CommPaymentConfigSO extends BaseSearchVO<CommPaymentConfigSO> {
    // PG코드
    private String pgCd;
    // 사용 여부
    private String useYn;
    // 수정 or 등록
    private String editYn;
    // PGID
    private String pgId;
    // 가맹점 명
    private String shopNm;
    // 가맹점 코드
    private String shopCd;
}
