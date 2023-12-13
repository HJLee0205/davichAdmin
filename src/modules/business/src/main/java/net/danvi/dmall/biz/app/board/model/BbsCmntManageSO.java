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
 * 작성자     : user
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode
public class BbsCmntManageSO extends BaseSearchVO<BbsCmntManageSO> {
    private String cmntSeq; // 댓글 순번
    private String lettNo; // 글 번호
    private String content; // 내용
    private String cmntSectYn; // 댓글 비밀 여부
    private String regrNm; // 등록자
    private String bbsId; // 게시판 아이디

    private String regDttm;
    private long regrNo;
    private String updDttm;
    private long updrNo;
    private String delDttm;
    private long delrNo;
    private String delYn;

    // 검색어 (닉네임, 내용)
    private String searchWord;

    // 삭제
    private String[] delCmntSeq;
}
