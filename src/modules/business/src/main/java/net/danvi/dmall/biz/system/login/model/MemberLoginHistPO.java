package net.danvi.dmall.biz.system.login.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.apache.poi.ss.formula.functions.T;
import dmall.framework.common.model.BaseModel;

import java.sql.Timestamp;

@Data
@EqualsAndHashCode(callSuper = false)
public class MemberLoginHistPO extends BaseModel<T> {

    /** UID */
    private static final long serialVersionUID = 1L;

    /** 사용자 번호 */
    private Long memberNo;

    /** 로그인 순번 */
    private Long loginNo;

    /** 로그인 IP */
    private String loginIp;

    /** 로그인 일시 */
    private Timestamp loginDttm;

}