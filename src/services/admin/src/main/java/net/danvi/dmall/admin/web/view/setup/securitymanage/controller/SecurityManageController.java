package net.danvi.dmall.admin.web.view.setup.securitymanage.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * Created by dong on 2016-06-13.
 */

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpConfigPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.ContentsProtectionPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.SecurityManagePO;
import net.danvi.dmall.biz.app.setup.securitymanage.service.SecurityManageService;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 9. 29.
 * 작성자     : dong
 * 설명       : 보안 관련 설정을 관리한다.
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/securitymanage/SecurityManage")
public class SecurityManageController {

    @Resource(name = "securityManageService")
    private SecurityManageService securityManageService;

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 보안 관련 정보를 취득하여 
     *          보안 설정 화면 (/admin/setup/securitymanage/securityManage) view에 설정하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/security-config")
    public ModelAndView viewSecurityConfig() {
        ModelAndView modelAndView = new ModelAndView("/admin/setup/securitymanage/securityManage");
        SecurityManagePO po = securityManageService.selectSecurityConfig();
        modelAndView.addObject(po);

        return modelAndView;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 보안 관련 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/security-config-update")
    public @ResponseBody ResultModel<SecurityManagePO> saveSecurityConfig(SecurityManagePO po) {
        return securityManageService.saveSecurityConfig(po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 접근 제한 IP 설정 정보를 취득하여 
     *          접근 제한 관리 화면(/admin/setup/securitymanage/accessBlockManage) 
     *          view 에 설정하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/accessblock-ip-config")
    public ModelAndView viewAccessBlockIpConfig() {
        ModelAndView modelAndView = new ModelAndView("/admin/setup/securitymanage/accessBlockManage");
        AccessBlockIpConfigPO po = securityManageService.selectAccessBlockIpConfig();
        modelAndView.addObject("po", po);

        return modelAndView;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 접근 제한 IP 목록을 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/accessblockip-list")
    public @ResponseBody ResultListModel<AccessBlockIpPO> selectAccessBlockIpList(AccessBlockIpPO po) {
        return securityManageService.selectAccessBlockIpList(po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 접근 제한 IP 설정 정보를 수정한다.  
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/accessblockip-config-insert")
    public @ResponseBody ResultModel<AccessBlockIpConfigPO> saveAccessBlockIpConfig(AccessBlockIpConfigPO po) {
        return securityManageService.saveAccessBlockIpConfig(po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 접근 제한 IP 설정 정보를 삭제한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/accessblockip-config-delete")
    public @ResponseBody ResultModel<AccessBlockIpConfigPO> deleteAccessBlockIpConfig(AccessBlockIpConfigPO po) {
        return securityManageService.deleteAccessBlockIpConfig(po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 컨텐츠 보호 설정 정보를 취득하여 
     *          컨텐츠 보호 관리 화면(/admin/setup/securitymanage/contentsProtectionManage) 
     *          view 에 설정하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/contentprotect-config")
    public ModelAndView viewContentsProtectionManage() {
        ModelAndView modelAndView = new ModelAndView("/admin/setup/securitymanage/contentsProtectionManage");
        ContentsProtectionPO po = securityManageService.selectContentsProtection();
        modelAndView.addObject("po", po);

        return modelAndView;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 컨텐츠 보호 정보를 수정한 후 결과를 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @RequestMapping("/contents-protection-update")
    public @ResponseBody ResultModel<ContentsProtectionPO> saveContentsProtection(ContentsProtectionPO po) {
        return securityManageService.updateContentsProtection(po);
    }
}
