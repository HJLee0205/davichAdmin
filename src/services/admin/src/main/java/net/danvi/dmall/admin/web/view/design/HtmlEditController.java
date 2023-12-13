package net.danvi.dmall.admin.web.view.design;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections.ArrayStack;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.HtmlEditPO;
import net.danvi.dmall.biz.app.design.model.HtmlEditSO;
import net.danvi.dmall.biz.app.design.model.HtmlEditVO;
import net.danvi.dmall.biz.app.design.service.HtmlEditService;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 6. 09.
 * 작성자     : dong
 * 설명       : html 에디터 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class HtmlEditController {

    @Resource(name = "htmlEditService")
    private HtmlEditService htmlEditService;

    // @Value("#{system['system.html.editor.path']}")
    // private String editPath;

    /** 원본 스킨 경로 */
    @Value("#{system['system.origin.skin.path']}")
    private String orgSkinPath;

    @RequestMapping("/html-edit-pc")
    public ModelAndView viewHtmlEdit(@Validated HtmlEditSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/html/htmlEditView");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        // 피씨와 모바일 구분값은 고정으로 처리해야하므로 url 정보 처리 해야함.
        // so.setPcGbCd("C");
        so.setWorkSkinYn("Y");

        // 작업 스킨정보 조회
        ResultModel<HtmlEditVO> resultModel = htmlEditService.getEditFileWorkInfo(so);
        HtmlEditVO htmlEditVO = resultModel.getData();
        // htmlEditVO.getPcGbCd();
        // log.debug("htmlEditVO : {}", htmlEditVO);
        // log.debug("htmlEditVO.getPcGbCd() : {}", htmlEditVO.getPcGbCd());
        String skin_id = "";
        String pcGbCd = "";

        // 작업중인 스킨관리가 없을경우 오류 문구 처리
        String nullData = "N";
        if (htmlEditVO == null) {
            nullData = "Y";
        } else {

            // siteId 가져오기
            String siteId = SiteUtil.getSiteId();

            // 기본경로 조회
            // String baseFilePath = "/" + siteId + "/" +
            // htmlEditVO.getSkinId();
            // String baseFilePath = htmlEditVO.getFolderPath();
            String baseFilePath = htmlEditVO.getSkinId();
            skin_id = htmlEditVO.getSkinId();
            pcGbCd = htmlEditVO.getPcGbCd();
             log.debug("dong baseFilePath : {}",  File.separator+baseFilePath);
            // log.debug("baseFilePath : {}", editPath + baseFilePath);
            // SiteUtil.getSiteRootPath(siteId) +
            // FileUtil.getCombinedPath("skins")
            // 작업스킨 정보 조회
            String workPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");
             log.debug("dongff baseFilePath :{}", workPath);

            so.setBaseFilePath(baseFilePath);

            List fileList = new ArrayList();
            // 폴더 정보를 재귀한수로 처리 하려고 함..
            // traversDir(new File(editPath + baseFilePath), 0, fileList);
            traversDir(new File(workPath + File.separator + baseFilePath), 0, fileList);

            // HtmlEditVO htmlEditVO = new HtmlEditVO();
            // for-loop 통한 전체 조회
            String fileInfo = "";
            String level = "";
            String fileNm = "";
            int idx = 1;
            int beforeIdx = 0;
            int cnt = 0;
            String filePath = "";

            List<HtmlEditVO> folderList = new ArrayList<HtmlEditVO>();
            HtmlEditVO htmlEditVOdtl = new HtmlEditVO();

            // 폴더 정보를 위한 값 정의 화면에 나오는 폴더 정보를 위한 값 셋팅
            ArrayStack arrayIdx = new ArrayStack(10);
            ArrayStack arrayFileNm = new ArrayStack(10);
            String[] array;
            for (Object list : fileList) {
                htmlEditVOdtl = new HtmlEditVO();
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

                htmlEditVOdtl.setIdxData(idx);
                htmlEditVOdtl.setBeforeIdx(beforeIdx);
                htmlEditVOdtl.setFileNm(fileNm);
                htmlEditVOdtl.setFilePath(filePath);
                htmlEditVOdtl.setBaseFilePath(baseFilePath);
                folderList.add(htmlEditVOdtl);
                idx++;
            }
            // htmlEditVO.setFileInfoArr(folderList);

            mv.addObject("folderList", folderList);
        }

        // log.debug("folderList : {}", folderList);
        mv.addObject("dataChk", nullData);
        mv.addObject("skinId", skin_id);
        mv.addObject("pcGbCd", pcGbCd);
        mv.addObject("so", so);

        return mv;
    }

    // recursive funtion
    private static void traversDir(File dir, final int level, final List fileList) {
        dir.listFiles(new FileFilter() {

            public boolean accept(File file) {
                if (file.isDirectory()) {
                    // 폴더 정보 리턴 하려고 함
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

    @RequestMapping("/html-edit")
    public ModelAndView viewHtmlEditHp(@Validated HtmlEditSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/design/html/htmlEditView");

        // 현재 사용하지 않음 차후 모바일쪽에서 필요할때 사용하려고 함.
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        // 피씨와 모바일 구분값은 고정으로 처리해야하므로 url 정보 처리 해야함.
        so.setPcGbCd("M");
        so.setWorkSkinYn("Y");

        ResultModel<HtmlEditVO> resultModel = htmlEditService.getEditFileWorkInfo(so);
        HtmlEditVO htmlEditVO = resultModel.getData();
        // htmlEditVO.getPcGbCd();
        // log.debug("htmlEditVO : {}", htmlEditVO);
        // log.debug("htmlEditVO.getPcGbCd() : {}", htmlEditVO.getPcGbCd());

        // siteId 가져오기
        String siteId = SiteUtil.getSiteId();

        // 차후 사이트 정보 작업정보 확인후 처리 하는게 좋을거 같습니다.
        String baseFilePath = htmlEditVO.getSkinId();
        // log.debug("dong baseFilePath : {}", editPath + File.separator +
        // baseFilePath);

        String workPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");
        // log.debug("dongff baseFilePath :{}", workPath);

        so.setBaseFilePath(baseFilePath);

        List fileList = new ArrayList();
        // 폴더 정보를 재귀한수로 처리 하려고 함..
        // traversDir(new File(editPath + baseFilePath), 0, fileList);
        traversDir(new File(workPath + File.separator + baseFilePath), 0, fileList);

        // HtmlEditVO htmlEditVO = new HtmlEditVO();
        // for-loop 통한 전체 조회
        String fileInfo = "";
        String level = "";
        String fileNm = "";
        int idx = 1;
        int beforeIdx = 0;
        int cnt = 0;
        String filePath = "";

        List<HtmlEditVO> folderList = new ArrayList<HtmlEditVO>();
        HtmlEditVO htmlEditVOdtl = new HtmlEditVO();

        ArrayStack arrayIdx = new ArrayStack(10);
        ArrayStack arrayFileNm = new ArrayStack(10);
        String[] array;
        for (Object list : fileList) {
            htmlEditVOdtl = new HtmlEditVO();
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

            htmlEditVOdtl.setIdxData(idx);
            htmlEditVOdtl.setBeforeIdx(beforeIdx);
            htmlEditVOdtl.setFileNm(fileNm);
            htmlEditVOdtl.setFilePath(filePath);
            htmlEditVOdtl.setBaseFilePath(baseFilePath);
            folderList.add(htmlEditVOdtl);
            idx++;
        }

        // htmlEditVO.setFileInfoArr(folderList);

        mv.addObject("folderList", folderList);

        // log.debug("folderList : {}", folderList);

        mv.addObject("so", so);

        return mv;
    }

    @RequestMapping("/file-info")
    public @ResponseBody ResultModel<HtmlEditVO> selectEditFileInfo(HtmlEditSO so) {
        // 선택된 폴더에 폴더 안의 정보 확인

        // 기존소스 삭제처리
        // ResultModel<HtmlEditVO> resultModel =
        // htmlEditService.getEditFileInfo(so);

        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();

        HtmlEditVO htmlEditVO = new HtmlEditVO();
        List<HtmlEditVO> folderList = new ArrayList<HtmlEditVO>();
        HtmlEditVO htmlEditVOdtl = new HtmlEditVO();

        String siteId = SiteUtil.getSiteId();
        String workPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");

        String file = workPath + File.separator + so.getBaseFilePath() + so.getFilePath();

        log.debug("file : {}", workPath);
        log.debug("file : {}", so.getBaseFilePath());
        log.debug("file : {}", so.getFilePath());

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
            for (int i = 0; i < files.length; i++) {
                htmlEditVOdtl = new HtmlEditVO();
                String fileName = files[i].getName();

                String fileValue = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
                // 폴더안의 정보를 폴더가 아닌 내용만 보여주게 처리 파일에 대해서만 처리
                if (files[i].isDirectory()) {

                } else {
                    // 수정 가능한 파일들만 확인후 보여준다.
                    if (fileValue.equals("js") || fileValue.equals("css") || fileValue.equals("jsp")
                            || fileValue.equals("html") || fileValue.equals("htm")) {
                        fileName.substring(fileName.length() - 3, fileName.length());
                        htmlEditVOdtl.setFileNm(fileName);
                        htmlEditVOdtl.setFilePath(so.getFilePath());
                        htmlEditVOdtl.setBaseFilePath(so.getBaseFilePath());
                        folderList.add(htmlEditVOdtl);
                    }
                }

            }
        }

        htmlEditVO.setFileInfoArr(folderList);
        resultModel.setData(htmlEditVO);

        return resultModel;
    }

    @RequestMapping("/file-detailinfo")
    public @ResponseBody ResultModel<HtmlEditVO> selectEditFileDtlInfo(HtmlEditSO so) {
        // ResultModel<HtmlEditVO> resultModel =
        // htmlEditService.getEditFileDtlInfo(so);

        // 선택된 파일정보 읽기

        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();
        HtmlEditVO htmlEditVO = new HtmlEditVO();

        String siteId = SiteUtil.getSiteId();
        String workPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");
        // 파일 읽기
        String file = workPath + File.separator + so.getBaseFilePath() + so.getFilePath() + File.separator+ so.getFileNm();

        // 파일 읽기처리
        FileReader in = null;
        try {
            File f = new File(file);
            if (f != null && f.exists()) {

                in = new FileReader(f);

                BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f),"utf-8"));

                int ch;
                StringBuffer stringBuffer = new StringBuffer();
                while ((ch = br.read()) != -1) {
                    stringBuffer.append((char) ch);
                }
                // 파일읽기 데이터를 스트링 버퍼에 담는다.
                htmlEditVO.setContent(stringBuffer.toString());
            }
        } catch (Exception e) {
            throw new CustomException("biz.exception.html.noresult", new Object[] { "HTML 편집" }, e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    throw new CustomException("biz.exception.html.noresult", new Object[] { "HTML 편집" }, e);
                }
            }
        }

        resultModel.setData(htmlEditVO);
        // log.debug("resultModel : {}", resultModel);
        return resultModel;
    }

    @RequestMapping("/file-detailnew")
    public ModelAndView selectEditFileDtlNew(@Validated HtmlEditSO so, BindingResult bindingResult) {
        // ResultModel<HtmlEditVO> resultModel =
        // htmlEditService.getEditFileDtlInfo(so);
        // 원본파일 보여주기
        ModelAndView mv = new ModelAndView("/admin/design/html/htmlEditOrgView");

        mv.addObject("so", so);

        return mv;
    }

    @RequestMapping("/html-insert")
    public @ResponseBody ResultModel<HtmlEditPO> insertHtmlEdit(@Validated(InsertGroup.class) HtmlEditPO po,
            BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        // if (bindingResult.hasErrors()) {
        // log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
        // throw new JsonValidationException(bindingResult);
        // }

        // 파일 생성하기
        ResultModel<HtmlEditPO> result = new ResultModel<>();
        // String file = editPath + po.getBaseFilePath() + "/" +
        // po.getFilePath() + "/" + po.getFileNm();

        String siteId = SiteUtil.getSiteId();
        String workPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");
        String file = workPath + File.separator + po.getBaseFilePath() + po.getFilePath() + File.separator
                + po.getFileNm();

        // log.debug("file : {}", file);

        File f1 = new File(file);

        try {
            // log.debug("===============================>>>f1 : {}", f1);
            if (f1 != null && !f1.exists()) {
                // 신규 파일 생성한다.
                f1.createNewFile();
            }
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "HTML 편집" }, e);
        }

        result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        return result;
    }

    @RequestMapping("/html-update")
    public @ResponseBody ResultModel<HtmlEditPO> updateHtmlEdit(@Validated(UpdateGroup.class) HtmlEditPO po,
            BindingResult bindingResult) throws Exception {

        // ResultModel<HtmlEditPO> result = htmlEditService.updateHtmlEdit(po);
        // 파일 수정하기
        ResultModel<HtmlEditPO> result = new ResultModel<>();

        FileWriter out = null;

        try {
            String siteId = SiteUtil.getSiteId();
            String workPath = SiteUtil.getSiteRootPath(siteId) + FileUtil.getCombinedPath("skins");
            String file = workPath + File.separator + po.getBaseFilePath() + po.getFilePath() + File.separator
                    + po.getFileNm();

            // 파일 정보를 덮어쓰기 처리
            File f = new File(file);
            if (f != null && f.exists()) {
                out = new FileWriter(f);
                out.write(po.getContent());
                out.close();
            }
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "HTML 편집" }, e);
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    throw new CustomException("biz.exception.html.noresult", new Object[] { "HTML 편집" }, e);
                }
            }
        }

        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    @RequestMapping("/origin-file-detailinfo")
    public @ResponseBody ResultModel<HtmlEditVO> selectOrgEditFileDtlInfo(HtmlEditSO so) {

        // 원본파일 미리보기
        ResultModel<HtmlEditVO> resultModel = new ResultModel<>();
        HtmlEditVO htmlEditVO = new HtmlEditVO();

        String siteId = SiteUtil.getSiteId();
        String saveOrgPath = orgSkinPath + FileUtil.getCombinedPath(siteId, so.getBaseFilePath());
        // 파일 읽기
        String file = saveOrgPath + so.getFilePath() + File.separator + so.getFileNm();

        // 원본 파일 읽기 처리
        FileReader in = null;
        try {
            File f = new File(file);
            if (f != null && f.exists()) {
                in = new FileReader(f);
                int ch;
                StringBuffer stringBuffer = new StringBuffer();
                while ((ch = in.read()) != -1) {
                    stringBuffer.append((char) ch);
                }
                // 파일읽기 데이터를 스트링 버퍼에 담는다.
                htmlEditVO.setContent(stringBuffer.toString());
            }
        } catch (Exception e) {
            throw new CustomException("biz.exception.html.noresult", new Object[] { "HTML 편집" }, e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    throw new CustomException("biz.exception.html.noresult", new Object[] { "HTML 편집" }, e);
                }
            }
        }

        resultModel.setData(htmlEditVO);
        // log.debug("resultModel : {}", resultModel);
        return resultModel;
    }

    @RequestMapping("/skin-preview")
    public @ResponseBody ResultModel<HtmlEditVO> preViewInfo(HtmlEditSO so) {

        // 파일 정보에 맞는 url 링크 가져오기

        ResultModel<HtmlEditVO> resultModel = htmlEditService.getPreViewInfo(so);
        HtmlEditVO htmlEditVO = resultModel.getData();

        resultModel.setData(htmlEditVO);
        // log.debug("resultModel : {}", resultModel);
        return resultModel;
    }
}
