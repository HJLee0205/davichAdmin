package net.danvi.dmall.biz.app.board.model;

import javax.validation.constraints.Max;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.annotation.BannedWordReplace;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.EditorBasePO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       : 게시글 PO
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper = false)
public class BbsLettManagePO extends EditorBasePO<BbsLettManagePO> {
    // 공통 게시글
    @NotEmpty(groups = { UpdateGroup.class })
    private String lettNo; // 글 번호
    @NotEmpty
    @Length(min = 1, max = 50)
    private String bbsId; // 게시판 아이디
    private String titleNo; // 타이틀 번호
    @Length(min = 0, max = 50)
    private String grpNo; // 그룹 번호
    private String grpNoReply; // 그룹 번호 답변
    @Length(min = 0, max = 200)
    @BannedWordReplace
    private String title; // 제목
    private String replyLettNo; // 답변 글 번호
    @BannedWordReplace
    private String replyTitle; // 답변 제목
    @BannedWordReplace
    private String replyContent; // 답변 내용
    @BannedWordReplace
    private String content; // 내용
    @Max(11)
    private Integer inqCnt; // 조회수
    @Max(11)
    private String ctgNo; // 카테고리 번호
    @Length(min = 0, max = 50)
    private String sectYn;
    @Length(min = 0, max = 1)
    private String openYn;
    @Length(min = 0, max = 16)
    private String goodsNo;
    @Length(min = 0, max = 10)
    private String lettLvl;
    private Integer lvl;
    @Length(min = 0, max = 10)
    private String pw;
    @Length(min = 0, max = 1)
    private String noticeYn;
    @Max(11)
    private Integer fileNo;
    private String fileNmOne;
    private String fileNmTwo;
    private String imgYn;
    @Length(min = 0, max = 50)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String regrNm;

    // 1:1 문의 게시글
    @Length(min = 0, max = 10)
    private String inquiryCd;
    @Length(min = 0, max = 18)
    private String ordNo;
    private String smsSendYn;
    private String emailSendYn;
    private String replyStatusYn;// 답변여부
    // 상품 문의/후기 게시글
    @Max(11)
    private Integer score;
    @Length(min = 0, max = 18)
    private String buyYn;
    @Length(min = 0, max = 1)
    private String blindUseYn;
    private String replyEmailRecvYn;
    private String email;
    private String expsYn;
    private String bbsGrade;
    private String svmnPayYn;
    private Integer svmnPayAmt;

    // faq 게시글
    @Length(min = 0, max = 10)
    private String faqGbCd;

    // 추가 된 칼럼
    @Length(min = 1, max = 1)
    private String delYn;

    // 칼럼 아닌 변수
    private String delLettNo;
    // 캡챠코드
    private String captchaCd;

    // 이메일 & SMS
    private long regrMemberNo; // 작성자 번호
    private long memberNo; // 원글 작성자 번호
    
    //판매자 번호
    private long sellerNo;
    
    //링크URL
    private String linkUrl;
    //관련검색어
    private String relSearchWord;

    private String imgRatioGbCd;    // 이미지 비율 구분 코드
    private String cmntDispGbCd;    // 댓글 공개 구분 코드
    private String[] recommendNo;   // 등록 상품
    private String seoSearchWord;   // SEO 검색 단어
    private String goodsTypeCd;     // 상품 유형 코드
    private String dispGbCd;        // 공개 유형 코드
    private String goodsNm;
}
