package net.danvi.dmall.admin.web.view.statistics.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.GoodsRsvSO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class GoodsRsvAnlsController {

    @RequestMapping("/goodsrsv-analysis-form")
    public ModelAndView viewGoodsRsvAnls(GoodsRsvSO goodsRsvSO) {
        ModelAndView mv = new ModelAndView("/admin/statistics/goodsRsvAnls");

        return mv;
    }
}
