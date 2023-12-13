package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2023. 01. 17.
 * 작성자     : slims
 * 설명       : 스플래시 관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class SplashVO extends BaseModel<SplashVO> {
    private int rownum;
    private String splashNo; // 스플래시 번호
    private String dispStartDttm; // 전시 시작일
    private String dispEndDttm; // 전시 종료일
    private String splashNm; // 스킨명
    private String fileNm; // 이미지명
    private String filePath; // 이미지경로
    private String imgFileInfo; // 이미지 파일정보
    private String dispYn; // 전시 여부
    private String fileSize; // 이미지 사이즈
    private String orgFileNm; // 원본 이미지 명
    private String applyAlwaysYn; // 무제한 적용 여부
}
