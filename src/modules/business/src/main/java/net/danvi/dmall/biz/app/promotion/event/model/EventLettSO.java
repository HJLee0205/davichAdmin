package net.danvi.dmall.biz.app.promotion.event.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 25
 * 작성자     : dong
 * 설명       : 이벤트 댓글 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class EventLettSO extends BaseSearchVO<EventLettSO> {
    @NotNull
    private int eventNo;
    private String wngYn;
    private Long memberNo;
    private String stRegDttm;
    private String endRegDttm;
    private String regDt;
    private String blindPrcYn;
    private String searchType;
}
