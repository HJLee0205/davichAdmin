package net.danvi.dmall.biz.batch.link.sabangnet.model;

import java.io.Serializable;
import java.util.List;

import org.apache.commons.lang3.builder.ToStringBuilder;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 02.core
 * 작성일     : 2016. 6. 28.
 * 작성자     : dong
 * 설명       : 사방넷 연계 요청 XML 생성을 위한 클래스
 * </pre>
 */
@Data
public class SabangnetRequest<T> implements Serializable {

    private static final long serialVersionUID = 2897472531790353232L;

    private String sendCompaynyId;
    private String sendAuthKey;
    private String sendDate;
    private List<T> data;

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}
