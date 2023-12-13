package net.danvi.dmall.front.web.view.seller.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.common.service.BizService;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2017. 11. 16.
 * 작성자     : 
 * 설명       : 판매자 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/front/seller")
public class SellerController {
    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "sellerService")
    private SellerService sellerService;
    

    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 판매자 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/seller-detail")
    public ModelAndView sellerDtl(@Validated SellerSO so, BindingResult bindingResult) throws Exception {

        ModelAndView mv = SiteUtil.getSkinView("/seller/seller_insert_form");

        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        // 판매자 상세 조회
        //mv.addObject("resultModel", sellerService.selectSellerInfo(so));
        
        return mv;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 판매자 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/seller-view")
    public ModelAndView sellerView(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/SellerView");
        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        // 판매자 상세 조회
        mv.addObject("resultModel", sellerService.selectSellerInfo(so));
        
        return mv;
    }    
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 21.
     * 작성자 : kimhy
     * 설명   : 아이디 중복확인
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/duplication-id-check")
    public @ResponseBody ResultModel<SellerVO> checkDuplicationId(SellerSO so, BindingResult bindingResult)
            throws Exception {
        ResultModel<SellerVO> result = new ResultModel<>();
        int loginId = sellerService.checkDuplicationId(so);
        if (loginId > 0) {
            result.setSuccess(false);
        } else {
            result.setSuccess(true);
        }
        return result;
    }
    
    
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 23.
     * 작성자 : kimhy
     * 설명   : 판매자 등록/수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 23. 김현열 - 최초생성
     * </pre>
     *
     * @param eventPO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/seller-info-save")
    public @ResponseBody ResultModel<SellerVO> saveSeller(@Validated SellerPO po, HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        ResultModel<SellerVO> result = null;
        try {

            // 파일 정보 등록
            List<FileVO> list = FileUtil.getSellerFileListFromRequest(mRequest,FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_SELLER));

            if (list != null) {
	            for (int i = 0; i < list.size(); i++) {
	            	String gb = list.get(i).getUserFile();

	            	if ("biz".equals(gb)) {
	                  po.setBizFilePath(list.get(i).getFilePath()); //사업자 등록증 파일 경로
	                  po.setBizFileNm(list.get(i).getFileName());		//사업자 등록증 파일명
	                  po.setBizOrgFileNm(list.get(i).getFileOrgName());  //사업자 등록증 원본 파일명
	            	} else if ("copy".equals(gb)) {
	                  po.setBkCopyFilePath(list.get(i).getFilePath()); //통장사본 파일 경로
	                  po.setBkCopyFileNm(list.get(i).getFileName());		//통장사본 파일 명
	                  po.setBkCopyOrgFileNm(list.get(i).getFileOrgName());  //통장사본 원본 파일 명
	            	} else if ("etc".equals(gb)) {
	                  po.setEtcFilePath(list.get(i).getFilePath()); //기타 파일 경로
	                  po.setEtcFileNm(list.get(i).getFileName());		//기타 파일 명
	                  po.setEtcOrgFileNm(list.get(i).getFileOrgName());  //기타 원본 파일 명
	            	}else if ("ceo".equals(gb)) {
	                  po.setCeoFilePath(list.get(i).getFilePath()); //대표자 파일 경로
	                  po.setCeoFileNm(list.get(i).getFileName());		//대표자 파일 명
	                  po.setCeoOrgFileNm(list.get(i).getFileOrgName());  //대표자 원본 파일 명
		            }else if ("ref".equals(gb)) {
	                  po.setRefFilePath(list.get(i).getFilePath()); //참조 파일 경로
	                  po.setRefFileNm(list.get(i).getFileName());		//참조 파일 명
	                  po.setRefOrgFileNm(list.get(i).getFileOrgName());  //참조 원본 파일 명
		            }
	            }
            }
            
            result = sellerService.saveSeller(po);
        } catch (Exception e) {
            e.printStackTrace();
            // TODO Auto-generated catch block
        }
        return result;
    }
    



}
