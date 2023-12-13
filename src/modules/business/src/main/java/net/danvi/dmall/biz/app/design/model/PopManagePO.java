package net.danvi.dmall.biz.app.design.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       : 팝업관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper = false)
public class PopManagePO extends EditorBasePO<PopManagePO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long popupNo; // 팝업번호

    private Long fileNo; // 파일번호
    private String pcGbCd; // 피씨 구분코드
    private String popupNm; // 팝업명
    private String content; // 내용
    private Long widthSize; // 가로길이
    private Long heightSize; // 세로길이
    private Long pstTop; // 높이위치
    private Long pstLeft; // 왼쪽위치

    private String filePath; // 파일 경로
    private String orgFileNm; // 원본 파일명
    private String fileNm; // 파일명
    private Long fileSize; // 파일 사이즈

    private Long sortSeq; // 정렬순서
    private String dispStartDttm; // 전시 시작일
    private String dispEndDttm; // 전시 종료일
    private String popupGrpCd; // 팝업 그룹코드
    private String popupGbCd; // 팝업 구분코드

    private Long cookieValidPeriod; // 쿠키 유효기간
    private String dispYn; // 전시여부
    private String applyAlwaysYn; // 무제한 적용 여부
    private String linkUrl; // 링크 URL

}
