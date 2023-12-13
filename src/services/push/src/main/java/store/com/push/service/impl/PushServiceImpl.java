package store.com.push.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.slf4j.Logger;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import store.com.push.service.PushService;

import javax.annotation.Resource;
import java.util.List;

/**
 * 다비젼의 푸시 예약 자료를 푸쉬서버를 가져온다.
 * @author 김현열
 * @since 2018.12.19
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2018.12.19  김현열          최초 생성
 *  </pre>
 */
@Service("pushService")
public class PushServiceImpl extends EgovAbstractServiceImpl implements PushService {

	private static final Logger logger = org.slf4j.LoggerFactory.getLogger(PushServiceImpl.class);

    @Resource(name="pushDAO")
    private PushDAO pushDAO;

    /*@Autowired
    private CloseableHttpClient httpClient;*/
    
	/* 다비젼 푸시 예약정보 조회 */
	public List<EgovMap> getPushRsvList() throws Exception {
		return pushDAO.getPushRsvList();
	}

	/* 푸시 예약정보 조회 */
	public int  getPushRsvListTotalCount() throws Exception {
		return pushDAO.getPushRsvListTotalCount();
	}

	/* 푸시 예약정보 페이징 조회 */
	public List<EgovMap> getPushRsvListPaging(EgovMap paramMap) throws Exception {
		return pushDAO.getPushRsvListPaging(paramMap);
	}

	/* 푸시 전송 결과 update */
	public int registPushRsv(List<EgovMap> send_list) throws Exception {
		return pushDAO.registPushRsv(send_list);
	}

	/* 푸시 예약정보 입력 */
	public void insertPushRsv(EgovMap map) throws Exception {
		pushDAO.insertPushRsv(map);
	}
	
	/* 푸시 예약정보 update */
	public void updatePushRsv(EgovMap map) throws Exception {
		pushDAO.updatePushRsv(map);
	}
		
	
	/* 다비젼 푸시 예약정보 동기화 결과 update */
	public void updatePushRsvByDv(EgovMap map) throws Exception {
		pushDAO.updatePushRsvByDv(map);
	}
	
	/* 푸시 발송예약정보 조회 */
	public List<EgovMap> getPushSendRsvList() throws Exception {
		return pushDAO.getPushRsvList();
	}
	
	/* 푸시 예약정보 중복여부 조회 */
	public int selectExsistData(EgovMap map) throws Exception {
		return pushDAO.selectExsistData(map);
	}
	 
	/* 푸시 발송대상정보 조회 */
	public List<EgovMap> getPushSendList() throws Exception {
		return pushDAO.getPushSendList();
	}

	/* 푸시 발송대상정보 조회 */
	public int  getPushSendListPagingCount() throws Exception {
		return pushDAO.getPushSendListPagingCount();
	}

	/* 푸시 발송대상정보 페이징 조회 */
	public List<EgovMap> getPushSendListPaging(EgovMap paramMap) throws Exception {
		return pushDAO.getPushSendListPaging(paramMap);
	}
	
	/* 쇼핑몰 회원정보 조회 */
    public EgovMap selectMemberInfo(EgovMap map) throws Exception {
    	return pushDAO.selectMemberInfo(map);
    }

	/* 푸시 추가정보 update */
	public void updatePushRsvAdd(EgovMap map) throws Exception {
		pushDAO.updatePushRsvAdd(map);
	}

	/* 다비젼 푸시 전송 결과 update */
	public void updateSendPushRsltByDv(EgovMap map) throws Exception {
		pushDAO.updateSendPushRsltByDv(map);
	}
	
	/* 푸시 전송 결과 update */
	public void updateSendPushRslt(EgovMap map) throws Exception {
		pushDAO.updateSendPushRslt(map);
	}

	/* 푸시 전송 결과 update */
	@Async
	public int updateSendPush(List<EgovMap> send_list) throws Exception {
		return pushDAO.updateSendPush(send_list);
	}

