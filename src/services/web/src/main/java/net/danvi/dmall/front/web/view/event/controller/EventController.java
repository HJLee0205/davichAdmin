package net.danvi.dmall.front.web.view.event.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.GoodsCtgVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.fasterxml.jackson.databind.ObjectMapper;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettVO;
import net.danvi.dmall.biz.app.promotion.event.model.EventPO;
import net.danvi.dmall.biz.app.promotion.event.model.EventSO;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import net.danvi.dmall.biz.app.promotion.event.service.EventService;
import net.danvi.dmall.biz.app.promotion.event.service.FrontEventService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.InsertGroup;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : Event 조회 관련 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/event")
public class EventController {
    @Resource(name = "frontEventService")
    private FrontEventService frontEventService;

    @Resource(name = "eventService")
    private EventService eventService;

    @Resource(name = "cacheService")
    private CacheService cacheService;
    
    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 이벤트 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/event-list")
    public ModelAndView selectEventList(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();

        // 필수 데이터 확인(사이트번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String today = df.format(new Date());

        // SO 선언
        EventSO ingSo = new EventSO();
        EventSO closeSo = new EventSO();
        EventSO wngSo = new EventSO();

        // 페이징 번호 set
        if ("close".equals(so.getEventCd())) {
            closeSo.setPage(so.getPage());
        } else if ("wng".equals(so.getEventCd())) {
            wngSo.setPage(so.getPage());
        }

        // 진행중인 이벤트 목록
        ingSo.setSiteNo(so.getSiteNo());
        String[] ingStatusCd = { "02" };
        ingSo.setEventKindCd("01");// 이벤트
        ingSo.setEventStatusCds(ingStatusCd);
        ingSo.setDelYn("N");
        ResultListModel<EventVO> eventIngList = eventService.selectEventListPaging(ingSo);
        // 지난 이벤트 목록
        closeSo.setSiteNo(so.getSiteNo());
        String[] closeStatusCd = { "03" };
        closeSo.setEventKindCd("01");// 이벤트
        closeSo.setEventStatusCds(closeStatusCd);
        closeSo.setDelYn("N");
        ResultListModel<EventVO> eventCloseList = eventService.selectEventListPaging(closeSo);

        // 당첨자 발표중인 이벤트 목록
        wngSo.setSiteNo(so.getSiteNo());
        String[] wngStatusCd = { "04" };
        wngSo.setEventKindCd("01");// 이벤트
        wngSo.setEventStatusCds(wngStatusCd);
        wngSo.setDelYn("N");
        ResultListModel<EventVO> eventWngList = eventService.selectEventListPaging(wngSo);

        // 최초 접속시에는 현재 진행중인 이벤트로 고정
        if (so.getEventCd() == null) {
            so.setEventCd("ing");
        }
        mav.addObject("so", so);
        mav.addObject("ingSo", ingSo);
        mav.addObject("closeSo", closeSo);
        mav.addObject("wngSo", wngSo);
        mav.addObject("eventIngList", eventIngList);
        mav.addObject("eventCloseList", eventCloseList);
        mav.addObject("eventWngList", eventWngList);
        mav.addObject("sessionMemberNo", memberNo);
        mav.setViewName("event/event_list");
        return mav;
    }

    //2016.09.02 - 모바일
    //진행중인 이벤트 리스트 페이지 ajax
    @RequestMapping(value = "/event-list-ajax")
    public ModelAndView ajaxEventList(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        // 필수 데이터 확인(사이트번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String today = df.format(new Date());

        // SO 선언
        EventSO ingSo = so;

        // 진행중인 이벤트 목록
        ingSo.setSiteNo(so.getSiteNo());
        String[] ingStatusCd = { "02" };
        ingSo.setEventKindCd("01");// 이벤트
        ingSo.setEventStatusCds(ingStatusCd);
        ingSo.setDelYn("N");
        ResultListModel<EventVO> eventIngList = eventService.selectEventListPaging(ingSo);

        // 최초 접속시에는 현재 진행중인 이벤트로 고정
        if (so.getEventCd() == null) {
            so.setEventCd("ing");
        }
        mav.addObject("so", so);
        mav.addObject("ingSo", ingSo);
        mav.addObject("eventIngList", eventIngList);
        mav.setViewName("event/ajaxEvent_list");
        return mav;
    }

