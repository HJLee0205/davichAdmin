package net.danvi.dmall.admin.web.view.example.controller;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.ExcelReader;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.example.model.EditorPO;
import net.danvi.dmall.biz.example.model.EditorVO;
import net.danvi.dmall.biz.example.model.ExampleVO;
import net.danvi.dmall.biz.example.model.ExampleVOListWrapper;
import net.danvi.dmall.biz.example.service.EditorExampleService;
import net.danvi.dmall.biz.system.remote.push.PushDelegateService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 3. 31.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/example")
public class ExampleController {

    @Value("#{back['system.upload.image.path']}")
    private String imageFilePath;

    @Value("#{back['system.upload.temp.image.path']}")
    private String tempImageFilePath;

    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "editorExampleService")
    private EditorExampleService editorExampleService;
    
    @Resource(name = "pushDelegateService")
    private PushDelegateService pushDelegateService;

    @RequestMapping("/example-view")
    public ModelAndView viewExample() {
        return new ModelAndView("/admin/example/example");
    }

    @RequestMapping("/upload")
    public ModelAndView upload() {
        return new ModelAndView("/admin/example/upload");
    }

    @RequestMapping("/test-validate")
    public ModelAndView testValidate(@Validated ExampleVO vo, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/example/example");

        if (bindingResult.hasErrors()) {

        }

        return mv;
    }

    @RequestMapping("/test-validate-json")
    public @ResponseBody ExampleVO testValidateJson(@Validated(InsertGroup.class) ExampleVO vo,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        log.debug("pwd : {}", vo.getPwd());
        log.debug("pwd : {}", CryptoUtil.decryptAES(vo.getPwd()));

        return vo;
    }

    @RequestMapping("/test-array-vo")
    public @ResponseBody ResultListModel<ExampleVO> testArrayVO(@Validated ExampleVOListWrapper wrapper,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<ExampleVO> resultList = new ResultListModel<>();
        resultList.setResultList(wrapper.getList());

        return resultList;
    }

    @RequestMapping("/editor")
    public ModelAndView editor() {
        return new ModelAndView("/admin/example/editor");
    }

    @RequestMapping("/save-editor")
    public @ResponseBody EditorPO saveEditor(@Validated(InsertGroup.class) EditorPO po, BindingResult bindingResult)
            throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        log.debug("PO : {}", po.toString());

        editorExampleService.saveEditor(po);

        return po;
    }

    @RequestMapping("/load-editor")
    public @ResponseBody ResultModel<EditorVO> loadEditor() throws Exception {
        EditorVO vo = new EditorVO();
        vo.setName("테스트 데이터 이름");
        vo.setContent(
                "<p>테스트 데이터 Contents<br/><img src=\"http://www.davichmarket.com/image/editor-image-view?id=20160524_93e2b05a3f418f80a8c3bc75aa07b208f15872cb3c300e278eed4139135ee235\"/></p>");

        ResultModel<EditorVO> resultModel = editorExampleService.selectEditor(vo);

        return resultModel;
    }
    
    
    @RequestMapping("/push-test")
    public ModelAndView appPushTest() throws Exception {
    	
        ModelAndView mv = new ModelAndView("/admin/example/appPushTest");
        return mv;
    }
    
    
    @RequestMapping("/beacon-push")
    public @ResponseBody ResultModel<PushSendVO> appPush(PushSendPO po) throws Exception {
    	
    	ResultModel<PushSendVO> result = new ResultModel<>();

        if (SessionDetailHelper.getDetails() != null) {
        	po.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
        	po.setReceiverNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
        	po.setReceiverId(String.valueOf(SessionDetailHelper.getDetails().getSession().getLoginId()));
        }
    	
    	//푸시서버 연계
    	pushDelegateService.beaconSend(po);
    	
        return result;
    }    
    
}
