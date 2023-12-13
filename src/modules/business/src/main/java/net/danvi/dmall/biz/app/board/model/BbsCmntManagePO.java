package net.danvi.dmall.biz.app.board.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.BannedWordReplace;
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
public class BbsCmntManagePO extends BaseModel<BbsCmntManagePO> {
    private String lettNo; // 글 번호
    @NotEmpty
    private String cmntSeq; // 댓글 순번
    @BannedWordReplace
    private String content; // 내용
    private String cmntSectYn; // 댓글 비밀 여부
    private String bbsId; // 게시판 아이디
}
