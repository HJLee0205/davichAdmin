package net.danvi.dmall.admin.web.view.common.controller;

import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.swing.ImageIcon;

import dmall.framework.common.constants.RequestAttributeConstants;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.main.model.AdminInfoVO;
import net.danvi.dmall.biz.app.main.model.AdminMainSO;
import net.danvi.dmall.biz.app.main.service.MainService;
import net.danvi.dmall.biz.system.model.MenuVO;
import net.danvi.dmall.biz.system.service.MenuService;
import nl.captcha.servlet.CaptchaServletUtil;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.EditorImageVO;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.util.CaptchaUtil;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
//import dmall.framework.common.util.ExecuteExtCmdUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.image.ImageHandler;
import dmall.framework.common.util.image.ImageInfoData;
import dmall.framework.common.util.image.ImageType;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 5.
 * 작성자     : dong
 * 설명       : 공통 업로드 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/common")
public class CommonController {

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Value("#{system['system.upload.path']}")
    private String uplaodFilePath;

    @Resource(name = "imageHandler")
    private ImageHandler imageHandler;

    @Resource(name = "menuService")
    private MenuService menuService;

    @Resource(name = "adminMainService")
    private MainService mainService;

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
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/file-upload")
    @ResponseBody
    public Map fileUploadResult(MultipartHttpServletRequest mRequest) {

        FileVO result;
        List<FileVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Map map = new HashMap();
        String[] fileFilter = new String[]{"pptx", "ppt", "xls", "xlsx", "doc", "docx", "hwp", "pdf", "gif", "png", "jpg", "jpeg", "txt"}; // txt는 SEO 설정의 robot.txt

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
                    path = FileUtil.getNowdatePath();
                    file = new File(FileUtil.getTempPath(path, fileName));

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.info("org file : {}", mFile);
                    log.info("dst file : {}", file);
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

            map.put("files", resultList);

            return map;
        } catch (IllegalStateException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } catch (IOException e) {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT, e);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
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
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/image-upload-temp")
    @ResponseBody
    public Map imageUploadResult(MultipartHttpServletRequest mRequest) {
        FileVO result;
        List<FileVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Map map = new HashMap();

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
                    path = FileUtil.getNowdatePath();
                    file = new File(FileUtil.getTempPath(path, fileName));

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.info("org file : {}", mFile);
                    log.info("dest file : {}", file);
                    mFile.transferTo(file);
                    result = new FileVO();
                    result.setFileExtension(extension);
                    result.setFileName(fileName);
                    result.setFileOrgName(fileOrgName);
                    result.setFileSize(mFile.getSize());
                    result.setFileType(mFile.getContentType());
                    result.setFilePath(path);

                    // 이미지 파일 가로, 세로 크기
                    Image img = new ImageIcon(FileUtil.getTempPath(path, fileName)).getImage();
                    result.setFileWidth(Integer.toString(img.getWidth(null)));
                    result.setFileHeight(Integer.toString(img.getHeight(null)));

                    resultList.add(result);

                }
            }

            map.put("files", resultList);
            return map;
        } catch (IllegalStateException e) {
            log.error("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            log.error("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
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
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/editor-image-upload")
    @ResponseBody
    public Map editorImageUploadResult(MultipartHttpServletRequest mRequest) {
        EditorImageVO result;
        List<EditorImageVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Map map = new HashMap();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
       //FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            String path;
            String filePath;
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
                    result.setImageUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) +UploadConstants.IMAGE_TEMP_EDITOR_URL + fileName);
                    result.setThumbUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN)+ fileName + CommonConstants.IMAGE_THUMBNAIL_PREFIX);
                    resultList.add(result);
                }
            }

            map.put("files", resultList);

            return map;
        } catch (IllegalStateException e) {
            log.error("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            log.error("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
//            ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 해당 대메뉴의 첫번째 메뉴로 리다이렉트
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/menu-redirect")
    public String firstMenu(MenuVO vo) throws Exception {

        vo = menuService.selectFirstMenu(vo);

        if (vo == null) {
            return View.redirect("/admin/main/main-view");
        } else {
            return View.redirect(vo.getUrl());
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 캡차 코드 출력
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/capcha")
    public String captcha() throws Exception {

        CaptchaServletUtil.writeImage(HttpUtil.getHttpServletResponse(),
                CaptchaUtil.createCaptchaImg(HttpUtil.getHttpServletRequest()).getImage());
        return View.voidView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 메뉴 검색
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping(value = "/find-menu")
    public @ResponseBody List<MenuVO> findMenu(MenuVO vo) {
        if (vo.getMenuNm().trim().length() > 1) {
            return menuService.findMenu(vo);
        } else {
            return new ArrayList<>();
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 좌측 영역의 관리자 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping(value = "/admin-info")
    public @ResponseBody AdminInfoVO getAdminInfo(AdminMainSO so) {
        return mainService.getAdminInfo(so);
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 디스크 정보 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping(value = "/disk-info")
    public @ResponseBody AdminInfoVO getAdminDiskInfo(AdminMainSO so) {
        return mainService.getAdminDiskInfo(so);
    }


}