package net.danvi.dmall.admin.web.view.common.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.common.model.FileDownloadSO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.util.FileUtil;

import javax.annotation.Resource;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 5.
 * 작성자     : dong
 * 설명       : 공통 다운로드 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/common")
public class DownloadController {

    // @Value("#{system['system.upload.path']}")
    // private String filePath;

    // @Resource(name = "bbsManageService")
    // private BbsManageService bbsManageService;
    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 파일 다운로드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileDownloadSO
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/common-download")
    public String fileDownload(ModelMap map, FileDownloadSO fileDownloadSO) throws Exception {
        FileVO file;

        switch (fileDownloadSO.getType()) {
        case "BBS":
            // 서비스에서 파일의 경로(업로드루트 + 파일경로 + 파일명)와 파일명을 가진 FileVO객체를 반환하도록 작성해주세요
            fileDownloadSO.setFileNo(fileDownloadSO.getId1());
//            file = bbsManageService.selectAtchFileDtl(fileDownloadSO);
//            log.debug(file.getFilePath() + "|||" + file.getFileOrgName());
            break;
        default:
            throw new CustomException("정의된 파일 타입이 아닙니다.");
        }

        FileViewParam fileView = new FileViewParam();

//        fileView.setFilePath(file.getFilePath());
//        fileView.setFileName(file.getFileOrgName());
//        fileView.setFilePath(FileUtil.getAllowedFilePath(file.getFilePath()));
//        fileView.setFileName(FileUtil.getAllowedFilePath(file.getFileOrgName()));
        map.put(AdminConstants.FILE_PARAM_NAME, fileView);

        return View.fileDownload();
    }

}
