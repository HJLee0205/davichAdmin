package net.danvi.dmall.biz.app.setup.term.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
public class TermConfigSO extends BaseSearchVO<TermConfigSO> {
    // 사이트 정보 코드
    private String siteInfoCd;
    // 사이트 정보 코드
    private String siteInfoNo;

    private String title;

    private Long siteNo;

    private String contents;

    private String keyData;

    private String memberCardNo;
    // 메인탭 여부
    private String isMain;
    // 사용 여부
    private String useYn;
    // 수정 or 업데이트
    private String type;
}
