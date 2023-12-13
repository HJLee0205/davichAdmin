package net.danvi.dmall.biz.app.setup.term.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 약관 개인정보 설정 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TermConfigVO extends EditorBasePO<TermConfigVO> {
    // 사이트 정보 코드
    private String siteInfoCd;
    // 사이트 정보 고유 코드
    private String siteInfoNo;
    // 사이트 타이틀
    private String title;
    // 사이트 정보 코드 (비회원)
    private String siteInfoCdNoMember;
    // 내용
    private String content;
    // 네용 (비회원)
    private String contentNoMember;
    // 표준약관 적용 여부
    private String stdTermsApplyYn;
    // 사용 여부
    private String useYn;
    // 메인탭 여부
    private String isMain;
    // 사인 이미지 Blob
    private byte[] sign;
    // 추가 / 업데이트
    private String type;
}
