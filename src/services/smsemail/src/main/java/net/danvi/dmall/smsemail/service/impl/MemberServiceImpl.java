package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.smsemail.dao.ProxyDao;
import net.danvi.dmall.smsemail.model.MemberManageSO;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.PushSendVO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.smsemail.model.request.SmsSendSO;
import net.danvi.dmall.smsemail.service.MemberService;
import net.danvi.dmall.smsemail.service.PushService;
import net.danvi.dmall.smsemail.service.SmsService;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by khy on 2018-08-30.
 */
@Service("memberService")
public class MemberServiceImpl implements MemberService {
    Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ProxyDao proxyDao;

    @Resource(name = "sqlSessionTemplatePush")
    private SqlSessionTemplate sqlSessionTemplate;

    @Resource(name = "pushService")
    private PushService pushService;

    @Autowired
    private SmsService smsService;


    /**
     * 푸시 전체 대상자 조회
     */
    @Override
    @Transactional(readOnly = true)
    public List<MemberManageVO> viewTotalPushList(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo("1");
        memberManageSO.setMemberStatusCd("01");
        List<MemberManageVO> list = proxyDao.selectList("push.selectTotalPushList",memberManageSO);
        return list;
    }

    /**
     * 푸시 전체 대상자 조회
     */
    @Override
    @Transactional(readOnly = true)
    /*@Async*/
    public List<MemberManageVO> viewTotalPushListPaging(MemberManageSO memberManageSO, PushSendVO rstVO)  throws Exception{
        List<MemberManageVO> list = new ArrayList<>(10000);
        memberManageSO.setSiteNo("1");
        memberManageSO.setMemberStatusCd("01");

        int totalCnt = this.selectTotalPushListPagingCount(memberManageSO);
        int loopUnit =100;
        int loopCnt = totalCnt/loopUnit;
        int loopLimit =0;
        int loopOffset = loopUnit;


        for(int i=1;i<=loopCnt+1;i++){
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() +" / "+ i +" Push LOG ...Paging start.  ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            memberManageSO.setLimit(loopLimit);
            memberManageSO.setOffset(loopOffset);
            list = proxyDao.selectListNolog("push.selectTotalPushListPaging",memberManageSO);
            pushService.sendPush(list, rstVO);
			loopLimit = loopOffset*(i);
			log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() +" / "+ i + " Push LOG ...Paging end.  ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        }

        /**
         * 푸시발송 상태 완료
         */
        PushSendPO po = new PushSendPO();
        po.setPushStatus("01");  //발송완료
        po.setPushNo(rstVO.getPushNo());
        po.setUpdrNo(rstVO.getSenderNo());
        this.sendFinish(po);

        return list;
    }

    /**
     * SMS 전체 대상자 조회
     */
    @Override
    @Transactional(readOnly = true)
    @Async
    public List<MemberManageVO> viewTotalSmsListPaging(SmsSendSO smsSendSO, SmsSendPO po)  throws Exception{
        List<MemberManageVO> list = new ArrayList<>(10000);

        net.danvi.dmall.smsemail.model.sms.SmsSendSO so = new net.danvi.dmall.smsemail.model.sms.SmsSendSO();
        MemberManageSO memberManageSO = new MemberManageSO();

        if(smsSendSO.getMemberManageSO()!=null) {
            BeanUtils.copyProperties(smsSendSO.getMemberManageSO(), memberManageSO);
        }

        // SMS 수신여부 허용
        memberManageSO.setSmsRecvYn("Y");

        int totalCnt = this.selectTotalSmsListPagingCount(memberManageSO);
        int loopUnit =1000;
        int loopCnt = totalCnt/loopUnit;
        int loopLimit =0;
        int loopOffset = loopUnit;



        for(int i=1;i<=loopCnt+1;i++){
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() +" / "+ i +" Sms LOG ... Paging start.  ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            memberManageSO.setLimit(loopLimit);
            memberManageSO.setOffset(loopOffset);

            list = proxyDao.selectListNolog("sms.selectTotalSmsListPaging",memberManageSO);

            smsService.send("" + memberManageSO.getSiteNo(), list,po);
			loopLimit = loopOffset*(i);
			log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() +" / "+ i + " Sms LOG ... Paging end.  ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        }


        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public int selectTotalPushListPagingCount(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo("1");
        memberManageSO.setMemberStatusCd("01");
        int totalCnt = proxyDao.selectOne("push.selectTotalPushListPagingCount",memberManageSO);
        return totalCnt;
    }

    @Override
    @Transactional(readOnly = true)
    public int selectTotalSmsListPagingCount(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo("1");

        // 회원상태코드 set(일반:01, 휴면:02, 탈퇴:03)
        memberManageSO.setMemberStatusCd("01");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("tel").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("memberNo").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
        }

        if (memberManageSO.getSidx().length() == 0) {
            memberManageSO.setSidx("REG_DTTM");
            memberManageSO.setSord("ASC");
        }

        int totalCnt = proxyDao.selectOne("sms.selectTotalSmsListPagingCount",memberManageSO);
        return totalCnt;
    }

    @Override
    @Transactional(readOnly = true)
    public int selectMemListByPushCount(Map<String, Object> map) {
        int totalCnt = proxyDao.selectOne("push.selectMemListByPushCount",map);
        return totalCnt;
    }


	@Override
	@Transactional(readOnly = true)
//	@Async
	public List<MemberManageVO> viewPushListCommonByMap(PushSendVO rstVO,PushSendVO rsltVO) throws Exception{
	    Map<String, Object> map = new HashMap<>();
	    map.put("siteNo",1);
        String s = rsltVO.getSrchCndt();
        String[] pairs = s.split(",");
        for (int i=0;i<pairs.length;i++) {
            String pair = pairs[i];
            String[] keyValue = pair.split("=");

            if (keyValue.length > 1 ) {
                if ("null".equals(keyValue[1])) {
                    map.put(keyValue[0].trim(), null);
                } else {
                    if(keyValue[1].equals("[]")){
                        map.put(keyValue[0].trim(), null);
                    }else {
                        map.put(keyValue[0].trim(), keyValue[1]);
                    }
                }
            }else{
                map.put(keyValue[0].trim(), null);
            }
        }

	    List<MemberManageVO> list = new ArrayList<>(10000);

        int totalCnt = this.selectMemListByPushCount(map);
        int loopUnit =100;
        int loopCnt = totalCnt/loopUnit;
        int loopLimit =0;
        int loopOffset = loopUnit;

        for(int i=1;i<=loopCnt+1;i++){
            map.put("limit",loopLimit);
            map.put("offset",loopOffset);

            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() +" / "+ i +" Push LOG ...Paging start.  ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            list = proxyDao.selectListNolog("push.selectMemListByPush", map);
            pushService.sendPush(list, rstVO);
			loopLimit = loopOffset*(i);
			log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() +" / "+ i + " Push LOG ...Paging end.  ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
        }

         /**
         * 푸시발송 상태 완료
         */
        PushSendPO po = new PushSendPO();
        po.setPushStatus("01");  //발송완료
        po.setPushNo(rstVO.getPushNo());
        po.setUpdrNo(rstVO.getSenderNo());
        this.sendFinish(po);

        return list;
	}

	@Override
	@Transactional(readOnly = true)
	public MemberManageVO selectMemberToken(PushSendPO po) {
	    return proxyDao.selectOne("push.selectMemberInfo", po);
	}

	private void sendFinish(PushSendPO po) {
        sqlSessionTemplate.update("push.updatePushStatus", po);
    }

}
