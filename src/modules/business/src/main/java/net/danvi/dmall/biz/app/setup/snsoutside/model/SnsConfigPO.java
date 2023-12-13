package net.danvi.dmall.biz.app.setup.snsoutside.model;

import org.hibernate.validator.constraints.Length;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 7.
 * 작성자     : dong
 * 설명       : SNS 외부연동 설정 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SnsConfigPO extends BaseModel<SnsConfigPO> {
    // 외부 연동 코드
    private String outsideLinkCd;
    // 연동 사용 여부
    private String linkUseYn;
    // 연동 운영 여부
    private String linkOperYn;
    // APP ID
    @Length(min = 0, max = 100)
    private String appId;
    // APP_SECRET
    @Length(min = 0, max = 100)
    private String appSecret;
    // APP_NAMESPACE
    @Length(min = 0, max = 100)
    private String appNamespace;
    // 쇼핑몰 명
    @Length(min = 0, max = 16)
    private String spmallNm;
    // 도메인 등록
    @Length(min = 0, max = 50)
    private String domainReg;
    // 쇼핑몰 로고 이미지
    private String spmallLogoImg;
    // Javascript Key
    @Length(min = 0, max = 100)
    private String javascriptKey;
    // 한글 도메인
    private String koreanDomain;
    // 변경 결과
    private String chgResult;
    // 컨텐츠 사용 여부
    private String contsUseYn;
}
