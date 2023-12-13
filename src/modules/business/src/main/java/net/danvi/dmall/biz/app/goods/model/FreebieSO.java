package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2017. 7. 12.
 * 작성자     : dong
 * 설명       : FreebieSO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieSO extends BaseSearchVO<FreebieSO> {
    // 사은품 번호
    private String freebieNo;
    // 검색 일자 시작
    private String searchDateFrom;
    // 검색 일자 종료
    private String searchDateTo;
    // 사용여부
    private String[] useYn;
    // 검색 유형
    private String searchType;
    // 검색어
    private String searchWord;
    // 프로모션
    private String isPromotion;
    // 검색 코드
    private String searchCode;
    // 처리 타입 (I: 등록/U: 수정/C: 복사)
    private String procType;
    // 새 사은품 번호
    private String newFreebieNo;
}
