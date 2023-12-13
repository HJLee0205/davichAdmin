package net.danvi.dmall.biz.batch.link.sabangnet.model;

import java.io.Serializable;
import java.util.List;

import org.apache.commons.lang3.builder.ToStringBuilder;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 결과 XML 매핑을 위한 클래스
 * </pre>
 */
@Data
public class SabangnetResult<T> implements Serializable {
    private static final long serialVersionUID = -3626922636516085610L;

    private String sendCompaynyId;
    private String sendAuthKey;
    private String sendDate;
    private List<T> data;

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}
