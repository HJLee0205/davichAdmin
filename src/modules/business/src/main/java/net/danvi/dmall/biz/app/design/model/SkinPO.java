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
 * 작성일     : 2016. 7. 21.
 * 작성자     : dong
 * 설명       : 스킨설정 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class SkinPO extends BaseModel<SkinPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long skinNo; // 스킨번호
    private String skinId; // 스킨아이디
    private String pcGbCd; // 피씨구분코드

    private Long orgSkinNo; // 원본스킨번호
    private String defaultSkinYn; // 기본스킨여부
    private String skinNm; // 스킨명
    private String imgNm; // 이미지명
    private String imgPath; // 이미지경로
    private String folderPath; // 폴더경로
    private String orgFolderPath; // 원본 폴더 경로
    private String applySkinYn; // 적용 스킨 여부
    private String workSkinYn; // 작업 스킨 여부
    private String delYn; // 전시 여부

    private String fileNm; // 파일명
    private String orgFileNm; // 원본 파일명
    private Long fileSize; // 파일사이즈
    private String filePath; // 파일 경로

    private String siteId; // 사이트 아이디

    private String skinBasicYn; // 기본스킨여부

}
