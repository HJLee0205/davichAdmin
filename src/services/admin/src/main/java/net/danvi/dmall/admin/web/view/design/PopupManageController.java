package net.danvi.dmall.admin.web.view.design;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.util.FileUtil;
import net.danvi.dmall.biz.app.design.model.*;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.service.PopupManageService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;

import java.io.File;
import java.util.List;
import java.util.Objects;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 09.
 * 작성자     : dong
 * 설명       : 게시판 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class PopupManageController {

    @Resource(name = "popupManageService")
    private PopupManageService popupManageService;

    @RequestMapping("/pop-manage")
    public ModelAndView viewPopManage(@Validated PopManageSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/design/popup/popupManageList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        if (so.getPcGbCd() == null || Objects.equals(so.getPcGbCd(), "")) {
            so.setPcGbCd("C");
        }
        if (so.getPopupGbCd() == null || Objects.equals(so.getPopupGbCd(), "")) {
            so.setPopupGbCd("P");
        }
        if (so.getPopupGrpCd() == null || Objects.equals(so.getPopupGrpCd(), "")) {
            so.setPopupGrpCd("MM");
        }

        mv.addObject("so", so);
        // 팝업 리스트 조회
        mv.addObject("resultListModel", popupManageService.selectPopManagePaging(so));

        return mv;
    }

    @RequestMapping("/pop-detail")
    public ModelAndView viewPopManageDtl(@Validated PopManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/popup/popupManageDtl");

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

    @RequestMapping("/pop")
    public ModelAndView selectPopManage(@Validated PopManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/popup/popupManageDtl");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        mv.addObject("editYn", "Y");
        mv.addObject("so", so);

        // 팝업 상세 조회- 수정용
        ResultModel<PopManageVO> result = popupManageService.selectPopManage(so);

        log.info("result = ", result);
        mv.addObject("resultListModel", result);

        return mv;
    }

    @RequestMapping("/pop-insert")
    public @ResponseBody ResultModel<PopManagePO> insertPopManage(@Validated(InsertGroup.class) PopManagePO po, HttpServletRequest mRequest,
                                                                  BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_POPUP));
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
        ResultModel<PopManagePO> result = popupManageService.insertPopManage(po);

        return result;
    }

    @RequestMapping("/pop-update")
    public @ResponseBody ResultModel<PopManagePO> updatePopManage(@Validated(UpdateGroup.class) PopManagePO po,
                          HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.info("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_POPUP));
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
        ResultModel<PopManagePO> result = popupManageService.updatePopManage(po);

        return result;
    }

    @RequestMapping("/pop-delete")
    public @ResponseBody ResultModel<PopManagePO> deletePopManage(PopManagePOListWrapper wrapper,
                                                                  BindingResult bindingResult) throws Exception {

        // 팝업 삭제 처리
        ResultModel<PopManagePO> result = popupManageService.deletePopManage(wrapper);

        return result;
    }

    @RequestMapping("/pop-view-update")
    public @ResponseBody ResultModel<PopManagePO> updatePopManageView(PopManagePOListWrapper wrapper,
                                                                      BindingResult bindingResult) throws Exception {

        // 리스트 화면에서 전시 미전시 처리
        ResultModel<PopManagePO> result = popupManageService.updatePopManageView(wrapper);

        return result;
    }

}
