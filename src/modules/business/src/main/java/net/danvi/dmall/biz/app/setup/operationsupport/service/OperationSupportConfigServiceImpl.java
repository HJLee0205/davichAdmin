package net.danvi.dmall.biz.app.setup.operationsupport.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigPO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigVO;
import net.danvi.dmall.core.remote.homepage.model.request.ImageHostingPO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultModel;
//import dmall.framework.common.util.ExecuteExtCmdUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 31.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("operationSupportConfigService")
@Transactional(rollbackFor = Exception.class)
public class OperationSupportConfigServiceImpl extends BaseService implements OperationSupportConfigService {
    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    /** 사이트에 설정된 SEO설정 정보를 조회한다. **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<OperSupportConfigVO> selectSeoConfig(Long siteNo) {
        OperSupportConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SEO_CONFIG + "selectSeoConfig", siteNo);
        ResultModel<OperSupportConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 사이트에 설정된 GA설정 정보를 조회한다. **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<OperSupportConfigVO> selectGaConfig(Long siteNo) {
        OperSupportConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SEO_CONFIG + "selectGaConfig", siteNo);
        ResultModel<OperSupportConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 사이트에 설정된 080 수신거부 서비스 설정 정보를 조회한다. **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<OperSupportConfigVO> select080Config(Long siteNo) {
        ResultModel<OperSupportConfigVO> result = new ResultModel<>();
        OperSupportConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SEO_CONFIG + "select080Config", siteNo);
        if (resultVO != null) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar cal = Calendar.getInstance(Locale.KOREA);
            Date now = cal.getTime();
            // Date now = null;
            // try {
            // now = format.parse("2016-10-22");
            // } catch (ParseException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }
            Date day1 = null;
            Date day2 = null;

            try {
                day1 = format.parse(resultVO.getSvcUseStartPeriod().substring(0, 10));
                day2 = format.parse(resultVO.getSvcUseEndPeriod().substring(0, 10));
            } catch (Exception e) {
                log.error("오류", e.getMessage());
            }

            if (now.equals(day1) || now.equals(day2) || (now.after(day1) && now.before(day2))) {
                String applyDate = format.format(day1);
                resultVO.setApplyInfo("개통완료(개통일: " + applyDate.substring(0, 4) + "년 " + applyDate.substring(5, 7) + "월 "+ applyDate.substring(8, 10) + "일)");
            }
        }

        result.setData(resultVO);
        return result;
    }

    /** 사이트에 설정된 이미지 호스팅 설정 정보를 조회한다. **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<OperSupportConfigVO> selectImageConfig(Long siteNo) {
        ResultModel<OperSupportConfigVO> result = new ResultModel<>();
        OperSupportConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SEO_CONFIG + "selectImageConfig",
                siteNo);

        if (resultVO != null) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            Calendar cal = Calendar.getInstance(Locale.KOREA);
            Date now = cal.getTime();
            // Date now = null;
            // try {
            // now = format.parse("2016-09-20");
            // } catch (ParseException e1) {
            // // TODO Auto-generated catch block
            // e1.printStackTrace();
            // }
            Date day1 = null;
            Date day2 = null;

            try {
                day1 = format.parse(resultVO.getSvcUseStartPeriod().substring(0, 10));
                day2 = format.parse(resultVO.getSvcUseEndPeriod().substring(0, 10));
            } catch (Exception e) {
                log.error("오류", e.getMessage());
            }

            if (now.equals(day1) || now.equals(day2) || (now.after(day1) && now.before(day2))) {
                String applyDate = format.format(day1);
                resultVO.setApplyInfo("개통완료(개통일: " + applyDate.substring(0, 4) + "년 " + applyDate.substring(5, 7) + "월 "
                        + applyDate.substring(8, 10) + "일)");
            }
        }
        result.setData(resultVO);
        return result;
    }

    /** 사이트에 설정된 SEO설정 정보를 수정한다. **/
    @Override
    public ResultModel<OperSupportConfigPO> updateSeoConfig(OperSupportConfigPO po, HttpServletRequest request)
            throws Exception {
        ResultModel<OperSupportConfigPO> resultModel = new ResultModel<>();

        // 현재의 이미지 경로를 가져온다.
        String curSrchFilePath = "";
        ResultModel<OperSupportConfigVO> seoModel = selectSeoConfig(po.getSiteNo());

        // 공백으로 초기화하지않으면 만약 데이터가 없어서 null일경우 밑의 if문 조건에서 에러를 뱉기때문에 무조건 초기화해야한다.
        if (seoModel.getData() != null) {
            curSrchFilePath = seoModel.getData().getSrchFilePath();
        }

        if (curSrchFilePath!=null && !curSrchFilePath.equals(po.getSrchFilePath())) {
            // 이미지 삭제
            File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_CONFIG, UploadConstants.PATH_SEO_SUPPORT, curSrchFilePath));
            FileUtil.delete(file);
        }

        // file이 null이 아닐때에만 업로드
        List<FileVO> list = getFileListFromRequest(request, SiteUtil.getSiteUplaodRootPath()
                + FileUtil.getCombinedPath(UploadConstants.PATH_CONFIG, UploadConstants.PATH_SEO_SUPPORT));

        if (list != null && list.size() == 1) {
            po.setSrchFilePath(list.get(0).getFilePath() + File.separator + list.get(0).getFileName());
        }

        proxyDao.update(MapperConstants.SETUP_SEO_CONFIG + "updateSeoConfig", po);

        // 프론트 사이트 정보 갱신
//        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 사이트에 설정된 GA설정 정보를 수정한다. **/
    @Override
    public ResultModel<OperSupportConfigPO> updateGaConfig(OperSupportConfigPO po, HttpServletRequest request)
            throws Exception {
        ResultModel<OperSupportConfigPO> resultModel = new ResultModel<>();

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_SEO_CONFIG + "updateGaConfig", po);

        // 프론트 사이트 정보 갱신
//        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 사이트에 설정된 080 수신거부 서비스 설정 정보를 수정한다. **/
    @Override
    public int update080Config(OperSupportConfigPO po) {
        return proxyDao.update(MapperConstants.SETUP_SEO_CONFIG + "update080Config", po);
    }

    @Override
    public int updateImgServConfig(ImageHostingPO po) {
        return proxyDao.update(MapperConstants.SETUP_SEO_CONFIG + "updateImgServSet", po);
    }

    private List<FileVO> getFileListFromRequest(HttpServletRequest request, String targetPath) {
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
        String[] fileFilter = { "txt" };
        Boolean checkExe;

        try {
            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {
                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);
                    checkExe = true;
                    for (String ex : fileFilter) {
                        if (ex.equalsIgnoreCase(extension)) {
                            checkExe = false;
                        }
                    }
                    //
                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    fileName = "Robots." + extension;
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
                    fileVO.setFilePath(path);
                    fileVO.setFileName(fileName);
                    fileVOList.add(fileVO);
                }
            }

        } catch (IllegalStateException e) {
            log.error("오류", e.getMessage());
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            log.error("오류", e.getMessage());
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }

        return fileVOList;
    }
}
