package net.danvi.dmall.biz.app.goods.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.*;
import dmall.framework.common.util.*;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.FreebieImageDtlPO;
import net.danvi.dmall.biz.app.goods.model.FreebieImageDtlVO;
import net.danvi.dmall.biz.app.goods.model.FreebieImageInfoVO;
import net.danvi.dmall.biz.app.goods.model.FreebiePO;
import net.danvi.dmall.biz.app.goods.model.FreebieSO;
import net.danvi.dmall.biz.app.goods.model.FreebieVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 12.
 * 작성자     : dong
 * 설명       : 사은품 구현 클래스
 * </pre>
 */
@Slf4j
@Service("freebieManageService")
@Transactional(rollbackFor = Exception.class)
public class FreebieManageServiceImpl extends BaseService implements FreebieManageService {
    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /** 사은품 이미지 업로드 경로 */
    @Value("#{system['system.upload.freebie.image.path']}")
    private String freebieImageFilePath;

    /** 사은품 이미지 임시 업로드 경로 */
    @Value("#{system['system.upload.freebie.temp.image.path']}")
    private String freebieTempImageFilePath;

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Resource(name = "bizService")
    private BizService bizService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 목록 조회.
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<FreebieVO> selectFreebieList(FreebieSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultListModel<FreebieVO> resultModel = new ResultListModel<>();
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        resultModel = proxyDao.selectListPage(MapperConstants.FREEBIE_MANAGE + "selectFreebieListPaging", so);
        for (int i = 0; i < resultModel.getResultList().size(); i++){
            FreebieVO freebieVO = (FreebieVO) resultModel.getResultList().get(i);
            freebieVO.setFreebieImg("/image/image-view?type=FREEBIEDTL&id1=" + freebieVO.getImgPath() + "_" + freebieVO.getImgNm());
        }
        return resultModel;
    }

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 단건 조회.
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<FreebieVO> selectFreebieContents(FreebieSO so) throws Exception {
        FreebieVO resultVO = proxyDao.selectOne(MapperConstants.FREEBIE_MANAGE + "selectFreebieContents", so);

        if(resultVO.getFreebieDscrt() != null) {
            HttpServletRequest request = HttpUtil.getHttpServletRequest();
            resultVO.setFreebieDscrt(StringUtil.replaceAll(resultVO.getFreebieDscrt(), UploadConstants.IMAGE_EDITOR_URL, (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
        }

        ResultModel<FreebieVO> result = new ResultModel<FreebieVO>(resultVO);

        // 이미지 정보 조회 조건 세팅
        CmnAtchFileSO fileso = new CmnAtchFileSO();
        fileso.setSiteNo(so.getSiteNo());
        fileso.setRefNo(so.getFreebieNo());
        fileso.setFileGb("TG_FREEBIE");

        // 공통 첨부 파일 조회
        editorService.setCmnAtchFileToEditorVO(fileso, resultVO);

        // 사은품 이미지 조회
        FreebieImageDtlVO dlgtImgInfo = proxyDao.selectOne(MapperConstants.FREEBIE_MANAGE + "selectFreebieImageInfo", so);
        resultVO.setDlgtImg(dlgtImgInfo);

        result.setData(resultVO);
        return result;
    }

    /**
     * 작성자 : dong
     * 설명 : 사은품 등록 이미지 조회.
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<FreebieImageInfoVO> selectDefaultImageInfo(FreebieSO so) {
        ResultModel<FreebieImageInfoVO> resultModel = new ResultModel<>();
        FreebieImageInfoVO freebieImageInfoVO = proxyDao
                .selectOne(MapperConstants.FREEBIE_MANAGE + "selectGoodsSiteInfo", so);

        if (1 > freebieImageInfoVO.getGoodsDefaultImgWidth() || 1 > freebieImageInfoVO.getGoodsDefaultImgHeight()) {
            freebieImageInfoVO.setGoodsDefaultImgWidth(240);
            freebieImageInfoVO.setGoodsDefaultImgHeight(240);
        }

        if (1 > freebieImageInfoVO.getGoodsListImgWidth() || 1 > freebieImageInfoVO.getGoodsListImgHeight()) {
            freebieImageInfoVO.setGoodsListImgWidth(90);
            freebieImageInfoVO.setGoodsListImgHeight(90);
        }

        // 리턴모델에 VO셋팅
        resultModel.setData(freebieImageInfoVO);
        return resultModel;
    }

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 등록.
     */
    @Override
    public ResultModel<FreebiePO> insertFreebieContents(FreebiePO po, HttpServletRequest request) throws Exception {
        ResultModel<FreebiePO> result = new ResultModel<>();

        // 에디터 내용의 업로드 이미지 정보 변경
        this.editUploadPathReplace(po);

        // 사은품 데이터 저장
        proxyDao.insert(MapperConstants.FREEBIE_MANAGE + "insertFreebieContents", po);

        // 에디터 이미지 저장
        this.saveFreebieEditContents(po);

        // 대표 이미지 저장
        String filePath = SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE);

        List<FileVO> fileList = FileUtil.getFileListFromRequest(request, filePath);
        if(fileList != null) {
            for(FileVO p : fileList) {
                FreebieImageDtlPO filePo = new FreebieImageDtlPO();
                filePo.setFreebieNo(po.getFreebieNo());
                filePo.setFreebieImgType("01");
                filePo.setImgPath(p.getFilePath());
                filePo.setImgNm(p.getFileName());
                filePo.setOrgImgNm(p.getFileOrgName());
                proxyDao.insert(MapperConstants.FREEBIE_MANAGE + "insertFreebieImageDtl", filePo);
            }
        }

        // 등록성공 메세지 설정
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 수정.
     */
    @Override
    public ResultModel<FreebiePO> updateFreebieContents(FreebiePO po, HttpServletRequest request) throws Exception {
        ResultModel<FreebiePO> result = new ResultModel<>();
        // 에디터 내용의 업로드 이미지 정보 변경
        this.editUploadPathReplace(po);

        // 사은품 데이터 수정
        proxyDao.update(MapperConstants.FREEBIE_MANAGE + "updateFreebieContents", po);

        // 에디터 이미지 저장
        this.saveFreebieEditContents(po);

        // 기존 이미지 조회
        FreebieImageDtlVO dlgtImgInfo = proxyDao.selectOne(MapperConstants.FREEBIE_MANAGE + "selectFreebieImageInfo", po);

        // 기존 이미지와 업로드 이미지 비교
        if(dlgtImgInfo != null && !po.getUploadFileNm().equals(dlgtImgInfo.getOrgImgNm())) {
            proxyDao.delete(MapperConstants.FREEBIE_MANAGE + "deleteFreebieImageDtl", po);

            String delFilePath = SiteUtil.getSiteUplaodRootPath() + File.separator +
                    UploadConstants.PATH_IMAGE + File.separator +
                    UploadConstants.PATH_FREEBIE + File.separator +
                    dlgtImgInfo.getImgPath() + File.separator + dlgtImgInfo.getImgNm();
            File file = new File(delFilePath);
            file.delete();
        }

        // 대표 이미지 저장
        String filePath = SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE);

        List<FileVO> fileList = FileUtil.getFileListFromRequest(request, filePath);
        if(fileList != null) {
            for(FileVO p : fileList) {
                FreebieImageDtlPO filePo = new FreebieImageDtlPO();
                filePo.setFreebieNo(po.getFreebieNo());
                filePo.setFreebieImgType("01");
                filePo.setImgPath(p.getFilePath());
                filePo.setImgNm(p.getFileName());
                filePo.setOrgImgNm(p.getFileOrgName());
                proxyDao.insert(MapperConstants.FREEBIE_MANAGE + "insertFreebieImageDtl", filePo);
            }
        }

        // 수정성공 메세지 설정
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /**
     * 작성자 : dong
     * 설명 : 사은품 이미지 정보 저장.
     */
    @Override
    public ResultModel<FreebiePO> saveFreebieImage(FreebiePO po) throws Exception {
        List<FreebieImageDtlPO> freebieImageDtlList = po.getFreebieImageDtlList();
        ResultModel<FreebiePO> result = new ResultModel<>();
        // 이미지 상세 정보 등록
        if (freebieImageDtlList != null && freebieImageDtlList.size() > 0) {
            // 만약 사은품 이미지 개별수정이 존재한다면 기존에 존재했던 이미지를 먼저 삭제한다.(지우지 않으면 쓰레기 파일이 되기때문에)
            FreebieSO so = new FreebieSO();
            so.setFreebieNo(po.getFreebieNo());
            List<FreebieImageDtlVO> freebieImageInfoList = proxyDao.selectList(MapperConstants.FREEBIE_MANAGE + "selectFreebieImageInfo", so);

            for (FreebieImageDtlPO freebieImageDtl : freebieImageDtlList) {
                String tempFileNm = freebieImageDtl.getTempFileNm();

                if (!StringUtils.isEmpty(tempFileNm)) {
                    String splitImgNm = tempFileNm.split("_")[1];
                    String splitImgSize = tempFileNm.split("_")[2]; // 이미지 사이즈 ex) _110x110x01

                    for (int i = 0; i < freebieImageInfoList.size(); i++) {
                        FreebieImageDtlVO tempVo = freebieImageInfoList.get(i);
                        String tempSplitImgNm = tempVo.getImgNm().split("_")[0];
                        String tempSplitImgSize = tempVo.getImgNm().split("_")[1]; // 이미지 사이즈 ex) _110x110x01\

                        // 파일명이 다르고 이미지 사이즈가 같다면 사은품 이미지 수정이기 때문에 기존 이미지를 제거
                        if (!splitImgNm.equals(tempSplitImgNm) && splitImgSize.equals(tempSplitImgSize)) {
                            String targetPath = SiteUtil.getSiteUplaodRootPath()
                                    + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE,
                                            FileUtil.getDatePath(tempVo.getImgPath() + "_" + tempVo.getImgNm()));
                            File file = new File(targetPath);
                            FileUtil.delete(file);
                        }
                    }
                }
            }

            // 제거가 완료되었다면 신규 이미지 등록
            for (FreebieImageDtlPO freebieImageDtl : freebieImageDtlList) {
                String tempFileNm = freebieImageDtl.getTempFileNm();

                if (!StringUtils.isEmpty(tempFileNm)) {
                    String tempThumFileNm = tempFileNm.substring(0, tempFileNm.lastIndexOf("_"))
                            + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

                    proxyDao.insert(MapperConstants.FREEBIE_MANAGE + "insertFreebieImageDtl", freebieImageDtl);

                    // 임시 경로의 이미지를 실제 서비스 경로로 복사
                    this.copyFreebieImage(tempFileNm);
                    this.copyFreebieImage(tempThumFileNm);

                    deleteTempFreebieImageFile(freebieTempImageFilePath, tempFileNm);
                }
            }
        }

        result.setData(po);
        return result;
    }

    @Override
    public ResultModel<FreebiePO> updateCheckFreebie(FreebiePO po) throws Exception {
        ResultModel<FreebiePO> result = new ResultModel<>();

        proxyDao.update(MapperConstants.FREEBIE_MANAGE + "updateCheckFreebie", po);

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    @Override
    public String selectFreebieNo() {
        return proxyDao.selectOne(MapperConstants.FREEBIE_MANAGE + "selectFreebieNo");
    }

    @Override
    public String copyFreebieContents(FreebieSO so) throws Exception {
        // 새로운 사은품 번호 조회
        String newFreebieNo = this.selectFreebieNo();
        // 기존 사은품 데이터 조회
        ResultModel<FreebieVO> resultModel = this.selectFreebieContents(so);
        FreebieVO resultVO = resultModel.getData();
        // 에디터 이미지 복사
        if(resultVO.getAttachImages() != null && resultVO.getAttachImages().size() > 0) {
            for(EditorImageVO imageVO : resultVO.getAttachImages()) {
                String extension = FilenameUtils.getExtension(imageVO.getFileName());
                // 기본 이미지 복사
                String orgFilePath = SiteUtil.getSiteUplaodRootPath() +
                        FileUtil.getCombinedPath(
                                UploadConstants.PATH_IMAGE,
                                UploadConstants.PATH_EDITOR,
                                FileUtil.getDatePath(imageVO.getTempFileName()));
                File orgFile= new File(orgFilePath);

                String newFileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
                String newFilePath = FileUtil.getNowdatePath();
                File newFile = new File(SiteUtil.getSiteUplaodRootPath() +
                        FileUtil.getCombinedPath(
                                UploadConstants.PATH_IMAGE,
                                UploadConstants.PATH_EDITOR,
                                newFilePath, newFileName));

                FileUtil.copy(orgFile, newFile);
                // 썸네일 이미지 복사
                String orgThumbFilePath = orgFilePath + CommonConstants.IMAGE_THUMBNAIL_PREFIX;
                File orgThumbFile = new File(orgThumbFilePath);

                String newThumbFilePath = newFile.getPath() + CommonConstants.IMAGE_THUMBNAIL_PREFIX;
                File newThumbFile = new File(newThumbFilePath);

                FileUtil.copy(orgThumbFile, newThumbFile);
                // 복사한 에디터 이미지 정보 DB 저장
                CmnAtchFilePO po = new CmnAtchFilePO();
                po.setSiteNo(so.getSiteNo());
                po.setRefNo(newFreebieNo);
                po.setFileGb("TG_FREEBIE");
                po.setFilePath(StringUtil.replaceAll(newFilePath, "/", ""));
                po.setOrgFileNm(imageVO.getFileName());
                po.setFileNm(newFileName);
                po.setFileSize(imageVO.getFileSize());
                po.setRegrNo(resultVO.getRegrNo());
                editorService.insertCmnAtchFile(po);
                // 복사한 이미지로 사은품 상세 내용 변경
                resultVO.setFreebieDscrt(StringUtil.replaceAll(resultVO.getFreebieDscrt(), imageVO.getImageUrl(),
                        UploadConstants.IMAGE_EDITOR_URL + StringUtil.replaceAll(newFilePath, "/", "") + "_" + newFileName));
            }
        }
        // 사은품 정보 복사
        FreebiePO po = new FreebiePO();
        po.setFreebieNo(newFreebieNo);
        po.setSiteNo(resultVO.getSiteNo());
        po.setFreebieNm(resultVO.getFreebieNm());
        po.setFreebieDscrt(resultVO.getFreebieDscrt());
        po.setUseYn(resultVO.getUseYn());
        po.setRegrNo(resultVO.getRegrNo());
        proxyDao.insert(MapperConstants.FREEBIE_MANAGE + "insertFreebieContents", po);
        // 대표 이미지 복사
        if(resultVO.getDlgtImg() != null) {
            FreebieImageDtlVO dlgtImg = resultVO.getDlgtImg();

            String extension = FilenameUtils.getExtension(dlgtImg.getImgNm());
            String newFileName = System.currentTimeMillis() + "." + extension;
            String newFilePath = FileUtil.getNowdatePath();
            File newFile = new File(SiteUtil.getSiteUplaodRootPath() +
                    FileUtil.getCombinedPath(
                            UploadConstants.PATH_IMAGE,
                            UploadConstants.PATH_FREEBIE,
                            newFilePath,
                            newFileName));

            String orgFilePath = SiteUtil.getSiteUplaodRootPath() +
                    FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE) +
                    dlgtImg.getImgPath() + File.separator + dlgtImg.getImgNm();
            File orgFile = new File(orgFilePath);

            FileUtil.copy(orgFile, newFile);

            FreebieImageDtlPO imgPo = new FreebieImageDtlPO();
            imgPo.setFreebieNo(newFreebieNo);
            imgPo.setFreebieImgType("01");
            imgPo.setImgPath(File.separator + newFilePath);
            imgPo.setImgNm(newFileName);
            imgPo.setOrgImgNm(dlgtImg.getOrgImgNm());
            proxyDao.insert(MapperConstants.FREEBIE_MANAGE + "insertFreebieImageDtl", imgPo);
        }

        return newFreebieNo;
    }

    /**
     * 작성자 : dong
     * 설명 : 사은품 정보 삭제.
     */
    @Override
    public ResultModel<FreebiePO> deleteFreebieContents(FreebiePO po) throws Exception {
        ResultModel<FreebiePO> result = new ResultModel<>();
        // 첨부된 에디터 파일이 존재한다면 삭제
//        this.deleteFreebieEditImage(po);

        // 첨부된 사은품 이미지파일이 존재한다면 삭제
//        this.deleteFreebieImage(po);

        // 쿼리 삭제
        proxyDao.update(MapperConstants.FREEBIE_MANAGE + "deleteFreebieContents", po);

        // 삭제성공 메세지 설정
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    private void editUploadPathReplace(FreebiePO po) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        po.setFreebieDscrt(StringUtil.replaceAll(po.getFreebieDscrt(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setFreebieDscrt(StringUtil.replaceAll(po.getFreebieDscrt(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 14.
     * 작성자 : dong
     * 설명   : 사은품 설명 저장 서비스 *
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 14. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    private void saveFreebieEditContents(FreebiePO po) throws Exception {
        String refNo = po.getFreebieNo();

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, refNo, "TG_FREEBIE");

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "TG_FREEBIE", po.getAttachImages());

        // 기존 등록된 파일명이 존재한다면 DB에 중복데이터가 또 입력되는걸 방지 하기위한 이중 Loop
        CmnAtchFileSO cso = new CmnAtchFileSO();
        cso.setSiteNo(po.getSiteNo());
        cso.setRefNo(po.getFreebieNo());
        cso.setFileGb("TG_FREEBIE");
        List<CmnAtchFilePO> getCmnAtchFileList = editorService.getCmnAtchFileList(cso);

        // 수정시 기존등록된 이미지 정보를 중복으로 또 등록하지 않기위한 Loop
        if (getCmnAtchFileList.size() > 0) {
            for (int i = 0; i < getCmnAtchFileList.size(); i++) {
                CmnAtchFilePO tempPo1 = getCmnAtchFileList.get(i);

                for (int j = 0; j < po.getAttachImages().size(); j++) {
                    CmnAtchFilePO tempPo2 = po.getAttachImages().get(j);

                    if (tempPo1.getFileNm().equals(tempPo2.getFileNm())) {
                        po.getAttachImages().remove(j);
                    }
                }
            }
        }

        for (CmnAtchFilePO p : po.getAttachImages()) {
            p.setSiteNo(po.getSiteNo());
            p.setRefNo(refNo);
            p.setFileGb("TG_FREEBIE");
            editorService.insertCmnAtchFile(p);
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : 사은품 에디터 이미지 파일 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    private void deleteFreebieEditImage(FreebiePO po) throws Exception {
        CmnAtchFileSO cso = new CmnAtchFileSO();
        cso.setSiteNo(po.getSiteNo());
        cso.setRefNo(po.getFreebieNo());
        cso.setFileGb("TG_FREEBIE");
        List<CmnAtchFilePO> atchFileList = editorService.getCmnAtchFileList(cso);

        for (int i = 0; i < atchFileList.size(); i++) {
            CmnAtchFilePO tempPo = atchFileList.get(i);
            tempPo.setRefNo(po.getFreebieNo());
            tempPo.setSiteNo(po.getSiteNo());
            editorService.deleteCmnAtchFileByFileNm(tempPo);
            FileUtil.deleteEditorImage(tempPo.getFilePath() + "_" + tempPo.getFileNm()); // 원본이미지
            FileUtil.deleteEditorImage(tempPo.getFilePath() + "_" + tempPo.getFileNm() + CommonConstants.IMAGE_THUMBNAIL_PREFIX); // 썸네일이미지
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 사은품 이미지 파일 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    private void deleteFreebieImage(FreebiePO po) throws Exception {
        // 실제 이미지 파일 삭제
        FreebieSO so = new FreebieSO();
        so.setFreebieNo(po.getFreebieNo());
        List<FreebieImageDtlVO> freebieImageInfoList = proxyDao
                .selectList(MapperConstants.FREEBIE_MANAGE + "selectFreebieImageInfo", so);

        for (int i = 0; i < freebieImageInfoList.size(); i++) {
            FreebieImageDtlVO tempVo = freebieImageInfoList.get(i);
            reaulDeleteFreebieImage(tempVo.getImgPath() + "_" + tempVo.getImgNm()); // 원본이미지
        }

        // DB에서 데이터 삭제
        proxyDao.delete(MapperConstants.FREEBIE_MANAGE + "deleteFreebieImageDtl", po);
    }

    private void loadFreebieImage(FreebieSO so, FreebieVO resultVO) {
        List<FreebieImageDtlVO> freebieImageInfoList = proxyDao
                .selectList(MapperConstants.FREEBIE_MANAGE + "selectFreebieImageInfo", so);
        long prevImgFreebieNo = -1;
        Map<String, Object> imgSetMap = null;
        Map<String, Object> imgDtlMap = null;
        List<Map<String, Object>> imgSetList = new ArrayList<>();
        List<Map<String, Object>> imgDtlList = null;

        for (FreebieImageDtlVO freebieImageInfo : freebieImageInfoList) {
            long freebieNo = freebieImageInfo.getFreebieNo();
            if (prevImgFreebieNo != freebieNo) {
                imgSetMap = new HashMap<>();
                imgSetMap.put("freebieNo", freebieImageInfo.getFreebieNo());

                imgDtlList = new ArrayList<>();
                imgSetMap.put("freebieImageDtlList", imgDtlList);
                imgSetList.add(imgSetMap);
                prevImgFreebieNo = freebieImageInfo.getFreebieNo();
            }

            if (imgSetList != null && imgSetList.size() > 0) {
                Map<String, Object> targetMap = null;
                for (Map<String, Object> imgSet : imgSetList) {
                    if (freebieNo == (long) imgSet.get("freebieNo")) {
                        targetMap = imgSet;
                        break;
                    }
                }
                imgDtlMap = new HashMap<>();
                imgDtlMap.put("freebieImgType", freebieImageInfo.getFreebieImgType());
                imgDtlMap.put("imgPath", freebieImageInfo.getImgPath());
                imgDtlMap.put("imgNm", freebieImageInfo.getImgNm());
                imgDtlMap.put("imgWidth", freebieImageInfo.getImgWidth());
                imgDtlMap.put("imgHeight", freebieImageInfo.getImgHeight());

                imgDtlMap.put("imgUrl", CommonConstants.IMAGE_TEMP_FREEBIE_URL + freebieImageInfo.getImgPath() + "_"
                        + freebieImageInfo.getImgNm());
                if (null != freebieImageInfo.getImgNm()) {
                    String imgNm = freebieImageInfo.getImgNm();
                    String fileNm = imgNm.substring(0, imgNm.lastIndexOf("_"))
                            + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX;

                    imgDtlMap.put("thumbUrl",
                            "/image/image-view?type=FREEBIEDTL&id1=" + freebieImageInfo.getImgPath() + "_" + fileNm);
                }

                List<Map<String, Object>> tempImgDtlList = (List<Map<String, Object>>) targetMap
                        .get("freebieImageDtlList");
                if (tempImgDtlList != null) {
                    tempImgDtlList.add(imgDtlMap);
                }
            }
        }
        resultVO.setFreebieImageSetList(imgSetList);
    }

    private static void deleteTempFreebieImageFile(String path, String tempFileNm) throws Exception {
        FileUtil.deleteTempFile(tempFileNm); // 이미지 삭제
        // 섬네일 삭제
        // FileUtil.deleteEditorTempImage(
        // tempFileNm.substring(0, tempFileNm.lastIndexOf("_")) +
        // CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 등록한 사은품 이미지 파일을 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @throws Exception
     */
    private void reaulDeleteFreebieImage(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE,
                FileUtil.getDatePath(fileName));
        File file = new File(targetPath);
        log.debug("등록한 사은품 이미지 파일을 삭제: {}", file);
        FileUtil.delete(file);

        // 쓰레기 썸네일 이미지 파일이 존재하면 제거
        File thumbnailFile = new File(targetPath.split("_")[0] + CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);
        if (thumbnailFile.exists()) {
            FileUtil.delete(thumbnailFile);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 임시경로의 사은품이미지를 실제 운영 경로로 복사(FileUtil에다 만들고싶었으나 내마음대로 추가하면 안될거 같기에 이곳에..)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @param fileName
     * @throws Exception
     */
    private void copyFreebieImage(String fileName) throws Exception {
        String path = SiteUtil.getSiteUplaodRootPath();
        String targetPath = path + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE);
        File orgFile = new File(
                path + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, FileUtil.getDatePath(fileName)));

        if (!orgFile.exists()) {
            log.debug("소스 파일 없음:{}", orgFile.getAbsolutePath());
            return;
        }
        File targetFile = new File(targetPath
                + FileUtil.getCombinedPath(FileUtil.getNowdatePath(), fileName.substring(fileName.indexOf("_") + 1)));
        log.debug("임시 경로의 이미지 파일을 실제 서비스 경로로 복사 : {} -> {}", orgFile, targetFile);
        FileUtil.copy(orgFile, targetFile);
    }
}