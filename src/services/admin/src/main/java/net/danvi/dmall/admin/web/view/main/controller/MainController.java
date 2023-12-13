package net.danvi.dmall.admin.web.view.main.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.main.model.MallWeekStatusVO;
import net.danvi.dmall.biz.app.statistics.model.VisitPathVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.main.model.AdminMainSO;
import net.danvi.dmall.biz.app.main.model.MallOperStatusVO;
import net.danvi.dmall.biz.app.main.model.TodayShoppingmallVO;
import net.danvi.dmall.biz.app.main.service.MainService;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 16.
 * 작성자     : dong
 * 설명       : 관리자 메인 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
public class MainController {

    @Resource(name = "adminMainService")
    private MainService mainService;

    @Autowired
    private RequestMappingHandlerMapping handlerMapping;

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
    @RequestMapping("/admin/main/main-view")
    public ModelAndView mainView(AdminMainSO so) {
        ModelAndView mav = new ModelAndView("/admin/main/main");
        log.debug("================================");
        log.debug("Start : " + "시작 페이지");
        log.debug("================================");

        mav.addAllObjects(mainService.getMain(so));

        return mav;
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
     * 2023. 2. 10. truesol - 주간현황 조회로 수정
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/admin/main/week-status")
    public @ResponseBody List<MallWeekStatusVO> viewMallWeekStatus(AdminMainSO so) {
        return mainService.getWeekStatus(so);
    }

    @RequestMapping("/admin/main/check-session")
    public @ResponseBody ModelAndView viewMallSessionCheck() {
        ModelAndView mav = new ModelAndView("/admin/main/session_check");
        return mav;
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
    @RequestMapping("/admin/main/visit-path")
    public @ResponseBody List<VisitPathVO> visitPath(AdminMainSO so) {
        return mainService.getVisitPath(so);
    }    
    

    @RequestMapping( value = "/admin/main/endPoints", method = RequestMethod.GET )
    public ModelAndView getEndPointsInView( Model model ){
        ModelAndView mav = new ModelAndView("/admin/main/endPoints");
        Map<RequestMappingInfo, HandlerMethod> map = handlerMapping.getHandlerMethods();

        model.addAttribute( "map", map );
        mav.addAllObjects((Map<String, ?>) model);

        return mav;
    }
    
    @RequestMapping("/admin/main/qrcode")
    public ModelAndView createQrCode(AdminMainSO so) {
    	ModelAndView mav = new ModelAndView("/admin/main/qrcode");
    	
        return mav;
    }

    @RequestMapping("/admin/main/mall-status")
    public @ResponseBody List<MallOperStatusVO> mallStatus(AdminMainSO so) {
        return mainService.getMallOperStatus(so);
    }
}