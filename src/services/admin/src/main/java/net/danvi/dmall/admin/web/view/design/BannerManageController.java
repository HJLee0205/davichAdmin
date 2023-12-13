package net.danvi.dmall.admin.web.view.design;

import java.util.List;
import java.util.Objects;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.BannerPO;
import net.danvi.dmall.biz.app.design.model.BannerPOListWrapper;
import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 07. 04.
 * 작성자     : dong
 * 설명       : 배너 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/design")
public class BannerManageController {

    @Value("#{system['system.upload.banner.image.path']}")
    private String bannerPath;

    @Value("#{system['system.upload.path']}")
    private String uploadPath;

    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;

    @RequestMapping("/banner")
    public ModelAndView viewBanner(@Validated BannerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/banner/bannerManageList");

        // 배너 리스트 조회
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        so.setSidx("REG_DTTM");
        so.setSord("DESC");

        if (Objects.equals(so.getTypeCd(), "main")) { // 메인 베너
            so.setBannerMenuCd("MN");
            so.setBannerAreaCd("MB1");
        } else if (Objects.equals(so.getTypeCd(), "sub")) { // 서브 베너
            so.setBannerMenuCd("MN");
            so.setBannerAreaCd("MB2");
        } else if (Objects.equals(so.getTypeCd(), "top")) { // 탑 베너
            so.setBannerMenuCd("MN");
            so.setBannerAreaCd("MB3");
        } else if (Objects.equals(so.getTypeCd(), "goodsTop")) { // 상품 상단 배너
            so.setBannerMenuCd("GDS");
            so.setBannerAreaCd("GDS1");
        } else if (Objects.equals(so.getTypeCd(), "goodsBottom")) { // 상품 하단 배너
            so.setBannerMenuCd("GDS");
            so.setBannerAreaCd("GDS2");
        }
        mv.addObject("so", so);
        // 화면에 보여줄 스킨리스트 조회 셀렉트 박스로 사용함
        //mv.addObject("resultListModel", bannerManageService.selectSkinList(so));

        return mv;
    }

    @RequestMapping("/banner-list")
    public @ResponseBody ResultListModel<BannerVO> selectBannerListPaging(BannerSO so) {
        so.setSidx("REG_DTTM");
        so.setSord("DESC");
        // 배너 리스트 페이징 조회
        ResultListModel<BannerVO> resultListModel = bannerManageService.selectBannerListPaging(so);
        return resultListModel;
    }

    @RequestMapping("/banner-detail")
    public ModelAndView viewBannerDtl(@Validated BannerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/banner/bannerManageDtl");

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        // 배너 상세 조회 - 상세 조회, 스킨리스트 조회
        ResultModel<BannerVO> result = bannerManageService.viewBannerDtl(so);

        mv.addObject("resultModel", result);
        mv.addObject("editYn", "Y");

        return mv;
    }

    @RequestMapping("/banner-detail-new")
    public ModelAndView viewBannerDtlNew(@Validated BannerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/design/banner/bannerManageDtl");

        // 배너 등록을 위한 화면값
        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        /*if (Objects.equals(so.getTypeCd(), "main")) {
            so.setBannerMenuCd("MN");
            so.setBannerAreaCd("MB1");
        } else if (Objects.equals(so.getTypeCd(), "sub")) {
            so.setBannerMenuCd("MN");
            so.setBannerAreaCd("MB2");
        } else if (Objects.equals(so.getTypeCd(), "top")) {
            so.setBannerMenuCd("MN");
            so.setBannerAreaCd("MB3");
        } else if (Objects.equals(so.getTypeCd(), "goodsTop")) {
            so.setBannerMenuCd("GDS");
            so.setBannerAreaCd("GDS1");
        } else if (Objects.equals(so.getTypeCd(), "goodsBottom")) {
            so.setBannerMenuCd("GDS");
            so.setBannerAreaCd("GDS2");
        }
        // 스킨리스트 값만 받아옴
        //ResultModel<BannerVO> result = bannerManageService.viewBannerDtlNew(so);

        mv.addObject("resultModel", null);*/
        mv.addObject("editYn", "N");

        return mv;
    }

