package net.danvi.dmall.biz.app.setup.personcertify.model;

import net.danvi.dmall.biz.system.validation.InsertGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       : 본인 확인 인증 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PersonCertifyConfigPO extends BaseModel<PersonCertifyConfigPO> {

    // 인증 수단 코드
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String certifyTypeCd;
    // 사이트 코드
    private String siteCd;
    // 사이트 패스워드
    private String sitePw;
    // 사용 여부
    private String useYn;
    // 인증 파일 경로
    private String certifyFilePath;
    // 회원 가입 사용 여부
    private String memberJoinUseYn;
    // 비밀번호 찾기 사용 여부
    private String pwFindUseYn;
    // 비회원 인증 사용 여부
    private String dormantmemberCertifyUseYn;
    // 성인 인증 접근 사용 여부
    private String adultCertifyAccessUseYn;

}
