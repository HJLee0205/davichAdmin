package net.danvi.dmall.biz.app.design.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 19.
 * 작성자     : dong
 * 설명       : 전시관리 SO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class DisplaySO extends BaseSearchVO<DisplaySO> {
    // private String siteNo;
    // 검색전용
    private String fromRegDt; // 조회 시작일
    private String toRegDt; // 조회 종료일
    // 기본값들
    private String dispNo; // 전시번호
    private String dispNm; // 전시 명
    private String dispCd; // 전시 코드
    private String dispCdNm; // 전시 코드 명
    private String linkUrl; // 링크 url
    private String dispLinkCd; // 전시 링크 코드
    private String filePath; // 파일경로
    private String orgFileNm; // 원본 파일 명
    private String fileNm; // 파일명
    private Long fileSize; // 파일 사이즈
    private Long sortSeq; // 정렬순서
    private String dispYn; // 전시여부

}
