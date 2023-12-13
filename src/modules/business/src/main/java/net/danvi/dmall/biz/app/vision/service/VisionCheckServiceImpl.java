package net.danvi.dmall.biz.app.vision.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import dmall.framework.common.util.image.ImageInfoData;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckCdPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckContactPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckDscrtVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckGlassesPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckResultVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckSO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckVO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;
import net.danvi.dmall.biz.app.vision.model.VisionStepVO;
import net.danvi.dmall.biz.app.vision.model.VisionVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 24.
 * 작성자     : yji
 * 설명       : 비전체크 서비스 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("visionCheckService")
@Transactional(rollbackFor = Exception.class)
public class VisionCheckServiceImpl  extends BaseService implements VisionCheckService{
	@Override
	public List<VisionCheckDscrtVO> selectVisonCheckDscrtList(VisionVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisonCheckDscrtList", vo);
	}
	
	@Override
	public List<VisionCheckDscrtVO> selectVisonCheckDscrtList2(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisonCheckDscrtList2", vo);
	}

	@Override
	public void insertVisionCheck(VisionCheckVO visionCheckVO) {
		proxyDao.insert(MapperConstants.VISION_CHECK + "insertVisionCheck", visionCheckVO);
	}
	
	@Override
	public void deleteVisionCheck(VisionCheckVO visionCheckVO) {
		proxyDao.delete(MapperConstants.VISION_CHECK + "deleteVisionCheck", visionCheckVO);
	}

	@Override
	public List<VisionCheckVO> selectVisionCheckList(VisionCheckVO visionCheckVO){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckList", visionCheckVO);
	}

	@Override
	public List<VisionCheckVO> selectPoMatrAjax(VisionCheckSO so) {
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectPoMatrAjax", so);

	}

	@Override
	public List<VisionCheckVO> selectLifeStyleAjax(VisionCheckSO so) {
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectLifeStyleAjax", so);
	}
	
	@Override
	public List<VisionCheckVO> selectContactAjax(VisionCheckSO so) {
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectContactAjax", so);
	}
	
