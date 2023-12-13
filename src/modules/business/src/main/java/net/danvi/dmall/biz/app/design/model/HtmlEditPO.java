package net.danvi.dmall.biz.app.design.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : html edit관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper = false)
public class HtmlEditPO extends EditorBasePO<HtmlEditPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private String tmplNo; // 템플릿 번호
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private String skinNo; // 스킨번호
    private String skinId; // 스킨 아이디

    private String screenNm; // 화면명
    private String fileNm; // 파일명
    private String baseFilePath; // 기본파일 경로
    private String filePath; // 파일 경로

    private String dispYn; // 전시여부
    private String content; // 내용

}
