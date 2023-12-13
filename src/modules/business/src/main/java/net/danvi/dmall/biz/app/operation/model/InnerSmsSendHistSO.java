package net.danvi.dmall.biz.app.operation.model;

import java.io.Serializable;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;

/**
 * Created by dong on 2016-08-29.
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class InnerSmsSendHistSO extends BaseSearchVO<InnerSmsSendHistSO> {

    /** 조회기간 시작일 */
    private String startDt;
    /** 조회기간 종료일 */
    private String endDt;

    /** 발송상태 */
    private String status;

    /** 수신자 ID */
    private String receiverId;
    /** 수신자 전화번호 */
    @Encrypt
    private String recvTelno;

    /** 자동발송 여부 */
    private String autoSendYn;
    /** 결과코드 검색 */
    private String searchResult;

    @Encrypt
    private String searchRecvTelno;
    @Encrypt
    private String searchSendTelno;
    /** 발송유형 */
    private String sendFrmCd;
    /** 검색 유형 */
    private String searchType;
    /** 검색어 */
    @Encrypt
    private String searchWords;

}
