package net.danvi.dmall.biz.app.setup.taxbill.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.taxbill.model.TaxBillConfigVO;
import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.taxbill.model.TaxBillConfigPO;
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
@Service("taxbillConfigService")
@Transactional(rollbackFor = Exception.class)
public class TaxBillConfigServiceImpl extends BaseService implements TaxBillConfigService {
    // @Value("#{system['system.upload.taxbill.image.path']}")
    // private String taxbillPath;

    /** 세금계산서 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<TaxBillConfigVO> selectTaxBillConfig(Long siteNo) {
        TaxBillConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_TAXBILL_CONFIG + "selectTaxBillConfig",
                siteNo);
        resultVO.setRealSealImgPath(SiteUtil.getSiteUplaodRootPath() + FileUtil
                .getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_TAXBILL, resultVO.getSealImgPath()));
        ResultModel<TaxBillConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 세금계산서 설정 정보 수정 서비스 **/
    @Override
    public ResultModel<TaxBillConfigPO> updateTaxBillConfig(TaxBillConfigPO po, HttpServletRequest request)
            throws Exception {
        ResultModel<TaxBillConfigPO> resultModel = new ResultModel<>();

        // 현재의 이미지 경로를 가져온다.
        String curSealImgPath = selectTaxBillConfig(po.getSiteNo()).getData().getSealImgPath();

        // 현재 등록된 이미지경로와 업데이트하는 이미지경로가 다르다면 새로운 이미지를 등록하는것이기 때문에
        // 기존 등록된 이미지를 제거한뒤 이미지를 새로 등록한다.
        if (!curSealImgPath.equals(po.getSealImgPath())) {
            // 이미지 삭제
            File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE,
                    UploadConstants.PATH_TAXBILL, curSealImgPath));
            FileUtil.delete(file);
        }

        // 이미지 업로드, 현재 세금계산서 개발포멧에 맞게 getFileListFromRequest메서드를 커스터마이징하여 사용
        List<FileVO> list = getFileListFromRequest(request, SiteUtil.getSiteUplaodRootPath()
                + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_TAXBILL));

        if (list != null && list.size() == 1) {
            po.setSealImgPath(list.get(0).getFilePath() + File.separator + list.get(0).getFileName());
        }

        proxyDao.update(MapperConstants.SETUP_TAXBILL_CONFIG + "updateTaxBillConfig", po);

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    /** 세금계산서 설정 인감이미지 삭제 서비스 **/
    @Override
    public ResultModel<TaxBillConfigPO> deleteTaxBillImage(TaxBillConfigPO po) throws Exception {
        ResultModel<TaxBillConfigPO> resultModel = new ResultModel<>();

        // 이미지 삭제
        File file = new File(SiteUtil.getSiteUplaodRootPath() + FileUtil.getCombinedPath(UploadConstants.PATH_IMAGE,
                UploadConstants.PATH_TAXBILL, po.getSealImgPath()));
        FileUtil.delete(file);

        // po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_TAXBILL_CONFIG + "updateTaxBillImage", po);

        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
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

                    fileName = "img_seal." + extension;
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
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }

        return fileVOList;
    }
}
