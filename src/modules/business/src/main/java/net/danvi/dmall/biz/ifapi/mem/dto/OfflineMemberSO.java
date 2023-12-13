package net.danvi.dmall.biz.ifapi.mem.dto;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OfflineMemSearchReqDTO
 * 작성자:   gh.jo
 * 작성일:   2023/02/06
 * 설명:    오프라인 회원 조회시 사용하는 요청 DTO (온라인->오프라인 조회시)
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/06 gh.jo  최초 생성
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineMemberSO {

    private String custName; //회원명

    private String hp; //휴대폰 번호

    private String strCode;//가맹점 코드(최근방문매장)

    private String mallNoCard;//온라인 카드번호
}
