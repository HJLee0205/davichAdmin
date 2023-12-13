package net.danvi.dmall.biz.app.promotion.freebiecndt.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieCndtSO extends BaseSearchVO<FreebieCndtSO> {
    private int freebieEventNo;
    private String searchStartDate; // 검색시작일
    private String searchEndDate; // 검색종료일
    private String[] freebieStatusCds; // 사은품이벤트상태코드
    private String periodSelOption; // 기간검색옵션 : 시작일기준, 종료일기준
    private String searchWords;
    private int pageNoOri; // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)

    // front
    private String goodsNo;
    private long freebieEventAmt; // 사은품지급 충족금액
}