    //2016.09.02-모바일
    //진행중인 이벤트 상세 페이지
    @RequestMapping(value = "/event-ing-list")
    public ModelAndView ingEventList(@Validated EventSO so, @Validated EventLettSO lettSo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/event/ingEvent_list");

        //텐션 이벤트 강제 이동
        if(so.getEventNo()!=0 && so.getEventNo()==36){
    	    RedirectView rv = new RedirectView("/m/front/event/teanseon-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

    	if(so.getEventNo()!=0 && so.getEventNo()==37){
    	    RedirectView rv = new RedirectView("/m/front/event/vegemil-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

    	if(so.getEventNo()!=0 && so.getEventNo()==38){
    	    RedirectView rv = new RedirectView("/front/event/chuseok-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

    	if(so.getEventNo()!=0 && so.getEventNo()==40){
    	    RedirectView rv = new RedirectView("/m/front/event/eyeluv-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

        //뜨레뷰
    	if(so.getEventNo()!=0 && so.getEventNo()==42){
    	    	//RedirectView rv = new RedirectView("/front/event/eyeluv-event");
    	    	RedirectView rv = new RedirectView("/front/event/trevues-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}
        //텐션
    	if(so.getEventNo()!=0 && so.getEventNo()==43){
    	    RedirectView rv = new RedirectView("/front/event/teanseon-event");

    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

        // 필수 데이터 확인(이벤트 번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        so.setDelYn("N");
        ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	String ingYn = result.getData().getIngYn();

    	so.setEventCd(ingYn);
    	
        lettSo.setEventNo(so.getEventNo());
        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);
        mav.addObject("eventLettList", eventLettList);
        mav.addObject("lettSo", lettSo);
        mav.addObject("resultModel", result);
        mav.addObject("so", so);
        
        return mav;
    }

    //2016.09.02 - 모바일
    //이벤트 댓글 리스트 페이지 ajax
    @RequestMapping(value = "/event-ing-ajax")
    public ModelAndView ajaxIngEventList(@Validated EventSO so, @Validated EventLettSO lettSo, BindingResult bindingResult) throws Exception {
        ModelAndView mav =SiteUtil.getSkinView();
        mav.addObject("so", so);

        // 필수 데이터 확인(이벤트 번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        lettSo.setEventNo(so.getEventNo());
        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);
        mav.addObject("lettSo", lettSo);
        mav.addObject("eventLettList", eventLettList);

        mav.setViewName("event/ajaxIngEvent_list");
        return mav;
    }

    //2016.09.02 - 모바일
    //이벤트 당첨자 리스트 페이지 추가
    @RequestMapping(value = "/winner-list")
    public ModelAndView selectWinnerList(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        // 필수 데이터 확인(사이트번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String today = df.format(new Date());

        // SO 선언
        EventSO wngSo = new EventSO();

        // 페이징 번호 set
        if ("wng".equals(so.getEventCd())) {
            wngSo.setPage(so.getPage());
        }

        // 당첨자 발표중인 이벤트 목록
        wngSo.setSiteNo(so.getSiteNo());
        String[] wngStatusCd = { "04" };
        wngSo.setEventStatusCds(wngStatusCd);
        wngSo.setEventKindCd("01");// 이벤트
        wngSo.setDelYn("N");
        ResultListModel<EventVO> eventWngList = eventService.selectEventListPaging(wngSo);

        // 최초 접속시에는 현재 진행중인 이벤트로 고정
        if (so.getEventCd() == null) {
            so.setEventCd("ing");
        }
        mav.addObject("so", so);
        mav.addObject("wngSo", wngSo);
        mav.addObject("eventWngList", eventWngList);
        mav.setViewName("event/winner_list");
        return mav;
    }

    //2016.09.02 - 모바일
    //이벤트 당첨자 리스트 ajax
    @RequestMapping(value = "/winner-list-ajax")
    public ModelAndView ajaxWinnerList(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        // 필수 데이터 확인(사이트번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String today = df.format(new Date());

        // SO 선언
        EventSO wngSo = so;

        // 페이징 번호 set
        if ("wng".equals(so.getEventCd())) {
            wngSo.setPage(so.getPage());
        }

        // 당첨자 발표중인 이벤트 목록
        wngSo.setSiteNo(so.getSiteNo());
        String[] wngStatusCd = { "04" };
        wngSo.setEventStatusCds(wngStatusCd);
        wngSo.setEventKindCd("01");// 이벤트
        wngSo.setDelYn("N");
        ResultListModel<EventVO> eventWngList = eventService.selectEventListPaging(wngSo);

        // 최초 접속시에는 현재 진행중인 이벤트로 고정
        if (so.getEventCd() == null) {
            so.setEventCd("ing");
        }
        mav.addObject("so", so);
        mav.addObject("wngSo", wngSo);
        mav.addObject("eventWngList", eventWngList);
        mav.setViewName("event/ajaxWinner_list");
        return mav;
    }

    //2016.09.02 - 모바일
    //지난 이벤트 리스트 페이지 추가
    @RequestMapping(value = "/event-close-list")
    public ModelAndView selectCloseEventList(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        // 필수 데이터 확인(사이트번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String today = df.format(new Date());

        // SO 선언
        EventSO closeSo = new EventSO();

        // 페이징 번호 set
        if ("close".equals(so.getEventCd())) {
            closeSo.setPage(so.getPage());
        }

        // 지난 이벤트 목록
        closeSo.setSiteNo(so.getSiteNo());
        String[] closeStatusCd = { "03" };
        closeSo.setEventKindCd("01");// 이벤트
        closeSo.setEventStatusCds(closeStatusCd);
        closeSo.setDelYn("N");
        ResultListModel<EventVO> eventCloseList = eventService.selectEventListPaging(closeSo);

        // 최초 접속시에는 현재 진행중인 이벤트로 고정
        if (so.getEventCd() == null) {
            so.setEventCd("ing");
        }
        mav.addObject("so", so);
        mav.addObject("closeSo", closeSo);
        mav.addObject("eventCloseList", eventCloseList);
        mav.setViewName("event/closeEvent_list");
        return mav;
    }

    //2016.09.02 - 모바일
    //closeEventList_ajax
    @RequestMapping(value = "/event-close-ajax")
    public ModelAndView ajaxCloseEventList(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        // 필수 데이터 확인(사이트번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String today = df.format(new Date());

        // SO 선언
        EventSO closeSo = so;

        // 페이징 번호 set
        if ("close".equals(so.getEventCd())) {
            closeSo.setPage(so.getPage());
        }

        // 지난 이벤트 목록
        closeSo.setSiteNo(so.getSiteNo());
        String[] closeStatusCd = { "03" };
        closeSo.setEventKindCd("01");// 이벤트
        closeSo.setEventStatusCds(closeStatusCd);
        closeSo.setDelYn("N");
        ResultListModel<EventVO> eventCloseList = eventService.selectEventListPaging(closeSo);

        // 최초 접속시에는 현재 진행중인 이벤트로 고정
        if (so.getEventCd() == null) {
            so.setEventCd("ing");
        }
        mav.addObject("so", so);
        mav.addObject("closeSo", closeSo);
        mav.addObject("eventCloseList", eventCloseList);
        mav.setViewName("event/ajaxCloseEvent_list");
        return mav;
    }

/*    *//**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명 : 단건 이벤트 조회
     *
     * @return
     * @throws Exception
     *//*
    @RequestMapping(value = "/event-detail")
    public @ResponseBody ResultModel<EventVO> ajaxViewEvent(@Validated EventSO so, BindingResult bindingResult)
            throws Exception {
        so.setDelYn("N");
        ResultModel<EventVO> result = eventService.selectEventInfo(so);
        EventVO resultVo = result.getData();
        resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
        result.setData(resultVo);
        return result;
    }*/
    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명 : 단건 이벤트 조회
     *
     * @return
     * @throws Exception
     */
     /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명 : 단건 이벤트 조회
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/m-event-detail")
    public @ResponseBody ResultModel<EventVO> ajaxViewEvent(@Validated EventSO so, BindingResult bindingResult)
            throws Exception {
        so.setDelYn("N");
        ResultModel<EventVO> result = eventService.selectEventInfo(so);
        EventVO resultVo = result.getData();
        resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
        result.setData(resultVo);
        return result;
    }
    
    @RequestMapping(value = "/event-detail")
    public ModelAndView selectEventView(@Validated EventSO so, BindingResult bindingResult) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/event/event_view");

        //텐션 이벤트 강제 이동
    	/*if(so.getEventNo()!=0 && so.getEventNo()==36){
    	    	RedirectView rv = new RedirectView("/front/event/teanseon-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}*/

    	if(so.getEventNo()!=0 && so.getEventNo()==37){
    	    RedirectView rv = new RedirectView("/front/event/vegemil-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

    	if(so.getEventNo()!=0 && so.getEventNo()==38){
    	    RedirectView rv = new RedirectView("/front/event/chuseok-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}

    	/*if(so.getEventNo()!=0 && so.getEventNo()==40){
    	    	RedirectView rv = new RedirectView("/front/event/eyeluv-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}*/
        //뜨레뷰
    	if(so.getEventNo()!=0 && so.getEventNo()==42){
    	    	//RedirectView rv = new RedirectView("/front/event/eyeluv-event");
    	    	RedirectView rv = new RedirectView("/front/event/trevues-event");
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}
        //텐션
    	if(so.getEventNo()!=0 && so.getEventNo()==43){
    	    RedirectView rv = new RedirectView("/front/event/teanseon-event");

    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);
    	}


    	//모바일일경우
    	if(SiteUtil.isMobile()) {
    		/*ModelAndView mav2 = new ModelAndView();
    		mav2.setViewName("redirect:/front/event/event-ing-list?eventNo="+so.getEventNo());
    		return mav2;*/
    		
    		RedirectView rv = new RedirectView("/m/front/event/event-ing-list?eventNo="+so.getEventNo());
    		rv.setExposeModelAttributes(false);
    		return new ModelAndView(rv);

    	}


        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();
        
        so.setDelYn("N");            
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);
    	
    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	String ingYn = result.getData().getIngYn();

    	so.setEventCd(ingYn);
    	  	
    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
    	/*if(ingYn != null && "Y".equals(ingYn)){*/
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}
        
    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);
        
    	return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명 : 이벤트 댓글 조회
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/event-comment-list")
    public @ResponseBody ResultListModel<EventLettVO> ajaxEventLettList(@Validated EventLettSO so,
                                                                        BindingResult bindingResult) throws Exception {

        // 필수 데이터 확인(이벤트 번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        return frontEventService.selectEventLettListPaging(so);
    }

    /*
     * @RequestMapping(value = "/event-comment-list")
     * public @ResponseBody ResultListModel<EventLettVO>
     * ajaxEventLettList(@Validated EventLettSO so,
     * BindingResult bindingResult) throws Exception {
     *
     * // 필수 데이터 확인(이벤트 번호)
     * if (bindingResult.hasErrors()) {
     * log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
     * throw new JsonValidationException(bindingResult);
     * }
     *
     * return frontEventService.selectEventLettListPaging(so);
     * }
     */

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명 : 당첨자 발표 조회
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/event-winning-info")
    public @ResponseBody ResultModel<EventLettVO> ajaxWngInfo(@Validated EventLettSO so,
            BindingResult bindingResult) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        // 필수 데이터 확인(이벤트 번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<EventLettVO> result = new ResultModel<EventLettVO>();
        
        result = frontEventService.selectEventLett(so);
        if(result.getData() != null) {
	        if(result.getData().getWngContentHtml() != null ) {
	        	result.getData().setWngContentHtml(StringUtil.replaceAll(result.getData().getWngContentHtml(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
	        	result.getData().setWngContentHtml(restoreClearXSS(result.getData().getWngContentHtml()));

	        }
        }
        
        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명 : 당첨자 발표 조회
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/event-winning-list")
    public @ResponseBody ResultListModel<EventLettVO> ajaxWngList(@Validated EventLettSO so,
            BindingResult bindingResult) throws Exception {

        // 필수 데이터 확인(이벤트 번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<EventLettVO> result = frontEventService.selectEventLettList(so);
        if (result.getResultList() != null) {
            for (int i = 0; i < result.getResultList().size(); i++) {
                EventLettVO tempVo = (EventLettVO) result.getResultList().get(i);
                tempVo.setWngContentHtml(restoreClearXSS(tempVo.getWngContentHtml()));
            }
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 이벤트 댓글 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * 2016. 5. 25. dong - 등록개발
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/event-comment-insert")
    public @ResponseBody ResultModel<EventLettPO> insertEventComment(@Validated(InsertGroup.class) EventLettPO po,
                                                                     BindingResult bindingResult) throws Exception {
        // 필수 데이터 확인(이벤트번호, 회원번호)
        // if (bindingResult.hasErrors()) {
        // log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
        // throw new JsonValidationException(bindingResult);
        // }

        ResultModel<EventLettPO> result = new ResultModel<EventLettPO>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();
        if (memberNo == null || memberNo == 0) {
            result.setSuccess(false);
            result.setMessage("로그인 후 이용가능합니다.");
            return result;
        }

        po.setMemberNo(memberNo);
        result = frontEventService.insertEventLett(po);
        log.debug(" ==result : {}", result.getData().getLettNo());

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 이벤트 댓글 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/event-comment-delete")
    public @ResponseBody ResultModel<EventLettPO> deleteEventLett(@Validated(InsertGroup.class) EventLettPO po,
            BindingResult bindingResult) throws Exception {
        // 필수 데이터 확인(이벤트댓글 번호, 삭제자번호)
        // if (bindingResult.hasErrors()) {
        // log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
        // throw new JsonValidationException(bindingResult);
        // }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();
        po.setMemberNo(memberNo);

        ResultModel<EventLettPO> result = frontEventService.deleteEventLett(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 출석체크 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/attendance-check-deatil")
    public ModelAndView viewAttendanceCheck(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        SiteSO ss = new SiteSO();
        ss.setSiteNo(so.getSiteNo());
        SiteVO basic_info = cacheService.selectBasicInfo(ss);

        // 1.출석체크 이벤트 조회
        so.setEventNo(Integer.parseInt(basic_info.getEventNo()));
        so.setEventKindCd("02");
        so.setDelYn("N");
        ResultModel<EventVO> event = eventService.selectEventInfo(so);

        mav.setViewName("event/view_attendance_check");
        mav.addObject("event", event);
        mav.addObject("so", so);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 24.
     * 작성자 : dong
     * 설명   : 출석체크 하기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 24. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/attendance-check")
    public @ResponseBody ResultModel<EventLettPO> insertAttendanceCheck(@Validated(InsertGroup.class) EventLettPO po,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 이벤트 정보 조회, 출석등록, 포인트 지급
        ResultModel<EventLettPO> result = new ResultModel<>();
        if (SessionDetailHelper.getDetails().isLogin()) {
            result = frontEventService.insertAttendanceCheck(po);
        } else {
            throw new Exception("로그인이 필요한 서비스 입니다.");
        }

        result.setSuccess(true);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : 출석체크 이벤트 회원 출석 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/attendance-info")
    public @ResponseBody ResultListModel<EventLettVO> attendanceInfo(@Validated EventLettSO so,
            BindingResult bindingResult) throws Exception {
        ResultListModel<EventLettVO> result = new ResultListModel<>();

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().isLogin()) {
            so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            result = frontEventService.selectAttendanceUserInfo(so);
        } else {
            result.setSuccess(true);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2019. 8. 12.
     * 작성자 : hskim
     * 설명   : 이모티콘 이벤트 지급
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 12. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/imoticon-reward")
    public @ResponseBody ResultModel<EventLettPO> imoticonReward(HttpServletRequest request) throws Exception {
    	ResultModel<EventLettPO> result = new ResultModel<EventLettPO>();

    	// 01. 사용자 광고참여 시작
        String url = "https://open-reward.kakao.com/api/v1/rewards/eb7d34ae9d10466f15199f8eeed0b5fa";
        DefaultHttpClient httpClient = new DefaultHttpClient();
        HttpPost httpPost = new HttpPost(url);
        
        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
        nameValuePairs.add(new BasicNameValuePair("uid",request.getParameter("mobile")));
        nameValuePairs.add(new BasicNameValuePair("uuid_type","OUTSIDE_ID"));
        
        try {
        	HttpEntity postParams = new UrlEncodedFormEntity(nameValuePairs);
        	httpPost.setEntity(postParams);
        	HttpResponse response = httpClient.execute(httpPost);
        	
        	StringBuilder sb = new StringBuilder();
        	BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
        	String line = "";
        	String js = "";
        	
        	while((line = rd.readLine()) != null) {
        		sb.append(line);
        	}
        	js = sb.toString();
        	
            JSONObject responseJson = new JSONObject(js);
            
            if(responseJson != null && "100".equals(responseJson.get("detail_code").toString())) {
            	JSONObject infoJson = responseJson.getJSONObject("info");
    			String join_token = infoJson.get("join_token").toString();
    			//String join_token = "iqS9hk4gzIyubWQDEv+8eYryfzRE/bVkizc9a7YvPKuVA1cUUQ3c9LXMpIfQDmCDLcqT/0E/mRSxyv415/1d1do6SLZ/4NLnvXD9qjHr89XiS9wuCQZutqb902cPQr/l";
    			
    			// 02. 사용자의 참여 완료 및 리워드 지급 요청
    			url = "https://open-reward.kakao.com/api/v1/rewards/eb7d34ae9d10466f15199f8eeed0b5fa/issues";
    			httpClient = new DefaultHttpClient();
    			httpPost = new HttpPost(url);
    			nameValuePairs = new ArrayList<NameValuePair>();
    			nameValuePairs.add(new BasicNameValuePair("receiver_id",request.getParameter("mobile")));
    			nameValuePairs.add(new BasicNameValuePair("receiver_id_type","PHONE_NUMBER"));
    			nameValuePairs.add(new BasicNameValuePair("reward_type","KAKAO_EMOTICON"));
    			nameValuePairs.add(new BasicNameValuePair("join_token",join_token));
    			
    			try {
    				postParams = new UrlEncodedFormEntity(nameValuePairs);
    				httpPost.setEntity(postParams);
    				response = httpClient.execute(httpPost);
    				
    				sb = new StringBuilder();
    	        	rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
    	        	line = "";
    	        	js = "";
    	        	
    	        	while((line = rd.readLine()) != null) {
    	        		sb.append(line);
    	        	}
    	        	js = sb.toString();
    	        	
    	            JSONObject resultJson = new JSONObject(js);
    	            
    	            if(resultJson != null && "100".equals(resultJson.get("detail_code").toString())) {
    	            	
    	            	// 03. 이벤트 참여정보 DB저장
    	            	EventLettPO po = new EventLettPO();
    	            	po.setMobile(request.getParameter("memMobile"));
    	            	
    	            	DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
    	            	if (SessionDetailHelper.getDetails().isLogin()) {
    	                    po.setMemberNo(sessionInfo.getSession().getMemberNo());
    	                }
    	            	eventService.insertImoticonInfo(po);
    	            	
    	            	result.setSuccess(true);
    	            	result.setMessage("이모티콘이 지급되었습니다.");
    	            } else {
    	            	result.setSuccess(false);
    	            	String msg = imoticonResponseMsg(resultJson.get("detail_code").toString());
    	    			result.setMessage(msg);
    	        		return result;
    	            }
    			} catch (Exception e) {
    	        	System.out.println("error"+e);
    	        }
    		}else {
    			result.setSuccess(false);
    			String msg = imoticonResponseMsg(responseJson.get("detail_code").toString());
    			result.setMessage(msg);
        		return result;
    		}
        } catch (Exception e) {
        	System.out.println("error"+e);
        }

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 8. 08.
     * 작성자 : hskim
     * 설명   : 이모티콘 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 08. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/imoticon-event")
    public ModelAndView viewImoticonEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/event/view_imoticon_event");
        
        // 11.SNS공유 관련 설정 조회
        Map<String, String> snsMap = new HashMap<>();
        SiteSO ss = new SiteSO();
        ss.setSiteNo(so.getSiteNo());
        SiteVO site_info = cacheService.selectBasicInfo(ss);
        if ("Y".equals(site_info.getContsUseYn())) {
            ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
            resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
            List<SnsConfigVO> snslist = resultListModel.getResultList();
            if (snslist != null && snslist.size() > 0) {
                for (SnsConfigVO vo : snslist) {
                    if ("Y".equals(vo.getLinkUseYn()) && "Y".equals(vo.getLinkOperYn())) {
                        switch (vo.getOutsideLinkCd()) {
                        case "01":// 페이스북
                            snsMap.put("fbAppId", vo.getAppId());
                            snsMap.put("fbAppSecret", vo.getAppSecret());
                            break;
                        case "02":// 네이버
                            snsMap.put("naverClientId", vo.getAppId());
                            snsMap.put("naverSecret", vo.getAppSecret());
                            break;
                        case "03":// 카카오톡
                            snsMap.put("javascriptKey", vo.getJavascriptKey());
                            break;
                        }
                    }
                }
            }
        }
        
        mav.addObject("snsMap", snsMap);
        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();
        
        so.setEventNo(29);
        so.setEventCd("ing");
        so.setDelYn("N");            
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);
    	
    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;
    	  	
    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{    		
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}
        
    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);
	        
	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }
    
    public String restoreClearXSS(String str) {
        if (!"".equals(str) && str != null) {
            str = str.trim();
            str = str.replaceAll("&#35;", "#");
            str = str.replaceAll("&lt;", "<");
            str = str.replaceAll("&gt;", ">");
            str = str.replaceAll("&#34;", "\\\"");
            str = str.replaceAll("&#39;", "'");
            str = str.replaceAll("&#40;", "\\(");
            str = str.replaceAll("&#41;", "\\)");
            str = str.replaceAll("&quot;", "\"");
        }
        return str;
    }
    
    public String imoticonResponseMsg(String code) {
    	String msg = "";
    	switch(code) {
			case "0": msg = "요청에 실패하였습니다.<br>다시 시도해주세요.";
			break;
			case "888": msg = "요청자의 ip가 허용되지 않았습니다.";
			break;
			case "999": msg = "api key가 올바르지 않습니다.";
			break;
			case "900": msg = "사용자 id가 올바르지 않습니다.";
			break;
			case "4001": msg = "이벤트가 종료되었습니다.";
			break;
			case "4002": msg = "리워드 타입 값이 올바르지 않습니다.";
			break;
			case "4003": msg = "http request 파라미터가 올바르지 않습니다.";
			break;
			case "4004": msg = "이미 리워드가 지급되었습니다.";
			break;
			case "4005": msg = "사용자 id 타입이 올바르지 않습니다.";
			break;
			case "4006": msg = "사용자의 카카오톡 계정이 존재하지 않습니다.";
			break;
			case "4008": msg = "현재 사용자의 디바이스를 지원하지 않습니다.";
			break;
			case "4009": msg = "아직 검수가 끝나지 않았습니다.";
			break;
			case "4010": msg = "광고를 보여주기 위한 정적 파일이 등록되지 않았습니다.";
			break;
			case "4011": msg = "jsoin_token 값이 올바르지 않습니다.";
			break;
			case "4013": msg = "http request content-type 값이 올바르지 않습니다.";
			break;
			case "4014": msg = "receiver_id type 값이 올바르지 않습니다.";
			break;
			case "4015": msg = "receiver_id 값이 올바르지 않습니다.";
			break;
			case "4016": msg = "조금 후 다시 시도해주세요.";
			break;
			case "4017": msg = "동일 이모티콘을 지난 '이모티콘 사용기간 + 30일' 내<br>해당 사용자에게 지급한 기록이 있습니다.";
			break;
			default: msg = "오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.";
			break;
		}
	    	
    	return msg;
    }


    /**
     * <pre>
     * 작성일 : 2019. 8. 08.
     * 작성자 : dong
     * 설명   : 텐션 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 08. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/teanseon-event")
    public ModelAndView viewTeanseonEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/event/view_teanseonsample_event");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();

        //상품 정보 조회
        /*GoodsDetailSO goodsSo = new GoodsDetailSO();
        goodsSo.setSiteNo(so.getSiteNo());
        goodsSo.setGoodsNo("G1903081648_4461");
        goodsSo.setSaleYn("Y");
        goodsSo.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        goodsSo.setGoodsStatus(goodsStatus);
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(goodsSo);
        mav.addObject("goodsInfo", goodsInfo);

        CategorySO cs = new CategorySO();
        cs.setSiteNo(so.getSiteNo());

        // 카테고리 번호가 넘어오지 않을경우 상품의 대표카테고리를 조회한다.
        for (int i = 0; i < goodsInfo.getData().getGoodsCtgList().size(); i++) {
            GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(i);
            if(i == 0) {
                mav.addObject("ctgNo", gcvs.getCtgNo());
            }
            if ("Y".equals(gcvs.getDlgtCtgYn())) {
                mav.addObject("ctgNo", gcvs.getCtgNo());
            }
        }*/


        //이벤트 정보 조회
        so.setEventNo(43);
        so.setEventCd("ing");
        so.setDelYn("N");
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}

    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);

	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2019. 8. 08.
     * 작성자 : dong
     * 설명   : 베지밀 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 08. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/vegemil-event")
    public ModelAndView viewVegemilEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/event/view_vegemil_event");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();

        //상품 정보 조회
        GoodsDetailSO goodsSo = new GoodsDetailSO();
        goodsSo.setSiteNo(so.getSiteNo());

        goodsSo.setSaleYn("Y");
        goodsSo.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        goodsSo.setGoodsStatus(goodsStatus);

        //상품 기본정보
        goodsSo.setGoodsNo("G2009141410_8234");
        ResultModel<GoodsDetailVO> goodsInfo5003 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfo5003", goodsInfo5003);

        // 단품정보
        String jsonList = "";
        if (goodsInfo5003.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfo5003.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfo5003", jsonList);


        goodsSo.setGoodsNo("G2009141415_8236");
        ResultModel<GoodsDetailVO> goodsInfo5007 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfo5007", goodsInfo5007);

         // 단품정보
        if (goodsInfo5007.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfo5007.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfo5007", jsonList);

        goodsSo.setGoodsNo("G2009141422_8237");
        ResultModel<GoodsDetailVO> goodsInfoT509 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfoT509", goodsInfoT509);
         // 단품정보
        if (goodsInfoT509.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfoT509.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfoT509", jsonList);

        goodsSo.setGoodsNo("G2009141426_8238");
        ResultModel<GoodsDetailVO> goodsInfoT511 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfoT511", goodsInfoT511);
         // 단품정보
        if (goodsInfoT511.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfoT511.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfoT511", jsonList);


        goodsSo.setGoodsNo("G2009141434_8240");
        ResultModel<GoodsDetailVO> goodsInfoT514 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfoT514", goodsInfoT514);
        // 단품정보
        if (goodsInfoT514.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfoT514.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfoT514", jsonList);

        goodsSo.setGoodsNo("G2009141439_8241");
        ResultModel<GoodsDetailVO> goodsInfoT519 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfoT519", goodsInfoT519);
         // 단품정보
        if (goodsInfoT519.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfoT519.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfoT519", jsonList);

        goodsSo.setGoodsNo("G2009141442_8242");
        ResultModel<GoodsDetailVO> goodsInfoT521 = goodsManageService.selectVegemilGoodsInfo(goodsSo);
        mav.addObject("goodsInfoT521", goodsInfoT521);

         // 단품정보
        if (goodsInfoT521.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfoT521.getData().getGoodsItemList());
        }
        mav.addObject("goodsItemInfoT521", jsonList);

        /*CategorySO cs = new CategorySO();
        cs.setSiteNo(so.getSiteNo());

        // 카테고리 번호가 넘어오지 않을경우 상품의 대표카테고리를 조회한다.
        for (int i = 0; i < goodsInfo.getData().getGoodsCtgList().size(); i++) {
            GoodsCtgVO gcvs = goodsInfo.getData().getGoodsCtgList().get(i);
            if(i == 0) {
                mav.addObject("ctgNo", gcvs.getCtgNo());
            }
            if ("Y".equals(gcvs.getDlgtCtgYn())) {
                mav.addObject("ctgNo", gcvs.getCtgNo());
            }
        }*/


        //이벤트 정보 조회
        so.setEventNo(37);
        so.setEventCd("ing");
        so.setDelYn("N");
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}

    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);

	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2019. 8. 08.
     * 작성자 : dong
     * 설명   : 텐션 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 08. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/chuseok-event")
    public ModelAndView viewChuseokEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/event/view_chuseok_event");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();


        //이벤트 정보 조회
        so.setEventNo(38);
        so.setEventCd("ing");
        so.setDelYn("N");
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}

    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);

	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2019. 8. 08.
     * 작성자 : dong
     * 설명   : 아이럽 라이트 사전예약 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 08. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/eyeluv-event")
    public ModelAndView viewEyeluvEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/event/view_eyeluv_event");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();

        //이벤트 정보 조회
        so.setEventNo(42);
        so.setEventCd("ing");
        so.setDelYn("N");
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}

    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);

	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }


    @RequestMapping(value = "/trevues-event")
    public ModelAndView viewTrevuesEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
//        ModelAndView mav = SiteUtil.getSkinView("/event/view_eyeluv_event");
        ModelAndView mav = SiteUtil.getSkinView("/event/view_trevues_event");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();

        //이벤트 정보 조회
        so.setEventNo(42);
        so.setEventCd("ing");
        so.setDelYn("N");
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}

    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);

	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 이벤트 공유하기정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * 2016. 5. 25. dong - 등록개발
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sns-shared-insert")
    public @ResponseBody ResultModel<EventLettPO> insertSnsShare(@Validated(InsertGroup.class) EventLettPO po,
                                                                     BindingResult bindingResult) throws Exception {
        ResultModel<EventLettPO> result = new ResultModel<EventLettPO>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();
        if (memberNo == null || memberNo == 0) {
            result.setSuccess(false);
            result.setMessage("로그인 후 이용가능합니다.");
            return result;
        }

        po.setMemberNo(memberNo);
        result = frontEventService.insertSnsShare(po);
        log.debug(" ==result : {}", result.getData().getLettNo());

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명 : SNS 공유하기 여부 조회
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sns-shared-info")
    public @ResponseBody ResultModel<EventLettVO> ajaxSnsSharedInfo(@Validated EventLettSO so,
            BindingResult bindingResult) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        // 필수 데이터 확인(이벤트 번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<EventLettVO> result = new ResultModel<EventLettVO>();

        result = frontEventService.selectSnsSharedInfo(so);

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2019. 8. 08.
     * 작성자 : dong
     * 설명   : 아이럽 라이트 사전예약 이벤트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 8. 08. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/teanseon-new-event")
    public ModelAndView viewTeanseonNewEvent(@Validated EventSO so, BindingResult bindingResult) throws Exception {
        //ModelAndView mav = SiteUtil.getSkinView("/event/view_eyeluv_event");
        ModelAndView mav = SiteUtil.getSkinView("/event/view_teansNew_event");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        Long memberNo = sessionInfo.getSession().getMemberNo();

        //이벤트 정보 조회
        so.setEventNo(47);
        so.setEventCd("ing");
        so.setDelYn("N");
    	ResultModel<EventVO> result = eventService.selectEventInfo(so);
    	EventVO resultVo = result.getData();
    	resultVo.setEventContentHtml(restoreClearXSS(resultVo.getEventContentHtml()));
    	result.setData(resultVo);

    	EventSO ingSo = new EventSO();
    	EventSO closeSo = new EventSO();
    	ResultListModel<EventVO> eventList = null;

    	if(so.getEventCd() != null && "ing".equals(so.getEventCd())){
	        // 진행중인 이벤트 목록
	        ingSo.setSiteNo(so.getSiteNo());
	        String[] ingStatusCd = { "02" };
	        ingSo.setEventKindCd("01");// 이벤트
	        ingSo.setEventStatusCds(ingStatusCd);
	        ingSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(ingSo);
    	}else{
    		// 지난 이벤트 목록
	        closeSo.setSiteNo(so.getSiteNo());
	        String[] closeStatusCd = { "03" };
	        closeSo.setEventKindCd("01");// 이벤트
	        closeSo.setEventStatusCds(closeStatusCd);
	        closeSo.setDelYn("N");
	        eventList = eventService.selectEventListPaging(closeSo);
    	}

    	mav.addObject("so", so);
    	mav.addObject("resultModel", result);
    	mav.addObject("eventList", eventList);
        mav.addObject("sessionMemberNo", memberNo);

        //모바일일경우
    	if(SiteUtil.isMobile()) {
	        EventLettSO lettSo = new EventLettSO();
	        lettSo.setSiteNo(so.getSiteNo());
	        lettSo.setEventNo(so.getEventNo());
	        lettSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<EventLettVO> eventLettList = frontEventService.selectEventLettListPaging(lettSo);

	        mav.addObject("eventLettList", eventLettList);
	        mav.addObject("lettSo", lettSo);
    	}
        return mav;
    }
}
