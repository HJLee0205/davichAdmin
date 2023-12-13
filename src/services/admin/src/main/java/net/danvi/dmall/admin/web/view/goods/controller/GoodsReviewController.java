package net.danvi.dmall.admin.web.view.goods.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

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
@RequestMapping("/admin/goods")
public class GoodsReviewController {
    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

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
    @RequestMapping("/board-goodsreview-detail")
    public ModelAndView viewBbsLettDtl(BbsLettManageSO so) {
        ModelAndView mv = new ModelAndView("/admin/goods/goodsReview/GoodsReviewDtl");
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        return mv;
    }

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
    @RequestMapping("goods-reviews")
    public ModelAndView viewBbsLettList(BbsLettManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId("review");

        ModelAndView mv = new ModelAndView("/admin/goods/goodsReview/GoodsReviewList");
        mv.addObject("so", so);

        return mv;
    }
}
