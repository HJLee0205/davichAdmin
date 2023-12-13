package net.danvi.dmall.biz.app.board.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode
public class BbsManageSO extends BaseSearchVO<BbsManageSO> {
    private String fromRegDt;
    private String toRegDt;
    private String useYn;
    private String searchKind;
    private String searchVal;
    // 게시판 설정
    private String bbsId;
    private String bbsNm;
    private String bbsKindCd;
    private String titleUseYn;
    private String titleKindCd;
    private String bbsAddr;
    private String readListUseYn;
    private String readListAuthCd;
    private String readLettContentUseYn;
    private String readLettContentAuthCd;
    private String writeLettUseYn;
    private String writeLettAuthCd;
    private String writeCommentUseYn;
    private String writeCommentAuthCd;
    private String writeReplyUseYn;
    private String writeReplyAuthCd;
    private String regrDispCd;
    private String iconSetUseYn;

    private String iconUseYnHot;
    private String iconCheckValueHot;
    private String iconUseYnNew;
    private String iconCheckValueNew;
    private String sectLettSetYn;
    private String noticeLettSetYn;
    private String topHtmlSet;
    private String bottomHtmlSet;
    private String bbsGbCd;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;

    private String regDttm;
    private long regrNo;
    private String updDttm;
    private long updrNo;
    private String delDttm;
    private long delrNo;
    private String delYn;

    // 게시판 타이틀
    private String titleNo;
    private String titleNm;

    private String sellerNo;
    private String memberNo;
}
