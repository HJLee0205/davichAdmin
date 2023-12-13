package net.danvi.dmall.biz.app.design.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 07. 04.
 * 작성자     : dong
 * 설명       : 배너관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class BannerSO extends BaseSearchVO<BannerSO> {
    // private String siteNo;
    // 검색전용
    private String typeCd; // 베너 타입
    private String fromRegDt; // 검색 시작일시
    private String toRegDt; // 검색 종료일시
    private String[] goodsTypeCds; // 베너 유형
    // 기본값들
    private String bannerNo; // 배너번호
    private String skinNo; // 스킨번호
    private String pcGbCd; // PC 구분 코드
    private String bannerMenuCd; // 배너 메뉴코드
    private String bannerAreaCd; // 배너 영역 코드
    private String bannerNm; // 배너명
    private String sortSeq; // 정렬순서
    private String dispYn; // 전시여부

    private String todayYn; // 오늘해당 조건여부
    private String goodsTypeCd; // 베너 유형
    private String applyAlwaysYn; // 무제한 적용 여부
}