    @RequestMapping("/banner-goods-list")
    public @ResponseBody ResultListModel<GoodsVO> selectBannerGoodsList(BannerSO so) throws Exception {
        log.info("selectBannerGoodsList");
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<GoodsVO> goodsVOList = bannerManageService.selectBannerGoodsList(so);
        log.info("selectBannerGoodsList goodsVOList = "+goodsVOList);

        return goodsVOList;
    }

    @RequestMapping("/banner-insert")
    public @ResponseBody ResultModel<BannerPO> insertBanner(@Validated(InsertGroup.class) BannerPO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if(po.getApplyAlwaysYn() != null && po.getApplyAlwaysYn().equals("Y")) {
            po.setDispEndDttm("");
            po.setDispStartDttm("");
        }
        po.setPcGbCd("C");
        //FileUtil.checkUploadable((MultipartHttpServletRequest) mRequest);
        // 파일 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BANNER));
        log.info("upload file list = "+list);
        if (list != null/* && list.size() == 1*/) {
            for (int i = 0; i < list.size(); i++) {
                if(i == 0) {
                    po.setFilePath(list.get(i).getFilePath());
                    po.setFileNm(list.get(i).getFileName());
                    po.setOrgFileNm(list.get(i).getFileName());
                    po.setFileSize(list.get(i).getFileSize());
                } else {
                    po.setFilePathM(list.get(i).getFilePath());
                    po.setFileNmM(list.get(i).getFileName());
                    po.setOrgFileNmM(list.get(i).getFileName());
                    po.setFileSizeM(list.get(i).getFileSize());
                }
            }
        }

        // 배너 정보 등록
        ResultModel<BannerPO> result = bannerManageService.insertBanner(po);

        return result;
    }

    @RequestMapping("/banner-update")
    public @ResponseBody ResultModel<BannerPO> updateBanner(@Validated(UpdateGroup.class) BannerPO po,
            HttpServletRequest mRequest, BindingResult bindingResult) throws Exception {

        // 필수 파라메터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if(po.getApplyAlwaysYn() != null && po.getApplyAlwaysYn().equals("Y")) {
            po.setDispEndDttm("");
            po.setDispStartDttm("");
        }
        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,
                FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BANNER));
        if (list != null /*&& list.size() == 1*/) {
            for (int i = 0; i < list.size(); i++) {
                if(i == 0) {
                    po.setFilePath(list.get(i).getFilePath());
                    po.setFileNm(list.get(i).getFileName());
                    po.setOrgFileNm(list.get(i).getFileName());
                    po.setFileSize(list.get(i).getFileSize());
                } else {
                    po.setFilePathM(list.get(i).getFilePath());
                    po.setFileNmM(list.get(i).getFileName());
                    po.setOrgFileNmM(list.get(i).getFileName());
                    po.setFileSizeM(list.get(i).getFileSize());
                }
            }
        }

        // 배너 정보 수정
        ResultModel<BannerPO> result = bannerManageService.updateBanner(po);

        return result;
    }

    @RequestMapping("/banner-view-update")
    public @ResponseBody ResultModel<BannerPO> updateBannerView(BannerPOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {
        // 배너 전시 미전시 처리
        ResultModel<BannerPO> result = bannerManageService.updateBannerView(wrapper);

        return result;
    }

    @RequestMapping("/banner-sort-update")
    public @ResponseBody ResultModel<BannerPO> updateBannerSort(BannerPO po,
            BindingResult bindingResult) throws Exception {
        // 배너 순서 변경 처리
        ResultModel<BannerPO> result = bannerManageService.updateBannerSort(po);

        return result;
    }

    @RequestMapping("/banner-delete")
    public @ResponseBody ResultModel<BannerPO> deleteBanner(BannerPOListWrapper wrapper, BindingResult bindingResult)
            throws Exception {
        // 배너 삭제
        ResultModel<BannerPO> result = bannerManageService.deleteBanner(wrapper);

        return result;
    }

}
