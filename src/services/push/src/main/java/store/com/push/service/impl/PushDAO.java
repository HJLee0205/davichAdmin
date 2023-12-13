package store.com.push.service.impl;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import store.com.cmm.service.impl.EgovComAbstractDAO;
import store.com.push.service.PushService;

import javax.annotation.Resource;
import java.util.List;

/**
 * 다비전 푸시 예약자료 동기화를 처리하는 DAO 클래스
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
 *  2018.12.18  김현열          최초 생성
 *  </pre>
 */
@Repository("pushDAO")
public class PushDAO extends EgovComAbstractDAO {
	
    @Resource(name = "sqlSessionTemplateMarket")
    private SqlSessionTemplate sqlSession_market;
    
    @Resource(name = "sqlSessionTemplateDavich")
    private SqlSessionTemplate sqlSession_davich;
    
    @Resource(name = "sqlSessionTemplate")
    private SqlSessionTemplate sqlSession;

    /** PushService */
	@Resource(name = "pushService")
	private PushService pushService;

	/* 다비젼 푸시 예약정보 조회 */
    public List<EgovMap> getPushRsvList() throws Exception {
    	return  sqlSession_davich.selectList("davich.selectPushRsvList");
    }

    /* 푸시 예약정보 총 건수 조회 */
    public int getPushRsvListTotalCount() throws Exception {
    	return  sqlSession_davich.selectOne("davich.selectPushRsvListTotalCount");
    }

    /* 푸시 예약정보 페이징 조회 */
    public List<EgovMap> getPushRsvListPaging(EgovMap map) throws Exception {
    	return  sqlSession_davich.selectList("davich.selectPushRsvListPaging",map);
    }

    /* 푸시 예약정보 update (동기화)*/
    public int registPushRsv(List<EgovMap> send_list) throws Exception {
        int result = 0;
        for(EgovMap map : send_list) {
            result += sqlSession.update("push.registPushRsv", map);
            result += sqlSession_davich.update("davich.updatePushRsv", map);
        }
        return result;
    }


	/* 푸시 예약정보 입력 */
    public void insertPushRsv(EgovMap map) throws Exception {
    	sqlSession.insert("push.insertPushRsv", map);
    }
    
	/* 푸시 예약정보 update (동기화)*/
    public void updatePushRsv(EgovMap map) throws Exception {
    	sqlSession.update("push.updatePushRsv", map);
    }
    
	/* 푸시 예약정보 존재여부 */
    public int selectExsistData(EgovMap map) throws Exception {
    	return sqlSession.selectOne("push.selectExsistData", map);
    }
    
	/* 다비젼 푸시 예약정보 동기화 결과 update */
    public void updatePushRsvByDv(EgovMap map) throws Exception {
    	sqlSession_davich.update("davich.updatePushRsv", map);
    }
    
	/* 푸시 발송예약정보 조회 */
    public List<EgovMap> getPushSendRsvList() throws Exception {
    	return  sqlSession.selectList("push.selectPushdbRsv");
    }
    
	/* 푸시 발송대상정보 조회 */
    public List<EgovMap> getPushSendList() throws Exception {
    	return  sqlSession.selectList("push.selectPushdbRsv");
    }

    /* 푸시 발송대상정보 페이징 조회 */
    public List<EgovMap> getPushSendListPaging(EgovMap map) throws Exception {
    	return  sqlSession.selectList("push.selectPushdbRsvPaging",map);
    }

    /* 푸시 발송대상정보 총 건수 조회 */
    public int getPushSendListPagingCount() throws Exception {
    	return  sqlSession.selectOne("push.selectPushdbRsvPagingCount");
    }
    
	/* 쇼핑몰 회원정보 조회 */
    public EgovMap selectMemberInfo(EgovMap map) throws Exception {
    	return sqlSession_market.selectOne("market.selectMemberInfo", map);
    }
    
	/* 푸시 예약정보 추가 정보 update */
    public void updatePushRsvAdd(EgovMap map) throws Exception {
    	sqlSession.update("push.updatePushRsvAdd", map);
    }

	/* 다비젼 푸시 전송 결과 update */
    public void updateSendPushRsltByDv(EgovMap map) throws Exception {
    	sqlSession_davich.update("davich.updateSendPushRslt", map);
    }
    
	/* 푸시 전송 결과 update */
    public void updateSendPushRslt(EgovMap map) throws Exception {
    	sqlSession.update("push.updateSendPushRslt", map);
    }

    /* 푸시 전송 결과 update */
    /*public int updateSendPush(List<EgovMap> send_list) throws Exception {
        int result = 0;
         for(EgovMap map : send_list) {

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

			// 앱 토큰이 없을경우
			if ("".equals(appToken)) {
				rst_map.put("sendYn", "F");
				rst_map.put("pushStatus", "01");
				rst_map.put("sendRst", "앱 미설치");
			} else {
				// 수신동의시
				if (("01".equals(alarmGb) && "1".equals(notiGb)) ||
					("02".equals(alarmGb) && "1".equals(eventGb)) ||
					("03".equals(alarmGb) && "1".equals(newsGb))) {

					// push 전송
					int rst = pushService.sendPush(map);
					if (rst == 200) {
						rst_map.put("sendYn", "Y");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "전송 성공");
					} else {
						rst_map.put("sendYn", "F");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "전송 실패");
					}
				} else {
					rst_map.put("sendYn", "F");
					rst_map.put("pushStatus", "01");
					rst_map.put("sendRst", "수신 미동의");
				}
			}

		   result += sqlSession.update("push.updateSendPushRslt", rst_map);
           result += sqlSession_davich.update("davich.updateSendPushRslt", rst_map);
		}

    	return result;
    }*/

    public int updateSendPush(List<EgovMap> send_list) throws Exception {
        int result = 0;
         for(EgovMap map : send_list) {

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

			// 앱 토큰이 없을경우
			if ("".equals(appToken)) {
				rst_map.put("sendYn", "F");
				rst_map.put("pushStatus", "01");
				rst_map.put("sendRst", "앱 미설치");
			} else {
				// 수신동의시
				if (("01".equals(alarmGb) && "1".equals(notiGb)) ||
					("02".equals(alarmGb) && "1".equals(eventGb)) ||
					("03".equals(alarmGb) && "1".equals(newsGb))) {

					// push 전송
					int rst = pushService.sendPush(map);
					if (rst == 200) {
						rst_map.put("sendYn", "Y");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "전송 성공");
					} else {
						rst_map.put("sendYn", "F");
						rst_map.put("pushStatus", "01");
						rst_map.put("sendRst", "전송 실패");
					}
				} else {
					rst_map.put("sendYn", "F");
					rst_map.put("pushStatus", "01");
					rst_map.put("sendRst", "수신 미동의");
				}
			}

		   result += sqlSession.update("push.updateSendPushRslt", rst_map);
           /*result += sqlSession_davich.update("davich.updateSendPushRslt", rst_map);*/
		}

    	return result;
    }

    private String getMapValue(EgovMap m, String key){
		  Object value = m.get(key);
		  return value == null ? "" : value.toString();
	}
    
}
