package net.danvi.dmall.admin.web.view.goods.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.GoodsImageHandler;
import net.danvi.dmall.admin.web.common.util.GoodsImageInfoData;
import net.danvi.dmall.admin.web.common.util.GoodsImageType;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.goods.model.FreebieImageInfoVO;
import net.danvi.dmall.biz.app.goods.model.FreebiePO;
import net.danvi.dmall.biz.app.goods.model.FreebieSO;
import net.danvi.dmall.biz.app.goods.model.FreebieVO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageUploadVO;
import net.danvi.dmall.biz.app.goods.service.FreebieManageService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
//import dmall.framework.common.util.ExecuteExtCmdUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 12.
 * 작성자     : dong
 * 설명       : 사은품 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class FreebieManageController {
    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Value("#{system['system.upload.path']}")
    private String uplaodFilePath;

    @Resource(name = "freebieManageService")
    private FreebieManageService freebieManageService;

    @Resource(name = "goodsImageHandler")
    private GoodsImageHandler imageHandler;

    @Resource(name = "siteService")
    private SiteService siteService;

    /**
     * <pre>
     * 작성일 : 2016. 7. 12.
     * 작성자 : dong
     * 설명   : 사은품 관리 목록 화면(/admin/goods/freebie/freebieManageList)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 12. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/freebie")
    public ModelAndView viewFreebieList() {
        ModelAndView mav = new ModelAndView("/admin/goods/freebie/freebieManageList");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 14.
     * 작성자 : dong
     * 설명   : 사은품 관리 상세 화면으로 이동한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 14. dong - 최초생성
     * </pre>
     *
     * @param freebieSO
     * @return
     */
    @RequestMapping("/freebie-detail")
    public ModelAndView viewFreebieDetail(FreebieSO so) {
        ModelAndView mav = new ModelAndView("/admin/goods/freebie/freebieDetail");

        if(so.getProcType().equals("I")) {
            String freebieNo = freebieManageService.selectFreebieNo();
            so.setFreebieNo(freebieNo);
        } else if(so.getProcType().equals("C")) {
            String freebieNo = freebieManageService.selectFreebieNo();
            so.setNewFreebieNo(freebieNo);
        }

        mav.addObject("so", so);
        mav.addObject("state", so.getProcType());

        return mav;
    }

    @RequestMapping("/copy-freebie-contents")
    public @ResponseBody String copyFreebieContents(FreebieSO so) throws Exception {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        so.setSiteNo(sessionInfo.getSiteNo());

        return freebieManageService.copyFreebieContents(so);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 12.
     * 작성자 : dong
     * 설명   : 사은품 관리 리스트 화면에서 선택한 조건에 해당하는 사은품 관련 정보를 취득하여 JSON 형태로 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 12. dong - 최초생성
     * </pre>
     *
     * @param freebieSO
     * @return
     */
    @RequestMapping("/freebie-list")
    public @ResponseBody ResultListModel<FreebieVO> selectFreebieListPaging(FreebieSO so) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        log.info("param so = {}", so);
        ResultListModel<FreebieVO> result = freebieManageService.selectFreebieList(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : dong
     * 설명   : 사은품 관리 상세 화면에서 사은품 관련 정보를 취득하여 JSON 형태로 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13. dong - 최초생성
     * </pre>
     *
     * @param freebieSO
     * @return
     */
    @RequestMapping("/freebie-contents")
    public @ResponseBody ResultModel<FreebieVO> selectFreebieContents(FreebieSO so) throws Exception {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        so.setSiteNo(sessionInfo.getSiteNo());
        ResultModel<FreebieVO> result = freebieManageService.selectFreebieContents(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : dong
     * 설명   : 사은품 목록을 취득하여 엑셀 다운로드 처리한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/freebie-excel-download")
    public String downloadExcel(FreebieSO so, Model model) throws Exception {
        // 엑셀로 출력할 데이터 조회
        ResultListModel<FreebieVO> result = freebieManageService.selectFreebieList(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "사은품명", "사용여부", "등록일", "수정일" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rowNum", "freebieNm", "useNm", "regDate", "updDate" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("사은품 목록", headerName, fieldName, result.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "사은품 목록_" + DateUtil.getNowDate()); // 엑셀
                                                                                 // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 14.
     * 작성자 : dong
     * 설명   : 사은품 관리 정보를 등록 후 결과를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 14. dong - 최초생성
     * </pre>
     *
     * @param FreebiePO
     * @return
     */
    @RequestMapping("/freebie-contents-insert")
    public @ResponseBody ResultModel<FreebiePO> insertFreebieContents(@Validated(InsertGroup.class) FreebiePO po,
                                                                      BindingResult bindingResult,
                                                                      HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<FreebiePO> resultModel = freebieManageService.insertFreebieContents(po, request);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 14.
     * 작성자 : dong
     * 설명   : 사은품 관리 정보 수정 후 결과를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 14. dong - 최초생성
     * </pre>
     *
     * @param FreebiePO
     * @return
     */
    @RequestMapping("/freebie-contents-update")
    public @ResponseBody ResultModel<FreebiePO> updateFreebieContents(FreebiePO po,
                                                                      BindingResult bindingResult,
                                                                      HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<FreebiePO> resultModel = freebieManageService.updateFreebieContents(po, request);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 21.
     * 작성자 : dong
     * 설명   : 사은품 관리 이미지 등록/수정 후 결과를 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 21. dong - 최초생성
     * </pre>
     *
     * @param List<FreebieImageDtlPO>
     * @return
     */
    @RequestMapping("/freebie-image-insert")
    public @ResponseBody ResultModel<FreebiePO> saveFreebieImage(FreebiePO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<FreebiePO> resultModel = freebieManageService.saveFreebieImage(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명   : 사은품 관리 체크된 정보 삭제 후 결과를 반환한다. 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 19. dong - 최초생성
     * </pre>
     *
     * @param FreebiePO
     * @return
     */
    @RequestMapping("/check-freebie-delete")
    public @ResponseBody ResultModel<FreebiePO> deleteCheckFreebieContents(FreebiePO po,
            @RequestParam(value = "paramFreebieNo[]") ArrayList<String> paramFreebieNo, BindingResult bindingResult)
            throws Exception {
        ResultModel<FreebiePO> resultModel = null;

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        for(String freebieNo : paramFreebieNo) {
            po.setFreebieNo(freebieNo);
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            }

            resultModel = freebieManageService.deleteFreebieContents(po);
        }

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명   : 사은품 관리 단일 정보 삭제 후 결과를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 19. dong - 최초생성
     * </pre>
     *
     * @param FreebiePO
     * @return
     */
    @RequestMapping("/freebie-delete")
    public @ResponseBody ResultModel<FreebiePO> deleteFreebieContents(FreebiePO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<FreebiePO> resultModel = null;

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        resultModel = freebieManageService.deleteFreebieContents(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 19.
     * 작성자 : dong
     * 설명 : 사은품 관련 기본 이미지 정보를 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 19. dong - 최초생성
     *
     * @param so
     * @return
     */
    @RequestMapping("/default-image-info")
    public @ResponseBody ResultModel<FreebieImageInfoVO> selectDefaultImageInfo(FreebieSO so) {
        ResultModel<FreebieImageInfoVO> resultModel = freebieManageService.selectDefaultImageInfo(so);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 업로드한 사은품 이미지를 임시 경로에 저장 후 이미지 파일 정보를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/freebie-image-upload")
    public String freebieImageUploadResult(Model model, MultipartHttpServletRequest mRequest) {
        GoodsImageUploadVO result;
        List<GoodsImageUploadVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();

        // log.info("img_param_1 :" + mRequest.getParameter("img_param_1"));
        // log.info("img_param_2 :" + mRequest.getParameter("img_param_2"));
        // log.info("img_detail_width :" +
        // mRequest.getParameter("img_detail_width"));
        // log.info("img_detail_height :" +
        // mRequest.getParameter("img_detail_height"));
        // log.info("img_thumb_width :" +
        // mRequest.getParameter("img_thumb_width"));
        // log.info("img_thumb_height :" +
        // mRequest.getParameter("img_thumb_height"));

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            String filePath;
            String path;
            String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
            Boolean checkExe;
            List<MultipartFile> files;
            GoodsImageInfoData imageInfoData;
            String imageType = mRequest.getParameter("img_param_1");

            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {

                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);
                    checkExe = true;

                    for (String ex : fileFilter) {
                        if (ex.equalsIgnoreCase(extension)) {
                            checkExe = false;
                        }
                    }

                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    if (mFile != null && mFile.getSize() > fileSize) {
                        throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                    }

                    fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
                    path = FileUtil.getNowdatePath();
                    filePath = getTempRootPath() + File.separator + path + File.separator + fileName;
                    file = new File(filePath);

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);
                    mFile.transferTo(file);

                    imageInfoData = new GoodsImageInfoData();
                    switch (imageType) {
                    case "02":
                        imageInfoData.setGoodsImageType(GoodsImageType.FREEBIE_IMAGE_TYPE_A);
                        break;
                    case "03":
                        imageInfoData.setGoodsImageType(GoodsImageType.FREEBIE_IMAGE_TYPE_B);
                        break;
                    case "04":
                        imageInfoData.setGoodsImageType(GoodsImageType.FREEBIE_IMAGE_TYPE_C);
                        break;
                    case "05":
                        imageInfoData.setGoodsImageType(GoodsImageType.FREEBIE_IMAGE_TYPE_D);
                        break;
                    case "06":
                        imageInfoData.setGoodsImageType(GoodsImageType.FREEBIE_IMAGE_TYPE_E);
                        break;
                    default:
                        // imageInfoData.setImageType(ImageType.GOODS_IMAGE);
                        imageInfoData.setGoodsImageType(GoodsImageType.FREEBIE_IMAGE);
                        break;
                    }

                    imageInfoData.setWidthForGoodsDetail(Integer.valueOf(mRequest.getParameter("img_detail_width")));
                    imageInfoData.setHeightForGoodsDetail(Integer.valueOf(mRequest.getParameter("img_detail_height")));
                    imageInfoData.setWidthForGoodsThumbnail(Integer.valueOf(mRequest.getParameter("img_thumb_width")));
                    imageInfoData
                            .setHeightForGoodsThumbnail(Integer.valueOf(mRequest.getParameter("img_thumb_height")));

                    imageInfoData.setOrgImgPath(file.getAbsolutePath());
                    imageHandler.job(imageInfoData);

                    List<File> destFileList = imageInfoData.getDestFileList();
                    for (File destFile : destFileList) {
                        String targetFileName = destFile.getName();
                        String[] fileInfoArr = targetFileName.split("_");
                        String[] sizeArr = fileInfoArr[1].split("x");

                        result = new GoodsImageUploadVO();
                        result.setFileName(fileOrgName);
                        result.setImageWidth(sizeArr[0]);
                        result.setImageHeight(sizeArr[1]);
                        result.setImgType(
                                targetFileName.substring(targetFileName.lastIndexOf("x") + 1, targetFileName.length()));
                        result.setTempFileName(DateUtil.getNowDate() + "_" + destFile.getName());
                        result.setFileSize(mFile.getSize());
                        result.setImageUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) +UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_" + targetFileName);
                        result.setThumbUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN)+ UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_"+ (targetFileName).substring(0, targetFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);

                        resultList.add(result);
                    }

                }
            }

            model.addAttribute("files", resultList);
            return View.jsonView();
        } catch (

        IllegalStateException e) {
            log.debug("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } catch (IOException e) {
            log.debug("{}", e);
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }
    }

    private String getTempRootPath() {
        return getSiteRootPath() + File.separator + UploadConstants.PATH_TEMP;
    }

    private String getSiteRootPath() {
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);

        return uplaodFilePath + File.separator + vo.getSiteId();
    }

    @RequestMapping("/check-freebie-update")
    public @ResponseBody ResultModel<FreebiePO> updateCheckFreebie(FreebiePO po,
                                                                   @RequestParam(value="paramFreebieNo[]") List<String> paramFreebieNo,
                                                                   BindingResult bindingResult) throws Exception {
        ResultModel<FreebiePO> resultModel = null;

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        for (String freebieNo : paramFreebieNo) {
            po.setFreebieNo(freebieNo);
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            }

            resultModel = freebieManageService.updateCheckFreebie(po);
        }

        return resultModel;
    }
}
