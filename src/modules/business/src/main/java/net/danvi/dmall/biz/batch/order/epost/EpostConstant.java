package net.danvi.dmall.biz.batch.order.epost;

/**
 * Created by dong on 2016-07-15.
 */
public class EpostConstant {
    public static final String SEND_COMPAYNY_ID = "sendCompaynyId";
    public static final String SEND_AUTH_KEY = "sendAuthKey";
    public static final String SEND_DATE = "sendAuthKey";
    public static final String SITE_NO = "siteNo";
    public static final String DOMAIN = "domain";

    /**
     * 우체국 택배 - 송신 파일 경로 ( 수정 금지 우체국통신모듈 세팅값 )
     */
    public static final String EPOST_WRITE_FILE_PATH = "C:/epost/ftpdata/posnet_data/send";
    /**
     * 우첵국 택배 - 수신 파일 경로 ( 수정 금지 우체국통신모듈 세팅값 )
     */
    public static final String EPOST_READ_FILE_PATH = "C:/epost/ftpdata/posnet_data/receive";
    /**
     * 우첵국 택배 - 송신 파일 이동 경로 ( 수정 금지 우체국통신모듈 세팅값 )
     */
    public static final String EPOST_WRITE_FILE_MOVE_PATH = "C:/epost/ftpdata/posnet_data/sent";
    /**
     * 우첵국 택배 - 수신 파일 이동 경로 ( 수정 금지 우체국통신모듈 세팅값 )
     */
    public static final String EPOST_READ_FILE_MOVE_PATH = "C:/epost/ftpdata/posnet_data/received";
}
