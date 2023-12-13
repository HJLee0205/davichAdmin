package net.danvi.dmall.biz.batch.order.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;

@Service("batchOrderService")
@Slf4j
public class BatchOrderServiceImpl extends BaseService implements BatchOrderService {

    @Resource(name = "orderService")
    private OrderService orderService;

    // 입금누락 주문목록조회
    @Override
    public List<Map> OrdNoneDepositList(Map vo) {
        return proxyDao.selectList("batch.order.selectNoneDepositOrdList", vo);
    }

    // 자동SMS발송
    @Override
    public void sendOrdAutoSms(String templateCode,String sendTypeCd, String siteNo, String ordNo) {
        OrderGoodsVO vo = new OrderGoodsVO();
        vo.setSiteNo(Long.valueOf(siteNo));
        vo.setOrdNo(ordNo);
        try {
            orderService.sendOrdAutoSms(templateCode,sendTypeCd, vo, new HashMap<>());
        } catch (Exception e) {
            log.debug("자동SMS발송 오류", e);
        }
    }

    // 자동메일발송
    @Override
    public void sendOrdAutoEmail(String sendTypeCd, String siteNo, String ordNo) {
        OrderGoodsVO vo = new OrderGoodsVO();
        vo.setSiteNo(Long.valueOf(siteNo));
        vo.setOrdNo(ordNo);
        try {
            orderService.sendOrdAutoEmail(sendTypeCd, vo);
        } catch (Exception e) {
            log.debug("자동메일발송 오류", e);
        }
    }

}
