package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

import javax.validation.constraints.NotNull;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 21.
 * 작성자     : dong
 * 설명       : 스킨설정 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class SplashPO extends BaseModel<SplashPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long splashNo; // 스킨번호
    private String splashNm; // 팝업명
    private String filePath; // 파일 경로
    private String orgFileNm; // 원본 파일명
    private String fileNm; // 파일명
    private Long fileSize; // 파일 사이즈
    private String dispYn; // 전시 여부
    private String applyAlwaysYn; // 사이트 아이디
    private String dispStartDttm; // 전시 시작일
    private String dispEndDttm; // 전시 종료일
}
