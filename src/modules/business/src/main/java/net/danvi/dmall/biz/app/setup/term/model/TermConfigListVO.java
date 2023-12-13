package net.danvi.dmall.biz.app.setup.term.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.Date;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 09. 01.
 * 작성자     : slims
 * 설명       : 약관 개인정보 설정 리스트 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TermConfigListVO extends BaseModel<TermConfigListVO> {
    // 사이트 정보 코드
    private int rowNum;
    // 사이트 정보 코드
    private Long siteNo;
    // 사이트 정보 코드
    private String siteInfoCd;
    // 사이트 정보 고유 코드
    private String siteInfoNo;
    // 사용 여부
    private String useYn;
    // 메인탭 여부
    private String isMain;

    private String title;

    private String regDt;

    private String sortNum;
}
