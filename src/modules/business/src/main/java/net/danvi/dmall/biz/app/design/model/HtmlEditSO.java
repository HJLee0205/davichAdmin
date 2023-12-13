package net.danvi.dmall.biz.app.design.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : html edit관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class HtmlEditSO extends BaseSearchVO<HtmlEditSO> {
    // private String siteNo;
    // 검색전용

    private String pcGbCd; // 피씨 구분코드
    private String skinNo; // 스킨번호
    private String skinId; // 스킨아이디
    private String tmplNo; // 템플릿 번호
    private String fileNm; // 파일명
    private String filePath; // 파일경로
    private String baseFilePath; // 기본파일경로
    private String applySkinYn; // 적용스킨여부
    private String workSkinYn; // 작업스킨여부

}
