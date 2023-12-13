package net.danvi.dmall.biz.app.board.model;

import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.MultiEditorBasePO;

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
public class BbsManagePO extends MultiEditorBasePO<BbsManagePO> {
    @NotEmpty
    @Length(min = 1, max = 50)
    private String bbsId;
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    @Length(min = 1, max = 50)
    private String bbsNm;
    @NotEmpty(groups = { InsertGroup.class })
    @Length(min = 1, max = 10)
    private String bbsGbCd;
    @NotEmpty(groups = { InsertGroup.class })
    @Length(min = 1, max = 10)
    private String bbsKindCd; // 게시판 종류

    @Length(min = 1, max = 1)
    private String useYn;
    @Length(min = 1, max = 1)
    private String titleUseYn;
    @Length(min = 1, max = 300)
    private String bbsAddr;
    @Length(min = 1, max = 1)
    private String readListUseYn;
    @Length(min = 1, max = 2)
    private String readListAuthCd;
    @Length(min = 1, max = 1)
    private String readLettContentUseYn;
    @Length(min = 1, max = 2)
    private String readLettContentAuthCd;
    @Length(min = 1, max = 1)
    private String writeLettUseYn;
    @Length(min = 1, max = 2)
    private String writeLettAuthCd;
    @Length(min = 1, max = 1)
    private String writeCommentUseYn;
    @Length(min = 1, max = 2)
    private String writeCommentAuthCd;
    @Length(min = 1, max = 1)
    private String writeReplyUseYn;
    @Length(min = 1, max = 2)
    private String writeReplyAuthCd;
    @Length(min = 1, max = 2)
    private String regrDispCd;
    @Length(min = 1, max = 1)
    private String iconSetUseYn;
    @Length(min = 1, max = 1)
    private String iconUseYnHot;
    @Length(min = 0, max = 10)
    private String iconCheckValueHot;
    @Length(min = 1, max = 1)
    private String iconUseYnNew;
    @Length(min = 0, max = 10)
    private String iconCheckValueNew;
    @Length(min = 0, max = 1)
    private String sectLettSetYn;
    @Length(min = 1, max = 2)
    private String noticeLettSetYn;
    @Length(min = 1, max = 2)
    private String bbsSpamPrvntYn;
    @Length(min = 1, max = 8000)
    private String topHtmlSet;
    @Length(min = 1, max = 8000)
    private String bottomHtmlSet;
    @Length(min = 1, max = 2)
    private String topHtmlYn;
    @Length(min = 1, max = 2)
    private String bottomHtmlYn;

    // 게시판 타이틀
    private String titleNo;
    private String titleNm;
    private String[] titleNmArr;

    // 삭제 예정(BbsLettMangerPO)에 이동
    private String delYn;

    private String name;
    private String content;

    private Long fileNo;
    private String refNo;
}
