package net.danvi.dmall.biz.app.promotion.timedeal.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 타임딜 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class TimeDealSO extends BaseSearchVO<TimeDealSO> {
    private int prmtNo;
    private String searchStartDate; // 검색시작일
    private String searchEndDate; // 검색종료일
    private String prmtStatusCd; // 타임딜상태
    private String prmtDcGbCd;	//프로모션 할인 구분 코드
    private String[] searchGoodsTypeCds;	//상품군
    private String searchDcValue;	//프로모션 할인율
    private String[] prmtStatusCds;
    private String searchWords;
    private String goodsNo;
    private String ctgNoArr; /* goodsController에서 사용 */
    private int pageNoOri; // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)
    // 타임딜 상태
    private String prmtStatusNm;
    // 사용여부
    private String useYn;

    private String searchApplyAlwaysYn;
    private String searchSeller;
    private String searchGoodsNo;
}
