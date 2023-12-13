package net.danvi.dmall.front.web.view.push.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.PushSendSO;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;
import net.danvi.dmall.biz.app.operation.service.AppStorePushService;
import net.danvi.dmall.biz.system.remote.push.PushDelegateService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.PushSendPO;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 파일명        : PushController.java
 * - 작성일        : 2018. 9. 6.
 * - 작성자        : dong
 * - 설명          : Push Controller
 * </pre>
 * @param <E>
 */
@Slf4j
@Controller
@RequestMapping("/front/push")
public class PushController<E> {
    
    @Resource(name = "pushDelegateService")
    private PushDelegateService pushDelegateService;
    
    @Resource(name = "appStorePushService")
    private AppStorePushService appStorePushService;

    
    /**
     * <pre>
     * 작성일 : 2018. 8. 16.
     * 작성자 : khy
     * 설명   : BEACON - PUSH 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 16. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/beacon-push")
    public @ResponseBody ResultModel<PushSendVO> appPush(PushSendPO po) throws Exception {
    	
    	ResultModel<PushSendVO> result = new ResultModel<>();
    	po.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
    	po.setReceiverNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
    	po.setReceiverId(String.valueOf(SessionDetailHelper.getDetails().getSession().getLoginId()));
    	
        Map<String, Object> param = new HashMap<>();
    	param.put("beaconId", po.getBeaconId());
    	
    	if (po.getMemberNo() != null && !"".equals(po.getMemberNo())) {
    	
	        Map<String, Object> res = InterfaceUtil.send("IF_BCN_001", param);
	    	
	        if ("1".equals(res.get("result"))) {
	        	
	        	po.setSendMsg(String.valueOf(res.get("memo")));
	        	po.setLink(String.valueOf(res.get("linkUrl")));
	        	po.setImgUrl(String.valueOf(res.get("imgUrl")));
	        	
	        	//푸시서버 연계
	        	pushDelegateService.beaconSend(po);
	        	
	        }else{
	        	throw new Exception(String.valueOf(res.get("message")));
	        }        
    	}
    	
        return result;
    }
        
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 16.
     * 작성자 : khy
     * 설명   : push 확인시 이력저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 16. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/push-check")
    public @ResponseBody RemoteBaseResult pushConfirm(PushSendPO po) throws Exception {
    	
    	
        if (SessionDetailHelper.getDetails().isLogin()) {
	    	po.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
	    	po.setReceiverNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
	    	po.setReceiverId(String.valueOf(SessionDetailHelper.getDetails().getSession().getLoginId()));
        }
    	
    	//푸시서버 연계
    	RemoteBaseResult result = pushDelegateService.pushConfirm(po);
    	
        return result;
    }
        
    
    
    
    /**
     * <pre>
     * 작성일 : 2018. 12. 22.
     * 작성자 : khy
     * 설명   : 가맹점 push 확인시 이력저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 12. 22. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/store-push-check")
    public @ResponseBody RemoteBaseResult storePushConfirm(PushSendPO po) throws Exception {
    	
        RemoteBaseResult result = new RemoteBaseResult();
    	result.setSuccess(true);

    	if (SessionDetailHelper.getDetails().isLogin()) {
	    	po.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
	    	po.setReceiverNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
	    	po.setReceiverId(String.valueOf(SessionDetailHelper.getDetails().getSession().getLoginId()));
        }
    	PushSendVO vo = appStorePushService.selectPushCheck(po);
    	result.setLink(vo.getLink());
    	
        return result;
    }    
    
}