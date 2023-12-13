package net.danvi.dmall.biz.app.operation.service;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.operation.model.PushSendPO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.dao.ProxyPushDao;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.PushSendSO;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoPO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.remote.push.PushDelegateService;
import net.danvi.dmall.biz.system.remote.smseml.SmsDelegateService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 14.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class AppPushServiceImpl extends BaseService implements AppPushService {
    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "smsDelegateService")
    private SmsDelegateService smsDelegateService;
    
    @Resource(name = "proxyPushDao")
    private ProxyPushDao proxyPushDao;
    
    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;
    
    
    @Value("#{system['system.upload.path']}")
    private String uplaodFilePath;

    @Value("#{system['system.domain']}")
    private String domain;
    
    @Override
    public ResultListModel<PushSendVO> selectPushHstPaging(PushSendSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        
        ResultListModel<PushSendVO> resultListModel = proxyPushDao.selectListPage(MapperConstants.PUSH + "selectPushListPaging", so);
        List<PushSendVO> list = resultListModel.getResultList();
        if (list != null && list.size() > 0) {
        	for (PushSendVO vo : list) {
                PushSendVO po = new PushSendVO();
                po.setSendDttm(vo.getSendDttm());

        		int ordCnt = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectPushPeriodOrdCnt", po);
        		vo.setOrdCnt(ordCnt);
        		int visitCnt = proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectPushPeriodVisitCnt", po);
        		vo.setVisitCnt(visitCnt);
        	}
        }
        
        return resultListModel;
    }
    
    @Override
    public ResultModel<PushSendVO> insertPush(PushSendVO vo, HttpServletRequest request) throws Exception {
        ResultModel<PushSendVO> result = new ResultModel<>();
        
        // 이미지 URL
        if (vo.getFileNm() != null) {
            String imgUrl = "https://"+domain;
            String path = vo.getFilePath().replace(File.separator, "");
            vo.setImgUrl(imgUrl + "/image/image-view?type=PUSH&id1=" + path + "_" + vo.getFileNm());
            //vo.setImgUrl("https://www.davichmarket.com/image/image-view?type=PUSH&id1=20190923_1569205982675.jpg");
        }

        if(vo.getLink()!=null && !vo.getLink().equals("")){
            //vo.setLink(URLEncoder.encode(vo.getLink(), "UTF-8"));

            vo.setLink(StringUtil.replaceAll(vo.getLink(), "&amp;", "&"));
        }

    	//push관리
    	proxyPushDao.insert(MapperConstants.PUSH + "insertPushManager", vo);
    	
    	//push조건
    	if ("all".equals(vo.getRecvCndtGb())) {
            proxyDao.insert(MapperConstants.PUSH + "insertPushConditionAll", vo);
        } else if ("search".equals(vo.getRecvCndtGb())) {
            Map<String, Object> map = new HashMap<>();
	        map.put("siteNo",1);
	        map.put("pushNo",vo.getPushNo());
            String s = vo.getSrchCndt();
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
            proxyDao.insert(MapperConstants.PUSH + "insertPushConditionSearch", map);
        	//proxyPushDao.insert(MapperConstants.PUSH + "insertPushCondition", vo);
    	} else if ("select".equals(vo.getRecvCndtGb())) {
        	for (PushSendVO po : vo.getList()) {
                PushSendPO receiver = new PushSendPO();
                receiver.setPushNo(vo.getPushNo());
                receiver.setReceiverNo(po.getReceiverNo());
                receiver.setReceiverId(po.getReceiverId());
                receiver.setReceiverNm(po.getReceiverNm());
                receiver.setAppToken(po.getAppToken());
                receiver.setOsType(po.getOsType());

        		if (receiver.getReceiverNo() != null && !"".equals(receiver.getReceiverNo())) {
                	proxyPushDao.insert(MapperConstants.PUSH + "insertPushCondition", receiver);
        		}
        	}
    	}

    	result.setData(vo);
        return result;    
    }   
    
    
    @Override
    public String selectPushNo() {
        return proxyPushDao.selectOne(MapperConstants.PUSH + "selectPushNo");
    }    
    
    
    @Override
    public ResultModel<PushSendVO> updatePushManager(PushSendVO vo) throws Exception {
        ResultModel<PushSendVO> result = new ResultModel<>();
    	//push관리
    	proxyPushDao.update(MapperConstants.PUSH + "updatePushManager", vo);
        
        return result;    
    }    
    
    
    @Override
    public ResultModel<PushSendVO> updatePushCancel(PushSendVO vo) throws Exception {
        ResultModel<PushSendVO> result = new ResultModel<>();
    	//push관리
    	proxyPushDao.update(MapperConstants.PUSH + "updatePushCancel", vo);
        
        return result;    
    }        
    
    
    @Override
    public List<PushSendPO> selectPushCondition(PushSendVO vo) {
        return proxyPushDao.selectList(MapperConstants.PUSH + "selectPushConditionList", vo);
    }
    
    @Override
    public PushSendVO selectPushManagerInfo(PushSendSO so) {
        PushSendVO vo = proxyPushDao.selectOne(MapperConstants.PUSH + "selectPushList", so);

        PushSendVO po = new PushSendVO();
        po.setSendDttm(vo.getSendDttm());

        int ordCnt = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectPushPeriodOrdCnt", po);
        vo.setOrdCnt(ordCnt);
        int visitCnt = proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectPushPeriodVisitCnt", po);
        vo.setVisitCnt(visitCnt);
        return vo;
    }
    
    
    @Override
    public void deletePush(PushSendVO vo) throws Exception {
    	proxyPushDao.delete(MapperConstants.PUSH + "deletePushManager", vo);
       	proxyPushDao.delete(MapperConstants.PUSH + "deletePushCondition", vo);
    }     
    
}
