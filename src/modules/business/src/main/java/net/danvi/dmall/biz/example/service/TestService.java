package net.danvi.dmall.biz.example.service;

import net.danvi.dmall.biz.example.model.CmnCdGrpPO;
import net.danvi.dmall.biz.example.model.CmnCdGrpVO;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;

/**
 * Created by dong on 2016-04-21.
 */
public interface TestService {

    public ResultModel<CmnCdGrpPO> insertCmnCdGrp(CmnCdGrpPO po) throws CustomException;
    public ResultModel<CmnCdGrpPO> updateCmnCdGrp(CmnCdGrpPO po) throws CustomException;

    public ResultModel<CmnCdGrpVO> selectCmnCdGrp(CmnCdGrpVO vo);

    public void xaInit();

    public void xaInsertTest();
    public void xaInsertErrorTest();

    public void xaUpdateTest();
    public void xaUpdateErrorTest();

    public void xaDeleteTest();
    public void xaDeleteErrorTest();

    public void xaInsertTest1();
    public void xaInsertTest2();
    public void xaInsertErrorTest1();

    public void xaUpdateTest1();
    public void xaUpdateErrorTest1();

    public void xaDeleteTest1();
    void xaDeleteErrorTest2();

}
