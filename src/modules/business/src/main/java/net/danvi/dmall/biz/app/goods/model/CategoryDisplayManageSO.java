package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 29.
 * 작성자     : kjw
 * 설명       : 카테고리 전시존 정보 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CategoryDisplayManageSO extends BaseSearchVO<CategoryDisplayManageSO> {
    // 카테고리 번호
    private String ctgNo;
    // 카테고리 전시존 번호
    private String ctgDispzoneNo;
    // 카테고리 전시존 사용여부
    private String useYn;
    // 카테고리 전시존 판매여부
    private String saleYn;

    // 프로모션 할인율
    private long prmtDcValue;
    // 프로모션 할인 구분 코드
    private String prmtDcGbCd;

}
