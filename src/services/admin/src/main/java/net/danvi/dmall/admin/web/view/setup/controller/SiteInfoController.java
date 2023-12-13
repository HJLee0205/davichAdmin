package net.danvi.dmall.admin.web.view.setup.controller;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.goods.model.GoodsIconVO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSizePO;
import net.danvi.dmall.biz.app.goods.model.GoodsImageSizeVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SitePO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import net.sf.image4j.codec.ico.ICODecoder;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * 사이트 정보 Controller
 * 
 * @author dong
 * @since 2016.05.04
 */
/**
 * 네이밍 룰
 * View 화면
 * Grid 그리드
 * Tree 트리
 * Ajax Ajax
 * Insert 입력
 * Update 수정
 * Delete 삭제
 * Save 입력 / 수정
 */
@Slf4j
@Controller
@RequestMapping("/admin/setup/siteinfo")
public class SiteInfoController {

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트 기본 정보 관리 화면 (/admin/setup/siteInfo)을 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/site-info")
    public ModelAndView viewtSiteInfo() {
        ModelAndView mav = new ModelAndView("/admin/setup/siteInfo");//
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트 기본 정보를 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @RequestMapping("/site-info-detail")
    public @ResponseBody ResultModel<SiteVO> selectSiteInfo(SiteSO vo) throws Exception {
        ResultModel<SiteVO> result = siteInfoService.selectSiteInfo(vo);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트 기본 정보 중 에디터의 내용을 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/site-info-html")
    public @ResponseBody ResultModel<SiteVO> selectSiteInfoHtml(@Validated SiteSO vo, BindingResult bindingResult)
            throws Exception {
        ResultModel<SiteVO> resultModel = siteInfoService.selectSiteInfoHtml(vo);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트 기본 정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/site-info-update")
    public @ResponseBody ResultModel<SitePO> udpateSiteInfo(@Validated(UpdateGroup.class) SitePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<SitePO> result = siteInfoService.updateSiteInfo(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트정보 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/site-info-delete")
    public @ResponseBody ResultModel<SitePO> deleteSiteInfo(@Validated(UpdateGroup.class) SitePO po,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<SitePO> result = siteInfoService.deleteSiteInfo(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 상품 관련 이미지 정보를 취득하여 
     *          상품 이미지 설정화면 (/admin/setup/imageConfig)과 함께 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/image-config")
    public ModelAndView viewImageConfig(@Validated SiteSO so) {
        ModelAndView mav = new ModelAndView("/admin/setup/imageConfig");
        ResultModel<GoodsImageSizeVO> result = siteInfoService.selectGoodsImageInfo(so);
        mav.addObject("resultModel", result);
        // 아이콘 추가 가능 여부
        mav.addObject("isAbleAddIcon",siteQuotaService.isIconAddible(SessionDetailHelper.getDetails().getSession().getSiteNo()));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트에 설정된 아이콘 목록을 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/icon-list")
    public @ResponseBody ResultListModel<GoodsIconVO> selectIconList(SiteSO so) throws Exception {
        ResultListModel<GoodsIconVO> result = new ResultListModel<>();

        List<GoodsIconVO> list = siteInfoService.selectIconList(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 사이트의 설정된 상품 관련 이미지 설정 정보를 취득하여 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/image-config-update")
    public @ResponseBody ResultModel<GoodsImageSizePO> updateImageConfig(
            @Validated(UpdateGroup.class) @RequestBody GoodsImageSizePO po, BindingResult bindingResult)
            throws Exception {

        // JSON 요청에 대한 LUCY 필터 수동 적용
        //LucyUtil.filter("/admin/setup/siteinfo/image-config-update", po);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }
        ResultModel<GoodsImageSizePO> result = siteInfoService.udpateImageConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 해당 사이트의 아이콘 추가 가능 여부를 조회하여 
     *          아이콘 추가가 가능한 경우, 아이콘 정보를 저장 처리한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/icon-image-upload")
    public String goodsIconUpload(Model model, MultipartHttpServletRequest mRequest) throws Exception {
        // 아이콘 추가 가능 여부
        boolean isAbleAddIcon = siteQuotaService.isIconAddible(SessionDetailHelper.getDetails().getSession().getSiteNo());
        if (isAbleAddIcon) {
            List<Map<String, Object>> resultList = siteInfoService.saveIconInfo(model, mRequest);
            model.addAttribute("files", resultList);
            model.addAttribute("message", MessageUtil.getMessage("biz.exception.gds.addicon.success"));
        } else {
            model.addAttribute("message", MessageUtil.getMessage("biz.exception.gds.addicon.notable"));
        }
        return View.jsonView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 업로드된 파비콘 이미지를 임시 이미지 저장소에 저장 처리 후 
     *          이미지 정보를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/favicon-upload")
    public String fileUploadResult(Model model, MultipartHttpServletRequest mRequest) {

        FileVO result;
        List<FileVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        try {
            String fileOrgName;
            String extension;
            String fileName;
            File file;
            File filePng;
            String path;
            String[] fileFilter = { "ico" };
            List<MultipartFile> files;

            while (fileIter.hasNext()) {
                files = mRequest.getMultiFileMap().get(fileIter.next());
                for (MultipartFile mFile : files) {

                    fileOrgName = mFile.getOriginalFilename();
                    extension = FilenameUtils.getExtension(fileOrgName);
                    boolean checkExe = true;
                    for (String ex : fileFilter) {
                        if (ex.equalsIgnoreCase(extension)) {
                            checkExe = false;
                        }
                    }
                    if (checkExe) {
                        throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                    }

                    if (mFile.getSize() > fileSize) {
                        throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                    }

                    fileName = System.currentTimeMillis() + "";
                    path = FileUtil.getNowdatePath();
                    file = new File(FileUtil.getTempPath(path, fileName));
                    filePng = new File(FileUtil.getTempPath(path, fileName + ".png"));

                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();
                    }

                    log.debug("원본파일 : {}", mFile);
                    log.debug("대상파일 : {}", file);

                    mFile.transferTo(file);
                    // mFile.transferTo(filePng);

                    // BufferedImage bufferedImage =
                    // ImageIO.read(mFile.getInputStream());
                    // BufferedImage bufferedImage = ImageIO.read(filePng);
                    List<BufferedImage> images = ICODecoder.read(file);
                    log.debug("이미지파일 : {}", images);
                    ImageIO.write(images.get(0), "png", filePng);

                    result = new FileVO();
                    result.setFileExtension(extension);
                    result.setFileOrgName(fileOrgName);
                    result.setFileName(fileName + ".png");
                    result.setFileSize(mFile.getSize());
                    result.setFileType(mFile.getContentType());
                    result.setFilePath(path);
                    resultList.add(result);
                }
            }

            model.addAttribute("files", resultList);
            return View.jsonView();

        } catch (IOException e) {
            // 파일이 올바른 파비콘 파일 형식이 아닐 경우 화면단에 메세지를 출력
            //
            model.addAttribute("files", resultList);
            return View.jsonView();

        } catch (IllegalStateException e) {
            //
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);

        } catch (Exception e) {
            //
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        } finally {
            // 사이트별 파일 권한 처리
            /*ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());*/
        }
    }

}