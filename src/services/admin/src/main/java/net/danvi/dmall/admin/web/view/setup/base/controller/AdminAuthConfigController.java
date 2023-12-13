package net.danvi.dmall.admin.web.view.setup.base.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.base.model.*;
import net.danvi.dmall.biz.app.setup.base.service.AdminAuthConfigService;
import net.danvi.dmall.biz.system.service.MenuService;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

import javax.annotation.Resource;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 5.
 * 작성자     : dong
 * 설명       : 관리자 권한 설정
 * </pre>
 */
@Controller
@RequestMapping("/admin/setup/base/baseInfoConfig/adminAuthConfig/")
@Slf4j
public class AdminAuthConfigController {

    @Resource(name = "adminAuthConfigService")
    private AdminAuthConfigService adminAuthConfigService;

    @Resource(name = "menuService")
    private MenuService menuService;

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 권한 설정 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("auth-config")
    public ModelAndView viewAdmAuthConfig() {
        ModelAndView mav = new ModelAndView("/admin/setup/base/baseInfoConfig/adminAuthConfig/AdmAuthConfig");
        mav.addObject("MENU", menuService.selectLevelOneMenu());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 그룹 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("manager-group-list")
    public @ResponseBody ResultListModel<ManagerGroupVO> selectManagerGroupList(ManagerGroupSO so) {
        ResultListModel<ManagerGroupVO> resultListModel = adminAuthConfigService.selectManagerGroupList(so);

        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 그룹 상세 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("manager-group-detail")
    public @ResponseBody ResultModel<ManagerGroupVO> selectManagerGroup(ManagerGroupVO vo) {
        ResultModel<ManagerGroupVO> resultModel = adminAuthConfigService.selectManagerGroup(vo);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 그룹 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("manager-group-insert")
    public @ResponseBody ResultModel<ManagerGroupPO> insertManagerGroup(ManagerGroupPO po,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ManagerGroupPO> resultModel = adminAuthConfigService.insertManagerGroup(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 그룹 변경
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("manager-group-update")
    public @ResponseBody ResultModel<ManagerGroupPO> updateManagerGroup(ManagerGroupPO po,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ManagerGroupPO> resultModel = adminAuthConfigService.updateManagerGroup(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 그룹 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("manager-group-delete")
    public @ResponseBody ResultModel<ManagerGroupPO> deleteManagerGroup(ManagerGroupPO po,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ManagerGroupPO> resultModel = adminAuthConfigService.deleteManagerGroup(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 목록 페이징 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("manager-list")
    public @ResponseBody ResultListModel<ManagerVO> selectManagerPaging(ManagerSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        so.setEncKeyword(so.getKeyword());

        ResultListModel<ManagerVO> resultListModel = adminAuthConfigService.selectManagerPaging(so);

        return resultListModel;
    }

    @RequestMapping("isaddible")
    public @ResponseBody ResultModel<ManagerPO> isAddible(ManagerSO so) {
        ResultModel resultModel = adminAuthConfigService.isAddible(so);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 관리자 정보 저장
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("manager-info-insert")
    public @ResponseBody ResultModel<ManagerPO> saveManager(ManagerPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<ManagerPO> resultModel = adminAuthConfigService.saveManager(wrapper);

        return resultModel;
    }

}
