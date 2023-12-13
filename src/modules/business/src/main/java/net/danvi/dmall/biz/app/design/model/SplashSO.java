package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
public class SplashSO extends BaseSearchVO<SplashSO> {
    // 검색전용
    // 검색전용
    private String fromRegDt; // 조회 시작일
    private String toRegDt; // 조회 종료일
    private String dateGubn; // 날짜 조회구분
    private String applyAlwaysYn; // 무제한 적용 여부
    private String splashNo; // 스킨번호
    private String splashNm; // 스킨명
    private String dispYn; // 전시 여부
    private String dispStartDttm; // 전시 시작일
    private String dispEndDttm; // 전시 종료일
}
