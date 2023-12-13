package net.danvi.dmall.biz.app.design.service;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.design.model.DisplayPO;
import net.danvi.dmall.biz.app.design.model.DisplayPOListWrapper;
import net.danvi.dmall.biz.app.design.model.DisplayVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.design.model.DisplaySO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5 9.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Service("displayManageService")
@Transactional(rollbackFor = Exception.class)
public class DisplayManageServiceImpl extends BaseService implements DisplayManageService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<DisplayVO> selectDisplayList(DisplaySO so) throws Exception {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        List<DisplayVO> temp = proxyDao.selectList(MapperConstants.DESIGN_DISPLAY + "selectDisplayOption", so);

        if (temp.size() < 200) {
            for (int i = 0; i < (200 - temp.size()); i++) {
                DisplayPO po = new DisplayPO();
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setDispCdNm("배너위치 입력");
                Long dispNo = bizService.getSequence("DISPLAY", po.getSiteNo());
                po.setDispNo(dispNo);
                po.setDispCd((temp.size() + i + 1) + "");

                proxyDao.insert(MapperConstants.DESIGN_DISPLAY + "insertDisplay", po);
            }
            temp = proxyDao.selectList(MapperConstants.DESIGN_DISPLAY + "selectDisplayOption", so);
        }

        ResultListModel<DisplayVO> resultListModel = proxyDao
                .selectListPage(MapperConstants.DESIGN_DISPLAY + "selectDisplayPaging", so);
        resultListModel.put("titleList", temp);

        return resultListModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<DisplayVO> viewDisplayDtl(DisplaySO so) {

        List<DisplayVO> temp = proxyDao.selectList(MapperConstants.DESIGN_DISPLAY + "selectDisplayOption", so);
        DisplayVO vo = new DisplayVO();
        vo.setTitleNmArr(temp);

        ResultModel<DisplayVO> result = new ResultModel<DisplayVO>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<DisplayVO> selectDisplay(DisplaySO so) {

        List<DisplayVO> temp = proxyDao.selectList(MapperConstants.DESIGN_DISPLAY + "selectDisplayOption", so);
        DisplayVO vo = proxyDao.selectOne("design.displayManage.selectDisplay", so);
        vo.setTitleNmArr(temp);

        ResultModel<DisplayVO> result = new ResultModel<DisplayVO>(vo);

        return result;
    }

    @Override
    public ResultModel<DisplayPO> insertDisplay(DisplayPO po) throws Exception {
        ResultModel<DisplayPO> result = new ResultModel<>();

        try {

            Long dispNo = bizService.getSequence("DISPLAY", po.getSiteNo());

            po.setDispNo(dispNo);

            proxyDao.insert("design.displayManage.insertDisplay", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "전시관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<DisplayPO> updateDisplay(DisplayPO po) throws Exception {
        ResultModel<DisplayPO> result = new ResultModel<>();

        try {
            proxyDao.update("design.displayManage.updateDisplay", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "전시관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<DisplayPO> deleteDisplay(DisplayPO po) throws Exception {
        ResultModel<DisplayPO> result = new ResultModel<>();

        try {

            proxyDao.delete("design.displayManage.deleteDisplay", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "전시관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<DisplayPO> updateDisplayBanner(DisplayPOListWrapper wrapper) throws Exception {
        ResultModel<DisplayPO> result = new ResultModel<>();

        for (DisplayPO po : wrapper.getList()) {
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            proxyDao.update("design.displayManage.updateDisplayBanner", po);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

}
