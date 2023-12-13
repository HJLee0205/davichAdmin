package net.danvi.dmall.biz.app.goods.service;

import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.swing.ImageIcon;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.*;
import dmall.framework.common.util.*;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.io.FilenameUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 22.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 관리 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("categoryManageService")
@Transactional(rollbackFor = Exception.class)
public class CategoryManageServiceImpl extends BaseService implements CategoryManageService {

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Override
    @Transactional(readOnly = true)
    public List<CategoryVO> selectCategoryList(CategorySO categorySO) {

        categorySO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCategoryList", categorySO);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryVO> selectCategoryList1depth(CategorySO categorySO) {

        categorySO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        
        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCategoryList1depth", categorySO);
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectCtgGoodsYn(CategoryPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectCtgGoodsYn", po);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public Integer selectCpYn(CategoryPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectCpYn", po);
        return result;
    }

    @Override
    public ResultModel<CategoryPO> deleteCategory(CategoryPO po) {
        ResultModel<CategoryPO> result = new ResultModel<>();
        try {
            // 하위 카테고리 번호 조회
            List<Integer> ctgNoList = selectChildCtgNo(po);
            File dFile;

            po.setChildCtgNoList(ctgNoList);

            List<String> dispNoList = new ArrayList<>();
            // 카테고리 전시zone 번호 조회
            List<CategoryDisplayManageVO> dispZoneList = proxyDao
                    .selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgDispZone", po);

            if (dispZoneList != null && dispZoneList.size() > 0) {
                for (int i = 0; i < dispZoneList.size(); i++) {
                    CategoryDisplayManageVO zoneVo = dispZoneList.get(i);
                    dispNoList.add(i, zoneVo.getCtgDispzoneNo());

                    if (zoneVo.getCtgDispzoneImgNm() != null && zoneVo.getCtgDispzoneImgNm() != "") {
                        // 등록되어 있는 파일정보
                        dFile = new File(
                                FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator + UploadConstants.PATH_CTG
                                        + File.separator + zoneVo.getCtgDispzoneImgPath().substring(0, 4)
                                        + File.separator + zoneVo.getCtgDispzoneImgPath().substring(4, 6)
                                        + File.separator + zoneVo.getCtgDispzoneImgPath().substring(6) + File.separator
                                        + zoneVo.getCtgDispzoneImgNm()));

                        // 등록되어 있는 파일 삭제
                        if (dFile.exists()) {
                            log.debug("삭제 파일 정보 :{}", dFile);
                            dFile.delete();
                        }
                    }
                }
                po.setDispNoList(dispNoList);

                // 카테고리 전시 상품 삭제
                proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteCtgDispGoods", po);

                // 카테고리 전시 zone 삭제
                proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteCtgDispZone", po);
            }
            // 상품 카테고리 삭제
            proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteGoodsCtg", po);

            // 카테고리 파일 정보 조회
            List<CategoryVO> fileVoList = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgFileInfo",
                    po);

            if (fileVoList != null && fileVoList.size() > 0) {
                // 카테고리 이미지 파일 삭제
                for (int j = 0; j < fileVoList.size(); j++) {
                    CategoryVO fileVo = fileVoList.get(j);
                    // 디폴트 이미지 삭제
                    if (fileVo.getCtgImgPath() != null && fileVo.getCtgImgPath().length() > 0) {
                        // 등록되어 있는 파일정보
                        dFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
                                + UploadConstants.PATH_CTG + File.separator + fileVo.getCtgImgPath().substring(0, 4)
                                + File.separator + fileVo.getCtgImgPath().substring(4, 6) + File.separator
                                + fileVo.getCtgImgPath().substring(6) + File.separator + fileVo.getCtgImgNm()));

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

            }

