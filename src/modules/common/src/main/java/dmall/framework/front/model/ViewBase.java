package dmall.framework.front.model;

import java.io.Serializable;

import lombok.Data;

/**
 * <pre>
* - 프로젝트명	: 01.common
* - 패키지명	: framework.front.model
* - 파일명		: ViewBase.java
* - 작성일		: 2016. 3. 2.
* - 작성자		: snw
* - 설명		: Front Base View 정보
 * </pre>
 */
@Data
public class ViewBase implements Serializable {

    private static final long serialVersionUID = 1L;

    private String stId;
    private String stNm;
    private String svcGbCd;
    private Integer mnStrNo;
    private String lang;
    private String imgPath;
    private String imgComPath;

}