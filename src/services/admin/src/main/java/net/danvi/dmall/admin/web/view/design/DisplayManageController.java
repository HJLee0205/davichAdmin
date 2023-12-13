package net.danvi.dmall.admin.web.view.design;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.design.model.DisplayPO;
import net.danvi.dmall.biz.app.design.model.DisplayPOListWrapper;
import net.danvi.dmall.biz.app.design.model.DisplaySO;
import net.danvi.dmall.biz.app.design.model.DisplayVO;
import net.danvi.dmall.biz.app.design.service.DisplayManageService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 19.
 * 작성자     : dong
 * 설명       : 게시판 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class DisplayManageController {

    @Value("#{system['system.upload.path']}")
    private String uploadPath;

    @Resource(name = "displayManageService")
    private DisplayManageService displayManageService;

    @RequestMapping("/display")
    public ModelAndView viewDisplay(@Validated DisplaySO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/display/displayManageList");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);
        mv.addObject("resultListModel", displayManageService.selectDisplayList(so));

        return mv;
    }

    @RequestMapping("/display-detail")
    public ModelAndView viewDisplayDtl(@Validated DisplaySO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/display/displayManageDtl");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);

        ResultModel<DisplayVO> result = displayManageService.viewDisplayDtl(so);

        mv.addObject("resultModel", result);

        return mv;
    }

    @RequestMapping("/display-detail-info")
    public ModelAndView selectDisplay(@Validated DisplaySO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/display/displayManageDtl");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);

        ResultModel<DisplayVO> result = displayManageService.selectDisplay(so);

        mv.addObject("resultModel", result);

        return mv;
    }

    @RequestMapping("display-banner")
    public @ResponseBody ResultModel<DisplayVO> selectDisplayBanner(DisplaySO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<DisplayVO> result = displayManageService.viewDisplayDtl(so);

        return result;
    }

    @RequestMapping("/display-update")
    public @ResponseBody ResultModel<DisplayPO> updateDisplay(@Validated(UpdateGroup.class) DisplayPO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_DISPLAY));
        if (list != null && list.size() == 1) {
            po.setFilePath(list.get(0).getFilePath());
            po.setFileNm(list.get(0).getFileName());
            po.setOrgFileNm(list.get(0).getFileName());
            po.setFileSize(list.get(0).getFileSize());
        }

        ResultModel<DisplayPO> result = displayManageService.updateDisplay(po);

        return result;
    }

    @RequestMapping("/display-banner-update")
    public @ResponseBody ResultModel<DisplayPO> updateDisplayView(DisplayPOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {

        ResultModel<DisplayPO> result = displayManageService.updateDisplayBanner(wrapper);

        return result;
    }

    /**
     * 첨부이미지 보기
     * 
     * @param map
     * @param so
     * @return
     */
    @RequestMapping(value = "/image-preview")
    public String viewImage(ModelMap map, DisplaySO so) {
        ResultModel<DisplayVO> result = displayManageService.selectDisplay(so);
        setMap(map, result.getData().getFilePath(), result.getData().getFileNm());

        return View.imageView();
    }

    private void setMap(ModelMap map, String filePath, String fileName) {
        FileViewParam fileView = new FileViewParam();
        fileView.setFilePath(
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_DISPLAY, filePath, fileName));
        map.put(AdminConstants.FILE_PARAM_NAME, fileView);
    }

    @RequestMapping("/display-insert")
    public @ResponseBody ResultModel<DisplayPO> insertDisplay(@Validated(InsertGroup.class) DisplayPO po,
            BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        ResultModel<DisplayPO> result = displayManageService.insertDisplay(po);

        return result;
    }

    @RequestMapping("/display-delete")
    public @ResponseBody ResultModel<DisplayPO> deleteDisplay(@Validated(DeleteGroup.class) DisplayPO po,
            BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        ResultModel<DisplayPO> result = displayManageService.deleteDisplay(po);

        return result;
    }

}
