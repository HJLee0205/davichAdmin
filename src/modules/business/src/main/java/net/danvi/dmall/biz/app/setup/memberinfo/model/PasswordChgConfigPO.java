package net.danvi.dmall.biz.app.setup.memberinfo.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 2.
 * 작성자     : dong
 * 설명       : 회원정보 변경 관리 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PasswordChgConfigPO extends BaseModel<PasswordChgConfigPO> {
    // 비밀번호 변경 안내 여부
    private String pwChgGuideYn;
    // 비밀번호 변경 안내 주기
    private String pwChgGuideCycle;
    // 비밀번호 변경 다음 변경 일자
    private String pwChgNextChgDcnt;
    // 비회원 취소 방법
    private String dormantMemberCancelMethod;
}
