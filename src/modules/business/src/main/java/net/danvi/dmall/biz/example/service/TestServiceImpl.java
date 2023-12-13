package net.danvi.dmall.biz.example.service;

import java.util.HashMap;
import java.util.Map;

import net.danvi.dmall.biz.example.model.CmnCdGrpVO;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.example.model.CmnCdGrpPO;
import dmall.framework.common.BaseService;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * Created by dong on 2016-04-21.
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class TestServiceImpl extends BaseService implements TestService {

    // @Resource(name = "dmallXaProxyDao")
    // private XaProxyDao dmallXaProxyDao;
    //
    // @Resource(name = "cjXaProxyDao")
    // private XaProxyDao cjXaProxyDao;

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public ResultModel<CmnCdGrpPO> insertCmnCdGrp(CmnCdGrpPO po) throws CustomException {
        ResultModel<CmnCdGrpPO> result = new ResultModel<>();
        try {
            proxyDao.insert("biz.app.example.insertCmnCdGrp", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
            po.setGrpDscrt("test");
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public ResultModel<CmnCdGrpPO> updateCmnCdGrp(CmnCdGrpPO po) throws CustomException {
        ResultModel<CmnCdGrpPO> result = new ResultModel<>();
        proxyDao.update("biz.app.example.updateCmnCdGrp", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        if (true) {
            // throw new CustomException("biz.exception.common.nodata");
        }
        return result;
    }

    @Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
    public ResultModel<CmnCdGrpVO> selectCmnCdGrp(CmnCdGrpVO vo) {
        vo = proxyDao.selectOne("biz.app.example.selectCmnCdGrp", vo);
        ResultModel<CmnCdGrpVO> result = new ResultModel<>(vo);
        if (vo == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodate"));
        }

        return result;
    }

    public void xaInit() {
        // dmallXaProxyDao.delete("biz.app.example.deleteAll");
        // cjXaProxyDao.delete("biz.app.example.deleteAll");
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaInsertTest() {
        // dmallXaProxyDao.insert("biz.app.example.insert", 1);
        // cjXaProxyDao.insert("biz.app.example.insert", 1);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaInsertErrorTest() {
        // dmallXaProxyDao.insert("biz.app.example.insert", 2);
        // cjXaProxyDao.insert("biz.app.example.insert", 2);
        // throw new RuntimeException("xaInsertErrorTest");
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaUpdateTest() {
        Map m = new HashMap<>();
        m.put("n", 2);
        m.put("test", 1);
        // dmallXaProxyDao.update("biz.app.example.update", m);
        // cjXaProxyDao.update("biz.app.example.update", m);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaUpdateErrorTest() {
        Map m = new HashMap<>();
        m.put("n", 3);
        m.put("test", 2);
        // dmallXaProxyDao.update("biz.app.example.update", m);
        // cjXaProxyDao.update("biz.app.example.update", m);
        // throw new RuntimeException("xaUpdateErrorTest");
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaDeleteTest() {
        // dmallXaProxyDao.delete("biz.app.example.delete", 2);
        // cjXaProxyDao.delete("biz.app.example.delete", 2);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaDeleteErrorTest() {
        // dmallXaProxyDao.delete("biz.app.example.delete", 1);
        // cjXaProxyDao.delete("biz.app.example.delete", 1);
        throw new RuntimeException("xaDeleteErrorTest");
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaInsertTest1() {
        // proxyDao.insert(proxyDao.getXA1(), "biz.app.example.insert", 1);
        // proxyDao.insert(proxyDao.getXA2(), "biz.app.example.insert", 1);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaInsertTest2() {
        // proxyDao.insert(proxyDao.getXA1(), "biz.app.example.insert", 3);
        // proxyDao.insert(proxyDao.getXA2(), "biz.app.example.insert", 3);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaInsertErrorTest1() {
        // proxyDao.insert(proxyDao.getXA1(), "biz.app.example.insert", 2);
        // proxyDao.insert(proxyDao.getXA2(), "biz.app.example.insert", 2);
        throw new RuntimeException("xaInsertErrorTest");
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaUpdateTest1() {
        Map m = new HashMap<>();
        m.put("n", 2);
        m.put("test", 1);
        // proxyDao.update(proxyDao.getXA1(), "biz.app.example.update", m);
        // proxyDao.update(proxyDao.getXA2(), "biz.app.example.update", m);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaUpdateErrorTest1() {
        Map m = new HashMap<>();
        m.put("n", 3);
        m.put("test", 2);
        // proxyDao.update(proxyDao.getXA1(), "biz.app.example.update", m);
        // proxyDao.update(proxyDao.getXA2(), "biz.app.example.update", m);
        throw new RuntimeException("xaUpdateErrorTest");
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaDeleteTest1() {
        // proxyDao.delete(proxyDao.getXA1(), "biz.app.example.delete", 2);
        // proxyDao.delete(proxyDao.getXA2(), "biz.app.example.delete", 2);
    }

    @Transactional(transactionManager = "JtaTransactionManager")
    public void xaDeleteErrorTest2() {
        // proxyDao.delete(proxyDao.getXA1(), "biz.app.example.delete", 3);
        // proxyDao.delete(proxyDao.getXA2(), "biz.app.example.delete", 3);
        // throw new RuntimeException("xaDeleteErrorTest");
    }
}
