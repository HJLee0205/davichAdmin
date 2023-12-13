package net.danvi.dmall.admin.web.view.statistics.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.GoodsRsvSO;
import net.danvi.dmall.biz.app.statistics.model.VisitRsvSO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class VisitRsvAnlsController {

    @RequestMapping("/visitrsv-analysis-form")
    public ModelAndView viewVisitRsvAnls(VisitRsvSO visitRsvSO) {
        ModelAndView mv = new ModelAndView("/admin/statistics/visitRsvAnls");

        return mv;
    }
}
