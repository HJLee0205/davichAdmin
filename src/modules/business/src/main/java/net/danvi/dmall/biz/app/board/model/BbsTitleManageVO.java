package net.danvi.dmall.biz.app.board.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 게시판 PO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class BbsTitleManageVO extends BaseModel<BbsManageVO> {
    // 게시판 타이틀
    private String titleNo;
    // 타이틀 명
    private String titleNm;
    private String[] titleNmArr;
}
