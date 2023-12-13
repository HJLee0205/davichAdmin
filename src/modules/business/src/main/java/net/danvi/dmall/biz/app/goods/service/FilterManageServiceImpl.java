package net.danvi.dmall.biz.app.goods.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : filter 정보 관리 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("filterManageService")
@Transactional(rollbackFor = Exception.class)
public class FilterManageServiceImpl extends BaseService implements FilterManageService {

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFilterList(FilterSO filterSO) {

        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.debug("selectFilterList : filterSO {}", filterSO);
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterList", filterSO);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFilterListGoodsType(FilterSO filterSO) {

        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.debug("selectFilterListDepth : filterSO {}", filterSO);
        if(filterSO.getGoodsTypeCd().equals("04")) {
            return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterListContact", filterSO);
        } else {
            return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterListGoodsType", filterSO);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFiltersGoodsType(FilterSO filterSO) {

        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.debug("selectFiltersGoodsType : filterSO {}", filterSO);
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFiltersGoodsType", filterSO);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFilterList1depth(FilterSO filterSO) {

        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.debug("selectFilterList1depth : filterSO {}", filterSO);
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterList1depth", filterSO);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFilterListDepth(FilterSO filterSO) {

        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.debug("selectFilterListDepth : filterSO {}", filterSO);
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterListDepth", filterSO);
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectFilterGoodsYn(FilterPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectFilterGoodsYn", po);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectCpYn(FilterPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectCpYn", po);
        return result;
    }

    @Override
    public ResultModel<FilterPO> deleteFilter(FilterPO po) {
        ResultModel<FilterPO> result = new ResultModel<>();
        try {
            // 하위 filter 번호 조회
            List<Integer> ctgNoList = selectChildFilterNo(po);
            log.debug("deleteFilter : ctgNoList {}", ctgNoList);
            File dFile;

            po.setChildFilterNoList(ctgNoList);
            log.debug("deleteFilter : param {}", po);
            // 상품 filter 삭제
            //proxyDao.delete(MapperConstants.FILTER_MANAGE + "deleteFilter", po);

            // filter 파일 정보 조회
            /*List<FilterVO> fileVoList = proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterFileInfo",
                    po);

            if (fileVoList != null && fileVoList.size() > 0) {
                // filter 이미지 파일 삭제
                for (int j = 0; j < fileVoList.size(); j++) {
                    FilterVO fileVo = fileVoList.get(j);
                    // 디폴트 이미지 삭제
                    if (fileVo.getFilterImgPath() != null && fileVo.getFilterImgPath().length() > 0) {
                        // 등록되어 있는 파일정보
                        dFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
                                + UploadConstants.PATH_CTG + File.separator + fileVo.getFilterImgPath().substring(0, 4)
                                + File.separator + fileVo.getFilterImgPath().substring(4, 6) + File.separator
                                + fileVo.getFilterImgPath().substring(6) + File.separator + fileVo.getFilterImgNm()));

                        // 등록되어 있는 파일 삭제
                        if (dFile.exists()) {
                            log.debug("삭제 파일 정보 :{}", dFile);
                            dFile.delete();
                        }
                    }

                    // 마우스오버 이미지 삭제
                    if (fileVo.getMouseoverImgPath() != null && fileVo.getMouseoverImgPath().length() > 0) {
                        // 등록되어 있는 파일정보
                        dFile = new File(
                                FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator + UploadConstants.PATH_CTG
                                        + File.separator + fileVo.getMouseoverImgPath().substring(0, 4) + File.separator
                                        + fileVo.getMouseoverImgPath().substring(4, 6) + File.separator
                                        + fileVo.getMouseoverImgPath().substring(6) + File.separator
                                        + fileVo.getMouseoverImgNm()));

                        // 등록되어 있는 파일 삭제
                        if (dFile.exists()) {
                            log.debug("삭제 파일 정보 :{}", dFile);
                            dFile.delete();
                        }
                    }
                }

            }*/

            // filter 삭제
            proxyDao.delete(MapperConstants.FILTER_MANAGE + "deleteFilter", po);

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public List<Integer> selectChildFilterNo(FilterPO po) {
        List<Integer> ctgNoList = proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectChildFilterNo", po);
        return ctgNoList;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<FilterVO> selectFilter(FilterSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();

        log.debug("selectFilter  :{}", so);
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        FilterVO vo = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectFilter", so);
        log.debug("selectFilter  vo :{}", vo);
        //vo.setFilterImgPath(StringUtil.replaceAll(vo.getFilterImgNm(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        //log.debug("selectFilter  vo 2 :{}", vo);
        /*if (vo.getFilterImgPath() != null && vo.getFilterImgPath().length() > 0) {
            // 이미지 파일 가로, 세로 크기
            Image img = new ImageIcon(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator + UploadConstants.PATH_CTG + File.separator
                            + vo.getFilterImgPath().substring(0, 4) + File.separator + vo.getFilterImgPath().substring(4, 6)
                            + File.separator + vo.getFilterImgPath().substring(6) + File.separator + vo.getFilterImgNm())).getImage();

            vo.setFilterNmImgWidth(Integer.toString(img.getWidth(null)));
            vo.setFilterNmImgHeight(Integer.toString(img.getHeight(null)));

        } else {
            vo.setFilterNmImgWidth("000");
            vo.setFilterNmImgHeight("000");
        }*/

        /*if (vo.getMouseoverImgPath() != null && vo.getMouseoverImgPath().length() > 0) {
            // 이미지 파일 가로, 세로 크기
            Image img = new ImageIcon(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
                    + UploadConstants.PATH_CTG + File.separator + vo.getMouseoverImgPath().substring(0, 4)
                    + File.separator + vo.getMouseoverImgPath().substring(4, 6) + File.separator
                    + vo.getMouseoverImgPath().substring(6) + File.separator + vo.getMouseoverImgNm())).getImage();
            vo.setMouseoverImgWidth(Integer.toString(img.getWidth(null)));
            vo.setMouseoverImgHeight(Integer.toString(img.getHeight(null)));
        } else {
            vo.setMouseoverImgWidth("000");
            vo.setMouseoverImgHeight("000");
        }*/

        /*// filter 상품, 판매중인 상품 갯수 조회 resultModel
        ResultModel<FilterVO> ctgGoodsCnt = new ResultModel<>();
        // filter 상품, 판매중인 상품 갯수 조회
        ctgGoodsCnt = selectFilterGoodsCnt(so);

        if (ctgGoodsCnt.getData() != null) {
            // filter에 등록된 상품 갯수
            if (ctgGoodsCnt.getData().getFilterGoodsCnt() != null) {
                vo.setFilterGoodsCnt(ctgGoodsCnt.getData().getFilterGoodsCnt());
            }
            // filter에 등록된 판매중인 상품 갯수
            if (ctgGoodsCnt.getData().getFilterSalesGoodsCnt() != null) {
                vo.setFilterSalesGoodsCnt(ctgGoodsCnt.getData().getFilterSalesGoodsCnt());
            }
        }*/

        // 에디터 파일 정보 조회
        // 이미지 디비 정보 조회 조건 세팅
        /*CmnAtchFileSO atchFileso = new CmnAtchFileSO();
        atchFileso.setSiteNo(so.getSiteNo());
        atchFileso.setRefNo(so.getFilterNo());
        atchFileso.setFileGb("TG_CTG");

        // 공통 첨부 파일 조회하여 VO에 담는다.
        editorService.setCmnAtchFileToEditorVO(atchFileso, vo);*/

        ResultModel<FilterVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<FilterVO> selectFilterGoodsCnt(FilterSO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        FilterVO vo = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectFilterGoodsCnt", so);

        ResultModel<FilterVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    public ResultModel<FilterPO> updateFilter(FilterPO po) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<FilterPO> result = new ResultModel<>();
        try {
        	File file;
            File ofile;
            File dfile;
            // 파일 정보 vo
            FilterVO fileFath = new FilterVO();
            FilterSO so = new FilterSO();

            // 디폴트 이미지 파일 삭제여부
            String dftImgDelYn = "N";

            // 디폴트 이미지 사용자가 삭제 했는지 여부
            if (("Y").equals(po.getDftDelYn())) {
                dftImgDelYn = "Y";
                po.setFilterImgNm("");
                po.setFilterImgPath("");
            }

            so.setSiteNo(po.getSiteNo());
            so.setFilterNo(po.getFilterNo());

            // 파일 정보 조회(새로운 파일이 있을 경우에만 삭제)
            fileFath = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectFilter", so);

            String newfilePathNm = DateUtil.getNowDate();
            String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)+ File.separator + newfilePathNm.substring(6);

            // filter 디폴트 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getDftFilePath() != null && po.getDftFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FILTER, newfilePath,po.getDftFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getDftFilePath() + File.separator+ po.getDftFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                log.debug("ort file : {}", ofile);
                log.debug("dest file : {}", file);

                FileUtil.move(ofile, file);

                // po.setFilterNmImgPath(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.TYPE_CTG,
                // po.getDftFilePath(), po.getDftFileName()));

                po.setFilterImgPath(newfilePathNm);
                po.setFilterImgNm(po.getDftFileName());

                dftImgDelYn = "Y";
            }

            //log.debug("updateFilter po : {}", po);

            // filter 정보 수정
            proxyDao.update(MapperConstants.FILTER_MANAGE + "updateFilter", po);
            
            // filter 등록상품 수수료율 조정 후 공급가 재설정
            //proxyDao.update(MapperConstants.FILTER_MANAGE + "updateSupplyPrice", po);

            // 디폴트 이미지 삭제
            if (("Y").equals(dftImgDelYn)) {
                if (fileFath.getFilterImgPath() != null && fileFath.getFilterImgPath().length() > 0) {
                    // 등록되어 있는 파일정보
                    dfile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
                            + UploadConstants.PATH_CTG + File.separator + fileFath.getFilterImgPath().substring(0, 4)
                            + File.separator + fileFath.getFilterImgPath().substring(4, 6) + File.separator
                            + fileFath.getFilterImgPath().substring(6) + File.separator + fileFath.getFilterImgNm()));

                    // 등록되어 있는 파일 삭제
                    if (dfile.exists()) {
                        log.debug("삭제 파일 정보 :{}", dfile);
                        dfile.delete();
                    }
                }
            }

            // 프론트 캐시 갱신
            //adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            //adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());

            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<FilterPO> insertFilter(FilterPO po) {
        ResultModel<FilterPO> result = new ResultModel<>();
        Long filterNo = (long) 0;
        try {
            filterNo = bizService.getSequence("FILTER_NO", po.getSiteNo());

            log.debug("insertFilter filterNo :{}", filterNo);
            log.debug("insertFilter po :{}", po);

            po.setFilterNo(String.valueOf(filterNo));
            proxyDao.insert(MapperConstants.FILTER_MANAGE + "insertFilter", po);

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
        	e.printStackTrace();
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }
        return result;
    }

    // @Override
    // public List<DisplayGoodsVO> selectFilterGoodsList(FilterSO so) {
    // return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFilterGoodsList", so);
    // }

    // @Override
    // public ResultModel<FilterPO> updateFilterGoodsDispYn(FilterPO po) {
    // ResultModel<FilterPO> result = new ResultModel<>();
    //
    // proxyDao.update(MapperConstants.FILTER_MANAGE + "updateFilterGoodsDispYn", po);
    //
    // result.setMessage(MessageUtil.getMessage("biz.common.update"));
    // return result;
    // }

    // @Override
    // public ResultModel<FilterPO> updateFilterShowGoodsManage(FilterPO po) {
    // ResultModel<FilterPO> result = new ResultModel<>();
    //
    // if (po.getDispGoodsExpsYn() == null || po.getDispGoodsExpsYn() == "") {
    // po.setDispGoodsExpsYn("N");
    // }
    //
    // if (po.getNoDispGoodsExpsYn() == null || po.getNoDispGoodsExpsYn() == "") {
    // po.setNoDispGoodsExpsYn("N");
    // }
    //
    // if (po.getSalemediumGoodsExpsYn() == null || po.getSalemediumGoodsExpsYn() == "") {
    // po.setSalemediumGoodsExpsYn("N");
    // }
    //
    // if (po.getSalestnbyGoodsExpsYn() == null || po.getSalestnbyGoodsExpsYn() == "") {
    // po.setSalestnbyGoodsExpsYn("N");
    // }
    //
    // // 사용자 지정 상품 정렬 인 경우
    // if (po.getExpsGoodsSortCd().equals("6")) {
    // // filter 상품 삭제 후 노출 우선 순위에 따라 Insert
    // proxyDao.delete(MapperConstants.FILTER_MANAGE + "deleteShowGoods", po);
    //
    // String[] goodsNoArr = po.getGoodsNoArr();
    // String[] dispYnArr = po.getDispYnArr();
    // String[] dlgtFilterYnArr = po.getDlgtFilterYnArr();
    // for (int i = 0; i < goodsNoArr.length; i++) {
    // po.setGoodsNo(goodsNoArr[i]);
    // po.setDispYn(dispYnArr[i]);
    // po.setDlgtFilterYn(dlgtFilterYnArr[i]);
    // po.setExpsPriorRank(Integer.toString(i + 1));
    //
    // proxyDao.insert(MapperConstants.FILTER_MANAGE + "insertShowGoods", po);
    // }
    // }
    //
    // proxyDao.update(MapperConstants.FILTER_MANAGE + "updateFilterShowGoodsManage", po);
    //
    // result.setMessage(MessageUtil.getMessage("biz.common.update"));
    // return result;
    // }

    /** 전체filter 목록을 조회 **/
    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFrontGnbList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFrontGnbList", siteNo);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectFrontLnbList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectFrontLnbList", siteNo);
    }

    /** 네이게이션 (하위에서 상위조회) **/
    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectUpNavagation(FilterSO so) {
        FilterVO cv = new FilterVO();// filter 정보 조회(상위filter 조회시 filter 레벨필요)
        cv = proxyDao.selectOne(MapperConstants.FILTER_MANAGE + "selectNavigationInfo", so);
        so.setFilterNm(cv.getFilterNm());
        so.setFilterLvl(cv.getFilterLvl());
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectUpNavagation", so);
    }

    /** 동일 상위,레벨 filter 조회 **/
    @Override
    @Transactional(readOnly = true)
    public List<FilterVO> selectNavigationList(FilterSO so) {
        return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectNavigationList", so);
    }
    
    @Override
    public ResultModel<FilterPO> updateFilterSort(FilterPO po) {
        ResultModel<FilterPO> result = new ResultModel<>();
        try {
	        // 순번 초기화
	        proxyDao.update(MapperConstants.FILTER_MANAGE + "filterSortInit", po);
	        
	        // 선택 filter 순번 업데이트
	        proxyDao.update(MapperConstants.FILTER_MANAGE + "updateFilterSort", po);
	        
	        // 순번 재정렬
	        proxyDao.update(MapperConstants.FILTER_MANAGE + "filterSortSetting", po);
	        
	        // 하위 filter LEVEL 재정렬
	        if(!"".equals(po.getDownFilterNo())) {	// 하위 filter가 존재할 경우
		        int orgLvl = Integer.parseInt(po.getOrgFilterLvl()); // 기존 LEVEL
		        int newLvl = Integer.parseInt(po.getFilterLvl());	  // 변경 LEVEL
		        int calcLvl = newLvl - orgLvl; // 이동한 LEVEL
		        
		        if(calcLvl != 0) {
		        	po.setCalcLvl(calcLvl);
		        	proxyDao.update(MapperConstants.FILTER_MANAGE + "filterLvlSetting", po);
		        }
	        }

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        
        return result;

    }
    
    @Override
    public List<FilterVO> selectMainDispGoodsList(FilterPO filterPO) {
    	return proxyDao.selectList(MapperConstants.FILTER_MANAGE + "selectMainDispGoodsList", filterPO);
    }
    
}
