package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OfflineMemberVO
 * 작성자:   gh.jo
 * 작성일:   2023/02/06
 * 설명:
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/06 gh.jo  최초 생성
 */
@Data
public class OfflineMemberVO {

        private String cdCust; //다비젼 회원코드

        private String nmCust; //다비젼 회원 이름

        private String handPhone;//핸드폰 번호

        private String lvl; //다비젼 회원 등급

        private String offlineCardNo; // 오프라인 카드번호

        private String combineYn;//통합회원 여부

        private String recentStrName; //최근 방문 매장 명

        private String strCode;//가맹점 코드(최근방문매장)

        private String birth;//생년월일

        private String emailRecvYn;//이메일 sms 동시 수신여부
}
