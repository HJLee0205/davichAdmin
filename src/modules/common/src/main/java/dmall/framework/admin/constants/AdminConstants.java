package dmall.framework.admin.constants;

import dmall.framework.common.constants.CommonConstants;

/**
 * Admin Constants
 * 
 * @author snw
 * @since 2015.06.11
 */
public final class AdminConstants extends CommonConstants {

    public static final String ADMIN_URL = "/admin";

    // =======================================================
    // 공통 : COM
    // =======================================================
    /** Error View */
    public static final String ERROR_VIEW_NAME = "/error/error";

    /** 공통 세션 ATTRIBUTE */
    public static final String ADMIN_SESSION_SET_ATTRIBUTE = "adminSession";

    public static final String CACHE_CODE_GROUP = "cache_code_group";

    public static final String CACHE_CODE = "cache_code";

    public static final String CACHE_CODE_VALUE = "cache_code_value";

    public static final String USE_YN_Y = "Y";
    public static final String USE_YN_N = "N";

    // =======================================================
    // 로그인 : LGN
    // =======================================================
    public static final String ADMIN_LOGIN_SESSION = "_admin_login_session";

    // =======================================================
    // 기본관리 : SYS
    // =======================================================

    // =======================================================
    // 사용자 : USR
    // =======================================================

    // =======================================================
    // 회원 : MBR
    // =======================================================

    // =======================================================
    // 전시 : DSP
    // =======================================================

    // =======================================================
    // 마케팅 : PRO
    // =======================================================

    // =======================================================
    // 상품 : GDS
    // =======================================================
    /** 경비 요율 */
    public static final double EXPENSES_RATE = 0.135;
    public static final int DLVR_DEFAULT_COST = 1000;
    public static final int ASB_LOD_DEFAULT_COST = 3000;

    // =======================================================
    // 주문 : ORD
    // =======================================================

    // =======================================================
    // 정산 : ADJ
    // =======================================================

    // =======================================================
    // 통계 : STA
    // =======================================================

    public static final String MYPAGE_URL = "https://www.davichmarket.com/mypage";
}