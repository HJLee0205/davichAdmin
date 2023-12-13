package net.danvi.dmall.biz.batch.link.sabangnet.model.request;

import lombok.Data;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;
import dmall.framework.common.annotation.CDATA;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 문의답변 등록 DATA 클래스
 * </pre>
 */
@Data
public class InquiryReply extends SabangnetData {
    private static final long serialVersionUID = -4047625213155635805L;

    @CDATA
    String num;
    @CDATA
    String csReContent;
}
