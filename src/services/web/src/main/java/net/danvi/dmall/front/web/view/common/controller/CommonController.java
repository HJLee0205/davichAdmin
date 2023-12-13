package net.danvi.dmall.front.web.view.common.controller;

import dmall.framework.common.constants.RequestAttributeConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.front.web.config.view.View;
import nl.captcha.servlet.CaptchaServletUtil;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.EditorImageVO;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.util.*;
import dmall.framework.common.util.image.ImageHandler;
import dmall.framework.common.util.image.ImageInfoData;
import dmall.framework.common.util.image.ImageType;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Slf4j
@Controller
public class CommonController {

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Value("#{system['system.upload.path']}")
    private String filePath;

    @Resource(name = "imageHandler")
    private ImageHandler imageHandler;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 업로드 된 파일을 임시 폴더에 저장한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/front/common/file-upload")
    public String fileUploadResult(Model model, MultipartHttpServletRequest mRequest) {

        FileVO result;
        List<FileVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        String[] fileFilter = new String[]{"pptx", "ppt", "xls", "xlsx", "doc", "docx", "hwp", "pdf", "gif", "png", "jpg", "jpeg"};

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            String path;
            List<MultipartFile> files;
            boolean checkExe = false;

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

                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    if (mFile.getSize() > fileSize) {
                        throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                    }

                    fileName = System.currentTimeMillis() + "";
                    path = DateUtil.getNowDate();
                    file = new File(FileUtil.getTempPath(path, fileName));

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);
                    mFile.transferTo(file);
                    result = new FileVO();
                    result.setFileExtension(extension);
                    result.setFileOrgName(fileOrgName);
                    result.setFileName(fileName);
                    result.setFileSize(mFile.getSize());
                    result.setFileType(mFile.getContentType());
                    result.setFilePath(path);
                    resultList.add(result);
                }
            }

            model.addAttribute("files", resultList);
            return View.jsonView();
        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 업로드된 이미지 파일을 임시 폴더에 저장한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/front/common/image-upload")
    public String imageUploadResult(Model model, MultipartHttpServletRequest mRequest) {
        FileVO result;
        List<FileVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            String path;
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            Boolean checkExe;
            List<MultipartFile> files;

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

                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    if (mFile.getSize() > fileSize) {
                        throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                    }

                    fileName = System.currentTimeMillis() + "";
                    path = DateUtil.getNowDate();
                    file = new File(FileUtil.getTempPath(path, fileName));

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);
                    mFile.transferTo(file);
                    result = new FileVO();
                    result.setFileExtension(extension);
                    result.setFileName(fileName);
                    result.setFileOrgName(fileOrgName);
                    result.setFileSize(mFile.getSize());
                    result.setFileType(mFile.getContentType());
                    result.setFilePath(path);
                    resultList.add(result);
                }
            }

            model.addAttribute("files", resultList);
            return View.jsonView();
        } catch (IllegalStateException e) {
            log.debug("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            log.debug("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 에디터로 업로드한 이미지를 임시 경로에 저장한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/front/common/editor-image-upload")
    public String editorImageUploadResult(Model model, MultipartHttpServletRequest mRequest) {
        EditorImageVO result;
        List<EditorImageVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            String path;
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            Boolean checkExe;
            List<MultipartFile> files;
            ImageInfoData imageInfoData;

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

                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    if (mFile.getSize() > fileSize) {
                        throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                    }

                    fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
                    path = FileUtil.getNowdatePath();
                    filePath = FileUtil.getTempPath(path, fileName);
                    file = new File(filePath);

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);
                    mFile.transferTo(file);

                    imageInfoData = new ImageInfoData();
                    imageInfoData.setImageType(ImageType.EDITOR_IMAGE);
                    imageInfoData.setOrgImgPath(file.getAbsolutePath());

                    imageHandler.job(imageInfoData);

                    fileName = DateUtil.getNowDate() + "_" + fileName;
                    result = new EditorImageVO();
                    result.setFileName(fileOrgName);
                    result.setTempFileName(fileName);
                    result.setFileSize(mFile.getSize());

                    // 이미지 미리보기 URL
                    result.setImageUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) +UploadConstants.IMAGE_TEMP_EDITOR_URL + fileName);
                    // 이미지 썸네일 URL
                    result.setThumbUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN)+ UploadConstants.IMAGE_TEMP_EDITOR_URL + fileName + CommonConstants.IMAGE_THUMBNAIL_PREFIX);

                    resultList.add(result);
                }
            }

            model.addAttribute("files", resultList);
            return View.jsonView();
        } catch (IllegalStateException e) {
            log.debug("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            log.debug("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }
    }

    @RequestMapping(value = "/front/common/capcha")
    public String captcha() throws Exception {

        CaptchaServletUtil.writeImage(HttpUtil.getHttpServletResponse(),
                CaptchaUtil.createCaptchaImg(HttpUtil.getHttpServletRequest()).getImage());
        return View.voidView();
    }

    @RequestMapping(value = "/front/common/error")
    public ModelAndView commonError() throws Exception {
        ModelAndView mv = new ModelAndView("error/notice");
        return mv;
    }
}