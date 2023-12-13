package net.danvi.dmall.biz.ifapi.util;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;

/**
 * Created by dong on 2016-04-14.
 */
@Component
public class IFMessageUtil {

    private static MessageSourceAccessor message;

//    @Resource(name = "message_if")
    private MessageSourceAccessor messageSourceAccessor;

    @PostConstruct
    public void init() {
        IFMessageUtil.message = messageSourceAccessor;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            메시지 코드
     * @return 메시지 문자열
     */
    public static String getMessage(String code) {
        String message = code;
        switch (code){
            case "ifapi.exception.common": message = "처리중 오류가 발생했습니다."; break;
            case "ifapi.exception.data.exists": message = "이미 등록된 데이터 입니다."; break;
            case "ifapi.exception.member.combine.already": message = "이미 통합된 회원 입니다. {0}"; break;
            case "ifapi.exception.member.combine.membergb.invalid": message = "쇼핑몰 정회원만 회원통합이 가능합니다."; break;
            case "ifapi.exception.member.notexist": message = "회원이 존재하지 않습니다."; break;
            case "ifapi.exception.member.notcombined": message = "통합회원이 아닙니다."; break;
            case "ifapi.exception.data.not.exist": message = "데이터가 존재하지 않습니다."; break;
            case "ifapi.exception.onpoint.overuse": message = "보유 포인트가 부족합니다."; break;
            case "ifapi.exception.member.id.duplicate": message = "사용할 수 없는 ID입니다."; break;
            case "ifapi.exception.member.recommend.id.invalid": message = "추천인 ID가 정확하지 않습니다."; break;
            case "ifapi.exception.product.notmapped": message = "매핑되지 않은 상품입니다."; break;
            case "ifapi.exception.order.orderno.exist": message = "이미 등록된 주문번호 입니다."; break;
            case "ifapi.exception.order.orderno.notmapped": message = "매핑되지 않은 주문번호입니다."; break;
            case "ifapi.exception.order.orderdtlseq.notmapped": message = "매핑되지 않은 주문상세번호입니다."; break;
            case "ifapi.exception.order.invoice.invalid": message = "송장번호가 유효하지 않습니다."; break;
            case "ifapi.exception.order.release.failed": message = "출고정보 등록에 실패했습니다."; break;

            case "ifapi.exception.return.invaliddata": message = "반품정보가 일치하지 않습니다."; break;
            case "ifapi.exception.purchseconfirm.invaliddata": message = "구매확정 정보가 일치하지 않습니다."; break;
            case "ifapi.exception.reserve.insert.already": message = "이미 등록된 방문예약정보 입니다"; break;
            case "ifapi.exception.reserve.preorder.mapped.already": message = "이미 등록된 사전예약 기획전 입니다."; break;
            case "ifapi.exception.reserve.preorder.notmapped": message = "매핑되지 않은 사전예약 기획전 입니다."; break;

            case "ifapi.exception.cpngc.notexist": message = "존재하지 않는 쿠폰입니다."; break;
            case "ifapi.exception.cpngc.alreadyused": message = "이미 사용된 쿠폰입니다."; break;
            case "ifapi.exception.cpngc.notused": message = "사용되지 않은 쿠폰입니다."; break;
        }
        return message;
        /*try {
            return message.getMessage(code);
        } catch (Exception e) {
            return code;
        }*/
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지 반환
     *          없으면 기본 메시지 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            메시지 코드
     * @param defaultMesssage
     *            기본 메시지
     * @return 메시지 문자열
     */
    public static String getMessage(String code, String defaultMesssage) {
        return message.getMessage(code, defaultMesssage);
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지에 인자를 매핑하여 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            코드 메시지
     * @param args
     *            메시지 인자
     * @return 메시지 문자열
     */
    public static String getMessage(String code, Object[] args) {
        return message.getMessage(code, args);
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 코드에 해당하는 메시지에 인자를 매핑하여 반환
     *          없으면 기본 메시지 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param code
     *            메시지 코드
     * @param args
     *            인자
     * @param defaultMesssage
     * @return 메시지 문자열
     */
    public static String getMessage(String code, Object[] args, String defaultMesssage) {
        return message.getMessage(code, args, defaultMesssage);
    }
}
