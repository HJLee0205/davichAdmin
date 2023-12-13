package net.danvi.dmall.biz.app.setup.snsoutside.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigPO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigSO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
//import dmall.framework.common.util.ExecuteExtCmdUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("snsOutsideLinkService")
@Transactional(rollbackFor = Exception.class)
public class SnsOutsideLinkServiceImpl extends BaseService implements SnsOutsideLinkService {
    // @Value("#{system['system.upload.snsconfig.image.path']}")
    // private String snsConfigPath;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    /** 컨텐츠 공유관리 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SnsConfigVO> selectContentsConfig(Long siteNo) {
        SnsConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SNS_MANAGE + "selectContentsConfig", siteNo);

        ResultModel<SnsConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 컨텐츠 공유관리 설정 정보 수정 서비스 **/
    @Override
    public ResultModel<SnsConfigPO> updateContentsConfig(SnsConfigPO po) throws Exception {
        ResultModel<SnsConfigPO> resultModel = new ResultModel<>();
        // po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_SNS_MANAGE + "updateContentsConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/
        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** SNS 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SnsConfigVO> selectSnsConfig(SnsConfigSO so) {
        SnsConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_SNS_MANAGE + "selectSnsConfig", so);

        ResultModel<SnsConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    public ResultListModel<SnsConfigVO> selectSnsConfigList(Long siteNo) {
        List<SnsConfigVO> list = proxyDao.selectList(MapperConstants.SETUP_SNS_MANAGE + "selectSnsConfigList", siteNo);
        ResultListModel<SnsConfigVO> result = new ResultListModel<>();
//        log.debug("=========== list : {}", list.toString());
        if (list == null || list.size() < 1) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        } else {
            result.setResultList(list);
        }
        return result;
    }

    /** SNS 설정 정보 수정 서비스 **/
    @Override
    public ResultModel<SnsConfigPO> updateSnsConfig(SnsConfigPO po) throws Exception {
        ResultModel<SnsConfigPO> resultModel = new ResultModel<>();
        boolean isFlag = false;

        // 유효성 검사
        if ("03".equals(po.getOutsideLinkCd())) { // 카카오 수정시 검사, 네이버 수정은 메서드가 따로 존재한다.
            isFlag = siteQuotaService.isSnsAddible(po.getSiteNo(), po.getOutsideLinkCd());
        } else { // 기본, 페이스북은 무조건 수정
            isFlag = true;
        }

        if (isFlag) {
            // isFlag가 Y라면 홈페이지에서 구매를한것이기때문에 linkOperYn을 Y로 한다.
            po.setLinkOperYn("Y");
            proxyDao.update(MapperConstants.SETUP_SNS_MANAGE + "updateSnsConfig", po);
            resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        } else {
            resultModel.setMessage("카카오 로그인 설정은 홈페이지에서 구매후 사용가능합니다.");
        }

        return resultModel;
    }

    /** SNS(Naver) 설정 정보 수정 서비스 **/
    @Override
    public ResultModel<SnsConfigPO> updateNaverSnsConfig(SnsConfigPO po, HttpServletRequest request) throws Exception {
        ResultModel<SnsConfigPO> resultModel = new ResultModel<>();
        boolean isFlag = siteQuotaService.isSnsAddible(po.getSiteNo(), po.getOutsideLinkCd());

        if (isFlag) {
            SnsConfigSO so = new SnsConfigSO();
            so.setSiteNo(po.getSiteNo());
            so.setOutsideLinkCd(po.getOutsideLinkCd());
            String curSpmallLogoImg = null;
            // 현재의 이미지 경로를 가져온다.
            if(selectSnsConfig(so).getData()!=null){
                curSpmallLogoImg = selectSnsConfig(so).getData().getSpmallLogoImg();
            }


            // 공백으로 초기화하지않으면 밑의 if문 조건에서 에러를 뱉기때문에 무조건 초기화해야한다.
            if (curSpmallLogoImg == null) {
                curSpmallLogoImg = "";
            }

            if (!curSpmallLogoImg.equals(po.getSpmallLogoImg())) {
                // 이미지 삭제
                File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_NAVERLOGO, curSpmallLogoImg));
                FileUtil.delete(file);
            }

            // file이 null이 아닐때에만 업로드
            // 이미지 업로드, 현재 세금계산서 개발포멧에 맞게 getFileListFromRequest메서드를 커스터마이징하여 사용
            List<FileVO> list = getFileListFromRequest(request, SiteUtil.getSiteUplaodRootPath()+ FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_NAVERLOGO));

            if (list != null && list.size() == 1) {
                po.setSpmallLogoImg(list.get(0).getFilePath() + File.separator + list.get(0).getFileName());
            }

            // isFlag가 Y라면 홈페이지에서 구매를한것이기때문에 linkOperYn을 Y로 한다.
            po.setLinkOperYn("Y");
            // po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.update(MapperConstants.SETUP_SNS_MANAGE + "updateSnsConfig", po);

            resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        } else {
            resultModel.setMessage("네이버 로그인 설정은 홈페이지에서 구매후 사용가능합니다.");
        }

        return resultModel;
    }

    /** SNS 로그인 설정 정보 초기값 등록 서비스 **/
    @Override
    public ResultModel<SnsConfigPO> updateInitSnsConfig() throws Exception {
        ResultModel<SnsConfigPO> resultModel = new ResultModel<>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        String siteTypeCd = "1"; // 임대형 무료, 임대형 유료, 독립형을 판단하는 코드가 들어가야한다.

        // initSubmit은 초기 기본으로 제공하는 로그인연동에 대한 기본데이터 등록이기 때문에 운영여부를 무조건 Y로 하여도상관없다.
        // 기본, 페이스북 로그인연동방식은 기본지원이므로 insert 시킨다.
        for (int i = 1; i < 5; i++) {
            SnsConfigPO paramPo = new SnsConfigPO();
            paramPo.setUpdrNo(sessionInfo.getSession().getMemberNo());
            paramPo.setSiteNo(sessionInfo.getSiteNo());
            paramPo.setOutsideLinkCd("0" + i);
            // 기본가입은 무조건 사용여부를 Y로 등록하고, 페이스북도 무료지원이긴 하지만 사용여부 직접 수정할수 있으므로 N으로 기본세팅한다.
            paramPo.setLinkUseYn("04".equals(paramPo.getOutsideLinkCd()) ? "Y" : "N");
            // 사이트 유형코드가 1 이라면 임시몰 무료형이기때문에 기본, 페이스북만 운영처리
            // 사이트 유형코드가 2,3 이라면 임시몰,독립형 무료이기때문에 유료처리
            if ("1".equals(siteTypeCd)) {
                if ("01".equals(paramPo.getOutsideLinkCd()) || "04".equals(paramPo.getOutsideLinkCd())) {
                    paramPo.setLinkOperYn("Y");
                } else {
                    paramPo.setLinkOperYn("N");
                }
            } else {
                paramPo.setLinkOperYn("Y");
            }
            proxyDao.update(MapperConstants.SETUP_SNS_MANAGE + "updateSnsConfig", paramPo);
        }

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
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

        try {
            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {
                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);

                    fileName = "img_naver_logo." + extension;
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
