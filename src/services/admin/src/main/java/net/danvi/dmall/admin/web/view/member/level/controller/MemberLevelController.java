package net.danvi.dmall.admin.web.view.member.level.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelSO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import net.danvi.dmall.biz.app.member.level.service.MemberLevelService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 6. 09.
 * 작성자     : dong
 * 설명       : 회원 등급 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/member/")
public class MemberLevelController {

    @Resource(name = "memberLevelService")
    private MemberLevelService memberLevelService;

    @Resource(name = "bizService")
    private BizService bizService;

    /**
     * <pre>
     * 작성일 : 2016. 6. 9.
     * 작성자 : dong
     * 설명   : 회원 등급 조회 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 9. dong - 최초생성
     * </pre>
     *
     * @param
     * @return
     */
    @RequestMapping("/level/membergrade")
    public ModelAndView viewMemGradeList() {
        ModelAndView mv = new ModelAndView("/admin/member/level/MemberGradeView");

        MemberLevelSO so = new MemberLevelSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원등급 리스트 조회
        mv.addObject("resultModel", memberLevelService.viewMemGradeList(so));

        // 회원가입 혜택 조회
        mv.addObject("signupBnfModel", memberLevelService.viewSignupBnf(so));

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 10.
     * 작성자 : dong
     * 설명   : 회원 등급 산정 기준 설정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 10. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelPO
     * @return
     */
    @RequestMapping("/level/membergrade-calculation-update")
    public @ResponseBody ResultModel<MemberLevelPO> updateMemGradeManageCfg(
            @Validated(UpdateGroup.class) MemberLevelPO po, BindingResult bindingResult) throws Exception {

        // 변경자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<MemberLevelPO> result = memberLevelService.updateMemGradeManageCfg(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : 자동 등급조정(갱신) 설정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelPO
     * @return
     */
    @RequestMapping("/level/membergrade-autoconfig-update")
    public @ResponseBody ResultModel<MemberLevelPO> updateMemGradeAsbConfig(MemberLevelPO po,
                                                                            BindingResult bindingResult) throws Exception {

        // 변경자 번호
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (StringUtils.isEmpty(po.getFirstSignupCouponYn())) {
            po.setFirstSignupCouponYn("N");
        }

        ResultModel<MemberLevelPO> result = memberLevelService.updateMemGradeAsbConfig(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : 회원등급 수정화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelSO
     * @return
     */
    @RequestMapping("/level/membergrade-update-form")
    public ModelAndView viewMemGradeUpdate(MemberLevelSO so, BindingResult bindingResult) throws Exception {

        ModelAndView mv = new ModelAndView("/admin/member/level/MemberGradeUpdate");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원등급 조회
        mv.addObject("resultModel", memberLevelService.viewMemGradeUpdate(so));

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : 회원등급 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelPO
     * @return
     */
    @RequestMapping("/level/membergrade-config-update")
    public @ResponseBody ResultModel<MemberLevelPO> updateMemGradeConfig(MemberLevelPO po,
                                                                         BindingResult bindingResult) throws Exception {

        // 변경자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 마켓포인트, 포인트, 구매 횟수 콤마 제거
        if (po.getTotBuyAmt() != null && po.getTotBuyAmt() != "") {
            po.setTotBuyAmt(po.getTotBuyAmt().replaceAll(",", ""));
        }
        if (po.getTotPoint() != null && po.getTotPoint() != "") {
            po.setTotPoint(po.getTotPoint().replaceAll(",", ""));
        }
        if (po.getTotBuyCnt() != null && po.getTotBuyCnt() != "") {
            po.setTotBuyCnt(po.getTotBuyCnt().replaceAll(",", ""));
        }

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if(po.getPointPvdGoodsTypeCdsArr() != null && po.getPointPvdGoodsTypeCdsArr().length > 0) {
            StringBuilder pointPvdGoodsTypeCds = new StringBuilder();
            for(int i = 0; i < po.getPointPvdGoodsTypeCdsArr().length; i++) {
                if(i == 0) {
                    pointPvdGoodsTypeCds = new StringBuilder(po.getPointPvdGoodsTypeCdsArr()[i]);
                } else {
                    pointPvdGoodsTypeCds.append(",").append(po.getPointPvdGoodsTypeCdsArr()[i]);
                }
            }
            po.setPointPvdGoodsTypeCds(pointPvdGoodsTypeCds.toString());
        }

        ResultModel<MemberLevelPO> result = memberLevelService.updateMemGradeConfig(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : 회원등급 등록화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelSO
     * @return
     */
    @RequestMapping("/level/membergrade-insert-form")
    public ModelAndView viewMemGradeInsert(MemberLevelSO so, BindingResult bindingResult) throws Exception {

        ModelAndView mv = new ModelAndView("/admin/member/level/MemberGradeUpdate");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        MemberLevelVO vo = new MemberLevelVO();
        vo.setMemberGradeManageCd(so.getMemberGradeManageCd());
        vo.setFlag("insert");
        ResultModel<MemberLevelVO> result = new ResultModel<>(vo);

        mv.addObject("resultModel", result);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : 회원등급 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelPO
     * @return
     */
    @RequestMapping("/level/mambergrade-insert")
    public @ResponseBody ResultModel<MemberLevelPO> insertMemGrade(MemberLevelPO po, BindingResult bindingResult)
            throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<MemberLevelPO> result = memberLevelService.insertMemGrade(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 회원 등급 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/level/membergrade-delete")
    public @ResponseBody ResultModel<MemberLevelPO> deleteMemGrade(@Validated(DeleteGroup.class) MemberLevelPO po,
            BindingResult bindingResult) throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<MemberLevelPO> result = memberLevelService.deleteMemGrade(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 13.
     * 작성자 : dong
     * 설명   : 회원 등급 레벨 발리데이션 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 13. dong - 최초생성
     * </pre>
     *
     * @param MemberLevelSO
     * @return
     */
    @RequestMapping("/level/membergrade-level-validate")
    public @ResponseBody Map<String, Integer> selectMemGradeLevelCnt(MemberLevelSO so, BindingResult bindingResult)
            throws Exception {

        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        Integer result = memberLevelService.selectMemGradeLevelCnt(so);

        Map<String, Integer> gradeLevelCnt = new HashMap<String, Integer>();
        gradeLevelCnt.put("gradeLevelCnt", result);

        return gradeLevelCnt;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 24.
     * 작성자 : dong
     * 설명   : 회원등급별 구매혜택을 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/level/membergrade-benefit")
    public ModelAndView viewMemGradeBenefit(MemberLevelSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ModelAndView mv = new ModelAndView("/admin/member/level/MemberLevelBenefit");
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<MemberLevelVO> memGradeBenefitGrpList = memberLevelService.getMemGradeBenefitGrpList(so);

        // 회원등급 리스트 조회
        for (int i = 0; i < memGradeBenefitGrpList.size(); i++) {
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            so.setMemberGradeBnfNo(memGradeBenefitGrpList.get(i).getMemberGradeBnfNo());
            List<MemberLevelVO> memGradeBenefitList = memberLevelService.viewMemGradeBenefitList(so);
            memGradeBenefitGrpList.get(i).setMemGradeBenefitList(memGradeBenefitList);
            mv.addObject("memGradeBenefitListSize" + i, memGradeBenefitList.size());
        }

        mv.addObject("memGradeBenefitGrpList", memGradeBenefitGrpList);
        mv.addObject("so", so);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 24.
     * 작성자 : dong
     * 설명   : 회원등급별 구매혜택을 등록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/level/membergradebenefit-insert-form")
    public ModelAndView viewMemberLevelBenefitInsert() {
        ModelAndView mv = new ModelAndView("/admin/member/level/MemberLevelBenefitInsert");

        MemberLevelSO so = new MemberLevelSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<MemberLevelVO> resultModel = memberLevelService.viewMemGradeList(so);
        // 회원등급 리스트 조회
        mv.addObject("resultModel", resultModel);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택을 등록한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/level/mambergrade-benefit-insert")
    public @ResponseBody ResultModel<MemberLevelPO> insertMemGradeBenefit(
            @Validated(InsertGroup.class) MemberLevelPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setMemberGradeBnfNo(bizService.getSequence("MEMBER_GRADE_BNF_NO"));

        ResultModel<MemberLevelPO> result = new ResultModel<MemberLevelPO>();
        for (int i = 0; i < po.getArrMemberGradeNo().length; i++) {
            po.setMemberGradeNo(po.getArrMemberGradeNo()[i]);
            po.setDcUnitCd(po.getArrDcUnitCd()[i]);
            po.setDcValue(po.getArrDcValue()[i]);

            po.setSvmnUnitCd(po.getArrSvmnUnitCd()[i]);
            po.setSvmnValue(po.getArrSvmnValue()[i]);
            po.setUseYn("N");

            result = memberLevelService.insertMemGradeBenefit(po);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 24.
     * 작성자 : dong
     * 설명   : 회원등급별 구매혜택을 수정 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/level/membergradebenefit-update-form")
    public ModelAndView viewMemberLevelBenefitUpdate(MemberLevelSO so) {
        ModelAndView mv = new ModelAndView("/admin/member/level/MemberLevelBenefitUpdate");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<MemberLevelVO> memGradeBenefitList = memberLevelService.viewMemGradeBenefitList(so);

        // 회원등급 리스트 조회
        mv.addObject("memGradeBenefitList", memGradeBenefitList);
        mv.addObject("so", so);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택을 수정한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/level/membergrade-benefit-update")
    public @ResponseBody ResultModel<MemberLevelPO> updateMemGradeBenefit(
            @Validated(InsertGroup.class) MemberLevelPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        ResultModel<MemberLevelPO> result = new ResultModel<MemberLevelPO>();
        for (int i = 0; i < po.getArrMemberGradeNo().length; i++) {
            po.setMemberGradeNo(po.getArrMemberGradeNo()[i]);
            po.setDcUnitCd(po.getArrDcUnitCd()[i]);
            po.setDcValue(po.getArrDcValue()[i]);
            po.setSvmnUnitCd(po.getArrSvmnUnitCd()[i]);
            po.setSvmnValue(po.getArrSvmnValue()[i]);
            po.setUseYn("N");
            
            log.debug("po.getArrChk()[i]::" + po.getArrChk()[i]);
            if ("insert".equals(po.getArrChk()[i])) {
                result = memberLevelService.insertMemGradeBenefit(po);
            } else {
                result = memberLevelService.updateMemGradeBenefit(po);
            }
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택을 등록한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/level/mambergrade-benefit-delete")
    public @ResponseBody ResultModel<MemberLevelPO> deleteMemGradeBenefit(
            @Validated(InsertGroup.class) MemberLevelPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<MemberLevelPO> result = new ResultModel<MemberLevelPO>();
        result = memberLevelService.deleteMemGradeBenefit(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택을 등록한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/level/membergrade-use-update")
    public @ResponseBody ResultModel<MemberLevelPO> updateUseYn(@Validated(InsertGroup.class) MemberLevelPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<MemberLevelPO> result = new ResultModel<MemberLevelPO>();
        result = memberLevelService.updateUseYn(po);

        return result;
    }
}
