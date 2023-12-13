package net.danvi.dmall.biz.app.design.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : html edit관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class HtmlEditVO extends BaseSearchVO<HtmlEditVO> {
    // private String siteNo;

    private String screenNm; // 화면명
    private String fileNm; // 파일명
    private String baseFilePath; // 기본파일 경로
    private String filePath; // 파일 경로
    private String dispYn; // 전시여부
    private String content; // 내용

    private String skinNo; // 스킨번호
    private String skinId; // 스킨아이디
    private String pcGbCd; // 피씨구분코드
    private String defaultSkinYn; // 기본스킨여부
    private String skinNm; // 스킨명
    private String imgNm; // 이미지명
    private String imgPath; // 이미지패스
    private String folderPath; // 폴더경로
    private String applySkinYn; // 적용스킨 여부
    private String workSkinYn; // 작업스킨여부

    private int idxData; // 트리 구조 키값
    private int beforeIdx; // 트리 구조 이전값

    // 템플릿 화면 추가
    private String tmplNm; // 템플릿 명
    private String tmplNo; // 템플릿 번호
    private String linkUrl; // 링크 url
    private String useYn; // 사용유무

    private List<HtmlEditVO> fileInfoArr; // 파일 리스트
}
