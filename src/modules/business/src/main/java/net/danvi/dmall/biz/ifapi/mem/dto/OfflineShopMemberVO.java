package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OfflineShopMemberSO
 * 작성자:   gh.jo
 * 작성일:   2023/02/20
 * 설명:    가맹점 회원 정보 조회
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/20 gh.jo  최초 생성
 */

@Data
public class OfflineShopMemberVO {

    private String loginId;

    private String pswrd;

    private String strCode;

    private String handPhone;

    private String name;
}
