package net.danvi.dmall.biz.app.promotion.event.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.BannedWordReplace;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 25
 * 작성자     : dong
 * 설명       : 이벤트 댓글 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class EventLettPO extends BaseModel<EventLettPO> {
    @NotNull
    private Long lettNo;

    private int eventNo;

    private Long memberNo;
    @BannedWordReplace
    private String content;
    private String blindPrcYn; /* 댓글 블라인드 처리 */
    private String wngYn; /* 이벤트당첨 여부 */
    private String wngYnOri; // 수정 전 이벤트당첨여부
    private String delYn;
    private String regDt;
    private Long delNo;
    
    // 이모티콘 이벤트
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mobile;

    private String shareType;

}
