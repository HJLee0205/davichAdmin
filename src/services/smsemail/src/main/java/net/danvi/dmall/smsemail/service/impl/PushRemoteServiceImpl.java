package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.MemberManageSO;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.PushSendVO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import net.danvi.dmall.smsemail.service.MemberService;
import net.danvi.dmall.smsemail.service.PushRemoteService;
import net.danvi.dmall.smsemail.service.PushService;
import net.sf.json.JSONObject;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * <pre>
 * 프로젝트명 : 앱 push 
 * 작성일     : 2018. 8. 31.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */

@Service("pushRemoteService")
public class PushRemoteServiceImpl implements PushRemoteService {
    Logger log = LoggerFactory.getLogger(this.getClass());
    
    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "sqlSessionTemplatePush")
    private SqlSessionTemplate sqlSessionTemplate;
    
    @Value("#{enc['push.firebase.key']}")
    private String firebaseKey;

	@Autowired
    private CloseableHttpClient httpClient;

    @Resource(name = "pushService")
    private PushService pushService;
    

    @Override
    public RemoteBaseResult send(PushSendPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        PushSendVO rstVO = sqlSessionTemplate.selectOne("push.selectPushList", po);

        try {
        	log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        	log.info("전송시작");
        	log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        	
        	List<MemberManageVO> rstList = null;
        	
        	if ("all".equals(po.getRecvCndtGb())) {
                MemberManageSO so = new MemberManageSO();
                rstList = memberService.viewTotalPushListPaging(so,rstVO);
        	} else if ("search".equals(po.getRecvCndtGb())) {
	        	PushSendVO rsltVO = this.selectPushCondition(po);
	        	rstList = memberService.viewPushListCommonByMap(rstVO,rsltVO);
        	} else if ("select".equals(po.getRecvCndtGb())) {
        		rstList = sqlSessionTemplate.selectList("push.selectPushConditionByPushList", po);
                pushService.sendPush(rstList, rstVO);
                /**
                     * 푸시발송 상태 완료
                */
                po.setPushStatus("01");  //발송완료
                this.sendFinish(po);
        	}        	
    		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
    		log.info("전송완료");
    		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        	

        	
        } catch (Exception e) {
            result.setSuccess(false);
            return result;
            //result.setMessage("대량 메일 전송 에러");
        }

        return result;
    }

    @Override
    public RemoteBaseResult isConnect(PushSendPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        try {
            result.setSuccess(true);
        } catch (Exception e) {
            result.setSuccess(false);
        }

        return result;
    }    
    
    private PushSendVO selectPushCondition(PushSendPO po) {
        return sqlSessionTemplate.selectOne("push.selectPushConditionList", po);
    }
    
    private void sendFinish(PushSendPO po) {
        sqlSessionTemplate.update("push.updatePushStatus", po);
    }

    @Override
    public RemoteBaseResult beaconSend(PushSendPO pushSendPO) throws Exception {
    	
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);
    	
        try {
        	
        	String token = "";
        	String osType = "";
        
        	if (pushSendPO.getToken() != null) {
            	token = pushSendPO.getToken();
        		osType = pushSendPO.getOsType();
        	} else {
        		MemberManageVO vo = memberService.selectMemberToken(pushSendPO);
        		token = vo.getAppToken();
        		osType = vo.getOsType();
        	}
        	
        	//push_no 채번
            Long push_no = sqlSessionTemplate.selectOne("push.selectPushNoByBeacon");
    	
			CloseableHttpClient client = HttpClientBuilder.create().build();
	        HttpPost post = new HttpPost("https://fcm.googleapis.com/fcm/send");
	        
	        post.setHeader("Content-type", "application/json");
	        post.setHeader("Authorization", "key=" + firebaseKey);
	        
	        // 알림내용
            JSONObject notification = new JSONObject();
            notification.put("title", "다비치마켓");
            notification.put("body", pushSendPO.getSendMsg());
            notification.put("sound", "default");
            // 알림포함정보
            JSONObject data = new JSONObject();
            data.put("link", pushSendPO.getLink());
            data.put("imgUrl", pushSendPO.getImgUrl());
            data.put("push_no", "B" + String.valueOf(push_no));

	        JSONObject message = new JSONObject();
	        
	        if ("android".equals(osType)) {
	        	data.put("title", "다비치마켓");
	        	data.put("body", pushSendPO.getSendMsg());
	        	
		        message.put("to", token);
	            message.put("data", data);
	        } else if ("ios".equals(osType)) {
		        message.put("to", token);
	            message.put("notification", notification);
	            message.put("data", data);
	            message.put("content_available", true);
	            message.put("mutable_content", true);
	            message.put("priority", "high");	            
	        } else {
		        message.put("to", token);
	            message.put("notification", notification);
	            message.put("data", data);
	        }
	        
            post.setEntity(new StringEntity(message.toString(), "UTF-8"));
            HttpResponse response = httpClient.execute(post);
			
            int rtCode = response.getStatusLine().getStatusCode();
            
            //결과저장
    	    if (rtCode == 200) {
    	    } else {
    	    }

            //푸시확인 이력
    	    pushSendPO.setPushNo(String.valueOf(push_no));
            sqlSessionTemplate.insert("push.insertPushBeaconHist", pushSendPO);
    	    
    	    
        } catch (Exception e) {
            result.setSuccess(false);
            //result.setMessage("대량 메일 전송 에러");
        }

        return result;

    }
    

    @Override
    public RemoteBaseResult pushConfirm(PushSendPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
        	
    		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
    		log.info("푸시이력 insert");
    		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
    		
    		PushSendVO vo = null;
    		String pushNo = String.valueOf(po.getPushNo()); 
    		
    		if (pushNo.startsWith("B")) {
        		vo = sqlSessionTemplate.selectOne("push.selectPushBeaconHist", po);
    		} else {
        		vo = sqlSessionTemplate.selectOne("push.selectPushList", po);
                //푸시확인 이력
                sqlSessionTemplate.insert("push.insertPushConfirm", po);
    		}

            result.setLink(vo.getLink());
        	
        } catch (Exception e) {
            result.setSuccess(false);
        }

        return result;
    }
        
    
}
