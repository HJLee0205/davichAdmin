package net.danvi.dmall.admin.web.view.common.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import net.danvi.dmall.biz.common.service.CodeCacheService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 5.
 * 작성자     : dong
 * 설명       : 공통코드 컨트롤러
 * </pre>
 */
@Controller
@RequestMapping("/admin/code")
public class CodeController {

    @Resource(name = "codeCacheService")
    private CodeCacheService codeCacheService;

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 코드 그룹에 해당하는 코드 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param cdGrp
     * @return
     */
    @RequestMapping("/code-list")
    public @ResponseBody ResultListModel<CmnCdDtlVO> selectCodeList(String cdGrp) {
        ResultListModel<CmnCdDtlVO> result = new ResultListModel<>();
        List<CmnCdDtlVO> list = codeCacheService.listCodeCache(cdGrp);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 코드 그룹과 사용자 정의값1의 조건에 해당하는 코드 목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param cdGrp
     * @param udv1
     * @return
     */
    @RequestMapping("/code-udiv1-list")
    public @ResponseBody ResultListModel<CmnCdDtlVO> selectCodeListUDV1(@RequestParam(name = "cdGrp") String cdGrp,
            @RequestParam(name = "udv1") String udv1) {
        ResultListModel<CmnCdDtlVO> result = new ResultListModel<>();
        List<CmnCdDtlVO> list = codeCacheService.listCodeCache(cdGrp, udv1, null, null, null, null);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }
}
