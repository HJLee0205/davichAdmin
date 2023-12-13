package dmall.framework.common.constants;

/**
 * Web Constants
 * 
 * @author snw
 * @since 2015.06.11
 */
public final class ExceptionConstants {

    public static final String BIZ_EXCEPTION = "biz.exception.";
    public static final String BIZ_EXCEPTION_COMMON = "biz.exception.common.";
    public static final String BIZ_EXCEPTION_LNG = "biz.exception.lng.";

    // =======================================================
    // 공통 : COM
    // =======================================================
    /** 오류가 발생하였습니다. 관리자에게 문의하시기 바랍니다. */
    public static final String ERROR_CODE_DEFAULT = "biz.exception.common.error";
    
    /** 지원하지 않는 서비스입니다. */
    public static final String NOT_SUPPORT_SERVICE = "biz.exception.common.not.support.service";

    /** 업로드 하실수 없는 파일입니다. */
    public static final String BAD_EXE_FILE_EXCEPTION = "biz.exception.file.not.support.extension";

    /** 제한된 용량을 초과하였습니다. */
    public static final String BAD_SIZE_FILE_EXCEPTION = "biz.exception.file.big.size";

    /** 캐시 생성중 오류가 발생하였습니다. */
    public static final String ERROR_CACHE = "";

    // =======================================================
    // 로그인 : LGN
    // =======================================================

    /** 로그인이 필요합니다. */
    public static final String ERROR_CODE_LOGIN_REQUIRED = "";

    /** 세션이 종료 되었습니다. */
    public static final String ERROR_CODE_LOGIN_SESSION = "";

    /** 사용자 아이디, 패스워드 를 확인해 주세요. */
    public static final String ERROR_CODE_LOGIN_FAIL = "wrongLoginInfo";

    /** 가입된 아이디가 없습니다. */
    public static final String ERROR_CODE_NOT_EXSITS_ID = "notExistsId";

    /** 비밀번호가 틀렸습니다. */
    public static final String ERROR_CODE_WRONG_PASSWORD = "wrongPassword";

    /** 승인되지 않은 사업자회원입니다. 사업자회원 가입신청 후 최대 1-2일내 승인처리됩니다. */
    public static final String ERROR_CODE_NOT_CONFIRM_ID = "notConfirmId";
    
    /** 사용자 상태가 올바르지 않습니다. 관리자에게 문의바랍니다. */
    public static final String ERROR_CODE_LOGIN_STATUS_FAIL = "";

    // =======================================================
    // 기본관리 : SYS
    // =======================================================
    /** 이미 등록되어 있는 그룹 코드입니다. */
    public static final String ERROR_CODE_GROUP_DUPLICATION_FAIL = "";

    /** 이미 등록되어 있는 코드입니다. */
    public static final String ERROR_CODE_DETAIL_DUPLICATION_FAIL = "";

    // =======================================================
    // 사용자 : USR
    // =======================================================
    /** 이미 등록되어 있는 관리자 ID 입니다. */
    public static final String ERROR_USER_DUPLICATION_FAIL = "";

    // =======================================================
    // 회원 : MBR
    // =======================================================
    /** 인증번호가 유효하지 않습니다. */
    public static final String ERROR_CERTIFY_KEY = "front.web.member.certify.key";

    // =======================================================
    // 전시 : DSP
    // =======================================================

    // =======================================================
    // 마케팅 : PRO
    // =======================================================

    // =======================================================
    // 상품 : GDS
    // =======================================================

    // =======================================================
    // 주문/클레임 : ORD
    // =======================================================
    /** 주문 내역 상태가 올바르지 않습니다. */
    public static final String ERROR_ORDER_NOT_CHANGE_DELIVERY_STATUS = "";

    // =======================================================
    // 정산 : ADJ
    // =======================================================

    // =======================================================
    // 통계 : STA
    // =======================================================

}