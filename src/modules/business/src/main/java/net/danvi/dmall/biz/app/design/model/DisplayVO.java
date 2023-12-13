package net.danvi.dmall.biz.app.design.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 19.
 * 작성자     : dong
 * 설명       : 전시관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class DisplayVO extends BaseModel<DisplayVO> {
    // private String siteNo;

    private String dispNo; // 전시번호
    private String dispNm; // 전시 명
    private String dispCd; // 전시 코드
    private String dispCdNm; // 전시 코드명
    private String linkUrl; // 링크 url
    private String dispLinkCd; // 전시 링크 코드
    private String filePath; // 파일 경로
    private String orgFileNm; // 원본 파일 명
    private String fileNm; // 파일 명
    private String fileSize; // 파일 사이즈
    private String sortSeq; // 정렬순서
    private String dispYn; // 전시 여부

    private List<DisplayVO> titleNmArr; // 전시명 배열정보
    private List<DisplayVO> displayArr; // 전시번호 배열정보

}