            // 카테고리 삭제
            proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteCategory", po);

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
    public List<Integer> selectChildCtgNo(CategoryPO po) {
        List<Integer> ctgNoList = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectChildCtgNo", po);
        return ctgNoList;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<CategoryVO> selectCategory(CategorySO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        CategoryVO vo = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectCategory", so);

        vo.setContent(StringUtil.replaceAll(vo.getContent(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));

        if (vo.getCtgImgPath() != null && vo.getCtgImgPath().length() > 0) {
            // 이미지 파일 가로, 세로 크기
            Image img = new ImageIcon(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator + UploadConstants.PATH_CTG + File.separator
                            + vo.getCtgImgPath().substring(0, 4) + File.separator + vo.getCtgImgPath().substring(4, 6)
                            + File.separator + vo.getCtgImgPath().substring(6) + File.separator + vo.getCtgImgNm())).getImage();

            vo.setCtgNmImgWidth(Integer.toString(img.getWidth(null)));
            vo.setCtgNmImgHeight(Integer.toString(img.getHeight(null)));

        } else {
            vo.setCtgNmImgWidth("000");
            vo.setCtgNmImgHeight("000");
        }

        if (vo.getMouseoverImgPath() != null && vo.getMouseoverImgPath().length() > 0) {
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
        }

        // 카테고리 상품, 판매중인 상품 갯수 조회 resultModel
        ResultModel<CategoryVO> ctgGoodsCnt = new ResultModel<>();
        // 카테고리 상품, 판매중인 상품 갯수 조회
        ctgGoodsCnt = selectCtgGoodsCnt(so);

        if (ctgGoodsCnt.getData() != null) {
            // 카테고리에 등록된 상품 갯수
            if (ctgGoodsCnt.getData().getCtgGoodsCnt() != null) {
                vo.setCtgGoodsCnt(ctgGoodsCnt.getData().getCtgGoodsCnt());
            }
            // 카테고리에 등록된 판매중인 상품 갯수
            if (ctgGoodsCnt.getData().getCtgSalesGoodsCnt() != null) {
                vo.setCtgSalesGoodsCnt(ctgGoodsCnt.getData().getCtgSalesGoodsCnt());
            }
        }

        // 에디터 파일 정보 조회
        // 이미지 디비 정보 조회 조건 세팅
        CmnAtchFileSO atchFileso = new CmnAtchFileSO();
        atchFileso.setSiteNo(so.getSiteNo());
        atchFileso.setRefNo(so.getCtgNo());
        atchFileso.setFileGb("TG_CTG");

        // 공통 첨부 파일 조회하여 VO에 담는다.
        editorService.setCmnAtchFileToEditorVO(atchFileso, vo);

        // MAIN_DISP_GOODS 전시번호 조회
        String ctgDispzoneNo = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectMainDispzoneNo", so);
        vo.setCtgDispzoneNo(ctgDispzoneNo);

        // 전시상품 조회
        List<GoodsVO> dispGoods = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectMainDispGoods", vo);
        vo.setDispGoodsList(dispGoods);
        // 목록배너 이미지 조회
        List<CtgImgPO> imgList = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgBannerImg", so);
        vo.setImgList(imgList);

        ResultModel<CategoryVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<CategoryVO> selectCtgGoodsCnt(CategorySO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        CategoryVO vo = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectCtgGoodsCnt", so);

        ResultModel<CategoryVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    public ResultModel<CategoryPO> updateCatagory(CategoryPO po, HttpServletRequest request) {
        //HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<CategoryPO> result = new ResultModel<>();
        try {
            // 카테고리 정보 수정
            proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateCatagory", po);

            if (po.getCtgLvl().equals("1")) {
                String[] deviceTypeCdArr = new String[]{"01", "02"};
                String[] deviceTypeNmArr = new String[]{"pc", "mobile"};
                for(int i=0; i<2; i++) {
                    // 전시상품 기존 정보 삭제
                    proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteCtgDispGoods", po);
                    // 새로운 전시상품 정보 등록
                    if(po.getGoodsNoArr() != null && po.getGoodsNoArr().length > 0) {
                        int sortSeq = 1;
                        for (String goodsNo : po.getGoodsNoArr()) {
                            po.setSortSeq(String.valueOf(sortSeq));
                            po.setDispZoneGoods(goodsNo);
                            proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertCatagoryDisplayGoods", po);
                            sortSeq++;
                        }
                    }

                    CtgImgPO imgPO = new CtgImgPO();
                    imgPO.setCtgNo(po.getCtgNo());
                    imgPO.setDeviceType(deviceTypeCdArr[i]);
                    // 목록배너 이미지 기존 정보 조회
                    List<String> ctgImgPOList = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgBannerImgNm", imgPO);
                    // parameter와 비교
                    List<String> existImgNm = new ArrayList<>();
                    for (String pcBannerImgNm : po.getPcBannerImgNmArr()) {
                        if(ctgImgPOList.contains(pcBannerImgNm)) {
                            existImgNm.add(pcBannerImgNm);
                        }
                    }

                    imgPO.setExistImgNm(existImgNm.toArray(new String[0]));
                    // DB에 존재하지 않는 이름의 이미지는 삭제
                    List<CtgImgPO> delImgList = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectNotExistImg", imgPO);
                    for(CtgImgPO delImg : delImgList) {
                        String delFilePath = SiteUtil.getSiteUplaodRootPath() + File.separator +
                                UploadConstants.PATH_CTG + delImg.getImgPath() + File.separator + delImg.getImgNm();
                        File file = new File(delFilePath);
                        file.delete();

                        proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteNotExistImg", delImg);
                    }

                    // 새로 요청된 이미지 저장
                    String filePath = SiteUtil.getSiteUplaodRootPath() + File.separator +
                            UploadConstants.PATH_CTG + File.separator +
                            UploadConstants.PATH_BANNER + File.separator +
                            deviceTypeNmArr[i] + File.separator +
                            po.getCtgNo();
                    String deviceType = deviceTypeNmArr[i].length() > 2 ? deviceTypeNmArr[i].substring(0,3) : deviceTypeNmArr[i];
                    List<FileVO> fileList = getFileListFromRequest(request, filePath, deviceType);
                    // DB에 이미지 정보 저장
                    if (fileList != null) {
                        int ctgImgNo = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectNewCtgImgNo");
                        for (FileVO fileVO : fileList) {
                            imgPO.setCtgImgNo(String.valueOf(ctgImgNo));
                            imgPO.setImgPath(fileVO.getFilePath());
                            imgPO.setImgNm(fileVO.getFileName());
                            imgPO.setOrgImgNm(fileVO.getFileOrgName());
                            imgPO.setRegrNo(po.getRegrNo());
                            proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertCtgBannerImg", imgPO);
                            ctgImgNo++;
                        }
                    }
                }
            } else {
                List<String> dispNoList = new ArrayList<>();
                dispNoList.add(po.getCtgDispzoneNo());
                po.setDispNoList(dispNoList);
                // 전시상품 기존 정보 삭제
                proxyDao.update(MapperConstants.CATEGORY_MANAGE + "deleteCtgDispGoods", po);
                // 새로운 전시상품 정보 등록
                if(po.getGoodsNoArr() != null && po.getGoodsNoArr().length > 0) {
                    int sortSeq = 1;
                    for (String goodsNo : po.getGoodsNoArr()) {
                        po.setSortSeq(String.valueOf(sortSeq));
                        po.setDispZoneGoods(goodsNo);
                        proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertCatagoryDisplayGoods", po);
                        sortSeq++;
                    }
                }
            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));


//        	File file;
//            File ofile;
//            File dfile;
//            // 파일 정보 vo
//            CategoryVO fileFath = new CategoryVO();
//            CategorySO so = new CategorySO();
//
//            // 디폴트 이미지 파일 삭제여부
//            String dftImgDelYn = "N";
//            // 마우스오버 이미지 파일 삭제여부
//            String moverImgDelYn = "N";
//
//            // 디폴트 이미지 사용자가 삭제 했는지 여부
//            if (("Y").equals(po.getDftDelYn())) {
//                dftImgDelYn = "Y";
//                po.setCtgImgNm("");
//                po.setCtgImgPath("");
//            }
//            // 마우스오버 이미지 사용자가 삭제 했는지 여부
//            if (("Y").equals(po.getMoverDelYn())) {
//                moverImgDelYn = "Y";
//                po.setMouseoverImgNm("");
//                po.setMouseoverImgPath("");
//            }
//
//            so.setSiteNo(po.getSiteNo());
//            so.setCtgNo(po.getCtgNo());
//
//            // 파일 정보 조회(새로운 파일이 있을 경우에만 삭제)
//            fileFath = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectCategory", so);
//
//            String newfilePathNm = DateUtil.getNowDate();
//            String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)+ File.separator + newfilePathNm.substring(6);
//
//            // 카테고리 디폴트 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
//            if (po.getDftFilePath() != null && po.getDftFilePath() != "") {
//
//                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_CTG, newfilePath,po.getDftFileName()));
//
//                ofile = new File(FileUtil.getTempPath() + File.separator + po.getDftFilePath() + File.separator+ po.getDftFileName());
//
//                if (!file.getParentFile().exists()) {
//                    file.getParentFile().mkdirs();
//                }
//
//                log.debug("원본파일 : {}", ofile);
//                log.debug("대상파일 : {}", file);
//
//                FileUtil.move(ofile, file);
//
//                // po.setCtgNmImgPath(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.TYPE_CTG,
//                // po.getDftFilePath(), po.getDftFileName()));
//
//                po.setCtgImgPath(newfilePathNm);
//                po.setCtgImgNm(po.getDftFileName());
//
//                dftImgDelYn = "Y";
//            }
//
//            // 카테고리 마우스오버 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
//            if (po.getMoverFilePath() != null && po.getMoverFilePath() != "") {
//
//                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_CTG, newfilePath,po.getMoverFileName()));
//
//                ofile = new File(FileUtil.getTempPath() + File.separator + po.getMoverFilePath() + File.separator+ po.getMoverFileName());
//
//                if (!file.getParentFile().exists()) {
//                    file.getParentFile().mkdirs();
//                }
//
//                log.debug("원본파일 : {}", ofile);
//                log.debug("대상파일 : {}", file);
//
//                FileUtil.move(ofile, file);
//
//                po.setMouseoverImgPath(newfilePathNm);
//                po.setMouseoverImgNm(po.getMoverFileName());
//
//                moverImgDelYn = "Y";
//            }
//
//            /*----------에디터 처리 start-----------*/
//
//            /*// 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
//            editorService.setEditorImageToService(po, po.getCtgNo(), "TG_CTG");
//
//            // 에디터 내용의 업로드 이미지 정보 변경
//            log.debug("변경전 내용 : {}", po.getContent());
//
//            po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
//            po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
//            log.debug("변경한 내용 : {}", po.getContent());
//
//            // 파일 구분세팅 및 파일명 세팅
//            FileUtil.setEditorImageList(po, "TG_CTG", po.getAttachImages());
//            log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());
//
//            // 파일 정보 디비 저장
//            for (CmnAtchFilePO p : po.getAttachImages()) {
//                if (p.getTemp()) {
//                    p.setRefNo(po.getCtgNo()); // 참조의 번호(게시판 번호, 팝업번호 등...)
//                    editorService.insertCmnAtchFile(p);
//                }
//            }*/
//
//            // 임시 경로의 이미지 삭제
//            //FileUtil.deleteEditorTempImageList(po.getAttachImages());
//
//            /*----------에디터 처리 end-----------*/
//
//            if (po.getCtgMainUseYn() == null || po.getCtgMainUseYn() == "") {
//                po.setCtgMainUseYn("N");
//            }
//
//            if (po.getNavigExpsYn() == null || po.getNavigExpsYn() == "") {
//                po.setNavigExpsYn("Y");
//            }
//            if (po.getBestBrandUseYn()==null || !po.getBestBrandUseYn().equals("Y")) {
//                po.setBestBrandUseYn("N");
//
//            }
//
//            // 메인노출 순번 정렬 처리
//            /*if("Y".equals(po.getMainExpsYn())){
//            	CategoryPO mpo = new CategoryPO();
//            	mpo.setSiteNo(po.getSiteNo());
//            	int mainExpsSeq = po.getMainExpsSeq();
//            	List<CategoryVO> mainExpsList = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectMainExpsList", po);
//
//            	int idx = 1;
//            	for(int i=0; i<mainExpsList.size();i++) {
//
//            		if(idx == mainExpsSeq) {
//            			mpo.setCtgNo(po.getCtgNo());
//            			mpo.setMainExpsSeq(idx);
//
//            			proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateMainExpsSort", mpo);
//
//            			idx++;
//            		}
//
//            		mpo.setCtgNo(mainExpsList.get(i).getCtgNo());
//            		mpo.setMainExpsSeq(idx);
//
//        	        proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateMainExpsSort", mpo);
//
//        	        idx++;
//            	}
//
//            }*/
//
//            // 카테고리 정보 수정
//            proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateCatagory", po);
//
//            /*// 카테고리 수수료 하위카테고리 적용
//            if(po.getSubCtgCmsRateApplyYn()!=null && !po.getSubCtgCmsRateApplyYn().equals("")){
//                proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateSubCtgCmsRate", po);
//            }
//
//            // 추천인 (카테고리 수수료 하위카테고리 적용)
//            if(po.getSubCtgRecomPvdRateApplyYn()!=null && !po.getSubCtgRecomPvdRateApplyYn().equals("")){
//                proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateSubRecomPvdRate", po);
//            }
//
//            // 마켓포인트 지급 (카테고리 수수료 하위카테고리 적용)
//            if(po.getSubCtgSvmnApplyYn()!=null && !po.getSubCtgSvmnApplyYn().equals("")){
//                proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateSubCtgSvmnRate", po);
//            }
//
//            // 마켓포인트 사용제한(카테고리 수수료 하위카테고리 적용)
//            if(po.getSubCtgMaxUseRateApplyYn()!=null && !po.getSubCtgMaxUseRateApplyYn().equals("")){
//                proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateSubMaxUseRate", po);
//            }
//
//            // 카테고리 등록상품 수수료율 조정 후 공급가 재설정
//            proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateSupplyPrice", po);*/
//
//            // 디폴트 이미지 삭제
//            if (("Y").equals(dftImgDelYn)) {
//                if (fileFath.getCtgImgPath() != null && fileFath.getCtgImgPath().length() > 0) {
//                    // 등록되어 있는 파일정보
//                    dfile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
//                            + UploadConstants.PATH_CTG + File.separator + fileFath.getCtgImgPath().substring(0, 4)
//                            + File.separator + fileFath.getCtgImgPath().substring(4, 6) + File.separator
//                            + fileFath.getCtgImgPath().substring(6) + File.separator + fileFath.getCtgImgNm()));
//
//                    // 등록되어 있는 파일 삭제
//                    if (dfile.exists()) {
//                        log.debug("삭제 파일 정보 :{}", dfile);
//                        dfile.delete();
//                    }
//                }
//            }
//
//            // 마우스오버 이미지 삭제
//            if (("Y").equals(moverImgDelYn)) {
//                if (fileFath.getMouseoverImgPath() != null && fileFath.getMouseoverImgPath().length() > 0) {
//                    // 등록되어 있는 파일정보
//                    dfile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
//                            + UploadConstants.PATH_CTG + File.separator + fileFath.getMouseoverImgPath().substring(0, 4)
//                            + File.separator + fileFath.getMouseoverImgPath().substring(4, 6) + File.separator
//                            + fileFath.getMouseoverImgPath().substring(6) + File.separator
//                            + fileFath.getMouseoverImgNm()));
//
//                    // 등록되어 있는 파일 삭제
//                    if (dfile.exists()) {
//                        log.debug("삭제 파일 정보 :{}", dfile);
//                        dfile.delete();
//                    }
//                }
//            }
//
//            // 프론트 캐시 갱신
//            //adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
//            //adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());
//
//            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<CategoryDisplayManagePO> updateCatagoryDisplayManage(CategoryDisplayManagePO po) {

        // 카테고리 전시zone 번호
        String ctgDispzoneNo = po.getCtgDispzoneNoArr();
        // 전시zone 명
        String dispzoneNm = po.getDispzoneNmArr();
        // 전시 zone 사용 여부
        String ctgDispzoneUseYn = po.getUseYnArray()[5];
        // 전시 zone 전시 유형 코드
        String ctgDispDispTypeCdArr;

        String[] dispZoneGoodsArr = po.getDispZoneGoods6();

        // 이미지 꾸미기 사용 여부 코드
        String ctgExhbtionCdArr;

        // 카테고리 전시ZONE 진열유형코드
        ctgExhbtionCdArr = po.getCtgExhbtionTypeCd6() == null ? "1" : po.getCtgExhbtionTypeCd6();
        
        // 주력제품
        if (po.getDispZoneGoods6() != null) {
            dispZoneGoodsArr = po.getDispZoneGoods6();
        }

        ctgDispDispTypeCdArr = po.getCtgDispDispTypeCd6() == null ? "" : po.getCtgDispDispTypeCd6();

        // 입력된 전시존 명 갯수만큼 데이터 입력(max 5)

        po.setCtgExhbtionTypeCd(ctgExhbtionCdArr);

        po.setCtgDispDispTypeCd(ctgDispDispTypeCdArr);

        po.setDispzoneNm(dispzoneNm == null ? "" : dispzoneNm);
        // if (dispzoneNm[i] != null && dispzoneNm[i] != "") {
        // }

        // 사용 여부 값 set
        if (ctgDispzoneUseYn != null && ctgDispzoneUseYn != "") {
            if (ctgDispzoneUseYn.equals("Y")) {
                po.setUseYn(ctgDispzoneUseYn);
            } else {
                po.setUseYn("N");
            }
        } else {
            po.setUseYn("N");
        }

        // 기존 전시존 수정 인 경우
        if (ctgDispzoneNo != null && !ctgDispzoneNo.equals("")) {
            po.setCtgDispzoneNo(ctgDispzoneNo);

            // 카테고리 전시존 정보 수정
            proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateCatagoryDisplayManage", po);

            // 카테고리 전시존 상품들 삭제(수정 및 추가인 경우 삭제 후 모든 데이터 재 등록)
            proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteCatagoryDisplayGoods", po);
        }
        // 새로 추가된 전시존 설정
        else {
            // if (dispzoneNm[i] != null && dispzoneNm[i] != "") {
            proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertCatagoryDisplayManage", po);

            Integer result = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectCtgDispzoneNo", po);
            po.setCtgDispzoneNo(Integer.toString(result));
            // }
        }

        // 카테고리 전시ZONE 상품 등록
        if (dispZoneGoodsArr != null) {
            int goodsCnt = 0;

            // 전시타입별 등록 가능한 상품 갯수
            switch (po.getCtgDispDispTypeCd() == null ? "01" : po.getCtgDispDispTypeCd()) {
            case "01":
                goodsCnt = 100;
                break;
            case "03":
                goodsCnt = 4;
                break;
            case "04":
                goodsCnt = 6;
                break;
            case "05":
                goodsCnt = 2;
                break;
            }
            int limitNum = 0;

            String[] goodsArr = dispZoneGoodsArr;

            if (goodsArr.length > goodsCnt) {
                limitNum = goodsCnt;
            } else {
                limitNum = goodsArr.length;
            }

            for (int j = 0; j < limitNum; j++) {
                po.setDispZoneGoods(goodsArr[j]);
                int sortSeq = j+1;
                po.setSortSeq(sortSeq);
                proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertCatagoryDisplayGoods", po);
            }
        }


        ResultModel<CategoryDisplayManagePO> result = new ResultModel<>();

        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    @Override
    public ResultModel<CategoryPO> insertCategory(CategoryPO po) {
        ResultModel<CategoryPO> result = new ResultModel<>();
        Long ctgNo = (long) 0;
        try {
            ctgNo = bizService.getSequence("CTG_NO", po.getSiteNo());

            po.setCtgNo(String.valueOf(ctgNo));
            proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertCategory", po);

            // 프론트 캐시 갱신
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            adminRemotingService.refreshGnbInfo(po.getSiteNo(), request.getServerName());
            adminRemotingService.refreshLnbInfo(po.getSiteNo(), request.getServerName());*/

            result.setSuccess(true);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (Exception e) {
        	e.printStackTrace();

            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }
        return result;
    }

    @Override
    public List<CategoryDisplayManageVO> selectCtgDispMngList(CategoryDisplayManageSO categoryDisplayManageSO) {

        List<CategoryDisplayManageVO> list = proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgDispMngList", categoryDisplayManageSO);

        List<CategoryDisplayManageVO> resultList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            CategoryDisplayManageVO vo = new CategoryDisplayManageVO();
            vo = list.get(i);

            // if (vo.getCtgDispzoneImgPath() != null && ("").equals(vo.getCtgDispzoneImgPath())) {
            if (vo.getCtgDispzoneImgPath() != null && vo.getCtgDispzoneImgPath().length() > 0) {
                // 이미지 파일 가로, 세로 크기
                Image img = new ImageIcon(FileUtil.getPath(UploadConstants.PATH_IMAGE + File.separator
                        + UploadConstants.PATH_CTG + File.separator + vo.getCtgDispzoneImgPath().substring(0, 4)
                        + File.separator + vo.getCtgDispzoneImgPath().substring(4, 6) + File.separator
                        + vo.getCtgDispzoneImgPath().substring(6) + File.separator + vo.getCtgDispzoneImgNm()))
                                .getImage();
                vo.setCtgDispzoneImgWidth(Integer.toString(img.getWidth(null)));
                vo.setCtgDispzoneImgHeight(Integer.toString(img.getHeight(null)));
            } else {
                vo.setCtgDispzoneImgWidth("000");
                vo.setCtgDispzoneImgHeight("000");
            }

            resultList.add(i, vo);
        }

        return resultList;
    }

    @Override
    public List<GoodsVO> selectCtgDispGoodsList(CategoryDisplayManageSO categoryDisplayManageSO) {

        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgDispGoodsList", categoryDisplayManageSO);
    }

    // @Override
    // public List<DisplayGoodsVO> selectCtgGoodsList(CategorySO so) {
    // return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectCtgGoodsList", so);
    // }

    // @Override
    // public ResultModel<CategoryPO> updateCtgGoodsDispYn(CategoryPO po) {
    // ResultModel<CategoryPO> result = new ResultModel<>();
    //
    // proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateCtgGoodsDispYn", po);
    //
    // result.setMessage(MessageUtil.getMessage("biz.common.update"));
    // return result;
    // }

    // @Override
    // public ResultModel<CategoryPO> updateCtgShowGoodsManage(CategoryPO po) {
    // ResultModel<CategoryPO> result = new ResultModel<>();
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
    // // 카테고리 상품 삭제 후 노출 우선 순위에 따라 Insert
    // proxyDao.delete(MapperConstants.CATEGORY_MANAGE + "deleteShowGoods", po);
    //
    // String[] goodsNoArr = po.getGoodsNoArr();
    // String[] dispYnArr = po.getDispYnArr();
    // String[] dlgtCtgYnArr = po.getDlgtCtgYnArr();
    // for (int i = 0; i < goodsNoArr.length; i++) {
    // po.setGoodsNo(goodsNoArr[i]);
    // po.setDispYn(dispYnArr[i]);
    // po.setDlgtCtgYn(dlgtCtgYnArr[i]);
    // po.setExpsPriorRank(Integer.toString(i + 1));
    //
    // proxyDao.insert(MapperConstants.CATEGORY_MANAGE + "insertShowGoods", po);
    // }
    // }
    //
    // proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateCtgShowGoodsManage", po);
    //
    // result.setMessage(MessageUtil.getMessage("biz.common.update"));
    // return result;
    // }

    /** 전체카테고리 목록을 조회 **/
    @Override
    @Transactional(readOnly = true)
    public List<CategoryVO> selectFrontGnbList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectFrontGnbList", siteNo);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<CategoryVO> selectFrontLnbList(Long siteNo) {
        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectFrontLnbList", siteNo);
    }

    /** 네이게이션 (하위에서 상위조회) **/
    @Override
    @Transactional(readOnly = true)
    public List<CategoryVO> selectUpNavagation(CategorySO so) {
        CategoryVO cv = new CategoryVO();// 카테고리 정보 조회(상위카테고리 조회시 카테고리 레벨필요)
        cv = proxyDao.selectOne(MapperConstants.CATEGORY_MANAGE + "selectNavigationInfo", so);
        so.setCtgNm(cv.getCtgNm());
        so.setCtgLvl(cv.getCtgLvl());
        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectUpNavagation", so);
    }

    /** 동일 상위,레벨 카테고리 조회 **/
    @Override
    @Transactional(readOnly = true)
    public List<CategoryVO> selectNavigationList(CategorySO so) {
        return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectNavigationList", so);
    }
    
    @Override
    public ResultModel<CategoryPO> updateCatagorySort(CategoryPO po) {
        ResultModel<CategoryPO> result = new ResultModel<>();
        try {
	        // 순번 초기화
	        proxyDao.update(MapperConstants.CATEGORY_MANAGE + "catagorySortInit", po);
	        
	        // 선택 카테고리 순번 업데이트
	        proxyDao.update(MapperConstants.CATEGORY_MANAGE + "updateCatagorySort", po);
	        
	        // 순번 재정렬
	        proxyDao.update(MapperConstants.CATEGORY_MANAGE + "catagorySortSetting", po);

            // 상품군 변경
            proxyDao.update(MapperConstants.CATEGORY_MANAGE + "catagoryGoodsTypeCdSetting", po);

	        // 하위 카테고리 LEVEL 재정렬
	        if(!"".equals(po.getDownCtgNo())) {	// 하위 카테고리가 존재할 경우
		        int orgLvl = Integer.parseInt(po.getOrgCtgLvl()); // 기존 LEVEL
		        int newLvl = Integer.parseInt(po.getCtgLvl());	  // 변경 LEVEL
		        int calcLvl = newLvl - orgLvl; // 이동한 LEVEL
		        
		        if(calcLvl != 0) {
		        	po.setCalcLvl(calcLvl);
		        	proxyDao.update(MapperConstants.CATEGORY_MANAGE + "catagoryLvlSetting", po);
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
    public List<CategoryVO> selectMainDispGoodsList(CategoryPO categoryPO) {
    	return proxyDao.selectList(MapperConstants.CATEGORY_MANAGE + "selectMainDispGoodsList", categoryPO);
    }

    private List<FileVO> getFileListFromRequest(HttpServletRequest request, String targetPath, String deviceType) {
        MultipartHttpServletRequest mRequest;
        if (request instanceof MultipartHttpServletRequest) {
            mRequest = (MultipartHttpServletRequest) request;
        } else {
            return null;
        }

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        Iterator<String> fileIter = mRequest.getFileNames();
        List<FileVO> fileVOList = new ArrayList<>();
        String fileOrgName;
        String extension;
        String fileName;
        File file;
        String path = "";
        List<MultipartFile> files;
        FileVO fileVO;
        String filedName;

        try {
            while (fileIter.hasNext()) {
                filedName = fileIter.next();
                if(filedName.contains(deviceType)) {
                    files = mRequest.getMultiFileMap().get(filedName);
                    for (MultipartFile mFile : files) {
                        fileOrgName = mFile.getOriginalFilename();
                        extension = FilenameUtils.getExtension(fileOrgName);

                        fileName = System.currentTimeMillis() + "_" + filedName.split("_")[1] + "." + extension;
                        file = new File(targetPath + path + File.separator + fileName);

                        if (!file.getParentFile().exists()) {
                            file.getParentFile().mkdirs();
                        }

                        log.debug("원본파일 : {}", mFile);
                        log.debug("대상파일 : {}", file);
                        mFile.transferTo(file);
                        fileVO = new FileVO();
                        fileVO.setFileExtension(extension);
                        fileVO.setFileOrgName(fileOrgName);
                        fileVO.setFileSize(mFile.getSize());
                        fileVO.setFileType(mFile.getContentType());
                        fileVO.setFilePath(targetPath.split("category")[1]);
                        fileVO.setFileName(fileName);
                        fileVOList.add(fileVO);
                    }
                }
            }

        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return fileVOList;
    }
}
