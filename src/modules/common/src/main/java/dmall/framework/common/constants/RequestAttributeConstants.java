package dmall.framework.common.constants;

/**
 * Created by dong on 2016-06-16.
 */
public class RequestAttributeConstants {

    // 리퀘스트에 저장하는 데이터의 키
    /** 리퀘스트에 저장하는 데이터의 키 - 메뉴 */
    public static final String MENU = "_DMALL_MENU";

    /** 리퀘스트에 저장하는 데이터의 키 - 사이트 정보 */
    public static final String SITE_INFO = "_DMALL_SITE_INFO";

    public static final String LEVEL_1_MENU = "_DMALL_LV1_MENU_AUTH";

    public static final String SUB_MENU = "_DMALL_SUB_MENU_AUTH";

    public static final String HTTP_SERVER_URL = "_DMALL_HTTP_SERVER_URL";
    public static final String HTTPS_SERVER_URL = "_DMALL_HTTPS_SERVER_URL";
    public static final String HTTPX_SERVER_URL = "_DMALL_HTTPX_SERVER_URL";

    /** 사이트 아이디(id1.test.com 의 'id1' 부분)의 Request 속성 키 */
    public static final String SITE_ID = "_DANVI_DMALL_SITE_ID";

    /** 스킨 뷰 */
    public static final String SKIN_VIEW = "_DMALL_SKIN_VIEW";
    /** 스킨 NO Request 속성 키 */
    public static final String SKIN_NO = "_SKIN_NO";
    /** 스킨 ID Request 속성 키 */
    public static final String SKIN_ID = "_SKIN_ID";
    /** 스킨 루트 절대 경로 Request 속성 키 */
//    public static final String SKIN_ROOT_PATH = "_SKIN_ROOT_PATH";
    /** 스킨 경로 Request 속성 키 */
    public static final String SKIN_PATH = "_SKIN_PATH";
    /** 스킨 CSS Request 속성 키 */
    public static final String SKIN_CSS_PATH = "_SKIN_CSS_PATH";
    /** 스킨 이미지 Request 속성 키 */
    public static final String SKIN_IMG_PATH = "_SKIN_IMG_PATH";
    /** 스킨 스크립트 Request 속성 키 */
    public static final String SKIN_JS_PATH = "_SKIN_JS_PATH";

    public static final String SKIN_VIEW_PATH = "_SKIN_VIEW_PATH";

    /** 기본 스킨 명 */
    public static String DEFAULT_SKIN_ID = "__SKIN";
    /** 프론트 사이트(상점) 기본 정보 */
    public static final String FRONT_SITE_INFO = "site_info";
    /** 프론트 사이트(상점) 대메뉴 정보 */
    public static final String FRONT_GNB_INFO = "gnb_info";
    /** 프론트 사이트(상점) 메뉴 정보 */
    public static final String FRONT_LNB_INFO = "lnb_info";
    /** 프론트 사이트(상점) 계좌번호 정보 */
    public static final String FRONT_NOPB_INFO = "nopb_info";
    /** 프론트 사이트(상점) 팝업 정보 */
    public static final String FRONT_POPUP_INFO = "popup_info";
    public static final String FRONT_POPUP_JSON = "popup_json";
    /** 모바일경로 - 모바일용 추가 2016-08-18 */
    public static final String MOBILE_PATH = "/m";
    public static final String MOBILE_DEFAULT_SKIN_ID = "__MSKIN";

    public static final String IMAGE_DOMAIN = "_IMAGE_DOMAIN";
}
