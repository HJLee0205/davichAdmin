package net.danvi.dmall.biz.system.model;

import java.util.Date;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

@Data
@EqualsAndHashCode(callSuper = false)
public class CmnCdGrpPO extends BaseModel<T> {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    /** 그룹 코드 */
    private String grpCd;

    /** 그룹 명 */
    private String grpNm;

    /** 사용자 정의1 명 */
    private String userDefine1Nm;

    /** 사용자 정의2 명 */
    private String userDefine2Nm;

    /** 사용자 정의3 명 */
    private String userDefine3Nm;

    /** 사용자 정의4 명 */
    private String userDefine4Nm;

    /** 사용자 정의5 명 */
    private String userDefine5Nm;

    /** 시스템 삭제 여부 */
    private String delYn;

    /** 시스템 삭제자 번호 */
    private Long delrNo;

    /** 시스템 삭제 일시 */
    private Date delDttm;

}