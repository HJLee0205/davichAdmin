package net.danvi.dmall.biz.app.operation.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * Created by dong on 2016-08-29.
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class SmsSendHistSO extends BaseSearchVO<SmsSendHistSO> {

    private static final long serialVersionUID = 369557903151858803L;

    /** 조회기간 시작일 */
    private String startDt;
    /** 조회기간 종료일 */
    private String endDt;

    /** 발송상태 */
    private String status;

    /** 수신자 ID */
    private String receiverId;
    /** 수신자 전화번호 */
    private String recvTelno;
    /** 자동발송 여부 */
    private String autoSendYn;
    /** 결과코드 검색 */
    private String searchResult;

    private String searchRecvTelno;
    /** 발송유형 */
    private String sendFrmCd;
    /** 검색어 */
    private String searchWords;
    /** 검색유형 */
    private String searchType;

}
