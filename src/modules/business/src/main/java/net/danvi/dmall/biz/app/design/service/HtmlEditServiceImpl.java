package net.danvi.dmall.biz.app.design.service;

import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.design.model.HtmlEditPO;
import net.danvi.dmall.biz.app.design.model.HtmlEditVO;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.design.model.HtmlEditSO;
import net.danvi.dmall.biz.common.service.BizService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6 9.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Service("htmlEditService")
@Transactional(rollbackFor = Exception.class)
public class HtmlEditServiceImpl extends BaseService implements HtmlEditService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    @Transactional(readOnly = true)
    public ResultModel<HtmlEditVO> getEditFileInfo(HtmlEditSO so) {
        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();

        HtmlEditVO htmlEditVO = new HtmlEditVO();

        List<HtmlEditVO> htmlList = proxyDao.selectList(MapperConstants.DESIGN_HTML_EDIT + "selectHtmlList", so);

        htmlEditVO.setFileInfoArr(htmlList);
        // 리턴모델에 VO셋팅
        resultModel.setData(htmlEditVO);
        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<HtmlEditVO> getEditFileDtlInfo(HtmlEditSO so) {
        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();

        // HtmlEditVO htmlEditVO = new HtmlEditVO();

        HtmlEditVO htmlEditVO = proxyDao.selectOne(MapperConstants.DESIGN_HTML_EDIT + "selectHtmlDtl", so);

        // htmlEditVO.setFileInfoArr(htmlList);
        // 리턴모델에 VO셋팅
        resultModel.setData(htmlEditVO);
        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<HtmlEditVO> getEditFileWorkInfo(HtmlEditSO so) {
        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();

        // HtmlEditVO htmlEditVO = new HtmlEditVO();

        HtmlEditVO htmlEditVO = proxyDao.selectOne(MapperConstants.DESIGN_HTML_EDIT + "selectHtmlWorkInfo", so);

        // htmlEditVO.setFileInfoArr(htmlList);
        // 리턴모델에 VO셋팅
        resultModel.setData(htmlEditVO);
        return resultModel;
    }

    @Override
    public ResultModel<HtmlEditPO> insertHtmlEdit(HtmlEditPO po) throws Exception {
        ResultModel<HtmlEditPO> result = new ResultModel<>();

        try {
            // if (po.getPcGbCd() == null || po.getPcGbCd().equals("")) {
            // po.setPcGbCd("C");
            // }

            // Long popupNo = bizService.getSequence("POPUP", po.getSiteNo());

            // po.setPopupNo(popupNo);

            proxyDao.insert("design.htmlEdit.insertHtmlEdit", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "HTML 편집" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<HtmlEditPO> updateHtmlEdit(HtmlEditPO po) throws Exception {
        ResultModel<HtmlEditPO> result = new ResultModel<>();

        try {
            proxyDao.update("design.htmlEdit.updateHtmlEdit", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "HTML 편집" }, e);
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<HtmlEditVO> getPreViewInfo(HtmlEditSO so) {
        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();

        // HtmlEditVO htmlEditVO = new HtmlEditVO();

        HtmlEditVO htmlEditVO = proxyDao.selectOne(MapperConstants.DESIGN_HTML_EDIT + "selectPreViewInfo", so);

        // htmlEditVO.setFileInfoArr(htmlList);
        // 리턴모델에 VO셋팅
        resultModel.setData(htmlEditVO);
        return resultModel;
    }

}
