package net.danvi.dmall.admin.web.view.design;

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.ArrayStack;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.ImageManagePO;
import net.danvi.dmall.biz.app.design.model.ImageManagePOListWrapper;
import net.danvi.dmall.biz.app.design.model.ImageManageSO;
import net.danvi.dmall.biz.app.design.model.ImageManageVO;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 20.
 * 작성자     : dong
 * 설명       : 이미지 관리 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class ImageManageController {

    @RequestMapping("/image-manage")
    public ModelAndView viewImageManage(@Validated ImageManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/image/imageManageView");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        String imagePath = SiteUtil.getSiteUplaodRootPath();

        // 차후 사이트 정보 작업정보 확인후 처리 하는게 좋을거 같습니다.
        String baseFilePath = "/image";

        // 폴더가 없으면 생성하기
        File baseFile = new File(imagePath + baseFilePath);
        // !표를 붙여주어 파일이 존재하지 않는 경우의 조건을 걸어줌
        if (!baseFile.exists()) {
            // 디렉토리 생성 메서드
            baseFile.mkdirs();
        }

        // log.debug("baseFilePath : {}", imagePath + baseFilePath);

        so.setBaseFilePath(baseFilePath);

        List fileList = new ArrayList();
        // 폴더 정보를 재귀한수로 처리 하려고 함..
        traversDir(new File(imagePath + baseFilePath), 0, fileList);

        // ImageManageVO imageManageVO = new ImageManageVO();
        // for-loop 통한 전체 조회
        String fileInfo = "";
        String level = "";
        String fileNm = "";
        int idx = 1;
        int beforeIdx = 0;
        int cnt = 0;
        String filePath = "";

        List<ImageManageVO> folderList = new ArrayList<ImageManageVO>();
        ImageManageVO imageManageVOdtl = new ImageManageVO();

        ArrayStack arrayIdx = new ArrayStack(10);
        ArrayStack arrayFileNm = new ArrayStack(10);
        String[] array;
        for (Object list : fileList) {
            imageManageVOdtl = new ImageManageVO();
            fileInfo = (String) list;
            array = fileInfo.split("@@@");
            level = array[0];
            fileNm = array[1];

            if (level.equals("0")) {
                arrayIdx.clear();
                arrayFileNm.clear();
                arrayIdx.push(idx);
                arrayFileNm.push("/" + fileNm);
                beforeIdx = 0;
                cnt = 0;
            } else {
                if (cnt > Integer.parseInt(level)) {
                    for (int j = 0; j < (cnt + 1 - Integer.parseInt(level)); j++) {
                        arrayIdx.pop();
                        arrayFileNm.pop();
                    }
                    arrayIdx.push(idx);
                    arrayFileNm.push("/" + fileNm);
                } else if (Integer.parseInt(level) > cnt) {
                    arrayIdx.push(idx);
                    arrayFileNm.push("/" + fileNm);
                } else if (Integer.parseInt(level) == cnt) {
                    arrayIdx.pop();
                    arrayFileNm.pop();
                    arrayIdx.push(idx);
                    arrayFileNm.push("/" + fileNm);
                }

                beforeIdx = Integer.parseInt((arrayIdx.get(arrayIdx.size() - 2)).toString());
                cnt = Integer.parseInt(level);
            }
            filePath = "";
            for (int k = 0; k < arrayFileNm.size() - 1; k++) {
                filePath += arrayFileNm.get(k);
            }
            filePath += "/" + fileNm;

            imageManageVOdtl.setIdxData(idx);
            imageManageVOdtl.setBeforeIdx(beforeIdx);
            imageManageVOdtl.setFileNm(fileNm);
            imageManageVOdtl.setFilePath(filePath);
            imageManageVOdtl.setBaseFilePath(baseFilePath);
            folderList.add(imageManageVOdtl);

             log.debug("imageManageVOdtl=====> : {}", imageManageVOdtl);
            idx++;
        }

        // imageManageVO.setFileInfoArr(folderList);

        mv.addObject("folderList", folderList);

        mv.addObject("so", so);

        return mv;
    }

    // recursive funtion
    private static void traversDir(File dir, final int level, final List fileList) {
        dir.listFiles(new FileFilter() {

            public boolean accept(File file) {
                if (file.isDirectory()) {
                    // 폴더 정보 리턴 하려고 함
                    // + file.getName());
                    fileList.add(level + "@@@" + file.getName());
                    traversDir(file, level + 1, fileList);
                }
                // else {
                // 파일 정보 리턴할려고 하는 부분
                // }
                return false;
            }

        });
    }

    @RequestMapping("/image-file-info")
    public @ResponseBody ResultModel<ImageManageVO> selectImageFileInfo(ImageManageSO so) {
        // 기존소스 삭제처리
        // ResultModel<ImageManageVO> resultModel =
        // imageManageService.getEditFileInfo(so);

        ResultModel<ImageManageVO> resultModel = new ResultModel<>();

        ImageManageVO imageManageVO = new ImageManageVO();
        List<ImageManageVO> folderList = new ArrayList<ImageManageVO>();
        ImageManageVO imageManageVOdtl = new ImageManageVO();

        String imagePath = SiteUtil.getSiteUplaodRootPath();
        String baseFilePath = "/image";

        String file = imagePath + baseFilePath + so.getFilePath();

        File f = new File(file);

        // 탐색기 생성시에는
        // 처음에 넘기는 데이터는 파일데이터가 아니라 디렉토리 데이터가 되야한다
        // 따라서 파일이면 false continue가 되도록 해야한다
        if (!f.exists() || !f.isDirectory()) {
            // exits는 Tests whether the file or directory denoted by this
            // abstract pathname exists의 기능이다.
            // isDirectory는 검색한 데이터에 대해 파일인지 디렉토리인지 확인을 해준다.
            // 파일이면 false 디렉토리면 true
            log.debug("ERROR : {}", "유효하지 않은 디렉토리 입니다.");
            // System.exit(0);// 프로그램 종료
        }
        if (f != null && f.exists()) {
            File[] files = f.listFiles();
            // 지정한 디렉토리의 하위디렉토리와 파일정보를 file[] 배열에 담는다.
            // int fileCnt = 0;
            for (int i = 0; i < files.length; i++) {
                imageManageVOdtl = new ImageManageVO();
                String fileName = files[i].getName();
                // String fileDate = files[i].lastModified()/1000/86400 + "";
                Date date = new Date(files[i].lastModified());
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);

                // files[i].isDirectory() ? "[" + fileName + "]" : fileName +
                // "(" +
                // files[i].length() + "bytes");
                // 삼항연산자를 이용해서 isDerectory를 이용해 Directory가 맞으면 [filename]을 출력하고
                // false면 파일명+파일용량(length가 크기)+byte 를 출력하게 된다.
                if (files[i].isDirectory()) {

                } else {
                    // 검색어가 없을때와 있을경우 맞는거에 대한값만 리턴한다.
                    if (so.getSearchNm() == null || so.getSearchNm().equals("")
                            || fileName.indexOf(so.getSearchNm()) > -1) {
                        // fileName.indexOf(so.getSearchNm());
                        imageManageVOdtl.setFileNm(fileName);
                        imageManageVOdtl.setFilePath(so.getFilePath());
                        imageManageVOdtl.setFileSize((files[i].length() / 1024) + " kb");
                        imageManageVOdtl.setFileDate(cal.get(Calendar.YEAR) + "." + (cal.get(Calendar.MONTH) + 1) + "."
                                + cal.get(Calendar.DAY_OF_MONTH));
                        imageManageVOdtl.setBaseFilePath(so.getBaseFilePath());
                        folderList.add(imageManageVOdtl);
                    }
                    // fileCnt++;
                }

            }
        }
        imageManageVO.setFileCnt(folderList.size());
        imageManageVO.setFileInfoArr(folderList);
        resultModel.setData(imageManageVO);

        return resultModel;
    }

    @RequestMapping("/image-delete")
    public @ResponseBody ResultModel<ImageManagePO> deleteImageManage(ImageManagePOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {

        ResultModel<ImageManagePO> result = new ResultModel<>();
        String imagePath = SiteUtil.getSiteUplaodRootPath();
        String baseFilePath = File.separator + "image";
        try {
            for (ImageManagePO po : wrapper.getList()) {
                String file = imagePath + baseFilePath + po.getFilePath() + File.separator + po.getFileNm();
                File f = new File(file);
                // 파일이 널이 아니고 파일이 있을때만 삭제처리
                if (f != null && f.exists()) {
                    FileUtil.delete(f);
                }
            }
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이미지 관리" }, e);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        return result;
    }

    @RequestMapping("/image-upload")
    public @ResponseBody ResultModel<ImageManagePO> insertImageUpload(@Validated(InsertGroup.class) ImageManagePO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        ResultModel<ImageManagePO> result = new ResultModel<>();
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        try {
            String imagePath = SiteUtil.getSiteUplaodRootPath();
            // 차후 사이트 정보 작업정보 확인후 처리 하는게 좋을거 같습니다.
            String baseFilePath = File.separator + "image";
            if (!po.getOrgFileNm().equals("")) {
                String file = imagePath + baseFilePath + po.getFilePath() + File.separator + po.getOrgFileNm();
                File f = new File(file);
                if (f != null && f.exists()) {
                    FileUtil.delete(f);
                }
            }

            FileUtil.getFileListRequest(mRequest, imagePath + baseFilePath + po.getFilePath());

        } catch (CustomException e) {
            throw (e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이미지 관리" }, e);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        return result;
    }

    @RequestMapping("/one-image-delete")
    public @ResponseBody ResultModel<ImageManagePO> deleteOneImageFile(@Validated(DeleteGroup.class) ImageManagePO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        ResultModel<ImageManagePO> result = new ResultModel<>();
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        try {
            String imagePath = SiteUtil.getSiteUplaodRootPath();
            //
            String baseFilePath = File.separator + "image";
            String file = imagePath + baseFilePath + po.getFilePath() + File.separator + po.getFileNm();
            File f = new File(file);
            // 파일이 널이 아니고 파일이 있을때만 삭제처리
            if (f != null && f.exists()) {
                FileUtil.delete(f);
            }

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이미지 관리" }, e);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        return result;
    }

    @RequestMapping("/image-folder-create")
    public @ResponseBody ResultModel<ImageManagePO> saveImageFolderCreate(
            @Validated(DeleteGroup.class) ImageManagePO po, HttpServletRequest mRequest, BindingResult bindingResult)
            throws Exception {

        ResultModel<ImageManagePO> result = new ResultModel<>();
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.save"));
        try {
            String imagePath = SiteUtil.getSiteUplaodRootPath();
            //
            String baseFilePath = File.separator + "image";

            String changeFileNm = FileUtil.replaceFileNm(po.getFileNm().toString());
            String file = imagePath + baseFilePath + po.getFilePath() + File.separator + changeFileNm;

            File dir = new File(file);
            // 폴더가 없으면 생성
            if (dir == null || !dir.exists() || !dir.isDirectory()) {
                dir.mkdir();
            }

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이미지 관리" }, e);
        }

        return result;
    }

    @RequestMapping("/image-folder-delete")
    public @ResponseBody ResultModel<ImageManagePO> deleteImageFolder(@Validated(DeleteGroup.class) ImageManagePO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        ResultModel<ImageManagePO> result = new ResultModel<>();
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        try {
            String imagePath = SiteUtil.getSiteUplaodRootPath();
            //
            String baseFilePath = File.separator + "image";
            String file = imagePath + baseFilePath + po.getFilePath();

            FileUtil.deleteFolder(file);

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "이미지 관리" }, e);
        }

        return result;
    }

}
