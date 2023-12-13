package net.danvi.dmall.biz.app.setup.siteinfo.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 게시판 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SiteVO extends EditorBaseVO<SiteVO> implements Serializable {
    private static final long serialVersionUID = -3080947872325640399L;

    // 업체명
    private String companyNm;
    // 대표자명
    private String ceoNm;
    // 이메일
    private String email;
    //기본 검색어
    private String defaultSrchWord;
    // 업태
    private String bsnsCdts;
    // 종목
    private String item;
    // 우편번호
    private String postNo;
    // 주소지번
    private String addrNum;
    // 주소 도로명
    private String addrRoadnm;
    // 주소 공통 상세
    private String addrCmnDtl;
    // 전화번호
    private String telNo;
    // 팩스번호
    private String faxNo;
    // 통신판매신고번호
    private String commSaleRegistNo;
    // 사업자번호
    private String bizNo;
    // 개인정보관리자
    private String privacymanager;
    // 사이트명
    private String siteNm;
    // 고객센터 전화번호
    private String custCtTelNo;
    // 고객센터 팩스번호
    private String custCtFaxNo;
    // 고객센터 이메일
    private String custCtEmail;
    // 고객센터 이메일명
    private String custCtAccount;
    // 고객센터 이메일도메인
    private String custCtDomain;
    // 고객센터 운영시간
    private String custCtOperTime;
    // 고객센터 점심시간
    private String custCtLunchTime;
    // 타이틀
    private String title;
    // 파비콘 경로
    private String fvcPath;
    // 로고 경로
    private String logoPath;
    // 자동 로그아웃 시간
    private String autoLogoutTime;
    // 설명
    private String dscrt;
    // 메일 이메일명
    private String mailAccount;
    // 메일 도메인
    private String mailDomain;
    // 대표 도메인
    private String dlgtDomain;
    // 임시 도메인
    private String tempDomain;
    // 사이트정보 코드
    private String siteInfoCd;
    // 사이트정보
    private String content;
    // 표준약관 동의여부
    private String stdTermsApplyYn;
    // 사방넷 아이디
    private String sbnID;
    // 사방넷 인증키
    private String sbnCertKey;
    // 사방냇 연동 시작일
    private String sbnStartDt;
    // 사방넷 연동 종료일
    private String sbnEndDt;
    // 택배 사용여부
    private String couriUseYn;
    // 매장픽업 사용여부
    private String directVisitRecptYn;
    // 기본 배송비 유형 코드
    private String defaultDlvrcTypeCd;
    // 기본 배송비
    private Long defaultDlvrc;
    // 기본 배송 최소 금액
    private Long defaultDlvrMinAmt;
    // 기본 배송 최소 배송비
    private Long defaultDlvrMinDlvrc;
    // 무통장 결제 사용여부
    private String nopbpaymentUseYn;
    // 배송 결제 방식 코드(선불/착불)
    private String dlvrPaymentKindCd;
    // 마켓포인트 지급 여부
    private String svmnPvdYn;
    // 마켓포인트 지금 기준 코드
    private String svmnPvdStndrdCd;
    // 마켓포인트 지급률
    private long svmnPvdRate;
    // 마켓포인트 절사 기준 코드
    private String svmnTruncStndrdCd;
    // 마켓포인트 지급 최소 금액
    // private long svmnPvdMinAmt;
    // 마켓포인트 사용 상품 합계 금액
    private long svmnUseGoodsTotalAmt;
    // 마켓포인트 사용 가능 보유 금액
    private long svmnUsePsbPossAmt;
    // 마켓포인트 최소 사용 금액
    private long svmnMinUseAmt;
    // 마켓포인트 최대 사용 금액
    private long svmnMaxUseAmt;
    // 마켓포인트 최대 사용 금액 구분
    private String svmnMaxUseGbCd;
    // 마켓포인트 사용 단위 코드
    private String svmnUseUnitCd;
    // 마켓포인트 자동 소멸 여부
    private String svmnAutoExtinctionYn;
    // 마켓포인트 사용 기한
    private int svmnUseLimitday;
    // 마켓포인트 쿠폰 중복 적용 여부
    private String svmnCpDupltApplyYn;
    // 포인트 지급 여부
    private String pointPvdYn;
    // 포인트 절사 기준 코드
    private String pointTruncStndrdCd;
    // 구매 후기 작성 포인트 (일반)
    private Long buyEplgWritePoint;
    // 구매 후기 작성 포인트 (프리미엄)
    private Long buyEplgWritePmPoint;
    // 포인트 적립 유효 기간
    private int pointAccuValidPeriod;
    // 인증 발신 번호
    private String certifySendNo;
    // 반품지 우편번호
    private String retadrssPost;
    // 반품지 주소 지번
    private String retadrssAddrNum;
    // 반품지 주소 도로명
    private String retadrssAddrRoadnm;
    // 반품지 주소 상세
    private String retadrssAddrDtl;
    // 추가 도메인1
    private String addDomain1;
    // 추가 도메인2
    private String addDomain2;
    // 추가 도메인3
    private String addDomain3;
    // 추가 도메인4
    private String addDomain4;
    // 관심 상품 노출 여부
    private String favGoodsExpsYn;
    // 관심 상품 새창연결 여부
    private String favGoodsNewpopYn;
    // 장바구니페이지 이동여부
    private String basketPageMovYn;
    // 상품 자동 삭제 사용 여부
    private String goodsAutoDelUseYn;
    // 상품 보관 일수
    private String goodsKeepDcnt;
    // 상품 보관 수량
    private String goodsKeepQtt;
    // 상품 보관 수량 제한 여부
    private String goodsKeepQttLimitYn;
    // 출석체크이벤트(번호)
    private String eventNo;
    // 커뮤니티 게시판 갯수(메뉴노출 관련)
    private int bbsCnt;
    // 고객센터 휴무정보
    private String custCtClosedInfo;
    // 하단 로고 정보
    private String bottomLogoPath;
    // 컨텐츠 공유 사용여부
    private String contsUseYn;

    // SEO 설정
    private String cmnUseYn;
    private String cmnTitle;
    private String cmnManager;
    private String cmnDscrt;
    private String cmnKeyword;
    private String goodsUseYn;
    private String goodsTitle;
    private String goodsManager;


    private String appVersionIos;
    // 강제 업데이트 여부 IOS
    private String forceUpdateYnIos;

    private String appVersionAndroid;
    // 강제 업데이트 여부 ANDROID
    private String forceUpdateYnAndroid;
}
