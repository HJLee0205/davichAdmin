package net.danvi.dmall.biz.app.setup.snsoutside.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 7.
 * 작성자     : dong
 * 설명       : SNS 외부연동 설정 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SnsConfigVO extends BaseModel<SnsConfigVO> {
    // 외부 연동 코드
    private String outsideLinkCd;
    // 연동 사용 여부
    private String linkUseYn;
    // 연동 운영 여부
    private String linkOperYn;
    // APP ID
    private String appId;
    // APP_SECRET
    private String appSecret;
    // APP_NAMESPACE
    private String appNamespace;
    // 쇼핑몰 명
    private String spmallNm;
    // 도메인 등록
    private String domainReg;
    // 쇼핑몰 로고 이미지
    private String spmallLogoImg;
    // Javascript Key
    private String javascriptKey;
    // 한글 도메인
    private String koreanDomain;
    // 변경 결과
    private String chgResult;
    // 컨텐츠 사용 여부
    private String contsUseYn;
    // SNS 추가 가능 여부
    private boolean isSnsAddible;
}
