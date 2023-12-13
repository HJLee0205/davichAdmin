package net.danvi.dmall.biz.app.setup.siteinfo.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.*;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsIconPO;
import net.danvi.dmall.biz.app.goods.model.GoodsIconVO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSizePO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSizeVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SitePO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.BaseService;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
//import dmall.framework.common.util.ExecuteExtCmdUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("siteInfoService")
@Transactional(rollbackFor = Exception.class)
public class SiteInfoServiceImpl extends BaseService implements SiteInfoService {

    private static final String FILE_NAME_FOR_FAVICON = "favicon.ico";
    private static final String FILE_NAME_FOR_FAVICON_PNG = "favicon.png";
    private static final String FILE_NAME_FOR_LOGO = "logo.png";
    private static final String FILE_NAME_FOR_BOTTOM_LOGO = "bottom_logo.png";

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * selectSiteInfo(SiteSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SiteVO> selectSiteInfo(SiteSO so) {
        ResultModel<SiteVO> result = new ResultModel<>();
        SiteVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", so);
        if (resultVO == null) {
            result = new ResultModel<SiteVO>();
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.noresult"));
        }
        result.setData(resultVO);
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * selectSiteInfoHtml(SiteSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SiteVO> selectSiteInfoHtml(SiteSO so) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<SiteVO> result = new ResultModel<>();
        SiteVO siteInfo = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfoHtml", so);


        if (siteInfo != null) {

            siteInfo.setContent(StringUtil.replaceAll(siteInfo.getContent(), UploadConstants.IMAGE_EDITOR_URL, request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) + UploadConstants.IMAGE_EDITOR_URL));
            // 이미지 정보 조회 조건 세팅
            CmnAtchFileSO fileso = new CmnAtchFileSO();
            fileso.setSiteNo(siteInfo.getSiteNo());
            fileso.setRefNo(siteInfo.getSiteInfoCd());
            fileso.setFileGb("COMPANY_INFO");

            // 공통 첨부 파일 조회
            editorService.setCmnAtchFileToEditorVO(fileso, siteInfo);
        }
        result.setData(siteInfo);
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * updateSiteInfo(SitePO)
     */
    @Override
    public ResultModel<SitePO> updateSiteInfo(SitePO po) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        // log.info("SitePO : {}", po);
        ResultModel<SitePO> result = new ResultModel<>();
        String refNo = po.getSiteInfoCd();

        if (null != po.getSbnStartDt()) {
            po.setSbnStartDt(po.getSbnStartDt().replaceAll("-", ""));
        }
        if (null != po.getSbnEndDt()) {
            po.setSbnEndDt(po.getSbnEndDt().replaceAll("-", ""));
        }

        // 파비콘 업로드 파일 정보 있을 경우
        if (!StringUtils.isEmpty(po.getFilePath()) && !StringUtils.isEmpty(po.getFileName())) {
            try {
                // 임시 이미지 파일
                String icoFileName = po.getFileName().substring(0, po.getFileName().lastIndexOf("."));
                File tempFile = new File(SiteUtil.getSiteUplaodRootPath()+ FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, po.getFilePath(), icoFileName));
                File tempFile2 = new File(SiteUtil.getSiteUplaodRootPath()+ FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, po.getFilePath(), po.getFileName()));

                // 파비콘 파일 경로로 올라갈 파일
                File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FAVICON, FILE_NAME_FOR_FAVICON));
                File filePng = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_FAVICON, FILE_NAME_FOR_FAVICON_PNG));
                // 경로 생성
                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }
                // log.debug("원본파일 : {}", tempFile);
                // log.debug("대상파일 : {}", file, file.exists());
                // 파일 이동, 기존 파일이 존재하면 삭제

                if (file.exists()) {
                    log.debug("기존파일 삭제 : {}");
                    FileUtil.delete(file);
                    if (filePng.exists()) {
                        FileUtil.delete(filePng);
                    }
                }
                FileUtil.move(tempFile, file);
                FileUtil.move(tempFile2, filePng);

                String fvcPath = "/image/image-view?type=" + UploadConstants.TYPE_FAVICON + "&id1="+ FILE_NAME_FOR_FAVICON_PNG;
                po.setFvcPath(fvcPath);

            } catch (IllegalStateException e) {
                //
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } catch (IOException e) {
                //
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            }
        }

        // 로고 업로드 파일 정보 있을 경우
        if (!StringUtils.isEmpty(po.getLogoFilePath()) && !StringUtils.isEmpty(po.getLogoFileName())) {
            try {
                // 임시 이미지 파일
                File tempFile = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, po.getLogoFilePath(), po.getLogoFileName()));

                // 로고 파일 경로로 올라갈 파일
                File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_LOGO, FILE_NAME_FOR_LOGO));
                // 경로 생성
                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }
                // log.debug("원본파일 : {}", tempFile);
                // log.debug("대상파일 : {}", file, file.exists());
                // 파일 이동, 기존 파일이 존재하면 삭제
                if (file.exists()) {
                    // log.debug("기존파일 삭제 : {}");
                    FileUtil.delete(file);
                }
                FileUtil.move(tempFile, file);

                String logoPath = "/image/image-view?type=" + UploadConstants.TYPE_LOGO + "&id1=" + FILE_NAME_FOR_LOGO;
                po.setLogoPath(logoPath);

            } catch (IllegalStateException e) {
                //
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } catch (IOException e) {
                //
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            }
        }

        // 하단 로고 업로드 파일 정보 있을 경우
        if (!StringUtils.isEmpty(po.getBottomLogoFilePath()) && !StringUtils.isEmpty(po.getBottomLogoFileName())) {
            try {
                // 임시 이미지 파일
                File tempFile = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, po.getBottomLogoFilePath(), po.getBottomLogoFileName()));

                // 로고 파일 경로로 올라갈 파일
                File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_LOGO, FILE_NAME_FOR_BOTTOM_LOGO));
                // 경로 생성
                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }
                // log.debug("원본파일 : {}", tempFile);
                // log.debug("대상파일 : {}", file, file.exists());
                // 파일 이동, 기존 파일이 존재하면 삭제
                if (file.exists()) {
                    // log.debug("기존파일 삭제 : {}");
                    FileUtil.delete(file);
                }
                FileUtil.move(tempFile, file);

                String bottomLogoPath = "/image/image-view?type=" + UploadConstants.TYPE_LOGO + "&id1="+ FILE_NAME_FOR_BOTTOM_LOGO;
                po.setBottomLogoPath(bottomLogoPath);

            } catch (IllegalStateException e) {
                //
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } catch (IOException e) {
                //
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            }
        }

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, refNo, "COMPANY_INFO");
        // 에디터 내용의 업로드 이미지 정보 변경
        // log.debug("변경전 내용 : {}", po.getContent());

        po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        // log.debug("변경한 내용 : {}", po.getContent());
        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "COMPANY_INFO", po.getAttachImages());
        // log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}",
        // po.getAttachImages());

        po.setSiteNo(po.getSiteNo()); // 사이트 번호 세팅
        po.setSiteInfoCd("01"); // 사이트 상세 정보 코드값 고정('01')
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        int cnt = proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateSiteDtl", po);
        if (cnt != 1) {
            throw new CustomException("사이트 상세 정보 수정 중 에러가 발생했습니다.");
        }

        cnt = proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateSite", po);
        if (cnt != 1) {
            throw new CustomException("사이트 정보 수정 중 에러가 발생했습니다.");
        }


        if(po.getBizNo()!=null)
        po.setBizNo(po.getBizNo().replaceAll("-",""));
        cnt = proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateCompany", po);
        if (cnt != 1) {
            throw new CustomException("업체 정보 수정 중 에러가 발생했습니다.");
        }

        /*if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType)) {
            int checkCnt = proxyDao.selectOne("checkTsSiteInfoCnt", po);
            if(checkCnt > 0){
            	proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateTsSiteInfo", po);
            }else{
            	proxyDao.insert(MapperConstants.SETUP_SITE_INFO + "insertTsSiteInfo", po);
            }
        }else{
        	proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateSiteHtml", po);
        }*/


        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            // 파일이 임시 파일일 경우만 등록 처리(2016.09.26)
            if (p.getTemp()) {
                p.setRefNo(refNo); // 참조의 번호
                editorService.insertCmnAtchFile(p);
            }
        }
        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        // 사이트 정보 캐시 갱신
        cacheService.refreshSiteInfoCache(po.getSiteNo());

        // 프론트 사이트 정보 갱신
        //adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());

        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * deleteSiteInfo(SitePO)
     */
    @Override
    public ResultModel<SitePO> deleteSiteInfo(SitePO po) throws Exception {
        ResultModel<SitePO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.SETUP_SITE_INFO + "deleteSiteInfo", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * selectGoodsImageInfo(net.danvi.dmall.biz.app.setup.siteinfo.model.
     * SiteSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsImageSizeVO> selectGoodsImageInfo(SiteSO so) {
        ResultModel<GoodsImageSizeVO> result = new ResultModel<>();
        GoodsImageSizeVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectImageConfig", so);
        if (resultVO == null) {
            result = new ResultModel<GoodsImageSizeVO>();
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.noresult"));
        }
        result.setData(resultVO);
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * selectIconList(SiteSO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<GoodsIconVO> selectIconList(SiteSO so) {
        return proxyDao.selectList(MapperConstants.SETUP_SITE_INFO + "selectIconList", so);
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * saveIconInfo(org.springframework.ui.Model,
     * org.springframework.web.multipart.MultipartHttpServletRequest)
     */
    @Override
    public List<Map<String, Object>> saveIconInfo(Model model, MultipartHttpServletRequest mRequest) throws Exception {
        Map<String, Object> result;
        List<Map<String, Object>> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            String filePath;
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            List<MultipartFile> files;

            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {

                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);

                    Boolean checkExe = true;
                    for (String ex : fileFilter) {
                        if (ex.equalsIgnoreCase(extension)) {
                            checkExe = false;
                        }
                    }
                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }
                    if (mFile != null && mFile.getSize() > fileSize) {
                        throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                    }
                    fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
                    filePath = FileUtil.getDatePath(new StringBuffer().append(DateUtil.getNowDate()).append("_").append(fileName).toString());
                    file = new File(SiteUtil.getSiteUplaodRootPath()+ FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, filePath));

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    // log.debug("원본파일 : {}", mFile);
                    // log.debug("대상파일 : {}", file);

                    mFile.transferTo(file);

                    result = new HashMap<>();
                    result.put("fileExtension", extension);
                    result.put("fileOrgName", fileName);
                    result.put("fileSize", mFile.getSize());
                    result.put("filePath", filePath.substring(0, filePath.lastIndexOf(File.separator)));
                    result.put("iconNo", fileName);
                    result.put("registFlag", "I");
                    result.put("iconPathNm",
                            ("<img src=\"/image/image-view?type=TEMP&path="
                                    + filePath.substring(0, filePath.lastIndexOf(File.separator)) + "&id1=" + fileName
                                    + "\">"));
                    resultList.add(result);
                }
            }

            return resultList;
        } catch (IllegalStateException e) {
            //
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            //
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see SiteInfoService#
     * updateGoodsImageInfo(net.danvi.dmall.biz.app.goods.model.
     * GoodsImageSizePO)
     */
    @Override
    public ResultModel<GoodsImageSizePO> udpateImageConfig(GoodsImageSizePO po) throws Exception {
        ResultModel<GoodsImageSizePO> result = new ResultModel<>();
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();

        if (po.getIconList() != null && po.getIconList().size() > 0) {
            for (int i = 0; i < po.getIconList().size(); i++) {
                String path = SiteUtil.getSiteUplaodRootPath();

                GoodsIconPO iconPO = po.getIconList().get(i);
                String tempFileName = iconPO.getImgNm();
                String extension = iconPO.getFileExtension();

                // 추가된 아이콘 처리
                if ("I".equals(iconPO.getRegistFlag()) && !StringUtils.isEmpty(iconPO.getImgNm())  && !StringUtils.isEmpty(iconPO.getImgPath())) {
                    String tempFilePath = FileUtil.getCombinedPath(path, UploadConstants.PATH_TEMP, iconPO.getImgPath(),tempFileName);

                    iconPO.setSiteNo(siteNo);
                    iconPO.setImgNm("_temp_icon");
                    iconPO.setIconTypeCd("2");
                    iconPO.setImgPath(FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_ICON));
                    iconPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    iconPO.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    proxyDao.insert(MapperConstants.SETUP_SITE_INFO + "insertIcon", iconPO);
                    StringBuffer sbFileName = new StringBuffer().append(iconPO.getIconNo()).append(".").append(extension);
                    String fileName = sbFileName.toString();
                    iconPO.setImgNm(fileName);
                    proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateIcon", iconPO);

                    File orgFile = new File(tempFilePath);
                    String targetPath = FileUtil.getCombinedPath(path, UploadConstants.PATH_IMAGE,UploadConstants.PATH_ICON, fileName);

                    if (orgFile.exists()) {
                        // log.debug("임시 경로의 이미지 파일을 실제 서비스 경로로 복사 : {} -> {}",
                        // orgFile, new File(targetPath));
                        FileUtil.copy(orgFile, new File(targetPath));
                        // log.debug("임시경로의 파일을 삭제: {}", file);
                        FileUtil.delete(orgFile);
                    }

                    // 삭제된 아이콘 처리
                } else if ("D".equals(iconPO.getRegistFlag()) && !StringUtils.isEmpty(String.valueOf(iconPO.getIconNo()))) {
                    proxyDao.delete(MapperConstants.SETUP_SITE_INFO + "deleteIcon", iconPO);
                    // 아이콘 파일 삭제 처리
                    // log.debug("아이콘 파일을 삭제: {}", tempFileName);
                    FileUtil.delete(new File(FileUtil.getCombinedPath(path, UploadConstants.PATH_IMAGE,UploadConstants.PATH_ICON, tempFileName)));
                }
            }
        }
        proxyDao.update(MapperConstants.SETUP_SITE_INFO + "updateGoodsImageInfo", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }
}
