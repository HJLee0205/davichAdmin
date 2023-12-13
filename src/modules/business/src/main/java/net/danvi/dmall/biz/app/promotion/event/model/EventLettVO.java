package net.danvi.dmall.biz.app.promotion.event.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 25
 * 작성자     : dong
 * 설명       : 이벤트 댓글 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class EventLettVO extends BaseModel<EventLettVO> {
    @NotNull
    private Long lettNo;

    @NotNull
    private int eventNo;
    private Long memberNo;
    private String content;
    private String wngYn;
    private String blindPrcYn; // 댓글 블라인드처리 여부
    private String eventNm;
    private String eventDscrt;
    private String applyStartDttm;
    private String applyEndDttm;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    private String memberNn;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;
    private String wngNm; // 당첨내용
    private String wngContentHtml; // 당첨 제목

    // 출석이벤트 출석일자
    private String attendanceDay;
    private String regLettDttm;

    // admin
    private int rowNum;
    private String sortNum;
    private String histStartDttm; /* 이력시작일시 */
    private String eventWngDttm; /* 당첨자발표일시 */

    private int shareCnt;
    private String regDt;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String prcrNm;
    private String eventWngDt;
}
