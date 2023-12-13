package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.PushSendVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.smsemail.dao.ProxyDao;
import net.danvi.dmall.smsemail.model.email.CustomerInfoPO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import net.danvi.dmall.smsemail.service.PushService;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by khy on 2018-08-30.
 */
@Service("pushService")
public class PushServiceImpl implements PushService {
    Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ProxyDao proxyDao;

    @Value("#{enc['push.firebase.key']}")
    private String firebaseKey;

	/*@Autowired
    private CloseableHttpClient httpClient;*/

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CustomerInfoPO send(PushSendPO emailSendPO) throws CloneNotSupportedException {

        CustomerInfoPO customerInfoPO = null;
        return customerInfoPO;
    }

    @Async
    public void sendPush(List<MemberManageVO> list, PushSendVO vo) throws Exception {
		log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        log.info(System.currentTimeMillis() + " Push LOG ... Send start. ");
        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

        CloseableHttpClient httpClient = HttpClients.createDefault();


    	HttpPost post = new HttpPost("https://fcm.googleapis.com/fcm/send");
	    post.setHeader("Content-Type", "application/json");
	    post.setHeader("Authorization", "key=" + firebaseKey);
		JSONObject message = new JSONObject();
		JSONObject iosMessage = new JSONObject();
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

		JSONArray regIds = new JSONArray();
		JSONArray iosRegIds = new JSONArray();
		CloseableHttpResponse response = null;
		int rowcount = 0;
    	int batchCount =0;
    	int rtCode =200;

		for(MemberManageVO listVO: list) {
            if ("android".equals(listVO.getOsType())) {
                data.put("title", "다비치마켓");
                data.put("body", msg);
                /*message.put("to", listVO.getAppToken());*/
                message.put("data", data);
              if (listVO.getAppToken()!= null ){
                    regIds.add(listVO.getAppToken());
               }
               //test
               /*if (listVO.getAppToken()!= null && listVO.getAppToken().equals("c_uEj53AZog:APA91bFp713VTUgkg7N5nVEztFqXxJ-h3GuV8UBTEj3DScI4MFi7st7yoHExsfvMZNJ-qto_JlW95ABFiCOlE9H8lAtSJaRXJpTmwC7yExT0RAKXWD__EGVovQ7w-cQq9bKVvdZBBEcz")){
                regIds.add(listVO.getAppToken());
                }*/
            } else if ("ios".equals(listVO.getOsType())) {
                /*message.put("to", listVO.getAppToken());*/
                iosMessage.put("notification", notification);
                iosMessage.put("data", data);
                iosMessage.put("content_available", true);
                iosMessage.put("mutable_content", true);
                iosMessage.put("priority", "high");
               if (listVO.getAppToken()!= null ){
                    iosRegIds.add(listVO.getAppToken());
               }
                //test
               /*if (listVO.getAppToken()!= null && listVO.getAppToken().equals("ehb7ucWcoaU:APA91bHl8TNqbgvEkl11gluR16sH9m6LwdL_T2JH6g9g2QrMZcTF474z44sBkMcHwekGWY9dUFh3BQ8mIu5ldfbH-8niN4V4vwRCjVNZwhTW4CWFu-8hmQMzYAIZJXulFNvZktBeuOex")){
                iosRegIds.add(listVO.getAppToken());
                }*/
            } else {
                /*message.put("to", listVO.getAppToken());*/
                message.put("data", data);
                iosMessage.put("notification", notification);
                iosMessage.put("data", data);

            }

	        rowcount++;
	        if(rowcount % 100 ==0){
	        	try {
	        	    if(regIds.size()>0) {
	        	        message.put("registration_ids", regIds);
                        post.setEntity(new StringEntity(message.toString(), "UTF-8"));
                        response = httpClient.execute(post);
                        rtCode = response.getStatusLine().getStatusCode();
                        //결과저장
                        if (rtCode == 200) {
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            log.info(" Push LOG ... Android Send Success...... ");
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        } else {
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            log.info(" Push LOG ... Android Send Fail...... ");
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        }
                    }
                    if(iosRegIds.size()>0) {
                        iosMessage.put("registration_ids", iosRegIds);
                        post.setEntity(new StringEntity(iosMessage.toString(), "UTF-8"));
                        response = httpClient.execute(post);
                        rtCode = response.getStatusLine().getStatusCode();
                        //결과저장
                        if (rtCode == 200) {
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            log.info(" Push LOG ... Ios Send Success...... ");
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        } else {
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            log.info(" Push LOG ... Ios Send Fail...... ");
                            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        }
                    }
 				}catch (Exception e){
					e.printStackTrace();
				} finally {
				    if(response !=null) {
                        response.close();
                    }
                    if(httpClient!=null){
                        httpClient.close();
                    }
				}
				regIds = new JSONArray();
				iosRegIds = new JSONArray();
			 	batchCount++;
	        }
		}

		// 저장하지 않은 데이터 건수가 남아있다면 남은거 처리
		if ((batchCount * 100) < list.size()) {
			try{
			    if(regIds.size()>0) {
			        message.put("registration_ids", regIds);
                    post.setEntity(new StringEntity(message.toString(), "UTF-8"));
                    response = httpClient.execute(post);

                    rtCode = response.getStatusLine().getStatusCode();
                    //결과저장
                    if (rtCode == 200) {
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        log.info(" Push LOG ... Android Send Success...... ");
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    } else {
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        log.info(" Push LOG ... Android Send Fail...... ");
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    }
                }

                if(iosRegIds.size()>0) {
                    iosMessage.put("registration_ids", iosRegIds);
                    post.setEntity(new StringEntity(iosMessage.toString(), "UTF-8"));
                    response = httpClient.execute(post);
                    rtCode = response.getStatusLine().getStatusCode();
                    //결과저장
                    if (rtCode == 200) {
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        log.info(" Push LOG ... Ios Send Success...... ");
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    } else {
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        log.info(" Push LOG ... Ios Send Fail...... ");
                        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    }
                }

			}catch (Exception e){
				e.printStackTrace();
			} finally {
			    if(response !=null) {
                    response.close();
                }
                if(httpClient!=null){
                    httpClient.close();
                }
			}
		}
        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        log.info(System.currentTimeMillis() + " Push LOG ... Send end. ");
        log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
     }
}
