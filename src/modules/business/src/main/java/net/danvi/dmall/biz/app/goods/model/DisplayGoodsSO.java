package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 1.
 * 작성자     : dong
 * 설명       : 메인전시관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class DisplayGoodsSO extends BaseSearchVO<DisplayGoodsSO> {
    // 검색전용
    private String useYn;
    private String dispSeq;
    private String siteDispSeq;
    // 모바일용 추가 2016-10-19 - 모바일 여부
    private String mobileModeYn;
    private String mainAreaGbCd; // 메인 전시 영역 구분
    private long maxSiteDispSeq;//메인 전시 마지막 순번
}
