package store.com.push.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.apache.http.impl.client.CloseableHttpClient;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import store.com.push.service.PushService;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
   "classpath:spring/context-datasource.xml"
  ,"classpath:spring/context-aspect.xml"
  ,"classpath:spring/context-security.xml"
  ,"classpath:spring/context-common.xml"
  ,"classpath:spring/context-egovuserdetailshelper.xml"
  ,"classpath:spring/context-mapper.xml"
  ,"classpath:spring/context-properties.xml"
  ,"classpath:spring/context-transaction.xml"
  ,"classpath:spring/context-validator.xml"

  })
public class DavichPushTask_test {

	private static final Logger logger = org.slf4j.LoggerFactory.getLogger(DavichPushTask.class);

	/** PushService */
	@Resource(name = "pushService")
	private PushService pushService;

	@Autowired
    private CloseableHttpClient httpClient;
	
	@Test
	public void davichPushSyncService() throws Exception {
		System.out.println("=========================");
		System.out.println("=======START ");
		System.out.println("=========================");

		List<EgovMap> send_list = new ArrayList<>(1000);

        int totalCnt = pushService.getPushRsvListTotalCount();
        int loopUnit =100;
        int loopCnt = totalCnt/loopUnit;
        int loopLimit =0;
        int loopOffset = loopUnit;
		if(totalCnt>0) {
			for (int i = 1; i <= loopCnt + 1; i++) {
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
				logger.info(System.currentTimeMillis() + " / " + i + " Push LOG ... Paging start.  ");
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
				EgovMap paramMap = new EgovMap();
				paramMap.put("limit", loopLimit);
				paramMap.put("offset", loopOffset);
				// 다비젼 푸시 예약자료 가져오기
				send_list = pushService.getPushRsvListPaging(paramMap);
				// 예약정보 (동기화)
				int result = pushService.registPushRsv(send_list);

				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
				logger.info(System.currentTimeMillis() + " / " + i + " Push LOG ... Paging end.  ");
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
			}
		}

		System.out.println("=========================");
		System.out.println("=======END");
		System.out.println("=========================");
	}
	
	@Test
	public void davichPushSendService() throws Exception {
		System.out.println("=========================");
		System.out.println("=======START");
		System.out.println("=========================");

		List<EgovMap> send_list = new ArrayList<>(1000);

        int totalCnt = pushService.getPushSendListPagingCount();
        int loopUnit =100;
        int loopCnt = totalCnt/loopUnit;
        int loopLimit =0;
        int loopOffset = loopUnit;
		if(totalCnt>0) {
			for (int i = 1; i <= loopCnt + 1; i++) {
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
				logger.info(System.currentTimeMillis() + " / " + i + " Push LOG ... Paging start.  ");
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

				EgovMap paramMap = new EgovMap();
				paramMap.put("limit", loopLimit);
				paramMap.put("offset", loopOffset);
				send_list = pushService.getPushSendListPaging(paramMap);
				/*int result = pushService.updateSendPush(send_list);*/
				int result = pushService.sendPush(send_list);
				loopLimit = loopOffset * (i);
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
				logger.info(System.currentTimeMillis() + " / " + i + " Push LOG ... Paging end.  ");
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
			}
		}
		System.out.println("=========================");
		System.out.println("=======END");
		System.out.println("=========================");
	}

}
