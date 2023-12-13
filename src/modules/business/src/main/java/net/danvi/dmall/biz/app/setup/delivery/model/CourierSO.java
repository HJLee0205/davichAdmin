package net.danvi.dmall.biz.app.setup.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CourierSO extends BaseSearchVO<CourierSO> {
    // 검색 일자 유형
    private String searchDateType;
    // 검색 일자 시작일
    private String searchDateFrom;
    // 검색 일자 종료일
    private String searchDateTo;
    // 검색 유형
    private String searchType;
    // 검색 단어
    private String searchWord;

}
