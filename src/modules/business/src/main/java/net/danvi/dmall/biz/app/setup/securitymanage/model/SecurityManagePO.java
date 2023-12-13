package net.danvi.dmall.biz.app.setup.securitymanage.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-06-13.
 */
@Data
public class SecurityManagePO extends BaseModel<SecurityManagePO> {
    /** 보안 서버 사용 유형 코드 */
    private String securityServUseTypeCd;
    /** 보안 서버 상태 코드 */
    private String securityServStatusCd;
    /** 인증서 적용 시작 일자 */
    private String applyStartDt;
    /** 인증서 적용 종료 일자 */
    private String applyEndDt;
    /** 보안서버 도메인 */
    private String domain;
    /** 보안서버 포트 */
    private Integer port;
    /** 인증 마크 표시 여부 */
    private String certifyMarkDispYn;

    public SecurityManagePO() {
        this.securityServUseTypeCd = "3";
        this.securityServStatusCd = "3";
        this.certifyMarkDispYn = "N";
    }
}
