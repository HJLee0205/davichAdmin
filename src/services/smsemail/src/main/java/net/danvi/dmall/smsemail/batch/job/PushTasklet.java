package net.danvi.dmall.smsemail.batch.job;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.smsemail.service.PushService;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Value;

import net.danvi.dmall.smsemail.batch.service.EmailBatchService;
import net.danvi.dmall.smsemail.batch.service.SmsBatchService;
import net.danvi.dmall.smsemail.model.MemberManageSO;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.PushSendVO;
import net.danvi.dmall.smsemail.model.email.EmailSendHistVO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import net.danvi.dmall.smsemail.service.MemberService;
import net.sf.json.JSONObject;

/**
 * <pre>
 * 프로젝트명 : 11.business
 * 작성일     : 2016. 8. 30.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
public class PushTasklet implements Tasklet {
	
    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "sqlSessionTemplatePush")
    private SqlSessionTemplate sqlSessionTemplate;
    
    @Value("#{enc['push.firebase.key']}")
    private String firebaseKey;

    @Resource(name = "pushService")
    private PushService pushService;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
    	
    	List<MemberManageVO> rstList = null;
    	
    	PushSendPO po = new PushSendPO();
    	po.setPushStatus("03");   //예약대기
		List<PushSendVO> list = sqlSessionTemplate.selectList("push.selectPushList", po);
		
		/*PushSendVO rstVO = sqlSessionTemplate.selectOne("push.selectPushList", po);*/

		for (PushSendVO vo : list) {
			// 현재시간이  발송예정일보다 클경우 실행  
			if ("1".equals(vo.getExeYn())) {
				
		    	if ("all".equals(vo.getRecvCndtGb())) {
		            MemberManageSO so = new MemberManageSO();
		            // 회원 전체 조회
		            /*rstList = memberService.viewTotalPushList(so);*/
                    rstList = memberService.viewTotalPushListPaging(so,vo);
		            
		    	} else if ("search".equals(vo.getRecvCndtGb())) {
		        	PushSendVO rsltVO = this.selectPushCondition(vo);
		        	rstList = memberService.viewPushListCommonByMap(vo,rsltVO);
		            
		    	} else if ("select".equals(vo.getRecvCndtGb())) {
		    		rstList = sqlSessionTemplate.selectList("push.selectPushConditionByPushList", vo);
		    		pushService.sendPush(rstList, vo);
		    	}        	
		    	
		    	// push 발송
				/*this.sendPush(rstList, vo);*/
		    	
				// push 완료
		    	PushSendPO spo = new PushSendPO();
		    	spo.setPushNo(vo.getPushNo());
				spo.setPushStatus("01");  //발송완료
		    	this.sendFinish(spo);    	
			}
		}

        return null;
    }
    
    private PushSendVO selectPushCondition(PushSendVO vo) {
        return sqlSessionTemplate.selectOne("push.selectPushConditionList", vo);
    }
    
    
    private void sendFinish(PushSendPO po) {
        sqlSessionTemplate.update("push.updatePushStatus", po);
    }    
    
    private void sendPush(List<MemberManageVO> list, PushSendVO vo) throws Exception {
    	
		for(MemberManageVO listVO: list) {
			
			CloseableHttpClient client = HttpClientBuilder.create().build();
	        HttpPost post = new HttpPost("https://fcm.googleapis.com/fcm/send");
	        
	        post.setHeader("Content-type", "application/json");
	        post.setHeader("Authorization", "key=" + firebaseKey);
	        
	        String msg = "";
	        msg += vo.getSendMsg();
	        msg += "\n수신거부: 환경설정에서 변경가능";
	        
	        // 알림내용
            JSONObject notification = new JSONObject();
            notification.put("title", "다비치마켓");
            notification.put("body", msg);
            notification.put("sound", "default");
        	//notification.put("mutable-content", 1);
	        
            // 알림포함정보
            JSONObject data = new JSONObject();
            data.put("link", vo.getLink());
            data.put("imgUrl", vo.getImgUrl());
            data.put("push_no", vo.getPushNo());
	        
	        JSONObject message = new JSONObject();
            
	        if ("android".equals(listVO.getOsType())) {
	        	data.put("title", "다비치마켓");
	        	data.put("body", msg);
	        	
		        message.put("to", listVO.getAppToken());
	            message.put("data", data);
	        } else if ("ios".equals(listVO.getOsType())) {
		        message.put("to", listVO.getAppToken());
	            message.put("notification", notification);
	            message.put("data", data);
	            message.put("content_available", true);
	            message.put("mutable_content", true);
	            message.put("priority", "high");	            
	        } else {
		        message.put("to", listVO.getAppToken());
	            message.put("notification", notification);
	            message.put("data", data);
	        }
	        
            post.setEntity(new StringEntity(message.toString(), "UTF-8"));
            HttpResponse response = client.execute(post);			
			
            int rtCode = response.getStatusLine().getStatusCode();
            
            //결과저장
    	    if (rtCode == 200) {
    	    } else {
    	    }	        
		}

    }    
    
    
}
