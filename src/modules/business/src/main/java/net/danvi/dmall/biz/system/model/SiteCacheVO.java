package net.danvi.dmall.biz.system.model;

import lombok.Data;
import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpPO;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
public class SiteCacheVO implements Serializable {
    private static final long serialVersionUID = -6080852410430615345L;

    /** 업체 번호 */
    private Long companyNo;
    /** 사이트 번호 */
    private Long siteNo;
    /** 사이트 ID */
    private String siteId;
    /** 사이트 명 */
    private String siteNm;
    /** 기본 검색어 */
    private String defaultSrchWord;

    /** 사이트(쇼핑몰) 상태 코드 */
    private String siteStatusCd;

    /** 사이트 유형 코드 */
    private String siteTypeCd;

    /** 자동 로그아웃 시간 */
    private int autoLogoutTime;

    /** 보안 서버 사용 유형 코드 */
    // private String securityServUseTypeCd;
    /** 보안 버서 상태 코드 */
    private String securityServStatusCd;
    /** 보안서버 만료일 */
    private Date applyEndDt;
    /** 인증마크 표시 여부 */
    private String certifyMarkDispYn;

    /** 마우스 우클릭 사용 여부 */
    private String mouseRclickUseYn;
    /** 드래그&복사 사용 여부 */
    private String dragCopyUseYn;

    /** 접근 제한 IP 리스트 */
    private List<AccessBlockIpPO> blockIpList;
    /** 금칙어 리스트 */
    private List<String> bannedWordList;

    /** 비밀번호 변경 안내 사용 여부 */
    private String pwChgGuideYn;
    /** 비밀번호 변경 안내 주기 */
    private Integer pwChgGuideCycle;
    /** 다음에 변경 안내 설정 */
    private Integer pwChgNextChgDcnt;
    /** 휴면회원 해제방법 */
    private String dormantMemberCancelMethod;

    /** 스킨 번호 **/
    private Long pcSkinNo; // PC
    private Long mobileSkinNo; // MOBILE

    /** 서비스 시작 일자 */
    private Date svcStartDt;
    /** 서비스 종료 일자 */
    private Date svcEndDt;

    /** 대표도메인 */
    private String dlgtDomain;
    /** 임시(2차) 도메인 */
    private String tempDomain;

    /** 이미지 호스팅 ID */
    private String imgId;

    /** sms/email 서비스 인증키 */
    private String certKey;
    
    /** 앱 최신버전 */
    private String appVersionIos;
    private String appVersionAndroid;
    /** 강제 업데이트 여부 IOS */
    private String forceUpdateYnIos;
    /** 강제 업데이트 여부 ANDROID */
    private String forceUpdateYnAndroid;
}
