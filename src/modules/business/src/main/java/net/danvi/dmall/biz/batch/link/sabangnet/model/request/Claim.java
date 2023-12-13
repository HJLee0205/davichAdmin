package net.danvi.dmall.biz.batch.link.sabangnet.model.request;

import lombok.Data;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 클레임수집 요청을 위한 클래스
 * </pre>
 */
@Data
public class Claim extends SabangnetData {
    private static final long serialVersionUID = -7059597037490095161L;

    String clmStDate;
    String clmEdDate;
    String clmField;
}
