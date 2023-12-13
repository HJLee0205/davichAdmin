package net.danvi.dmall.biz.app.setup.term.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       : 약관 개인정보 설정 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TermConfigPO extends EditorBasePO<TermConfigPO> {
    // 사이트 정보 고유번호
    private Long siteInfoNo;
    // 상위 사이트 정보 고유번호
    private Long upSiteInfoNo;

    // 사이트 정보 코드
    private String siteInfoCd;
    // 사이트 정보 코드 (비회원)
    private String siteInfoCdNoMember;
    // 사이트 정보 코드 (반품/교환)
    private String siteInfoCdExchange;
    // 사이트 정보 코드 (반품/환불)
    private String siteInfoCdRefund;

    // 변경 title
    private String title;
    // 기존 title
    private String beforeTitle;

    // 내용
    private String content;
    // 내용 (비회원)
    private String contentNoMember;
    // 내용 (반품/교환)
    private String contentExchange;
    // 내용 (반품/환불)
    private String contentRefund;

    // 표준 약관 적용 여부
    private String stdTermsApplyYn;
    // 사용 여부
    private String useYn;

}
