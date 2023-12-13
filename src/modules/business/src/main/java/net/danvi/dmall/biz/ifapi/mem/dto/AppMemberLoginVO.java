package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   AppMemberLoginReqDTO
 * 작성자:   gh.jo
 * 작성일:   2023/02/06
 * 설명:     앱로그인 일시 다비전 기록 DTO
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/06 gh.jo  최초 생성
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class AppMemberLoginVO extends BaseReqDTO {

    /**
     * 쇼핑몰 회원번호
     */
    private String memNo;

    /**
     * ERP 회원코드
     */
    @ExceptLog
    private String cdCust;

}