	@Override
	public List<VisionStepVO> selectVisionAge(VisionStepVO vo) {
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionAge", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep1(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep1", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep2(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep2", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep3(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep3", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep4(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep4", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep4g(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep4g", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep5(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep5", vo);
	}
	
	@Override
	public List<VisionStepVO> selectVisionStep5c(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep5c", vo);
	}

	@Override
	public List<VisionStepVO> selectVisionStep10(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionStep10", vo);
	}

	@Override
	public List<VisionStepVO> selectStepNm(VisionStepVO vo){
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectStepNm", vo);
	}	

	@Override
	 public int insertVisionCheckGun(VisionGunVO vo) throws Exception {
		return proxyDao.insert(MapperConstants.VISION_CHECK + "insertVisionCheckGun", vo);
	}
	
	@Override
	public List<VisionGunVO> selectVisionCheckGunList(VisionGunVO vo) throws Exception{
		return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckGunList", vo);
	}
	
	@Override
	public ResultModel<VisionGunVO> selectVisionCheckGun(VisionGunVO vo) throws Exception{
		ResultModel<VisionGunVO> result = new ResultModel<VisionGunVO>();
		
		vo = proxyDao.selectOne(MapperConstants.VISION_CHECK + "selectVisionCheckGun", vo);
		
		// 게시글 파일 리스트 조회		
		AtchFileVO afVO = new AtchFileVO();
		afVO.setLettNo(Integer.toString(vo.getGunNo()));
		afVO.setFileGb("TC_VISION_CHECK_GUN");
        List<AtchFileVO> temp = proxyDao.selectList(MapperConstants.BBS_ATCH_FILE + "selectAtchFileList2", afVO);
        
        if(temp.size() > 0) {
        	vo.setAtchFileArr(temp);
        }
        
        result.setSuccess(true);
        result.setData(vo);
        
		return result;
	}
	
	@Override
	public ResultModel<VisionGunVO> updateVisionCheckGun(VisionGunVO vo, HttpServletRequest request) throws Exception{
		ResultModel<VisionGunVO> result = new ResultModel<VisionGunVO>();
		
		try {
			proxyDao.update(MapperConstants.VISION_CHECK + "updateVisionCheckGun", vo);
			insertAtchFile(request, vo);
			result.setMessage(MessageUtil.getMessage("biz.common.insert"));
		}catch(Exception e) {
			result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
		}
		return result;
	}

    @Override
    public ResultModel<AtchFilePO> insertAtchFile(HttpServletRequest request, VisionGunVO vo) throws Exception {
        String filePath = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_VISION;
        List<FileVO> fileList = getFileListFromRequest(request, filePath, vo.getImgYn());
        ResultModel<AtchFilePO> result = new ResultModel<>();
        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        int i = 0;
        // 게시글 첨부 파일 등록
        if (fileList != null) {
            try {
                for (FileVO p : fileList) {

                    AtchFilePO filePo = new AtchFilePO();
                    filePo.setSiteNo(vo.getSiteNo());
                    filePo.setLettNo(Integer.toString(vo.getGunNo()));
                    filePo.setFileGb("TC_VISION_CHECK_GUN");
                    filePo.setFilePath(p.getFilePath());
                    filePo.setOrgFileNm(p.getFileOrgName());
                    filePo.setFileNm(p.getFileName());
                    filePo.setExtsn(p.getFileExtension());
                    filePo.setFileSize(p.getFileSize());
                    filePo.setRegrNo(vo.getRegrNo());                   

                    if (StringUtil.nvl(vo.getImgYn(), "N").equals("Y") && i == 0) {
                        filePo.setImgYn(vo.getImgYn());
                    } else {
                        filePo.setImgYn("N");
                    }
                    
                    proxyDao.insert(MapperConstants.BBS_ATCH_FILE + "insertAtchFile", filePo);
                    i++;
                }
                result.setMessage("success");
            } catch (DuplicateKeyException e) {
                throw new CustomException("biz.exception.common.exist", new Object[] { "파일 정보" }, e);
            }
        } else {
            result.setMessage("success");
        }

        return result;
    }
    
    public List<FileVO> getFileListFromRequest(HttpServletRequest request, String targetPath, String gb) {
        // 다중 파일 정보 조회
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
        String path;
        List<MultipartFile> files;
        FileVO fileVO;
        ImageInfoData imageInfoData;

        try {
            int index = 0;
            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {
                    if (!"".equals(mFile.getOriginalFilename())) {
                        fileOrgName = mFile.getOriginalFilename();
                        extension = FilenameUtils.getExtension(fileOrgName);

                        fileName = System.currentTimeMillis() + "";
                        path = File.separator + FileUtil.getNowdatePath();
                        file = new File(targetPath + path + File.separator + fileName);

                        if (!file.getParentFile().exists()) {
                            file.getParentFile().mkdirs();
                        }

                        log.debug("원본파일 : {}", mFile);
                        log.debug("대상파일 : {}", file);
                        mFile.transferTo(file);

                        /*if ("Y".equals(gb) && index == 0) {
                            index++;
                            imageInfoData = new ImageInfoData();
                            imageInfoData.setImageType(ImageType.EDITOR_IMAGE_BBS);
                            imageInfoData.setOrgImgPath(file.getAbsolutePath());
                            imageHandler.job(imageInfoData);
                        }*/
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
            }

        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }

        return fileVOList;
    }
    
    @Override
    public ResultModel<AtchFilePO> deleteAtchFile(AtchFilePO po) throws Exception {
        ResultModel<AtchFilePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        FileVO vo = proxyDao.selectOne(MapperConstants.BBS_ATCH_FILE + "selectAtchFileDtl", po);
        String fileNm = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_VISION + File.separator
                + vo.getFilePath() + File.separator + vo.getFileName();

        File file = new File(fileNm);
        file.delete();

        if ("Y".equals(vo.getImgYn())) {
            File file2 = new File(fileNm + "_" + UploadConstants.BBS_IMG_SIZE_TYPE);
            file2.delete();
        }
        // 게시글 파일 정보 삭제
        try {
            proxyDao.update(MapperConstants.BBS_ATCH_FILE + "deleteAtchFile", po);
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }
    
    @Override
    public List<VisionCheckCdPO> selectVisionCheckCD(VisionCheckCdPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckCD", po);
    }
    
    @Override
    public List<VisionCheckCdPO> selectVisionCheckRecommTestGr(VisionCheckCdPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckRecommTestGr", po);
    }
    
    @Override
    public List<VisionCheckCdPO> selectVisionCheckRecommCmntGr(VisionCheckCdPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckRecommCmntGr", po);
    }
    
    @Override
    public List<VisionCheckCdPO> selectVisionCheckRecommTestCr(VisionCheckCdPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckRecommTestCr", po);
    }
    
    @Override
	public List<VisionCheckCdPO> selectVisionCheckResult(VisionCheckCdPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckResult", po);
    }
    
    @Override
	public List<VisionGunVO> selectVisionCheckGunInGlasses(VisionCheckGlassesPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckGunInGlasses", po);
    }
    
    @Override
    public List<VisionGunVO> selectVisionCheckGunInContact(VisionCheckContactPO po) throws Exception{
    	return proxyDao.selectList(MapperConstants.VISION_CHECK + "selectVisionCheckGunInContact", po);
    }
    
    @Override
	public List<AtchFileVO> selectVisionCheckGunImage(int lettNo) throws Exception{
    	return proxyDao.selectList(MapperConstants.BBS_ATCH_FILE + "selectAtchFileList", lettNo);
    }
    
    @Override
    public void insertVisionCheckResult(VisionCheckResultVO vo)  throws Exception{
    	proxyDao.insert(MapperConstants.VISION_CHECK + "insertVisionCheckResult", vo);
    }
    
    @Override
    public void deleteVisionCheckResult(VisionCheckResultVO vo)  throws Exception{
    	proxyDao.insert(MapperConstants.VISION_CHECK + "deleteVisionCheckResult", vo);
    }
    
    @Override
	public VisionCheckResultVO selectVisionCheck2Result(VisionCheckResultVO vo)  throws Exception{
    	return proxyDao.selectOne(MapperConstants.VISION_CHECK + "selectVisionCheck2Result", vo);
    }
}
