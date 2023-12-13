package net.danvi.dmall.biz.batch.link.sabangnet.model.request;

import lombok.Data;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetRequest;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 7. 22.
 * 작성자     : dong
 * 설명       : 사방넷 연계 송장등록 요청 XML 생성을 위한 클래스
 * </pre>
 */
@Data
public class InvoiceRequest extends SabangnetRequest<Invoice> {
    private static final long serialVersionUID = 4850487535882603265L;

    private String sendCompaynyId;
    private String sendAuthKey;
    private String sendDate; // 전송일자
    private String sendInvEditYn; // 송장정보수정여부
}
