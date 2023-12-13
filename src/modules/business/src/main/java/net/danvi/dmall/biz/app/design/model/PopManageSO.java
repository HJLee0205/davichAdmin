package net.danvi.dmall.biz.app.design.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       : 팝업관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class PopManageSO extends BaseSearchVO<PopManageSO> {
    // private String siteNo;
    // 검색전용
    private String fromRegDt; // 조회 시작일
    private String toRegDt; // 조회 종료일
    private String dateGubn; // 날짜 조회구분
    private String applyAlwaysYn; // 무제한 적용 여부
    // 기본값들
    private String popupNo; // 팝업번호
    private String fileNo; // 파일번호
    private String pcGbCd; // 피씨구분코드
    private String popupNm; // 팝업명
    private String content; // 내용
    private String widthSize; // 가로길이
    private String heightSize; // 세로길이
    private String pstTop; // 높이위치
    private String pstLeft; // 왼쪽 위치
    private String sortSeq; // 정렬순서
    private String dispStartDttm; // 전시 시작일
    private String dispEndDttm; // 전시 종료일
    private String popupGrpCd; // 팝업 그룹코드
    private String popupGbCd; // 팝업 구분코드
    private String cookieValidPeriod; // 쿠키 유효일수
    private String dispYn; // 전시여부
    private String linkUrl; // 링크
    
    // QR코드에 필요
    private String goodsNo;
    private String eventNo;
    private String prmtNo;

}
