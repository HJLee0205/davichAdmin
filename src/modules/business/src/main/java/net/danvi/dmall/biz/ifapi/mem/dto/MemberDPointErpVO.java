package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/***
 * 2023-05-28 210
 * 통합회원 erp DPoint 통합 포인트 컨트롤러
 * */
@Data
public class MemberDPointErpVO {
     public static final String DE_MEMBER_POINT_TEST = "00";//테스트포인트
     public static final String DE_MEMBER_REGISTER = "01";//회원가입포인트
     public static final String DE_BUY_EPLG_WRITE_POINT = "02";//상품 후기 일반
     public static final String DE_BUY_EPLG_WRITE_PM_POINT = "03";//상품 후기 사진(프리미엄)
     public static final String DE_MEMBER_LEAVE = "04";//회원탈퇴
     public static final String DE_MEMBER_PAYMENT_USE = "05";//결제 포인트 사용
     public static final String DE_MEMBER_PAYMENT_CANCEL = "06";//결제 포인트 취소
     public static final String DE_MEMBER_PAYMENT_ACCUMULATE = "07";//결제 포인트 적립
     public static final String DE_MEMBER_PAYMENT_ACCUMULATE_CANCEL = "08";//결제 포인트 적립 회수


//     LocalDateTime now = LocalDateTime.now();
//     String formatedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
     private String dtype; //마켓쪽디비에 쌓을 로그용 포인트 타입, 추적 ex DE_MEMBER_REGISTER
     private String dates;      /* 영업일자 */
     private String cdcust;    /* 회원번호 */
     private String inflag;    /* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
     private String pdate;      /* 적용일자 */
     private String strcode;   /* 가맹점코드 */
     private String strnm;//개망점 이름
     private String canctype;  /* 0:정상/2:반품 */
     private int salamt;    /* 구매총금액 */
     private int payamt01;   /* [현금]정산금액 */
     private int payamt02;   /* [카드]정산금액 */
     private int payamt03;   /* 포인트사용 금액 */
     private int salpoint;  /* 발생포인트*/
     private int usePoint;//사용 포인트
     private int cdno;      /* 카드번호 */
     private String str_code_to;/* 포인트 사용 체인점 코드 */
     private String goodsno;     /* 리뷰상품번호 */
     private String ordno;       /* 주문번호 */
     private String memberno;    /* 포인트발생 회원번호 */
     private String dtypeNm;
     private String inflagNm;
     private long ordSeq;//결제나 취소 같은 경우는 해당 상품의 주문 시퀀스가 있다 구분하기위해

}
