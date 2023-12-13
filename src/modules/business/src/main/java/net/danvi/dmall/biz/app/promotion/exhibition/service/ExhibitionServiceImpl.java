package net.danvi.dmall.biz.app.promotion.exhibition.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.*;
import dmall.framework.common.util.*;
import net.danvi.dmall.biz.app.goods.model.KeywordSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionDispzoneVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPOListWrapper;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionTargetVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 기획전서비스임플
 * </pre>
 */
@Slf4j
@Service("exhibitionService")
@Transactional(rollbackFor = Exception.class)
public class ExhibitionServiceImpl extends BaseService implements ExhibitionService {

    @Resource(name = "editorService")
    private EditorService editorService;

    // 기획전목록 조회 페이징
    @Override
    public ResultListModel<ExhibitionVO> selectExhibitionListPaging(ExhibitionSO so) {
        if (so.getPeriodSelOption() == null || so.getPeriodSelOption().equals("")) {
            so.setPeriodSelOption("applyStartDttm");
        }
        ResultListModel<ExhibitionVO> result = proxyDao.selectListPage(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionListPaging", so);
        return result;
    }

    // 기획전 등록
    @Override
    public ResultModel<ExhibitionPO> insertExhibition(ExhibitionPO po, HttpServletRequest request) throws Exception {
        /*----------이미지 업로드 정보 start-----------*/
        String filePath = FileUtil.getPath(UploadConstants.PATH_EXHIBITION);
        List<FileVO> fileList = FileUtil.getFileListFromRequest(request, filePath);
        if(fileList != null) {
            for (FileVO fileVO : fileList) {
                po.setPrmtWebBannerImgPath(fileVO.getFilePath());
                po.setPrmtWebBannerImg(fileVO.getFileName());
                po.setPrmtWebBannerImgOrg(fileVO.getFileOrgName());
            }
        }
        /*----------이미지 업로드 정보 end-----------*/

        /*----------에디터 처리 start-----------*/
        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        String refNo = Integer.toString(po.getPrmtNo());

        // 에디터 내용의 업로드 이미지 정보 변경
        log.info("변경전 내용 : {}", po.getPrmtContentHtml());
        po.setPrmtContentHtml(StringUtil.replaceAll(po.getPrmtContentHtml(),(String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
        po.setPrmtContentHtml(StringUtil.replaceAll(po.getPrmtContentHtml(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        log.info("변경한 내용 : {}", po.getPrmtContentHtml());

        editorService.setEditorImageToService(po, refNo, "TP_PROMOTION");
        FileUtil.setEditorImageList(po, "TP_PROMOTION", po.getAttachImages());
        log.info("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                p.setFileGb("TP_PROMOTION");
                editorService.insertCmnAtchFile(p);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());
        /*----------에디터 처리 end-----------*/

        /*----------기획전 등록 start-----------*/
        ResultModel<ExhibitionPO> result = new ResultModel<>();

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        try {
            proxyDao.insert(MapperConstants.PROMOTION_EXHIBITION + "insertExhibition", po);

            for (String goodsNo : po.getGoodsNoArr()) {
                po.setGoodsNo(goodsNo);
                proxyDao.insert(MapperConstants.PROMOTION_EXHIBITION + "insertExhibitionTargetGoods", po);
            }

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "기획전 등록" }, e);
        }
        /*----------기획전 등록 end-----------*/

        return result;
    }

    // 기획전 수정
    @Override
    public ResultModel<ExhibitionPO> updateExhibition(ExhibitionPO po, HttpServletRequest request) throws Exception {
        /*---------------이미지 업로드 start-----------------*/
        ExhibitionSO so = new ExhibitionSO();
        so.setSiteNo(po.getSiteNo());
        so.setPrmtNo(po.getPrmtNo());

        ExhibitionVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionDtl", so);

        if (StringUtil.isNotEmpty(vo.getPrmtWebBannerImg())) {
            String delFilePath = FileUtil.getPath(UploadConstants.PATH_EXHIBITION) + vo.getPrmtWebBannerImg();
            File file = new File(delFilePath);
            if(file.exists()) {
                file.delete();
            }

            String uploadFilePath = FileUtil.getPath(UploadConstants.PATH_EXHIBITION);
            List<FileVO> fileList = FileUtil.getFileListFromRequest(request, uploadFilePath);

            if(fileList != null) {
                for (FileVO fileVO : fileList) {
                    po.setPrmtWebBannerImgPath(fileVO.getFilePath());
                    po.setPrmtWebBannerImg(fileVO.getFileName());
                    po.setPrmtWebBannerImgOrg(fileVO.getFileOrgName());
                }
            }
        } else {
            po.setPrmtWebBannerImgOrg("");
        }
        /*---------------이미지 업로드 end-----------------*/

        /*----------에디터 처리 start-----------*/
        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        String refNo = Integer.toString(po.getPrmtNo());

        // 에디터 내용의 업로드 이미지 정보 변경
        log.info("변경전 내용 : {}", po.getPrmtContentHtml());
        po.setPrmtContentHtml(StringUtil.replaceAll(po.getPrmtContentHtml(),(String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) ,""));
        po.setPrmtContentHtml(StringUtil.replaceAll(po.getPrmtContentHtml(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        log.info("변경한 내용 : {}", po.getPrmtContentHtml());

        editorService.setEditorImageToService(po, refNo, "TP_PROMOTION");
        FileUtil.setEditorImageList(po, "TP_PROMOTION", po.getAttachImages());
        log.info("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호(게시판 번호, 팝업번호 등...)
                p.setFileGb("TP_PROMOTION");
                editorService.insertCmnAtchFile(p);
            }
        }
        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());
        /*----------에디터 처리 end-----------*/

        /*---------------기획전 등록 start-----------------*/
        ResultModel<ExhibitionPO> result = new ResultModel<>();

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        try {
            proxyDao.update(MapperConstants.PROMOTION_EXHIBITION + "updateExhibition", po);

            proxyDao.delete(MapperConstants.PROMOTION_EXHIBITION + "deleteExhibitionTargetGoods", po);

            for(String goodsNo :po.getGoodsNoArr()){
                po.setGoodsNo(goodsNo);
                proxyDao.insert(MapperConstants.PROMOTION_EXHIBITION + "insertExhibitionTargetGoods", po);
            }
            result.setSuccess(true);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "기획전 수정" }, e);
        }
        /*---------------기획전 등록 end-----------------*/


        return result;
    }

    // 기획전 삭제
    @Override
    public ResultModel<ExhibitionPO> deleteExhibition(ExhibitionPOListWrapper wrapper) throws Exception {
        ResultModel<ExhibitionPO> result = new ResultModel<>();

        String deletePath = FileUtil.getPath(UploadConstants.PATH_EXHIBITION);
        for (ExhibitionPO po : wrapper.getList()) {
            // 기획전 상품 삭제
            wrapper.setPrmtNo(po.getPrmtNo());
            proxyDao.delete(MapperConstants.PROMOTION_EXHIBITION + "deleteExhibitionTargetGoods", wrapper);

            // 대표이미지 삭제
            ExhibitionSO so = new ExhibitionSO();
            so.setSiteNo(wrapper.getSiteNo());
            so.setPrmtNo(po.getPrmtNo());
            ExhibitionVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionDtl", so);
            File file = new File(deletePath + vo.getPrmtWebBannerImg());
            if (file.exists()) {
                file.delete();
            }
        }

        // 기획전 삭제
        proxyDao.update(MapperConstants.PROMOTION_EXHIBITION + "deleteExhibition", wrapper);

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;

    }

    // 기획전 상세조회(단건)
    @Override
    public ResultModel<ExhibitionVO> selectExhibitionDtl(ExhibitionSO so) throws Exception {
        ExhibitionVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionDtl", so);

        if(vo.getPrmtContentHtml() != null) {
            HttpServletRequest request = HttpUtil.getHttpServletRequest();
            vo.setPrmtContentHtml(StringUtil.replaceAll(vo.getPrmtContentHtml(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        }

        ResultModel<ExhibitionVO> result = new ResultModel<>();

        // 상품번호 가져오기
        List<ExhibitionTargetVO> goodsList = proxyDao.selectList(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionTargetGoods", so);
        vo.setGoodsList(goodsList);

        // 에디터 파일 조회
        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(so.getSiteNo());
        s.setRefNo(Integer.toString(so.getPrmtNo()));
        s.setFileGb("TP_PROMOTION");
        editorService.setCmnAtchFileToEditorVO(s, vo);

        result.setData(vo);
        return result;

    }

    // 진행중인 기획전 조회
    @Override
    public ResultListModel<ExhibitionVO> selectOtherExhibitionList(ExhibitionSO so) {
        List<ExhibitionVO> temp = proxyDao.selectList(MapperConstants.PROMOTION_EXHIBITION + "selectOtherExhibition",so);
        ResultListModel<ExhibitionVO> resultListModel = new ResultListModel<ExhibitionVO>();
        resultListModel.setResultList(temp);
        return resultListModel;
    }
    // 기획전 적용 전시리스트조회
    @Override
	public List<ExhibitionVO> selectEhbDispMngList(ExhibitionSO so) {
    	List<ExhibitionVO> result = proxyDao.selectList(MapperConstants.PROMOTION_EXHIBITION + "selectEhbDispMngList", so);
    	return result;
    }
    //기획전 전시리스트 상품조회
    @Override
	public List<GoodsVO> selectEhbDispGoodsList(ExhibitionSO so) {

	    List<GoodsVO> goodslist =proxyDao.selectList(MapperConstants.PROMOTION_EXHIBITION + "selectEhbDispGoodsList", so);

        for(int j=0; j<goodslist.size(); j++) {

            if(goodslist.get(j).getCouponAvlInfo()!=null && !goodslist.get(j).getCouponAvlInfo().equals("")) {
                GoodsVO dispVo = goodslist.get(j);
                int avlLen = goodslist.get(j).getCouponAvlInfo().split("\\|").length;

                for(int l=0;l<avlLen;l++){
                    if(l==0)
                    dispVo.setCouponApplyAmt(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    if(l==1)
                    dispVo.setCouponDcAmt(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    if(l==2)
                    dispVo.setCouponDcRate(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    if(l==3)
                    dispVo.setCouponDcValue(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    if(l==4)
                    dispVo.setCouponBnfCd(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    if(l==5)
                    dispVo.setCouponBnfValue(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                    if(l==6)
                    dispVo.setCouponBnfTxt(goodslist.get(j).getCouponAvlInfo().split("\\|")[l]);
                }
            }
        }


        return goodslist;
    }
    // 기획전 설정내용조회
    @Override
    public ResultModel<ExhibitionVO> selectExhibitionInfo(ExhibitionSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ExhibitionVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionDtl", so);
        vo.setPrmtContentHtml(StringUtil.replaceAll(vo.getPrmtContentHtml(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        vo.setPrmtContentHtml(StringUtil.replaceAll(vo.getPrmtContentHtml(), "&amp;amp;", "&"));
        ResultModel<ExhibitionVO> result = new ResultModel<ExhibitionVO>(vo);
        return result;
    }

    // 기획전적용 상품리스트조회
    @Override
    public ResultListModel<GoodsVO> selectExhibitionGoodsList(ExhibitionSO so) {
        ResultListModel<GoodsVO> result = new ResultListModel<GoodsVO>();
        result = proxyDao
                .selectListPageWoTotal(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionGoodsListPaging", so);
        return result;
    }

    // 상품번호/카테고리로 기획전 조회
    @Override
    public ResultModel<ExhibitionVO> selectExhibitionByGoods(ExhibitionSO so) throws Exception {
        ExhibitionVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionByGoods", so);
        ResultModel<ExhibitionVO> result = new ResultModel<>(vo);
        return result;
    }

    // 기획전 고유 번호로 연결된 상품 조회
    @Override
    public ResultListModel<ExhibitionTargetVO> selectExhibitionTargetTotal(ExhibitionSO so) {
        ResultListModel<ExhibitionTargetVO> result = new ResultListModel<ExhibitionTargetVO>();
        List<ExhibitionTargetVO> goodsResult = proxyDao.selectList(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionTargetTotal");

        result.put("goodsResult", goodsResult);
        return result;
    }

    // 기획전 복사
    @Override
    public ResultModel<ExhibitionPO> copyExhibitionInfo(ExhibitionPO po) throws CustomException {

        ResultModel<ExhibitionPO> result = new ResultModel<>();

        try {
            // 기본 기획전정보 복사
            proxyDao.insert(MapperConstants.PROMOTION_EXHIBITION + "copyExhibitionInfo", po);
            // 기획전대상 복사
            proxyDao.insert(MapperConstants.PROMOTION_EXHIBITION + "copyExhibitionTargetGoods", po);


        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "기획전복사" }, e);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsVO> selectExhibitionTargetGoodsList(ExhibitionSO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectExhibitionTargetGoodsList so = "+so);
        List<GoodsVO> result = proxyDao.selectList(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionTargetGoodsList", so);
        if(result != null && result.size() > 0) {
            for (int i = 0; i < result.size(); i++) {
                result.get(i).setRownum(i + 1);
            }
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2023. 03. 17.
     * 작성자 : slims
     * 설명   : 프로모션에 이미 등록 되어있으면 1 없으면 0을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 03. 17. slims - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @Override
    @Transactional(readOnly = true)
    public Integer selectExhibitionTargetGoodsExist(ExhibitionSO exhibitionSO) {
        Integer result = proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectExhibitionTargetGoodsExist", exhibitionSO);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public String selectNewPrmtNo() {
        return proxyDao.selectOne(MapperConstants.PROMOTION_EXHIBITION + "selectNewPrmtNo");
    }

}