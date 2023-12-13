package net.danvi.dmall.biz.example.service;

import net.danvi.dmall.biz.example.model.CmnCdDtlPO;
import net.danvi.dmall.biz.example.model.CmnCdGrpVO;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.example.model.CmnCdDtlSO;
import net.danvi.dmall.biz.example.model.CmnCdDtlVO;
import net.danvi.dmall.biz.example.model.CmnCdGrpPO;
import net.danvi.dmall.biz.example.model.CmnCdGrpPOListWrapper;
import net.danvi.dmall.biz.example.model.CmnCdGrpSO;
import dmall.framework.common.BaseService;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * Created by dong on 2016-04-11.
 */
@Service("cmnCdService")
@Transactional(rollbackFor = Exception.class)
public class CmnCdServiceImpl extends BaseService implements CmnCdService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<CmnCdGrpVO> selectCmnCdGrpPaging(CmnCdGrpSO cmnCdGrpSO) {

        // 정렬조건이 없으면 기본으로...
        if (cmnCdGrpSO.getSidx().length() == 0) {
            cmnCdGrpSO.setSidx("REG_DTTM");
            cmnCdGrpSO.setSord("DESC");
        }

        return proxyDao.selectListPage("biz.app.example.selectCmnCdGrpPaging", cmnCdGrpSO);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<CmnCdGrpVO> selectCmnCdGrp(CmnCdGrpVO vo) {
        vo = proxyDao.selectOne("biz.app.example.selectCmnCdGrp", vo);
        ResultModel<CmnCdGrpVO> result = new ResultModel<>(vo);
        if (vo == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodate"));
        }

        return result;
    }

    @Override
    public ResultModel<CmnCdGrpPO> insertCmnCdGrp(CmnCdGrpPO po) throws CustomException {
        ResultModel<CmnCdGrpPO> result = new ResultModel<>();
        try {
            proxyDao.insert("biz.app.example.insertCmnCdGrp", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<CmnCdGrpPO> updateCmnCdGrp(CmnCdGrpPO po) throws CustomException {
        ResultModel<CmnCdGrpPO> result = new ResultModel<>();
        proxyDao.update("biz.app.example.updateCmnCdGrp", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    @Override
    public ResultModel<CmnCdGrpPO> deleteCmnCdGrp(CmnCdGrpPOListWrapper wrapper) {
        ResultModel<CmnCdGrpPO> result = new ResultModel<>();
        wrapper.setDelrNo(0L);
        proxyDao.delete("biz.app.example.deleteCmnCdGrp", wrapper);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<CmnCdDtlVO> selectCmnCdDtlPaging(CmnCdDtlSO so) {
        return proxyDao.selectListPage("biz.app.example.selectCmnCdDtlPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<CmnCdDtlVO> selectCmnCdDtl(CmnCdDtlVO vo) {
        vo = proxyDao.selectOne("biz.app.example.selectCmnCdDtl", vo);
        ResultModel<CmnCdDtlVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    public ResultModel<CmnCdDtlPO> insertCmnCdDtl(CmnCdDtlPO po) {
        ResultModel<CmnCdDtlPO> result = new ResultModel<>();
        proxyDao.insert("biz.app.example.insertCmnCdDtl", po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    @Override
    public ResultModel<CmnCdDtlPO> updateCmnCdDtl(CmnCdDtlPO po) {
        ResultModel<CmnCdDtlPO> result = new ResultModel<>();
        proxyDao.update("biz.app.example.updateCmnCdDtl", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    @Override
    public ResultModel<CmnCdDtlPO> deleteCmnCdDtl(CmnCdDtlPO po) {
        ResultModel<CmnCdDtlPO> result = new ResultModel<>();
        proxyDao.delete("biz.app.example.deleteCmnCdDtl", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }
}
