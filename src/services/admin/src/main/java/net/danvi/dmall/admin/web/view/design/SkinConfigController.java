package net.danvi.dmall.admin.web.view.design;

import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;

import dmall.framework.common.constants.UploadConstants;
import net.danvi.dmall.biz.app.design.model.*;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.FileZipUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.design.service.SkinConfigService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 21.
 * 작성자     : dong
 * 설명       : 스킨설정 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class SkinConfigController {

    @Resource(name = "skinConfigService")
    private SkinConfigService skinConfigService;
    
    @Value("#{system['system.upload.path']}")
    private String uploadPath;

    // @Value("#{system['system.html.editor.path']}")
    // private String editPath;

    @Value("#{system['system.html.mobile.editor.path']}")
    private String editMobilePath;

    @RequestMapping("/pc-skin")
    public ModelAndView viewSkin(@Validated SkinSO so, BindingResult bindingResult) {
        // 스킨 화면
        ModelAndView mv = new ModelAndView("/admin/design/skin/skinPcConfig");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 기본 조회 조건 PC 일경우 C 모바일경우 M
        // 화면 자체가 PC화면 자체이기 때문에 값을 고정시켰음.
        so.setPcGbCd("C");

        List<SkinVO> skin_list = new ArrayList<>();

        // 스킨 리스트 조회
        skin_list = skinConfigService.selectSkinList(so);

        mv.addObject("so", so);
        mv.addObject("resultListModel", skin_list);

        return mv;
    }

    @RequestMapping("/real-skin-update")
    public @ResponseBody ResultModel<SkinPO> updateRealSkin(@Validated(UpdateGroup.class) SkinPO po,
            BindingResult bindingResult) throws Exception {

        // 스킨 실제적용스킨 처리

        // log.debug("SkinPO : {}", po);
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setApplySkinYn("Y");

        // 스킨을 실제 적용스킨으로 처리함
        ResultModel<SkinPO> result = skinConfigService.updateRealSkin(po);

        return result;
    }

    @RequestMapping("/work-skin-update")
    public @ResponseBody ResultModel<SkinPO> updateWorkSkin(@Validated(UpdateGroup.class) SkinPO po,
            BindingResult bindingResult) throws Exception {

        // 스킨 작업스킨 처리

        // log.debug("SkinPO : {}", po);
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setWorkSkinYn("Y");

        // 스킨을 작업스킨으로 업데이트
        ResultModel<SkinPO> result = skinConfigService.updateWorkSkin(po);

        return result;
    }

    @RequestMapping("/zip-upload")
    public @ResponseBody ResultModel<SkinPO> insertZipUpload(@Validated(InsertGroup.class) SkinPO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        ResultModel<SkinPO> result = new ResultModel<>();
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        try {

            // 1. 업로드 파일 경로를 넣는다
            String tempPath = FileUtil.getTempPath("");
            log.debug("tempPath : {}", tempPath);

            // 2. zip 파일 정보를 업로드 한다.
            List<FileVO> list = FileUtil.getFileListRequest(mRequest, tempPath);
            log.debug("temp file list : {}", list);

            // 3. zip 파일에 업로드 된 정보를 얻는다.
            if (list != null && list.size() == 1) {
                po.setFilePath(list.get(0).getFilePath());
                po.setFileNm(list.get(0).getFileName());
                po.setOrgFileNm(list.get(0).getFileName());
                po.setFileSize(list.get(0).getFileSize());
            }

            // 4. 스킨처리는 서비스에서 한다.
            result = skinConfigService.insertZipUpload(po);

        } catch (CustomException e) {
            throw (e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "스킨 관리" }, e);
        }

        // result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        return result;
    }

    @RequestMapping("/skin-copy")
    public @ResponseBody ResultModel<SkinPO> insertCopySkin(@Validated(InsertGroup.class) SkinPO po,
            BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SkinPO> result = skinConfigService.insertCopySkin(po);

        return result;
    }

    @RequestMapping("/skin-download")
    public String downloadSkin(SkinSO so, HttpServletResponse response) throws Exception {

        // siteId 가져오기
        String siteId = SiteUtil.getSiteId();

        // 경로 가져오기
        String savePath = SiteUtil.getSiteRootPath(siteId) + File.separator + "skins" + File.separator;
        String tempPath = FileUtil.getTempPath("");

        String skinId = so.getSkinId();

        // 압축 파일 생성 하기
        FileZipUtil.createZipFile(savePath + skinId, tempPath + File.separator + skinId + ".zip", true);

        String fileName = skinId + ".zip";
        File file = new File(tempPath + File.separator + skinId + ".zip");

        // 다운로드 처리
        response.setContentType("application/download; charset=utf-8");
        response.setContentLength((int) file.length());

        fileName = URLEncoder.encode(fileName, "utf-8");
        fileName = fileName.replaceAll("\\+", " ");
        fileName = fileName.replaceAll("\r", "");
        fileName = fileName.replaceAll("\n", "");

        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        FileUtil.writeFileToResponse(response, file);

        // 압축파일 삭제
        File delFile = new File(tempPath + File.separator + skinId + ".zip");

        // 파일이 널이 아니고 파일이 있을때만 삭제처리
        if (delFile != null && delFile.exists()) {
            FileUtil.delete(delFile);
        }

        return View.voidView();
    }

    @RequestMapping("/skin-delete")
    public @ResponseBody ResultModel<SkinPO> deleteSkin(@Validated(DeleteGroup.class) SkinPO po,
            BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // log.debug(">>>>FileView Name=" + skinId + ".zip");
        // log.debug("=====================> po : {}", po);

        ResultModel<SkinPO> result = skinConfigService.deleteSkin(po);

        return result;
    }

    @RequestMapping("/mobile-skin")
    public ModelAndView viewMobileSkin(@Validated SkinSO so, BindingResult bindingResult) {

        ModelAndView mv = new ModelAndView("/admin/design/skin/skinPcConfig");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 기본 조회 조건 PC 일경우 C 모바일경우 M
        // 화면 자체가 모바일화면 자체이기 때문에 값을 고정시켰음.
        so.setPcGbCd("M");

        List<SkinVO> skin_list = new ArrayList<>();

        skin_list = skinConfigService.selectSkinList(so);

        mv.addObject("so", so);
        mv.addObject("resultListModel", skin_list);

        return mv;
    }

    @RequestMapping("/realmobile-skin-update")
    public @ResponseBody ResultModel<SkinPO> updateRealMobileSkin(@Validated(UpdateGroup.class) SkinPO po,
            BindingResult bindingResult) throws Exception {

        // log.debug("SkinPO : {}", po);
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setApplySkinYn("Y");

        ResultModel<SkinPO> result = skinConfigService.updateRealMobileSkin(po);

        return result;
    }

    @RequestMapping("/splash-manage")
    public ModelAndView viewSplashManage(@Validated SplashSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/design/splash/splashManageList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);
        // 팝업 리스트 조회
        mv.addObject("resultListModel", skinConfigService.selectSplashManagePaging(so));

        return mv;
    }

    @RequestMapping("/splash-new")
    public ModelAndView viewSplashManageDtl(@Validated SplashSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/splash/splashConfig");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        mv.addObject("editYn", "N");
        mv.addObject("so", so);

        // 팝업 상세 조회- 등록용 < 값조회안함>
        ResultModel<PopManageVO> result = null;

        mv.addObject("resultListModel", result);

        return mv;
    }

    @RequestMapping("/splash-detail")
    public ModelAndView viewSplash(@Validated SplashSO so, BindingResult bindingResult) throws Exception {
        // 스킨 화면
        ModelAndView mv = new ModelAndView("/admin/design/splash/splashConfig");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("editYn", "Y");
        mv.addObject("so", so);

        // 팝업 상세 조회- 수정용
        ResultModel<SplashVO> result = skinConfigService.selectSplashManage(so);

        log.info("result = ", result);
        mv.addObject("resultListModel", result);

        return mv;
    }

    @RequestMapping("/splash-insert")
    public @ResponseBody ResultModel<SplashPO> insertSplashManage(@Validated(InsertGroup.class) SplashPO po, HttpServletRequest mRequest,
                                                                  BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_SPLASH));
        log.info("upload file list = " + list);
        if (list != null/* && list.size() == 1*/) {
            for (int i = 0; i < list.size(); i++) {
                if (i == 0) {
                    po.setFilePath(list.get(i).getFilePath());
                    po.setFileNm(list.get(i).getFileName());
                    po.setOrgFileNm(list.get(i).getFileName());
                    po.setFileSize(list.get(i).getFileSize());
                }
            }
        }
        if(po.getApplyAlwaysYn() != null && po.getApplyAlwaysYn().equals("Y")) {
            po.setDispEndDttm("");
            po.setDispStartDttm("");
        }
        // 팝업 등록
        ResultModel<SplashPO> result = skinConfigService.insertSplashManage(po);

        return result;
    }

    @RequestMapping("/splash-update")
    public @ResponseBody ResultModel<SplashPO> updateSplashManage(@Validated(UpdateGroup.class) SplashPO po,
                                                                  HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest, FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_SPLASH));
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                if (i == 0) {
                    po.setFilePath(list.get(i).getFilePath());
                    po.setFileNm(list.get(i).getFileName());
                    po.setOrgFileNm(list.get(i).getFileName());
                    po.setFileSize(list.get(i).getFileSize());
                }
            }
        }
        if(po.getApplyAlwaysYn() != null && po.getApplyAlwaysYn().equals("Y")) {
            po.setDispEndDttm("");
            po.setDispStartDttm("");
        }
        // 팝업 수정
        ResultModel<SplashPO> result = skinConfigService.updateSplashManage(po);

        return result;
    }

    @RequestMapping("/splash-delete")
    public @ResponseBody ResultModel<SplashPO> deleteSplashManage(SplashPOListWrapper wrapper,
                                                                  BindingResult bindingResult) throws Exception {

        // 팝업 삭제 처리
        ResultModel<SplashPO> result = skinConfigService.deleteSplashManage(wrapper);

        return result;
    }
    

    /**
     * <pre>
     * 작성일 : 2018. 9. 7.
     * 작성자 : khy
     * 설명   : 업로드된 이미지 파일을 임시 폴더에 저장한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 7. khy - 최초생성
     * </pre>
     *
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/splash-image-upload")
    @ResponseBody
    public Map imageUploadResult(MultipartHttpServletRequest mRequest) {
        Iterator<String> fileIter = mRequest.getFileNames();
        Map map = new HashMap();

        try {
            String fileOrgName;
            String extension;
            File file;
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            Boolean checkExe;
            List<MultipartFile> files;
            
            String imagePath = SiteUtil.getSiteUplaodRootPath();
            String baseFilePath = File.separator + "image";
            String filePath = imagePath + baseFilePath + File.separator + "splash" + File.separator + "splash";

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

                    file = new File(filePath);

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    mFile.transferTo(file);
                }
            }
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

}
