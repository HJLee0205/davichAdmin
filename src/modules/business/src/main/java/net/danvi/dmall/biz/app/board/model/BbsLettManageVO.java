package net.danvi.dmall.biz.app.board.model;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.EditorBaseVO;
import dmall.framework.common.util.CryptoUtil;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 게시글 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BbsLettManageVO extends EditorBaseVO<BbsLettManageVO> {
    // 공통 게시판
    private String num;
    private String rowNum;
    private String lettNo; // 글 번호
    private String bbsId; // 게시판 아이디
    private String grpNo; // 그룹 번호
    private String title; // 제목
    private String content; // 내용
    private String inqCnt; // 조회수
    private String sectYn; // 비밀 여부
    private String openYn; // 공개 여부
    private String lettLvl; // 글 레벨
    private String lvl;
    private String pw; // 비밀 번호
    private String noticeYn; // 공지 여부
    private String fileNo; // 파일 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String regrNm; // 등록자
    private String regrDispCd;
    private String memberGradeNm; // 회원 등급 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId; // 로그인 아이디
    private String memberNo; // 회원 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm; // 회원 명
    private String cmntCnt; // 댓글 수
    private String memberNn; // 회원 닉네임


    private String titleNo; // 말머리 번호
    private String titleNm; // 말머리 명
    private String noticeLettSetCd;
    private String noticeLettSetCdYn;

    private String iconCheckValueHot;
    private String iconCheckValueNew;
    private String imgFilePath;
    private String imgFileNm;

    private List<AtchFileVO> atchFileArr;

    // 1:1 문의 게시글
    private String inquiryCd;
    private String inquiryNm;
    private String ordNo;
    private String replyStatusYn;// 답변여부
    private String replyStatusYnNm;// 답변여부
    private String replyStatusYnBtn;// 답변버튼
    private String replyLettNo;
    private String replyTitle;
    private String replyContent;
    private String smsSendYn;
    private String emailSendYn;

    // 상품 문의/후기 게시글
    private String ctgCd;
    private String brandNm;
    private String goodsNo; //
    private String goodsNm;
    private String goodsImg;
    private String score;
    private String buyYn;
    private String buyYnNm;
    private String expsYn;
    private String expsYnNm;
    private String blindUseYn;
    private String blindUseYnNm;
    private String replyEmailRecvYn;// 이메일답변회신여부(문의)
    private String email; // 이메일(문의)
    private String reviewCount; // 상품후기글 합계
    private String qeustionCount; // 상품문의글 합계
    private String averageScore;// 상품별 평점 평균치(후기)
    private String supplyPrice; // 공급가
    private String inqTag; // 선택답안 태그

    // faq 게시글
    private String faqGbCd;
    private String faqGbNm;

    private String goodsDispImgC;
    private String goodsDispImgA;

    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date regDttm;
    
    private String sellerNo;
    private String sellerNm;
    private String sellerId;
    
    private String svmnPayYn ;
    private Long svmnPayAmt ;
    
    //링크URL
    private String linkUrl;
    //관련검색어
    private String relSearchWord;
    // seo 검색 단어
    private String seoSearchWord;

    // 스타일추천투표/스타일픽/컬렉션 게시글
    private String goodsTypeCd;     // 상품 유형 코드
    private String goodsTypeCdNm;
    private String dispGbCd;        // 공개 유형 코드
    private String dispGbCdNm;
    private String cmntGbCd;        // 댓글 허용 구분 코드
    private String cmntGbNm;
    private String imgRatioGbCd;    // 이미지 비율 구분 코드
    private String imgRatioGbNm;
    private String cmntDispGbCd;    // 댓글 공개 구분 코드
    private String cmntDispGbNm;
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date endDttm;
    private String voteCnt;         // 투표수
    private String salePrice;       // 판매가
    private String stockQtt;        // 재고
    private String goodsSaleStatusNm; // 판매상태
    private String erpItmCode;      // 다비젼 상품코드
    private List<BbsLettManageVO> styleGoodsArr;    // 등록 상품 정보
}
