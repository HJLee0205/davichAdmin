package store.com.push.web;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import store.com.push.service.PushService;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

public class DavichPushTask {
	
    private static final Logger logger = org.slf4j.LoggerFactory.getLogger(DavichPushTask.class);
	
	
	/** PushService */
	@Resource(name = "pushService")
	private PushService pushService;
	
	public void davichPushSyncService() throws Exception {
		logger.debug("=======SYNC START========== ");

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

		logger.debug("=======SYNC END==========");
	}
	
	
	public void davichPushSendService() throws Exception {
		
		logger.debug("=======PUSH SEND START==========");

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
				//int result = pushService.updateSendPush(send_list);
				int result = pushService.sendPush(send_list);
				loopLimit = loopOffset * (i);
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
				logger.info(System.currentTimeMillis() + " / " + i + " Push LOG ... Paging end.  ");
				logger.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
			}
		}

		logger.debug("=======PUSH SEND END==========");
	}	

}
