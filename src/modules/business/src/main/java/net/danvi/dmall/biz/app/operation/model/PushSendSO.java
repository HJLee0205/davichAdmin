package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PushSendSO extends BaseSearchVO<PushSendSO> {
    private String searchDateFrom;
    private String searchDateTo;
    private String pushStatus;
    private String alarmGb;
    private String sendMsg;
    
    private String pushNo;
    private String pageGb;

}
