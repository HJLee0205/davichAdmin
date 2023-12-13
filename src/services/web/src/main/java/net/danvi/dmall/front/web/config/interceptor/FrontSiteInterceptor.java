package net.danvi.dmall.front.web.config.interceptor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.fasterxml.jackson.databind.ObjectMapper;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CookieUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.basicinfo.service.BasicInfoService;
import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.app.goods.model.CategoryPO;
import net.danvi.dmall.biz.app.goods.model.CategoryVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;

/**
 * 상점벌 화면으로 이동
 * Created by dong on 2016-03-14.
 */
@Slf4j
public class FrontSiteInterceptor extends HandlerInterceptorAdapter {

    private String SSL_SEAL_MARK = "SSL_SEAL_MARK";
    private String PG_SEAL_MARK = "PG_SEAL_MARK";

    @Value(value = "#{front['system.ssl.seal.mark.image']}")
    private String sslSealMarkImage;

    @Value(value = "#{front['system.pg.01.seal.mark.image']}")
    private String pg01SealMarkImage;

    @Value(value = "#{front['system.pg.02.seal.mark.image']}")
    private String pg02SealMarkImage;

    @Value(value = "#{front['system.pg.03.seal.mark.image']}")
    private String pg03SealMarkImage;

    @Value(value = "#{front['system.pg.04.seal.mark.image']}")
    private String pg04SealMarkImage;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "basicInfoService")
    private BasicInfoService basicInfoService;

    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;

    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;
    
    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        log.debug("URL : {}", request.getRequestURL());

        Long siteNo = siteService.getSiteNo(request.getServerName());
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);
        if(SiteUtil.isMobile()){
            request.setAttribute("_MOBILE_PATH", "/m");
        }
        request.setAttribute(RequestAttributeConstants.SITE_INFO, siteCacheVO);

        if (modelAndView != null) {
            ResultListModel<BasicInfoVO> result = basicInfoService.selectBasicInfo(siteNo);
            // 사이트 공통정보
            request.setAttribute(RequestAttributeConstants.FRONT_SITE_INFO, result.get("site_info"));
            // 사이트 메뉴정보
            request.setAttribute(RequestAttributeConstants.FRONT_GNB_INFO, result.get("gnb_info"));
            request.setAttribute(RequestAttributeConstants.FRONT_LNB_INFO, result.get("lnb_info"));
            // 카테고리 주력제품 정보
            CategoryPO cp = new CategoryPO();
            cp.setSiteNo(siteNo);
            List<CategoryVO> categoryVO = categoryManageService.selectMainDispGoodsList(cp);
            modelAndView.addObject("main_disp_goods", categoryVO);
            
            // 무통장 계좌정보
            request.setAttribute(RequestAttributeConstants.FRONT_NOPB_INFO, result.get("nopb_info"));
            // 팝업 정보
            // request.setAttribute(RequestAttributeConstants.FRONT_POPUP_INFO,
            // result.get("popup_info"));
            String jsonList = "";
            if (result.get("popup_info") != null) {
                ObjectMapper mapper = new ObjectMapper();
                jsonList = mapper.writeValueAsString(result.get("popup_info"));
                request.setAttribute(RequestAttributeConstants.FRONT_POPUP_JSON, jsonList);
                request.setAttribute(RequestAttributeConstants.FRONT_POPUP_INFO, result.get("popup_info"));
            }
            //구글애널리틱스 ID
            request.setAttribute("anlsId", result.get("anlsId"));


            MemberManageSO so = new MemberManageSO();
            DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
            if(sessionInfo.getSession().getMemberNo()!=null) {
            	
            	// mypage일경우만 처리
            	if (request.getRequestURL().indexOf("mypage") > 0 || 
            			request.getRequestURL().indexOf("order") > 0 ||
            			request.getRequestURL().indexOf("coupon") > 0 ||
            			request.getRequestURL().indexOf("member") > 0 ||
            			request.getRequestURL().indexOf("interest/interest-item-list") > 0 ||
            			request.getRequestURL().indexOf("customer/inquiry-list") > 0 ||
            			request.getRequestURL().indexOf("vision") > 0 ||
            			request.getRequestURL().indexOf("visit") > 0 ||
            			SiteUtil.isMobile() ) {
            	
	                so.setMemberNo(sessionInfo.getSession().getMemberNo());
	
	                // 02. 마켓포인트 조회search > 회원기본정보 set
	                ResultModel<MemberManageVO> prcAmt = memberManageService.selectMemSaveMn(so);
	                modelAndView.addObject("memberPrcAmt", prcAmt.getData().getPrcAmt());
	
	
	                // 02. 포인트 조회search > 회원기본정보 set
	                // 인터페이스로 보유 포인트 조회
	                long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
	                Map<String, Object> param = new HashMap<>();
	            	param.put("memNo", memberNo);
	            	
	            	String integrationMemberGbCd = SessionDetailHelper.getDetails().getSession().getIntegrationMemberGbCd();
	            	if("03".equals(integrationMemberGbCd)){
		                Map<String, Object> point_res = InterfaceUtil.send("IF_MEM_008", param);

                        if ("1".equals(point_res.get("result"))) {
                        }else{
                            point_res.put("mtPoint",0);
                        }
		                modelAndView.addObject("memberPrcPoint", point_res.get("mtPoint"));
	            	}
	                /*ResultModel<MemberManageVO> prcPoint = memberManageService.selectMemPoint(so);
	                modelAndView.addObject("memberPrcPoint", prcPoint.getData().getPrcPoint());*/
	
	
	                // 02.보유쿠폰search > 회원기본정보 set
	                Integer couponCount = memberManageService.selectCouponGetPagingCount(so);// 할인쿠폰
	                modelAndView.addObject("memberCouponCnt", Integer.toString(couponCount));
            	}
            }

            if (!HttpUtil.isAjax(request)) {
                //footer area 공지사항 공통 노출...
                BbsLettManageSO bbsSo = new BbsLettManageSO();
                // 1.공지사항 조회(최근등록순 5건)
                bbsSo.setBbsId("notice");
                bbsSo.setOrderGb("main");
                ResultListModel<BbsLettManageVO> noticeList = bbsManageService.selectBbsLettPaging(bbsSo);
                modelAndView.addObject("noticeList", noticeList);

                //메인 Footer
                String skinNo = "";
                if(SiteUtil.isMobile()) {
                    if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
                        skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
                    } else {
                        skinNo = "119";
                    }
                }else {
                    if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
                        skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
                    } else {
                        skinNo = "2";
                    }
                }

                BannerSO bs = new BannerSO();
                bs.setSiteNo(siteNo);// 사이트번호셋팅
                bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
                bs.setDispYn("Y");
                bs.setTodayYn("Y");
                bs.setSidx("SORT_SEQ");
                bs.setSord("ASC");
                ResultListModel<BannerVO> bannerVo = new ResultListModel<>();
                bs.setBannerMenuCd("MN");
                bs.setBannerAreaCd("MB8");
                bannerVo = bannerManageService.selectBannerListPaging(bs);
                modelAndView.addObject("footer_banner", bannerVo);
                
                // 탑배너 조회
                String tbanner_cookie = CookieUtil.getCookie(request, "tbanner");
                BannerSO tbs = new BannerSO();
                ResultListModel<BannerVO> tbannerVo = new ResultListModel<>();
                if(tbanner_cookie == null || tbanner_cookie == "") {
	                tbs.setSiteNo(siteNo);// 사이트번호셋팅
	                tbs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
	                tbs.setDispYn("Y");
	                tbs.setTodayYn("Y");
	                tbs.setSidx("SORT_SEQ");
	                tbs.setSord("ASC");
	                if(SiteUtil.isMobile()) {
	                	tbs.setBannerMenuCd("MO");
		                tbs.setBannerAreaCd("MTB");
	                }else {
	                	tbs.setBannerMenuCd("CM");
		                tbs.setBannerAreaCd("TB");
	                }
	                
	                tbannerVo = bannerManageService.selectBannerListPaging(tbs);
                }
                modelAndView.addObject("top_banner", tbannerVo);

                Map<String, String> snsMap = new HashMap<>();
                ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
                resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
                List<SnsConfigVO> snslist = resultListModel.getResultList();
                if (snslist != null && snslist.size() > 0) {
                    for (SnsConfigVO snsconfigVO : snslist) {
                        if ("Y".equals(snsconfigVO.getLinkUseYn()) && "Y".equals(snsconfigVO.getLinkOperYn())) {
                            switch (snsconfigVO.getOutsideLinkCd()) {
                                case "01":// 페이스북
                                    snsMap.put("fbAppId", snsconfigVO.getAppId());
                                    snsMap.put("fbAppSecret", snsconfigVO.getAppSecret());
                                    break;
                                case "02":// 네이버
                                    snsMap.put("naverClientId", snsconfigVO.getAppId());
                                    snsMap.put("naverSecret", snsconfigVO.getAppSecret());
                                    break;
                                case "03":// 카카오톡
                                    snsMap.put("javascriptKey", snsconfigVO.getJavascriptKey());
                                    break;
                            }
                        }
                    }
                }
                modelAndView.addObject("snsOutsideLink", resultListModel);
                modelAndView.addObject("snsMap", snsMap);
            }
        }

        setBasicInfo(request, siteCacheVO);

        super.postHandle(request, response, handler, modelAndView);

        request.setAttribute(RequestAttributeConstants.SITE_ID, SiteUtil.getSiteId());
    }

    private void setBasicInfo(HttpServletRequest request, SiteCacheVO siteCacheVO) throws Exception {

        request.setAttribute(RequestAttributeConstants.HTTP_SERVER_URL, "http://" + request.getServerName());
        request.setAttribute(RequestAttributeConstants.HTTPS_SERVER_URL, "https://" + request.getServerName());
        request.setAttribute(RequestAttributeConstants.HTTPX_SERVER_URL,request.getScheme() + "://" + request.getServerName());

        if ("Y".equals(siteCacheVO.getCertifyMarkDispYn())) {
            request.setAttribute(SSL_SEAL_MARK, "<img src=\"" + sslSealMarkImage + "\"/>");
        } else {
            request.setAttribute(SSL_SEAL_MARK, "");
        }

        String pgPath = "";
        CommPaymentConfigSO so = new CommPaymentConfigSO();
        so.setSiteNo(siteService.getSiteNo(request.getServerName()));
        so.setUseYn("Y");
        ResultModel<CommPaymentConfigVO> result = paymentManageService.selectCommPaymentConfig(so);
        if (result.getData() != null) {
            CommPaymentConfigVO vo = result.getData();
            if ("Y".equals(vo.getEscrowUseYn()) && "Y".equals(vo.getSafebuyImgDispSetCd())) {
                String pgCd = vo.getPgCd();
                if ("01".equals(pgCd)) {
                    pgPath = pg01SealMarkImage;
                } else if ("02".equals(pgCd)) {
                    pgPath = pg02SealMarkImage;
                } else if ("03".equals(pgCd)) {
                    pgPath = pg03SealMarkImage;
                } else if ("04".equals(pgCd)) {
                    pgPath = pg04SealMarkImage;
                }
            }
            request.setAttribute(PG_SEAL_MARK, "<img src=\"" + pgPath + "\"/>");
        }
    }
}