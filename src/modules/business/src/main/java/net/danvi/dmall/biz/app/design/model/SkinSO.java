package net.danvi.dmall.biz.app.design.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 21.
 * 작성자     : dong
 * 설명       : 스킨설정 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class SkinSO extends BaseSearchVO<SkinSO> {
    // private String siteNo;
    // 검색전용
    private String skinNo; // 스킨번호
    // private String site_no;
    private String skinId; // 사이트 아이디
    private String pcGbCd; // 피씨구분코드
    private String orgSkinNo; // 원본스킨번호
    private String defaultSkinYn; // 기본스킨여부
    private String skinNm; // 스킨명
    private String imgNm; // 이미지명
    private String imgPath; // 이미지경로
    private String folderPath; // 폴더경로
    private String orgFolderPath; // 원본 폴더 경로
    private String applySkinYn; // 적용 스킨 여부
    private String workSkinYn; // 작업 스킨 여부
    private String delYn; // 전시 여부

}
