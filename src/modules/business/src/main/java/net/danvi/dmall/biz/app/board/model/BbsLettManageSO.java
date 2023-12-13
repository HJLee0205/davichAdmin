package net.danvi.dmall.biz.app.board.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : user
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode
public class BbsLettManageSO extends BaseSearchVO<BbsLettManageSO> {
    private String fromRegDt;
    private String toRegDt;
    private String useYn;
    private String searchKind;
    private String searchVal;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchValEncrypt;
    private String qstSearchKind;
    private String qstSearchVal;
    private String rvSearchKind;
    private String rvSearchVal;
    
    
    // 게시판(bbsSO)
    private String bbsKindCd;
    private String noticeLettSetYn;
    private String titleUseYn;
    private String customerCd;

    // 공통 게시판
    private String bbsId;
    private String bbsNm;
    private String lettNo;
    private String grpNo;
    private String title;
    private String content;
    private String inqCnt;
    private String ctgCd;
    private String sectYn;
    private String openYn;
    private String goodsNo;
    private String lettLvl;
    private String pw;
    private String noticeYn;
    private String fileNo;
    private String fileGb;
    private String orderGb;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String regrNm;

    // 1:1 문의 게시글
    private String[] inquiryCds;
    private String inquiryCd;
    private String ordNo;
    private Integer lvl;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    private String pageGb;
    // 상품 문의/후기 게시글
    private String searchCtg1;
    private String searchCtg2;
    private String searchCtg3;
    private String searchCtg4;
    private String expsYn;
    private String score;
    private String buyYn;
    private String blindUseYn;
    private String replyStatusYn;
    private String searchGoodsName;
    // faq 게시글
    private String[] faqGbCds;
    private String faqGbCd;
    private String cmntSectYn;

    // 삭제
    private String delSelectLettNoCnt;
    private String[] delLettNo;

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
    private long memberNo;
    
    //모바일 추가 - 모바일 여부
    private String mobileYn;
    
    //판매자번호 추가 (검색조건)
    private String selSellerNo;
    
    //메인여부
    private String mainYn;

    // 상품상세 문의하기 팝업을 바로 띄우기위한 처리
    private String opt;
    
    //링크URL
    private String linkUrl;
    //관련검색어
    private String relSearchWord;

    // 투표 상태
    private String[] voteStatusCds; // 01 : 투표중 / 02 : 투표종료

    // 상품 유형
    private String[] goodsTypeCds;
    private String goodsTypeCd;

    // 노출 여부
    private String[] expsYns;

    // 페이지 구분
    private String pageGbn; // A : 관리자 / S : 입점사
}
