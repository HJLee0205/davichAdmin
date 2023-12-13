package net.danvi.dmall.smsemail.model.email;

import java.util.Date;

import net.danvi.dmall.smsemail.model.request.EmailSendPO;

/**
 * Created by dong on 2016-08-31.
 */
public class CustomerInfoPO {
    /** 아이디 */
    private Long id;
    // private Long real_id; // 캠페인아이디 - 솔루션 관리
    /** 작성자 ID */
    private String userId;
    private String title;
    private String content;
    /** 보내는 사람 메일 */
    private String sender;
    /** 보내는 사람 이름 */
    private String senderAlias;
    /** 받는 사람 이름 */
    private String receiverAlias;
    /** 발송시작시간 */
    private Date send_time;
    /** 발송시작시간 */
    private String sendTimeSel;
    /** 예약발송시간 */
    private String reservationDttm;
    // private String file_name; // 첨부파일명
    // private String file_contents; // BASE64로 인코등된 첨부파일
    // private String wasRead; // 인지여부 - 솔루션 관리
    // private String wasSend; // 대상저장정보전달여부 - 솔루션 관리
    // private String wasComplete; // 발송완료여부 - 솔루션 관리
    private String needRetry; // 재시도필요유무
    private Integer retryCount; // 재시도횟수
    private Date registDate; // 입력시간
    private String linkYn; // 링크분석유무
    private Integer totalCount; // 총발송 신청통수

    public CustomerInfoPO() {
    }

    public CustomerInfoPO(EmailSendPO po) {
        this.userId = po.getSenderNo().toString();
        this.title = po.getSendTitle();
        this.content = po.getSendContent();
        this.sender = po.getSendEmail();
        this.senderAlias = po.getSenderNm();
        this.linkYn = "Y";
        this.sendTimeSel = po.getSendTimeSel();
        this.reservationDttm = po.getReservationDttm();
    }

    public String getSendTimeSel() {
        return sendTimeSel;
    }

    public void setSendTimeSel(String sendTimeSel) {
        this.sendTimeSel = sendTimeSel;
    }

    public String getReservationDttm() {
        return reservationDttm;
    }

    public void setReservationDttm(String reservationDttm) {
        this.reservationDttm = reservationDttm;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getSenderAlias() {
        return senderAlias;
    }

    public void setSenderAlias(String senderAlias) {
        this.senderAlias = senderAlias;
    }

    public String getReceiverAlias() {
        return receiverAlias;
    }

    public void setReceiverAlias(String receiverAlias) {
        this.receiverAlias = receiverAlias;
    }

    public Date getSend_time() {
        return send_time;
    }

    public void setSend_time(Date send_time) {
        this.send_time = send_time;
    }

    public String getNeedRetry() {
        return needRetry;
    }

    public void setNeedRetry(String needRetry) {
        this.needRetry = needRetry;
    }

    public Integer getRetryCount() {
        return retryCount;
    }

    public void setRetryCount(Integer retryCount) {
        this.retryCount = retryCount;
    }

    public Date getRegistDate() {
        return registDate;
    }

    public void setRegistDate(Date registDate) {
        this.registDate = registDate;
    }

    public String getLinkYn() {
        return linkYn;
    }

    public void setLinkYn(String linkYn) {
        this.linkYn = linkYn;
    }

    public Integer getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Integer totalCount) {
        this.totalCount = totalCount;
    }
}
