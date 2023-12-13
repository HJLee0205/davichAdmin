package net.danvi.dmall.biz.app.setup.payment.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 14.
 * 작성자     : dong
 * 설명       : PG연동 설정 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SimplePaymentConfigVO extends BaseModel<SimplePaymentConfigVO> {
    // 간편 결제 사용 여부
    private String simplepayUseYn;
    // 간편 결제 PG 코드
    private String simpPgCd;
    // 간편 결제 유형 코드
    private String simpPgTypeCd;
    // 사용 설정 코드
    private String useSetCd;
    // 가맹점 코드
    private String frcCd;
    // 상점 ID
    private String storeId;
    // 상점 PW
    private String storePw;
    // 사용 영역 코드
    private String useAreaCd;
    // 디자인 설정 코드
    private String dsnSetCd;
}
