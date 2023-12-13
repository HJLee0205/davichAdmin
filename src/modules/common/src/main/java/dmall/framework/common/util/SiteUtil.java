package dmall.framework.common.util;

import java.io.File;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.mobile.device.site.SitePreference;
import org.springframework.mobile.device.site.SitePreferenceUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import eu.bitwalker.useragentutils.DeviceType;
import eu.bitwalker.useragentutils.UserAgent;
import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.constants.RequestAttributeConstants;

@Component
@Slf4j
public class SiteUtil {

    private static String PRODUCT_DOMAIN = "";
    private static String TEST_DOMAIN = "";
    private static String DEV_DOMAIN = "";
    private static String LOCAL_DOMAIN = "";
    private static String _siteRootPath = "";
    private static String _mobileSiteRootPath = "";
    private static String _uploadRootPath = "";
    private static String _server = "";

    /** 사이트 도메인(id1.test.com 의 'test.com' 부분) */
    /** 운영서버 도메인 */
    @Value(value = "#{business['system.domain.product']}")
    private String productDomain;
    /** 스테이징(테스트)서버 도메인 */
    @Value(value = "#{business['system.domain.test']}")
    private String testDomain;
    /** 개발서버 도메인 */
    @Value(value = "#{business['system.domain.dev']}")
    private String devDomain;
    /** 로컬 도메인 */
    @Value(value = "#{business['system.domain.local']}")
    private String localDomain;

    /** 사이트별 디렉토리가 생성되는 상위 경로 */
    @Value(value = "#{system['system.site.root.path']}")
    private String siteRootPath;

    @Value(value = "#{system['system.upload.path']}")
    private String uploadRootPath;

    @Value(value = "#{system['m.system.site.root.path']}")
    private String mobileSiteRootPath;

    @Value(value = "#{system['m.system.upload.path']}")
    private String mobileUploadRootPath;

    @Value(value = "#{system['system.server']}")
    private String server;

