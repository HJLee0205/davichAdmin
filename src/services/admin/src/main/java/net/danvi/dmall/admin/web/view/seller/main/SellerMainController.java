package net.danvi.dmall.admin.web.view.seller.main;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.danvi.dmall.biz.app.main.model.MallWeekStatusVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.main.model.AdminMainSO;
import net.danvi.dmall.biz.app.main.model.MallOperStatusVO;
import net.danvi.dmall.biz.app.main.service.MainService;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.system.model.MenuVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.MenuService;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.CookieUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2017. 11. 16.
 * 작성자     : 
 * 설명       : 판매자 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/seller/main")
public class SellerMainController {

    @Resource(name = "adminMainService")
    private MainService mainService;    
    
    @Resource(name = "sellerService")
    private SellerService sellerService;
    
    @Resource(name = "menuService")
    private MenuService menuService;
    
    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 메인 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/main-view")
    public ModelAndView mainView(AdminMainSO so, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("/admin/seller/main/main");
        log.debug("================================");
        log.debug("Start : " + "시작 페이지");
        log.debug("================================");
        
        
        // 화면에서 넘어온 값을 cookie에 저장
 	   if ( (so.getSellerId() != null && !"".equals(so.getSellerId())) &&     	   
 	   		(so.getSellerNm() != null && !"".equals(so.getSellerNm())) &&
 	   	     so.getSellerNo() != null) {
 		   
		   SessionDetailHelper.getSession().setSellerId(so.getSellerId());
		   SessionDetailHelper.getSession().setSellerNo(so.getSellerNo());
		   SessionDetailHelper.getSession().setSellerNm(so.getSellerNm());
		   
		   DmallSessionDetails details = SessionDetailHelper.getDetails();
		   
           try {
    		   String cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);
               response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue));
           } catch (Exception e) {
               log.error("쿠키 추가 오류", e);
           }		   
 	   }

 	    so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
       
        mav.addAllObjects(mainService.getSellerMain(so));

        return mav;
    }
    
    
    
    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 해당 대메뉴의 첫번째 메뉴로 리다이렉트
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common/menu-redirect")
    public String firstMenu(MenuVO vo) throws Exception {

        vo = menuService.selectFirstMenu(vo);

        if (vo == null) {
            return View.redirect("/admin/seller/main/main-view");
        } else {
            return View.redirect(vo.getUrl());
        }
    }    

    
    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 쇼핑몰 운영현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/week-status")
    public @ResponseBody List<MallWeekStatusVO> viewMallOperStatus(AdminMainSO so) {
    	so.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
        return mainService.getWeekStatus(so);
    }
    

}