	 @Async
    public int sendPush(EgovMap map) throws Exception {

		logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        logger.info(System.currentTimeMillis() + " Push LOG ... Send start. ");
        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

			CloseableHttpClient httpClient = HttpClients.createDefault();

	        HttpPost post = new HttpPost("https://fcm.googleapis.com/fcm/send");

	        post.setHeader("Content-type", "application/json");
	        post.setHeader("Authorization", "key=" + "AAAAPGJylvg:APA91bHScGbRNQxOr1rm5NqGttQ4TlYTBH4bKGgSIdafd5aTsfaSTj8ud6Lb9MWcr0Wd-vN7zNF0zuJM8ipop0zs2btTu8V-PUTY4sJHiKNTKeUZGUpxPeYarXeifxizVpu1gu0LvTMu");

	        String msg = "";
	        msg += getMapValue(map, "sendMsg");
	        msg += "\n수신거부: 환경설정에서 변경가능";

	        // 알림내용
            JSONObject notification = new JSONObject();
            notification.put("title", "다비치마켓");
            notification.put("body", msg);
            notification.put("sound", "default");

            // 알림포함정보
            JSONObject data = new JSONObject();
            data.put("link", getMapValue(map, "link"));
            data.put("imgUrl", getMapValue(map, "imgUrl"));
            data.put("push_no", "S" + getMapValue(map, "rsvNo"));

	        JSONArray regIds = new JSONArray();

	        JSONObject message = new JSONObject();

	        if ("android".equals(getMapValue(map, "osType"))) {
	        	data.put("title", "다비치마켓");
	        	data.put("body", msg);
		        message.put("to", map.get("appToken").toString());
	            message.put("data", data);
	        } else if ("ios".equals(getMapValue(map, "osType"))) {
		        message.put("to", map.get("appToken").toString());
	            message.put("notification", notification);
	            message.put("data", data);
	            message.put("content_available", true);
	            message.put("mutable_content", true);
	            message.put("priority", "high");
	        } else {
		        message.put("to", map.get("appToken").toString());
	            message.put("notification", notification);
	            message.put("data", data);
	        }

	       if (map.get("appToken")!= null ){
                regIds.add(map.get("appToken").toString());
           }

	        if (map.get("appToken")!= null && map.get("appToken").toString().equals("cnzr2JBMT4A:APA91bHylPVzfV5Z3D4L_7yaV9-DotXPFCL1piIGt6l-13pf3RlJYLRIrvNJtY_xP_BYueHGg0bQqw8IbsfIwhks9l0yaHYaij9LlGfSoEOWqk4hEAiZpRWJlXmydTr8n0ysMFCnYf6D")){
                regIds.add(map.get("appToken").toString());
            }

			message.put("registration_ids", regIds);

            post.setEntity(new StringEntity(message.toString(), "UTF-8"));
            HttpResponse response = httpClient.execute(post);

            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
			logger.info(System.currentTimeMillis() + " Push LOG ... Send end. ");
			logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

            return response.getStatusLine().getStatusCode();
    }