    @PostConstruct
    public void init() {
        _server = server;
        PRODUCT_DOMAIN = productDomain;
        TEST_DOMAIN = testDomain;
        DEV_DOMAIN = devDomain;
        LOCAL_DOMAIN = localDomain;

        _siteRootPath = siteRootPath;
        _mobileSiteRootPath = mobileSiteRootPath;
        _uploadRootPath = uploadRootPath;

    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 사이트 루트 경로 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @return 사이트 루트 경로 문자열
     */
    public static String getSiteRootPath() {
        return getSiteRootPath(getSiteId());
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 사이트 아이디를 받아, 사이트 루트 경로 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param siteId
     * @return
     */
    public static String getSiteRootPath(String siteId) {
        /*Device device = DeviceUtils.getCurrentDevice(HttpUtil.getHttpServletRequest());
        log.debug("device.isNormal : {}", device.isNormal());
        SitePreference sitePreference = SitePreferenceUtils.getCurrentSitePreference(HttpUtil.getHttpServletRequest());
        if(sitePreference != null) {
            log.debug("sitePreference.isNormal : {}", sitePreference.isNormal());
        } else {
            log.debug("sitePreference is null");
        }

        if (sitePreference == null || sitePreference.isNormal()) {
            return _siteRootPath + File.separator + siteId;
        } else {
            return _mobileSiteRootPath + File.separator + siteId;
        }*/
        if(isMobile()){
            return _mobileSiteRootPath + File.separator + siteId;
        }else{
            return _siteRootPath + File.separator + siteId;
        }

    }

    public static String getSiteRootPath(String siteId,String mobilePath) {
        /*Device device = DeviceUtils.getCurrentDevice(HttpUtil.getHttpServletRequest());
        log.debug("device.isNormal : {}", device.isNormal());
        SitePreference sitePreference = SitePreferenceUtils.getCurrentSitePreference(HttpUtil.getHttpServletRequest());
        if(sitePreference != null) {
            log.debug("sitePreference.isNormal : {}", sitePreference.isNormal());
        } else {
            log.debug("sitePreference is null");
        }

        if (sitePreference == null || sitePreference.isNormal()) {
            return _siteRootPath + File.separator + siteId;
        } else {
            return _mobileSiteRootPath + File.separator + siteId;
        }*/
        if(isMobile()){
            return _mobileSiteRootPath + File.separator + siteId;
        }else{
            if(mobilePath!=null && !mobilePath.equals("")){
                return _mobileSiteRootPath + File.separator + siteId;
            }else{
                return _siteRootPath + File.separator + siteId;
            }

        }

    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : 사이트 업로드 루트 패스 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. dong - 최초생성
     * </pre>
     *
     * @return 사이트 업로드 경로 문자열
     */
    public static String getSiteUplaodRootPath() {
        return _uploadRootPath + File.separator + getSiteId();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 15.
     * 작성자 : dong
     * 설명   : 사이트 아이디를 받아, 사이트 업로드 루트 경로 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 15. dong - 최초생성
     * </pre>
     *
     * @param siteId
     *            사이트 아이디
     * @return
     */
    public static String getSiteUplaodRootPath(String siteId) {
        return _uploadRootPath + File.separator + siteId;
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 사이트 ID 반환 = 사이트 URL의 서브 도메인
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @return 사이트 ID 문자열
     */
    public static String getSiteId() {
        String siteId = (String) SessionUtil.getAttribute(RequestAttributeConstants.SITE_ID);
        /*log.debug("site id : {}", siteId);*/
        return siteId;
    }

    // /**
    // * <pre>
    // * 작성일 : 2016. 4. 29.
    // * 작성자 : dong
    // * 설명 : 뷰네임을 받아 사이트ID를 붙여서 반환한다.
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 4. 29. dong - 최초생성
    // * </pre>
    // *
    // * @param viewName
    // * @return 사이트ID가 붙은 뷰네임 문자열
    // */
    // public static String getStoreViewName(String viewName) {
    // return (getSiteId() + "/" + viewName).replaceAll("[/]{2,}", "/");
    // }
    //
    // /**
    // * <pre>
    // * 작성일 : 2016. 4. 29.
    // * 작성자 : dong
    // * 설명 : 사이트 ID를 뷰네임에 붙여서 반환한다
    // *
    // * 수정내역(수정일 수정자 - 수정내용)
    // * -------------------------------------------------------------------------
    // * 2016. 4. 29. dong - 최초생성
    // * </pre>
    // *
    // * @param modelAndView
    // * ModelAndView 객체
    // * @return 사이트ID가 붙은 뷰네임 문자열
    // */
    // public static String getViewNameByStoreId(ModelAndView modelAndView) {
    // String viewName = modelAndView.getViewName();
    // String siteId = getSiteId();
    //
    // return ("site/" + siteId + "/" + viewName).replaceAll("[/]{2,}", "/");
    // }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 사이트 아이디와 스킨명을 뷰네임에 붙여서 반환
     *          Velocity의 ResourceLoaderPath 를 루트로 본 경로
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param skinName
     * @param modelAndView
     * @return
     */
    public static String getViewNameByStoreId(String skinName, ModelAndView modelAndView) {
        String viewName = modelAndView.getViewName();
        String siteRootPath= SiteUtil.getSiteRootPath();
        String viewPath =( getSkinViewPath(skinName) + "/" + viewName).replaceAll("[/]{2,}", "/");
        String returnView ="";

        /** 해당 스킨폴더에 파일이 존재하지 않는다면 기본 webapps 의 파일을 사용한다. */
        File file = new File(siteRootPath+"/"+viewPath+".jsp");
        if(!file.exists()) {
            returnView = viewName;
        }else{
            returnView = "site/" +getSiteId() + viewPath;
        }
        return returnView;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 스킨 경로를 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param skinName
     *            스킨명
     * @return 스킨 경로 문자열
     */
    public static String getSkinPath(String skinName) {
        if (skinName == null || skinName.equals(getDefaultSkinId())) {
            if(isMobile()){
                return "/m/skin";
            }else{
                return "/skin";
            }

        } else {
            if(isMobile()) {
                return ("/m/skins/" + skinName).replaceAll("[/]{2,}", "/");
            }else {
                return ("/skins/" + skinName).replaceAll("[/]{2,}", "/");
            }
        }
    }

    public static String getSkinViewPath(String skinName) {

        if (skinName == null || skinName.equals(getDefaultSkinId())) {
            return ("/" + getDefaultSkinId()  + "/views").replaceAll("[/]{2,}", "/");
        } else {
            return ("/skins/" + skinName + "/views").replaceAll("[/]{2,}", "/");
        }
    }

    public static String getSkinViewPathWithSiteId(String skinName) {

        return getSiteId() + getSkinViewPath(skinName);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 스킨의 CSS경로를 반환
     *          아파치 웹서버 설정에 의해 회원 폴더를 루트로 본 절대경로
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param skinName
     *            스킨명
     * @return 스킨의 CSS 경로 문자열
     */
    public static String getSkinCssPath(String skinName) {
        return (getSkinPath(skinName) + "/css").replaceAll("[/]{2,}", "/");
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 스킨의 이미지 경로를 반환
     *          아파치 웹서버 설정에 의해 회원 폴더를 루트로 본 절대경로
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param skinName
     *            스킨명
     * @return 스킨의 이미지 경로 문자열
     */
    public static String getSkinImagePath(String skinName) {
        return (getSkinPath(skinName) + "/img").replaceAll("[/]{2,}", "/");
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 스킨의 스크립트 경로를 반환
     *          아파치 웹서버 설정에 의해 회원 폴더를 루트로 본 절대경로
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param skinName
     *            스킨명
     * @return 스킨의 스크립트 경로 문자열
     */
    public static String getSkinScriptPath(String skinName) {
        return (getSkinPath(skinName) + "/js").replaceAll("[/]{2,}", "/");
    }

    /**
     * <pre>
     * 작성일 : 2016. 4. 29.
     * 작성자 : dong
     * 설명   : 사이트 URL에서 사이트 ID를 추출하여 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 4. 29. dong - 최초생성
     * </pre>
     *
     * @param serverName
     *            사이트 URL
     * @return 사이트 ID 문자열
     */
    // public static String getStoreIdFromServerName(String serverName) {
    // serverName = serverName.replaceAll("." + DOMAIN, "").replaceAll(DOMAIN, "");
    //
    // if ("".equals(serverName) || "www".equalsIgnoreCase(serverName)) {
    // serverName = "www";
    // }
    //
    // return serverName;
    // }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 사이트 기본 스킨 설정의 ModelAndVeiw를 생성 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public static ModelAndView getSkinView() {
        ModelAndView mav = new ModelAndView();
        mav.addObject(RequestAttributeConstants.SKIN_VIEW, true);
        mav.addObject(RequestAttributeConstants.SKIN_ID, getDefaultSkinId() );
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 뷰를 지정하여 스킨 ModelAndView를 생성
     *          레이아웃과 스킨은 기본
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param viewName
     * @return
     */
    public static ModelAndView getSkinView(String viewName) {
        ModelAndView mav = new ModelAndView(viewName);

        mav.addObject(RequestAttributeConstants.SKIN_VIEW, true);
        mav.addObject(RequestAttributeConstants.SKIN_ID, getDefaultSkinId());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 스킨 이름과 뷰를 지정하여 스킨 ModelAndView를 생성
     *          레이아웃은 기본
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param skinName
     * @param viewName
     * @return
     */
    public static ModelAndView getSkinView(String skinName, String viewName) {
        ModelAndView mav = new ModelAndView(viewName);
        mav.addObject(RequestAttributeConstants.SKIN_VIEW, true);
        mav.addObject(RequestAttributeConstants.SKIN_ID, skinName);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 모바일 접속 여부를 반환한다(web:false, mobile:true)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public static boolean isMobile() {
        return isMobile(HttpUtil.getHttpServletRequest());
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 27.
     * 작성자 : dong
     * 설명   : UserAgentUtils 를 사용하여 사용자 요청의 모바일 여부를 반환한다.
     *          컴퓨터의 요청이 아니면 무조건 모바일
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 27. dong - 최초생성
     * </pre>
     *
     * @param request
     * @return
     */
    public static boolean isMobile(HttpServletRequest request) {
        UserAgent ua = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
        if (ua.getOperatingSystem().getDeviceType() == DeviceType.COMPUTER) {
            return false;
        }else if (ua.getOperatingSystem().getDeviceType() == DeviceType.UNKNOWN) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 30.
     * 작성자 : dong
     * 설명   : 이메일 등, 외부로 노출되는 도메인을 처리한다.
     *          로컬 개발 환경과 개발 서버 환경을 위함
     *          로컬환경에선 로컬 환경을 개발 환경으로,
     *            back.xml 의 system.domain.local 의 값을 system.domain.dev의 값으로
     *          개발환경에선 로컬 환경을 개발 환경으로,
     *            back.xml 의 system.domain.local 의 값을 system.domain.dev의 값,
     *            system.domain.product 의 값을 system.domain.dev의 값으로
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 30. dong - 최초생성
     * </pre>
     *
     * @param domain
     * @return
     */
    public static String getExternalDomain(String domain) {
        switch (_server) {
        case "product" :
            domain = StringUtil.replaceAll(domain, DEV_DOMAIN, PRODUCT_DOMAIN);
            break;
        case "dev":
            domain = StringUtil.replaceAll(domain, LOCAL_DOMAIN, DEV_DOMAIN);
            break;
        case "local":
            domain = StringUtil.replaceAll(domain, PRODUCT_DOMAIN, LOCAL_DOMAIN);
            domain = StringUtil.replaceAll(domain, DEV_DOMAIN, LOCAL_DOMAIN);
            break;
        default:
            break;
        }

        return domain;
    }

    public static String getDefaultSkinId() {
        Device device = DeviceUtils.getCurrentDevice(HttpUtil.getHttpServletRequest());

        if (device.isNormal()) {
            return RequestAttributeConstants.DEFAULT_SKIN_ID;
        } else {
            return RequestAttributeConstants.MOBILE_DEFAULT_SKIN_ID;
        }
    }
}
