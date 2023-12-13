package net.danvi.dmall.biz.app.setup.personcertify.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 본인 확인 인증 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PersonCertifyConfigVO extends BaseModel<PersonCertifyConfigVO> {
    // 인증 유형 코드
    private String certifyTypeCd;
    // 사용 여부
    private String useYn;
    // 사이트 코드
    private String siteCd;
    // 사이트 패스워드
    private String sitePw;
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
    // 성인 인증 수단 설정 여부
    private String checkExistAdultCertifyYn;
    // 반환 url
    private String returnUrl;
    // PRI 정보
    private String priInfo;
    // 인코딩 데이터
    private String encData;

}
