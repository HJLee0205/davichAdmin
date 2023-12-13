package net.danvi.dmall.biz.batch.member.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.mem.dto.MemberOffLevelResDTO;
import net.danvi.dmall.biz.ifapi.mem.service.MemberService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelSO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 17.
 * 작성자     : dong
 * 설명       : 회원 관련 배치 Service
 * </pre>
 */
@Service("memberBatchService")
@Slf4j
public class MemberBatchServiceImpl extends BaseService implements MemberBatchService {
    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "memberService")
    private MemberService memberService;

    @Resource(name = "logService")
    private LogService logService;

    public List<MemberManageVO> memDormantReader() {
        return proxyDao.selectList("batch.member.selectDormantMemTarget");
    }

    public List<MemberManageVO> memDormantAlamReader() {
        return proxyDao.selectList("batch.member.selectDormantMemTargetAlam");
    }

    public ResultModel<MemberManagePO> memDormantAlamWriter(MemberManageVO vo)
            throws AddressException, MessagingException, Exception {

        // sms 치환코드 set
        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

        // send 객체 set
        SmsSendSO smsSendSO = new SmsSendSO();
        smsSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        smsSendSO.setSendTypeCd("21");
        smsSendSO.setMemberNo(vo.getMemberNo());
        smsSendSO.setMemberTemplateCode("mk015");

        smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);

        ResultModel<MemberManagePO> result = new ResultModel<>();

        return result;
    }

    public ResultModel<MemberManagePO> memDormantWriter(MemberManageVO vo)
            throws AddressException, MessagingException, Exception {

        // sms 치환코드 set
        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
        smsReplaceVO.setUserId(vo.getLoginId());
        smsReplaceVO.setDormantDttm(vo.getDormantDttm());

        // send 객체 set
        SmsSendSO smsSendSO = new SmsSendSO();
        smsSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        smsSendSO.setSendTypeCd("22");
        smsSendSO.setMemberNo(vo.getMemberNo());
        smsSendSO.setMemberTemplateCode("mk016");

        smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);

        // 회원정보 휴면 테이블로 이동
        proxyDao.insert("batch.member.insertDormantMem", vo);
        proxyDao.update("batch.member.updateMem", vo);

        ResultModel<MemberManagePO> result = new ResultModel<>();

        return result;
    }

    public List<MemberManageVO> selectWithdrawalMemTargetBbs() {
        return proxyDao.selectList("batch.member.selectWithdrawalMemTargetBbs");
    }

    public void deleteMemberNoRelationBbsInfo(MemberManageVO vo) {
        proxyDao.delete("batch.member." + "deleteMemberNoRelationBbsInfo", vo);
    }

    public List<MemberManageVO> selectWithdrawalMemTargetOrd() {
        return proxyDao.selectList("batch.member.selectWithdrawalMemTargetOrd");
    }

    public void deleteMemberNoRelationOrdInfo(MemberManageVO vo) {
        proxyDao.delete("batch.member." + "deleteMemberNoRelationOrdInfo", vo);

    }

    public List<MemberLevelVO> selectMemGradeRearrangeList() {
        List<MemberLevelVO> rerrangeList = proxyDao.selectList("batch.member." + "selectMemGradeRearrangeList");
        return rerrangeList;
    }

    public List<MemberLevelVO> selectMemGradeList(MemberLevelSO so) {
        List<MemberLevelVO> memGradeList = proxyDao.selectList("batch.member." + "viewMemGradeList", so);
        return memGradeList;
    }

    public void updateMemGradeRearrange(MemberLevelPO po) {
        proxyDao.update("batch.member." + "updateMemGrade", po);
        proxyDao.update("batch.member." + "updateMemGradeRearrange", po);

    }

    public void updateMailSendResult(EmailSendPO po) {
        proxyDao.update("batch.member." + "updateMailSendResult", po);

    }
    
    
    public void interfaceMemberGrade() throws Exception {
    	
    	Map<String, Object> result = new HashMap<>();
    	
    	//result = InterfaceUtil.send("IF_MEM_007", null);
        ifUpdateErpMemLvlOnMall(null); // interface_block_temp
    	log.info("===============");
		log.info(result.toString());
    	log.info("===============");
    	
        /*if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }*/
    }
    
    
    public List<VisitVO> selectMemVisitRsvList() {
        List<VisitVO> visitList = proxyDao.selectList("batch.member." + "selectVisitRsv");
        return visitList;
    }
    
    
    /**
     * 설명       : 방문예약자 알림 보내기 구현
     */    
    public ResultModel<VisitVO> visitRsvAlamWriter(VisitVO vo)
            throws AddressException, MessagingException, Exception {

        ResultModel<VisitVO> result = new ResultModel<>();
        
        ///
        
    	

        return result;
    }

    public void ifUpdateErpMemLvlOnMall(Map<String, Object> param) throws Exception {

        String ifId = Constants.IFID.MEM_OFF_LVL;

        ObjectMapper objectMapper = new ObjectMapper();
        BaseReqDTO orderRegReqDTO = objectMapper.convertValue(param, BaseReqDTO.class);

        try {
            // 쇼핑몰 처리 부분
            /* 배치성능 저하이슈로인한 dblink 방식으로 변경*/
            //String resParam = sendUtil.send(null, ifId);
            // 응답 Json을 DTO형태로 변환
            //MemberOffLevelResDTO resDto = (MemberOffLevelResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), MemberOffLevelResDTO.class);
            //if(Constants.RESULT.SUCCESS.equals(resDto.getResult())) {
            // 조회 결과가 성공이면 테이블에 갱신
            //	memberService.updateErpMemberLvl(resDto.getOffLevelList());
            //}

            MemberOffLevelResDTO resDto = new MemberOffLevelResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            memberService.updateErpMemberLvl();

            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, orderRegReqDTO, resDto);

        } catch (CustomIfException ce) {
            ce.setReqParam(orderRegReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderRegReqDTO, ifId);
        }
    }
}
