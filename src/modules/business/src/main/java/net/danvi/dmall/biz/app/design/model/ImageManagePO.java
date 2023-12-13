package net.danvi.dmall.biz.app.design.model;

import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

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
public class ImageManagePO extends BaseModel<ImageManagePO> {
    // private String siteNo;

    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private String fileNm; // 파일명
    private String orgFileNm; // 원본파일명
    private String baseFilePath; // 기본파일경로
    private String filePath; // 파일경로

}
