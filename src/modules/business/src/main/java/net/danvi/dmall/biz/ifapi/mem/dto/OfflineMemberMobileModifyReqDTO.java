package net.danvi.dmall.biz.ifapi.mem.dto;


import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;


/**
 * 2023-06-19 210
 * 매장에서 고객 핸드폰 번호를 변경 하면 몰쪽도 같이 변경
 * 회원통합,포인트 관련 문제 때문에 동기화 필요
 *
 * **/
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineMemberMobileModifyReqDTO extends BaseReqDTO {

    /**
     * 다비젼 회원코드
     */
    private String cdCust;

    /**
     * 휴대폰번호
     */
    private String hp;

    /**
     * 사이트번호
     */
    private String siteNo;

    // DB 저장을 위한 변수
    /**
     * 수정자
     */
    private String updrNo;

    /**
     * 쇼핑몰 회원번호
     */
    private String memNo;
}
