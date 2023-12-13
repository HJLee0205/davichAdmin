package net.danvi.dmall.biz.app.goods.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.goods.model.RestockNotifyPO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyPOListWrapper;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyVO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendPO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.RestockNotifySO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.TextReplacerUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("restockNotifyService")
@Transactional(rollbackFor = Exception.class)
public class RestockNotifyServiceImpl extends BaseService implements RestockNotifyService {

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    // 재입고 알림 상품 목록 조회
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<RestockNotifyVO> selectRestockNotifyListPaging(RestockNotifySO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.RESTOCK_NOTIFY + "selectRestockNotifyListPaging", so);
    }

    // 재입고 알림 상품 상세 조회
    @Override
    @Transactional(readOnly = true)
    public ResultModel<RestockNotifyVO> selectRestockNotify(RestockNotifyVO vo) {
        // 재입고 알림 상품 정보 조회
        RestockNotifyVO restockInfo = proxyDao.selectOne(MapperConstants.RESTOCK_NOTIFY + "selectRestockNotify", vo);
        // 재입고 알림 상품 대표이미지 조회
        List<String> imgList = proxyDao.selectList(MapperConstants.RESTOCK_NOTIFY + "selectRestockGoodsImgList", vo);
        restockInfo.setImgList(imgList);
        // 재입고 알림 요청 회원 조회
        List<RestockNotifyVO> restockMemberList = proxyDao.selectList(MapperConstants.RESTOCK_NOTIFY + "selectRestockMemberList", vo);
        restockInfo.setRestockMemberList(restockMemberList);
        // 재입고 알림 발송 내역 조회
        List<RestockNotifyVO> notifySendLog = proxyDao.selectList(MapperConstants.RESTOCK_NOTIFY + "selectNotifySendLog", vo);
        restockInfo.setNotifySendLog(notifySendLog);

        ResultModel<RestockNotifyVO> result = new ResultModel<>(restockInfo);

        return result;
    }

    /** 재입고 알림 등록여부조회 **/
    @Override
    public RestockNotifyVO selectDuplicateAlarm(RestockNotifyVO vo) {
        RestockNotifyVO restockNotifyVO = new RestockNotifyVO();
        restockNotifyVO = proxyDao.selectOne(MapperConstants.RESTOCK_NOTIFY + "selectDuplicateAlarm", vo);
        return restockNotifyVO;
    }

    /** 재입고 알림 등록 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see RestockNotifyService#
     * insertRestockNotify(net.danvi.dmall.biz.app.goods.model.
     * RestockNotifyPO)
     */
    @Override
    public ResultModel<RestockNotifyPO> insertRestockNotify(RestockNotifyPO po) throws Exception {
        ResultModel<RestockNotifyPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.RESTOCK_NOTIFY + "insertRestockNotify", po);
        return result;
    }

    /** 재입고 알림 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see RestockNotifyService#
     * updateRestockNotify(net.danvi.dmall.biz.app.goods.model.
     * RestockNotifyPO)
     */
    @Override
    public ResultModel<RestockNotifyPO> updateRestockNotify(RestockNotifyPO po) throws Exception {
        ResultModel<RestockNotifyPO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.RESTOCK_NOTIFY + "updateRestockNotify", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    // 재입고 알림 관리자 메모 수정
    @Override
    public ResultModel<RestockNotifyPO> updateRestockNotifyMemo(RestockNotifyPO po) throws Exception {
        ResultModel<RestockNotifyPO> result = new ResultModel<>();

        proxyDao.update(MapperConstants.RESTOCK_NOTIFY + "updateRestockNotifyMemo", po);

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /** 재입고 알림 삭제 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see RestockNotifyService#
     * deleteRestockNotify(net.danvi.dmall.biz.app.goods.model.
     * RestockNotifyPO)
     */
    @Override
    public ResultModel<RestockNotifyPOListWrapper> deleteRestockNotify(RestockNotifyPOListWrapper po) throws Exception {
        ResultModel<RestockNotifyPOListWrapper> result = new ResultModel<>();
        List<RestockNotifyPO> restockNotifyList = po.getList();
        for (RestockNotifyPO restockNotifyPO : restockNotifyList) {
            proxyDao.delete(MapperConstants.RESTOCK_NOTIFY + "deleteRestockNotify", restockNotifyPO);
            proxyDao.delete(MapperConstants.RESTOCK_NOTIFY + "deleteRestockNotifyMemo", restockNotifyPO);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    public ResultModel<RestockNotifyPOListWrapper> sendRestockSms(RestockNotifyPOListWrapper po) throws Exception {
        ResultModel<RestockNotifyPOListWrapper> result = new ResultModel<>();

        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(po.getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
        List<RestockNotifyPO> restockNotifyList = po.getList();

        if (restockNotifyList != null && restockNotifyList.size() > 0) {
            List<SmsSendPO> listpo = new ArrayList<SmsSendPO>();

            for (RestockNotifyPO restockNotifyPO : restockNotifyList) {
                ReplaceCdVO replaceCdVO = new ReplaceCdVO();
                replaceCdVO.setSiteNm(siteInfo.getData().getSiteNm());
                replaceCdVO.setMemberNm(restockNotifyPO.getReceiverNm());
                replaceCdVO.setGoodsNm(restockNotifyPO.getGoodsNm());

                SmsSendPO sendPo = new SmsSendPO();
                sendPo.setSiteNo(po.getSiteNo());
                sendPo.setRecvTelNo(restockNotifyPO.getRecvTelNo().replaceAll("[^0-9]", ""));
                sendPo.setReceiverNo(String.valueOf(restockNotifyPO.getReceiverNo()));
                sendPo.setReceiverNm(restockNotifyPO.getReceiverNm());
                sendPo.setSendTelno(siteInfo.getData().getCertifySendNo() == null ? "00000000000"
                        : siteInfo.getData().getCertifySendNo());
                sendPo.setSendWords(TextReplacerUtil.replace(replaceCdVO, restockNotifyPO.getSendWords()));
                sendPo.setSendTargetCd("01");
                sendPo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                sendPo.setAutoSendYn(CommonConstants.YN_Y);
                sendPo.setSendFrmCd("01");

                /*
                 * smsSendService.sendSms(sendPo);
                 *
                 * restockNotifyPO.setAlarmStatusCd("2"); // 송신
                 * updateRestockNotify(restockNotifyPO);
                 */

                listpo.add(sendPo);
            }
            // SMS발송 서비스 호출
            smsSendService.sendSms(listpo);

            // 발송 서비스 호출 후 송신으로 상태 변경
            for (RestockNotifyPO restockNotifyPO : restockNotifyList) {
                restockNotifyPO.setAlarmStatusCd("2"); // 송신
                restockNotifyPO.setUpdrNo(po.getUpdrNo());
                updateRestockNotify(restockNotifyPO);
            }

            // 발송 내역 저장
            RestockNotifyPO restockNotifyPO = new RestockNotifyPO();
            restockNotifyPO.setGoodsNo(restockNotifyList.get(0).getGoodsNo());
            restockNotifyPO.setSendCnt(restockNotifyList.size());
            restockNotifyPO.setRegrNo(SessionDetailHelper.getSession().getMemberNo());
            proxyDao.insert(MapperConstants.RESTOCK_NOTIFY + "insertRestockNotifySendLog", restockNotifyPO);
        }
        result.setMessage(MessageUtil.getMessage("biz.exception.gds.send.restock"));
        return result;
    }

    @Override
    public ResultModel<RestockNotifyPOListWrapper> sendCheckedRestock(RestockNotifyPOListWrapper po) throws Exception {
        ResultModel<RestockNotifyPOListWrapper> result = new ResultModel<>();

        // 선택된 상품
        List<RestockNotifyPO> list = po.getList();
        // 하나씩 접근
        for(RestockNotifyPO item : list) {
            // 상품번호로 상품 정보 조회
            RestockNotifyVO restockInfo = proxyDao.selectOne(MapperConstants.RESTOCK_NOTIFY + "selectRestockNotify", item);
            // 재입고 알림 요청 회원 목록 조회
            List<RestockNotifyVO> restockMemberList = proxyDao.selectList(MapperConstants.RESTOCK_NOTIFY + "selectRestockMemberList", item);
            // 회원 한명씩 접근
            List<RestockNotifyPO> sendList = new ArrayList<>();
            for(RestockNotifyVO member : restockMemberList) {
                RestockNotifyPO restockNotifyPO = new RestockNotifyPO();

                restockNotifyPO.setGoodsNo(item.getGoodsNo());
                restockNotifyPO.setMemberNo(member.getMemberNo());
                restockNotifyPO.setGoodsNm(restockInfo.getGoodsNm());
                restockNotifyPO.setRecvTelNo(member.getMobile());
                restockNotifyPO.setReceiverNo(member.getMemberNo().toString());
                restockNotifyPO.setReceiverNm(member.getMemberNm());
                restockNotifyPO.setSendWords("상점명 : #[siteNm]\n회원명 : #[memberNm]\n상품명 : #[goodsNm]");

                sendList.add(restockNotifyPO);
            }
            RestockNotifyPOListWrapper sendWrapper = new RestockNotifyPOListWrapper();
            sendWrapper.setSiteNo(po.getSiteNo());
            sendWrapper.setUpdrNo(po.getUpdrNo());
            sendWrapper.setList(sendList);

            sendRestockSms(sendWrapper);
        }

        result.setMessage(MessageUtil.getMessage("biz.exception.gds.send.restock"));
        return result;
    }

    @Override
    public ResultListModel<RestockNotifyVO> selectRestockNotifySendListPaging(RestockNotifySO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("ALARM_DTTM");
            so.setSord("DESC");
        }

        return proxyDao.selectListPage(MapperConstants.RESTOCK_NOTIFY + "selectRestockNotifySendListPaging", so);
    }
}
