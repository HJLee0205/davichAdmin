package net.danvi.dmall.biz.example.service;

import net.danvi.dmall.biz.example.model.*;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * Created by dong on 2016-04-11.
 */
public interface CmnCdService {
    public ResultListModel<CmnCdGrpVO> selectCmnCdGrpPaging(CmnCdGrpSO cmnCdGrpSO);

    public ResultModel<CmnCdGrpVO> selectCmnCdGrp(CmnCdGrpVO vo);

    public ResultModel<CmnCdGrpPO> insertCmnCdGrp(CmnCdGrpPO po) throws Exception;

    public ResultModel<CmnCdGrpPO> updateCmnCdGrp(CmnCdGrpPO po) throws Exception;

    public ResultModel<CmnCdGrpPO> deleteCmnCdGrp(CmnCdGrpPOListWrapper wrapper);

    public ResultListModel<CmnCdDtlVO> selectCmnCdDtlPaging(CmnCdDtlSO cmnCdDtlSO);

    public ResultModel<CmnCdDtlVO> selectCmnCdDtl(CmnCdDtlVO vo);

    public ResultModel<CmnCdDtlPO> insertCmnCdDtl(CmnCdDtlPO po);

    public ResultModel<CmnCdDtlPO> updateCmnCdDtl(CmnCdDtlPO po);

    public ResultModel<CmnCdDtlPO> deleteCmnCdDtl(CmnCdDtlPO po);
}
