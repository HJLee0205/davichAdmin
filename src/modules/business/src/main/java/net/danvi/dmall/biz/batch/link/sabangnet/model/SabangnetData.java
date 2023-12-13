package net.danvi.dmall.biz.batch.link.sabangnet.model;

import java.io.Serializable;

import org.apache.commons.lang3.builder.ToStringBuilder;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 요청 XML 생성을 위한 Data 클래스
 * </pre>
 */
@Data
public class SabangnetData implements Serializable {

    private static final long serialVersionUID = 7219947546095637270L;

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}
