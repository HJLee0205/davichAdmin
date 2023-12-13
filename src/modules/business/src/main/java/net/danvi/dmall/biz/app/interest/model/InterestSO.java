package net.danvi.dmall.biz.app.interest.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class InterestSO extends BaseSearchVO<InterestSO> {
    private Long memberNo; // 회원번호
    private String goodsNo; // 상품번호

    // 시작
    private String stRegDttm;
    // 종료
    private String endRegDttm;
}
