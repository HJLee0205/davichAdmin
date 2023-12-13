package net.danvi.dmall.admin.web.view.design;

import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.*;
import net.danvi.dmall.biz.app.design.service.IconManageService;
import net.danvi.dmall.biz.app.design.service.IconManageService;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Objects;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 07. 04.
 * 작성자     : dong
 * 설명       : 배너 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class IconManageController {

    @Resource(name = "iconManageService")
    private IconManageService iconManageService;

    @RequestMapping("/icon")
    public ModelAndView viewIcon(@Validated IconSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/icon/iconManageList");

        // 배너 리스트 조회
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        so.setSidx("REG_DTTM");
        so.setSord("DESC");

        mv.addObject("so", so);
        // 화면에 보여줄 스킨리스트 조회 셀렉트 박스로 사용함
        //mv.addObject("resultListModel", iconManageService.selectSkinList(so));

        return mv;
    }

    @RequestMapping("/icon-list")
    public @ResponseBody ResultListModel<IconVO> selectIconListPaging(IconSO so) {
        so.setSidx("REG_DTTM");
        so.setSord("DESC");
        // 배너 리스트 페이징 조회
        ResultListModel<IconVO> resultListModel = iconManageService.selectIconListPaging(so);
        return resultListModel;
    }

    @RequestMapping("/icon-detail")
    public ModelAndView viewIconDtl(@Validated IconSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/icon/iconManageDtl");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);

        // 배너 상세 조회 - 상세 조회, 스킨리스트 조회
        ResultModel<IconVO> result = iconManageService.viewIconDtl(so);

        mv.addObject("resultModel", result);
        mv.addObject("editYn", "Y");

        return mv;
    }

    @RequestMapping("/icon-detail-new")
    public ModelAndView viewIconDtlNew(@Validated IconSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/icon/iconManageDtl");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);

        mv.addObject("editYn", "N");

        return mv;
    }

    @RequestMapping("/icon-goods-list")
    public @ResponseBody ResultListModel<GoodsVO> selectIconGoodsList(IconSO so) throws Exception {
        log.info("selectIconGoodsList");
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<GoodsVO> goodsVOList = iconManageService.selectIconGoodsList(so);
        log.info("selectIconGoodsList goodsVOList = "+goodsVOList);

        return goodsVOList;
    }

    @RequestMapping("/icon-insert")
    public @ResponseBody ResultModel<IconPO> insertIcon(@Validated(InsertGroup.class) IconPO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        //FileUtil.checkUploadable((MultipartHttpServletRequest) mRequest);
        // 파일 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_ICON));
        log.info("upload file list = "+list);
        if (list != null/* && list.size() == 1*/) {
            for (int i = 0; i < list.size(); i++) {
                if(i == 0) {
                    po.setImgPath(list.get(i).getFilePath());
                    po.setImgNm(list.get(i).getFileName());
                    po.setOrgImgNm(list.get(i).getFileName());
                    po.setImgSize(list.get(i).getFileSize());
                }
            }
        }

        // 배너 정보 등록
        ResultModel<IconPO> result = iconManageService.insertIcon(po);

        return result;
    }

    @RequestMapping("/icon-update")
    public @ResponseBody ResultModel<IconPO> updateIcon(@Validated(UpdateGroup.class) IconPO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_ICON));
        if (list != null /*&& list.size() == 1*/) {
            for (int i = 0; i < list.size(); i++) {
                if(i == 0) {
                    po.setImgPath(list.get(i).getFilePath());
                    po.setImgNm(list.get(i).getFileName());
                    po.setOrgImgNm(list.get(i).getFileName());
                    po.setImgSize(list.get(i).getFileSize());
                }
            }
        }

        // 배너 정보 수정
        ResultModel<IconPO> result = iconManageService.updateIcon(po);

        return result;
    }

    @RequestMapping("/icon-view-update")
    public @ResponseBody ResultModel<IconPO> updateIconView(IconPOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {
        // 배너 전시 미전시 처리
        ResultModel<IconPO> result = iconManageService.updateIconView(wrapper);

        return result;
    }

    @RequestMapping("/icon-delete")
    public @ResponseBody ResultModel<IconPO> deleteIcon(IconPOListWrapper wrapper, BindingResult bindingResult)
            throws Exception {
        // 배너 삭제
        ResultModel<IconPO> result = iconManageService.deleteIcon(wrapper);

        return result;
    }

}
