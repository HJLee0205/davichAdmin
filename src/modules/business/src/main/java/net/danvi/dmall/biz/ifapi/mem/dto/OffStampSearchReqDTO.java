package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OffStampSearchReqDTO
 * 작성자:   gh.jo
 * 작성일:   2023/02/23
 * 설명:
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/23 gh.jo  최초 생성
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffStampSearchReqDTO extends BaseReqDTO {

    private String memNo; //쇼핑몰 회원번호

    private String cdCust; //다비젼 회원번호
}
