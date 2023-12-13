package net.danvi.dmall.biz.batch.link.sabangnet.model.result;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 문의사항 수집을 위한 클래스
 * </pre>
 */
@Data
public class CsResult extends SabangnetData {
    private static final long serialVersionUID = -1657565324462741448L;

    private String ifSno;
    private String ifNo;
    private String ifId;
    private Long siteNo;

    private String num;
    private String mallId;
    // 로그인아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String mallUserId;
    private String csStatus;
    private String regDm;
    private String orderId;
    private String productId;
    private String mallProdId;
    private String productNm;
    private String subject;
    private String cnts;
    private String insNm;
    private String insDm;
    private String rplyCnts;
    private String updNm;
    private String updDm;
    private String sendDm;
    private String csGubun;

    private Long regrNo;
    private Long updrNo;

}
