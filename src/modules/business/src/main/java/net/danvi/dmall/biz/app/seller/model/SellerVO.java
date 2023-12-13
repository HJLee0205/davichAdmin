package net.danvi.dmall.biz.app.seller.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.EditorBaseVO;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SellerVO extends EditorBaseVO<SellerVO> {
    private String rowNum;

    private Long siteNo ;                //사이트 번호
    private String sellerNo; 			 //판매자 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String sellerId; 			 //판매자 ID
    private String sellerNm ;            //업체명
    private String pw ;					 //비밀번호
    private String ceoNm; 				 //대표자명	
    private String bizRegNo; 			 //사업자등록번호	
    private String paymentActNm; 		 //결제 계좌명	
    private String paymentBank ;		 //결제은행
    private String paymentBankNm ;		 //결제은행 명
    private String paymentActNo ;		 //결제계좌번호
    private String bsnsCdts; 			 //업태
    private String st; 					 //업종
    private String dlgtTel; 			 //대표자 전화번호	
    private String mobileNo; 			 //대표자 휴대폰번호
    private String fax; 			     //팩스
    private String email;                //이메일
    private String postNo;               //우편번호
    private String addr; 				 //주소		
    private String addrDtl; 			 //상세주소
    private String retadrssPostNo; 		 //반품 우편번호
    private String retadrssAddr ;		 //반품 주소
    private String retadrssDtlAddr; 	 //반품 상세주소
    private String taxbillRecvMail; 	 //세금계산서 수신 이메일	
    private String homepageUrl; 		 //홈페이지 url
    private String managerNm; 			 //담당자명 	
    private String managerTelno; 		 //담당자 전화번호
    private String managerMobileNo; 	 //담당자 휴대폰번호	
    private String managerPos;           //담당자 직급
    private String managerEmail;         //담당자 이메일
    private String courierCd;            //배송 업체 코드
    private String courierCdNm;          //배송 업체 명
    private String dlvrGb;               //배송구분
    private Long dlvrAmt;                //배송비 
    private Long chrgSetAmt;             //유료 배송비 기준금액
    private Long chrgDlvrAmt;            //유료 배송비 금액 
    private String statusCd;             //상태코드 ( 01:입점신청, 02:승인, 03:거래정지)
    private String statusNm;             //상태코드 ( 01:입점신청, 02:승인, 03:거래정지)
    private String bizFilePath;          //사업자 등록증 파일 경로
    private String bizFileNm;            //사업자 등록증 파일명
    private String bizOrgFileNm;         //사업자 등록증 원본 파일명
    private String bkCopyFilePath;       //통장사본 파일 경로 
    private String bkCopyFileNm;         //통장사본 파일 명  
    private String bkCopyOrgFileNm;      //통장사본 원본 파일 명
    private String etcFilePath;          //기타 파일 경로
    private String etcFileNm;            //기타 파일 명
    private String etcOrgFileNm;         //기타 원본 파일 명
    private String ceoFilePath;          //대표자 사진 파일 경로
    private String ceoFileNm;            //대표자 사진 파일 명
    private String ceoOrgFileNm;         //대표자 사진 원본 파일 명
    private String farmIntro;            //농장소개
    private String inputGbn;     // 입력구분
    private String fileName;     // 파일명
    private String filePath;     // 파일경로
    private String fileGbn;
    private String regDt;
    private String managerMemo;     //관리자메모
    private int sellerCmsRate;      //판매자 수수료율
    private String recomPvdRate;    //추천인 적립율
   
    private String sellerSvmnGbCd;      //판매자 마켓포인트 지급 설정
    private int sellerSvmnAmt;       //판매자 마켓포인트 지급 금액
    private int sellerSvmnMaxUseRate;      //판매자 마켓포인트 사용 제한 율
    
    private String storeInquiryGbCd; 	//입점 문의 구분 코드
    private String storeInquiryGbCdNm; 	//입점 문의 구분 코드 명
    private String storeInquiryContent; //입점 문의 내용
    private String refFilePath;			//참조 파일 경로
    private String refFileNm;			//참조 파일 명
    private String refOrgFileNm;		//참조 원본 파일 명
    private String calculateNo;
    private int svmnLoadrate;           //적립금 본사부담율

    private String replyStatusYnNm;   // 입점 문의 답변상태
    private String storeInquiryReply;    // 입점 문의 답변 내용
    private Long refFileSize;   // 참조 파일 사이즈
    private String aprvYn;  // 승인 여부

    private String chgDttm;   // 변경 시각
    private String chgNm;   // 변경 이력 항목

    private List<SellerVO> chgLog;  // 변경 이력
}
