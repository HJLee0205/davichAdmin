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
 * 작성일     : 2023. 01. 17.
 * 작성자     : slims
 * 설명       : 아이콘관리 PO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class IconPO extends BaseModel<IconPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long iconNo; // 아이콘 번호
    // private String siteNo;
    private String iconDispnm; // 아이콘명
    private String imgPath; // 파일 경로
    private String orgImgNm; // 원본 파일명
    private String imgNm; // 파일명
    private Long imgSize; // 파일 사이즈
    private String dispYn; // 전시 여부
    private String goodsTypeCd; // 아이콘 유형
    private String[] goodsList; // 상품 리스트
    private String iconTypeCd; // 아이콘 타입 코드 1 : skin, 2: resource
}
