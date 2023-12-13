package net.danvi.dmall.admin.web.view.seller.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 6. 3.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/seller/goods")
public class SellerGoodsQuestionController {
    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시글 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("goods-questions")
    public ModelAndView viewBbsLettList(BbsManageSO so) {
        String viewPage = "/admin/seller/goods/goodsQuestion/GoodsQuestionList";
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId("question");
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 보기 화면
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
    @RequestMapping("/board-goodsquestion-detail")
    public ModelAndView viewBbsLettDtl(BbsLettManageSO so) {
        String viewPage = "/admin/seller/goods/goodsQuestion/GoodsQuestionReplyInsert";

        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        return mv;
    }
}
