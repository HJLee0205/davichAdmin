package net.danvi.dmall.biz.batch.sttcs.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import net.danvi.dmall.biz.batch.sttcs.SttcsConstant;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.batch.sttcs.model.ProcRunnerVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.model.ResultModel;

@Service("sttcsService")
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class SttcsServiceImpl extends BaseService implements SttcsService {

    // 1.방문자분석 집계
    @Override
    public void registVstrAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.insert("batch.sttcs." + "insertVstrAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_VSTR_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 2.방문경로분석 집계
    @Override
    public void registVisitPathAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.update("batch.sttcs." + "insertVisitPathAnls", vo);
            proxyDao.update("batch.sttcs." + "updateVisitPathAnls", vo);

            //방문예약 페이지 접근 경로 분석 집계
            proxyDao.update("batch.sttcs." + "insertVisitRsvPathAnls", vo);
            proxyDao.update("batch.sttcs." + "updateVisitRsvPathAnls", vo);

            //방문접수 분석 집계
            proxyDao.update("batch.sttcs." + "insertVisitRsvComPathAnls", vo);
            proxyDao.update("batch.sttcs." + "updateVisitRsvComPathAnls", vo);

            
        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_VISIT_PATH_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 3.방문자IP분석 집계
    @Override
    public void registVstrIpAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.update("batch.sttcs." + "insertVstrIpAnls", vo);
            proxyDao.update("batch.sttcs." + "updateVstrIpAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_VSTR_IP_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 4.신규회원분석 집계
    @Override
    public void registNwMemberAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.insert("batch.sttcs." + "insertNwMemberAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_NW_MEMBER_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 5.회원마켓포인트분석 집계
    @Override
    public void registMemberSvmnAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.update("batch.sttcs." + "insertMemberSvmnAnls", vo);
            proxyDao.update("batch.sttcs." + "updateMemberSvmnAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_MEMBER_SVMN_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 6.카테고리상품분석 집계
    @Override
    public void registCtgGoodsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.update("batch.sttcs." + "insertCtgGoodsAnls", vo);
            proxyDao.update("batch.sttcs." + "updateCtgGoodsAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_CTG_GOODS_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 7.판매순위 상품분석 집계
    @Override
    public void registSaleRankGoodsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.update("batch.sttcs." + "insertSaleRankGoodsAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_SALE_RANK_GOODS_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 8.장바구니 상품분석 집계
    @Override
    public void registBasketGoodsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.update("batch.sttcs." + "insertBasketGoodsAnls", vo);
            proxyDao.update("batch.sttcs." + "updateBasketGoodsAnls", vo);
            proxyDao.update("batch.sttcs." + "deleteBasketGoodsAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_BASKET_GOODS_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 9.주문통계분석 집계
    @Override
    public void registOrdSttcsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.insert("batch.sttcs." + "insertOrdSttcsAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_ORD_STTCS_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 10.매출통계분석 집계
    @Override
    public void registSalesSttcsAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.insert("batch.sttcs." + "insertSalesSttcsAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_SALES_STTCS_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }

    // 11.로그인현황분석 집계
    @Override
    public void registLoginCurStatusAnls(ProcRunnerVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        ResultModel<String> result = new ResultModel<>();

        try {
            proxyDao.insert("batch.sttcs." + "insertLoginCurrentStatusAnls", vo);

        } catch (Exception e) {
            log.error(e.toString());
            log.debug("■ {} ERROR. Exception : {}", SttcsConstant.BT_PGM_NM_LOGIN_CURSTATUS_ANLS, e.toString());
            // result.setSuccess(false);
            // throw new CustomException("biz.exception.common.error");
        }
    }
}
