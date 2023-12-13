package dmall.framework.common.constants;

public class CommonConstants {

    public static final String HTTP_SESSION = "_http_session";

    public static final String SESSION_ID_COOKIE_NAME = "JSESSIONID";
    public static final String SESSION_ID_OBJECT_NAME = "sessionId";

    public static final String LOGIN_COOKIE_NAME = "DMALL_AUTH";

    public static final String LATELY_GOODS_COOKIE_NAME = "LATELY_GOODS";

    public static final String JSON_VIEW_NAME = "jsonView";
    public static final String EXCEL_VIEW_NAME = "excelView";
    public static final String IMAGE_VIEW_NAME = "imageView";
    public static final String FILE_VIEW_NAME = "fileView";
    public static final String VOID_VIEW_NAME = "voidView";

    public static final String EXCEL_PARAM_NAME = "excelParam";
    public static final String EXCEL_LIST_PARAM_NAME = "excelListParam";
    public static final String EXCEL_PARAM_FILE_NAME = "excelFileName";
    public static final String FILE_PARAM_NAME = "fileParam";

    public static final String CONTROLLER_RESULT_CODE = "resultCode";
    public static final String CONTROLLER_RESULT_MSG = "resultMsg";

    // ResponsBody 형태의 Controller Result Code
    public static final String CONTROLLER_RESULT_CODE_SUCCESS = "S";
    public static final String CONTROLLER_RESULT_CODE_FAIL = "F";

    public static final int RECORD_COUNT_PAGE = 10;

    public static final int AJAX_LOGIN_SESSION_ERROR = 1000;

    public static final String EXCEPTION_VIEW_NAME = "/exception/error";

    public static final String EXCEPTION_MESSAGE_COMMON = "biz.exception.common.";

    public static final String GRID_DATE_FORMAT = "Y-m-d H:i:s A";

    public static final String COMMON_END_DATE = "9999-12-31 23:59:59";

    public static final String YN_Y = "Y";
    public static final String YN_N = "N";

    public static final String DATE_TIMEZONE = "Asia/Seoul";
    public static final String DATE_LOCALE = "ko";
    public static final String DATE_YYYYMMDD = "yyyy-MM-dd";
    public static final String DATE_YYYYMMDDHHMMSS = "yyyy-MM-dd HH:mm:ss";

    /* 이미지 관련 상수 */
    /** 섬네일 접미어 */
    public static final String IMAGE_THUMBNAIL_PREFIX = "_150x100";
    /** 에디터 업로드 이미지 미리보기 URL */
    // public static final String IMAGE_TEMP_EDITOR_URL =
    // "/image/preview?id=";
    /** 에디터 업로드 이미지 URL */
    // public static final String IMAGE_EDITOR_URL = "/image/editor-image-view?id=";

    /* 상품 이미지 관련 상수 */
    /** 상품이미지 섬네일 접미어 */
    public static final String IMAGE_GOODS_THUMBNAIL_PREFIX = "_110x110x01";
    /** 상품이미지 업로드 이미지 미리보기 URL */
    public static final String IMAGE_TEMP_GOODS_URL = "/image/preview?id=";
    /** 상품이미지 업로드 이미지 URL */
    public static final String IMAGE_GOODS_URL = "/image/preview-goods-image?id=";

    /* 사은품 이미지 관련 상수 */
    /** 사은품이미지 업로드 이미지 미리보기 URL */
    public static final String IMAGE_TEMP_FREEBIE_URL = "/image/preview?id=";
    /** 사은품이미지 업로드 이미지 URL */
    public static final String IMAGE_FREEBIE_URL = "/image/preview-freebie-image?id=";

    // 미디어 코드
    /** 미디어 코드 - PC */
    public static final String MEDIA_CD_PC = "01";
    /** 미디어 코드 - 모바일 */
    public static final String MEDIA_CD_MOBILE = "02";

    // 모바일 OS 코드
    /** 모바일 OS 코드 - 안드로이드 */
    public static final String MOBILE_OS_ANDROID = "01";
    /** 모바일 OS 코드 - IOS */
    public static final String MOBILE_OS_IOS = "02";

    // 서버 코드
    /** 서버 코드 - FO (31.front.web) */
    public static final String SERVER_CD_FO = "01";
    /** 서버 코드 - MO */
    public static final String SERVER_CD_MO = "02";
    /** 서버 코드 - BO */
    public static final String SERVER_CD_BO = "03";

    public static final String AUTH_GB_CD_ADMIN = "A";
    public static final String AUTH_GB_CD_MANAGER = "M";

    // 회원 번호
    // 배치
    public static final Long MEMBER_SYSTEM = 1L;
    public static final Long MEMBER_BATCH_SYSTEM = 100L;
    public static final Long MEMBER_BATCH_GOODS = 120L;
    public static final Long MEMBER_BATCH_MEMBER = 140L;
    public static final Long MEMBER_BATCH_ORDER = 170L;

    // 인터페이스
    public static final Long MEMBER_INTERFACE_SYSTEM = 200L;
    public static final Long MEMBER_INTERFACE_SETUP = 280L;
    public static final Long MEMBER_INTERFACE_ORDER = 270L;
}