    @Async
    public int sendPush(List<EgovMap> send_list) throws Exception {

		logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        logger.info(System.currentTimeMillis() + " Push LOG ... Send start. ");
        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

		CloseableHttpClient httpClient = HttpClients.createDefault();

		HttpPost post = new HttpPost("https://fcm.googleapis.com/fcm/send");

		post.setHeader("Content-type", "application/json");
		post.setHeader("Authorization", "key=" + "AAAAPGJylvg:APA91bHScGbRNQxOr1rm5NqGttQ4TlYTBH4bKGgSIdafd5aTsfaSTj8ud6Lb9MWcr0Wd-vN7zNF0zuJM8ipop0zs2btTu8V-PUTY4sJHiKNTKeUZGUpxPeYarXeifxizVpu1gu0LvTMu");

		JSONObject message = new JSONObject();
		JSONObject iosMessage = new JSONObject();

		JSONArray regIds = new JSONArray();
		JSONArray iosRegIds = new JSONArray();
		CloseableHttpResponse response = null;
		int rowcount = 0;
    	int batchCount =0;
    	int rtCode =200;

		for(EgovMap map: send_list) {

			//push 수신동의여부 확인
			String appToken = getMapValue(map, "appToken");
			String alarmGb = getMapValue(map, "alarmGb");
			String notiGb = getMapValue(map, "notiGb");
			String eventGb = getMapValue(map, "eventGb");
			String newsGb = getMapValue(map, "eventGb");

			EgovMap rst_map = new EgovMap();
			rst_map.put("rsvNo", getMapValue(map, "rsvNo"));
			rst_map.put("seqNo", getMapValue(map, "seqNo"));
			rst_map.put("sempNo", getMapValue(map, "sempNo"));

			String msg = "";
			msg += getMapValue(map, "sendMsg");
			msg += "\n수신거부: 환경설정에서 변경가능";

			// 알림내용
			JSONObject notification = new JSONObject();
			notification.put("title", "다비치마켓");
			notification.put("body", msg);
			notification.put("sound", "default");

			// 알림포함정보
			JSONObject data = new JSONObject();
			data.put("link", getMapValue(map, "link"));
			data.put("imgUrl", getMapValue(map, "imgUrl"));
			data.put("push_no", "S" + getMapValue(map, "rsvNo"));


            if ("android".equals(getMapValue(map, "osType"))) {
                data.put("title", "다비치마켓");
                data.put("body", msg);
                /*message.put("to", listVO.getAppToken());*/
                message.put("data", data);
              if (map.get("appToken")!= null ){
					// 수신동의시
					if (("01".equals(alarmGb) && "1".equals(notiGb)) ||
						("02".equals(alarmGb) && "1".equals(eventGb)) ||
						("03".equals(alarmGb) && "1".equals(newsGb))) {

                   		regIds.add(map.get("appToken").toString());
                   		 //test
						   /*if (appToken!= null && appToken.equals("ebEI87-cRbaooQImjSUVfX:APA91bFQHbfxgm_JCHGCo9RQhYuirNl0t7ZQv0hRMZIK61oCiqezbpXrKyrvdWuzzWCB_m2NMQA5Ug8E6zn2tZrlbLk0jb61ZgRnnwP6K00-kh1Z2w0GsawGBqEssxAf1ODN6Uqk06zm")){
							regIds.add(map.get("appToken").toString());
							}*/

                    	rst_map.put("sendYn", "Y");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "전송 성공");
					} else {
						rst_map.put("sendYn", "F");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "수신 미동의");
					}
					updateSendPushRslt(rst_map);
               }else{
               		rst_map.put("sendYn", "F");
					rst_map.put("pushStatus", "01");
					rst_map.put("sendRst", "전송 실패");
					updateSendPushRslt(rst_map);
               }


            } else if ("ios".equals(getMapValue(map, "osType"))) {
                /*message.put("to", listVO.getAppToken());*/
                iosMessage.put("notification", notification);
                iosMessage.put("data", data);
                iosMessage.put("content_available", true);
                iosMessage.put("mutable_content", true);
                iosMessage.put("priority", "high");
               if (map.get("appToken")!= null ){
               		// 수신동의시
					if (("01".equals(alarmGb) && "1".equals(notiGb)) ||
						("02".equals(alarmGb) && "1".equals(eventGb)) ||
						("03".equals(alarmGb) && "1".equals(newsGb))) {

						iosRegIds.add(map.get("appToken").toString());
						 //test
             /*  if (appToken!= null && appToken.equals("ebEI87-cRbaooQImjSUVfX:APA91bFQHbfxgm_JCHGCo9RQhYuirNl0t7ZQv0hRMZIK61oCiqezbpXrKyrvdWuzzWCB_m2NMQA5Ug8E6zn2tZrlbLk0jb61ZgRnnwP6K00-kh1Z2w0GsawGBqEssxAf1ODN6Uqk06zm")){
                iosRegIds.add(map.get("appToken").toString());
                }*/

						rst_map.put("sendYn", "Y");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "전송 성공");
					} else {
						rst_map.put("sendYn", "F");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "수신 미동의");
					}
               }else{
               		rst_map.put("sendYn", "F");
					rst_map.put("pushStatus", "01");
					rst_map.put("sendRst", "전송 실패");

               }
               updateSendPushRslt(rst_map);

            } else {
                /*message.put("to", listVO.getAppToken());*/
                message.put("data", data);
                iosMessage.put("notification", notification);
                iosMessage.put("data", data);

                rst_map.put("sendYn", "F");
				rst_map.put("pushStatus", "01");
				rst_map.put("sendRst", "전송 실패");
				updateSendPushRslt(rst_map);
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
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            logger.info(" Push LOG ... Android Send Success...... ");
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        } else {
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            logger.info(" Push LOG ... Android Send Fail...... ");
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        }
                    }
                    if(iosRegIds.size()>0) {
                        iosMessage.put("registration_ids", iosRegIds);
                        post.setEntity(new StringEntity(iosMessage.toString(), "UTF-8"));
                        response = httpClient.execute(post);
                        rtCode = response.getStatusLine().getStatusCode();
                        //결과저장
                        if (rtCode == 200) {
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            logger.info(" Push LOG ... Ios Send Success...... ");
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        } else {
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                            logger.info(" Push LOG ... Ios Send Fail...... ");
                            logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
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
		if ((batchCount * 100) < send_list.size()) {
			try{
			    if(regIds.size()>0) {
			        message.put("registration_ids", regIds);
                    post.setEntity(new StringEntity(message.toString(), "UTF-8"));
                    response = httpClient.execute(post);

                    rtCode = response.getStatusLine().getStatusCode();
                    //결과저장
                    if (rtCode == 200) {
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        logger.info(" Push LOG ... Android Send Success...... ");
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    } else {
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        logger.info(" Push LOG ... Android Send Fail...... ");
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    }
                }

                if(iosRegIds.size()>0) {
                    iosMessage.put("registration_ids", iosRegIds);
                    post.setEntity(new StringEntity(iosMessage.toString(), "UTF-8"));
                    response = httpClient.execute(post);
                    rtCode = response.getStatusLine().getStatusCode();
                    //결과저장
                    if (rtCode == 200) {
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        logger.info(" Push LOG ... Ios Send Success...... ");
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                    } else {
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
                        logger.info(" Push LOG ... Ios Send Fail...... ");
                        logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
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

		logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
		logger.info(System.currentTimeMillis() + " Push LOG ... Send end. ");
		logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

		return rtCode;
    }

	private String getMapValue(EgovMap m, String key){
		  Object value = m.get(key);
		  return value == null ? "" : value.toString();
	}
}
