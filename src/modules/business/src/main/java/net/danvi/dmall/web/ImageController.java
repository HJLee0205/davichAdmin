package net.danvi.dmall.web;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.model.ImageViewSO;
import net.danvi.dmall.biz.common.service.FileService;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.view.View;

import javax.annotation.Resource;
import java.io.File;

/**
 * Created by dong on 2016-06-13.
 */
@Slf4j
public class ImageController {

    @Resource(name = "fileService")
    private FileService fileService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 타입에 따라 대상 폴더에서 fileName에 해당하는 이미지를 읽어 이미지를 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param vo
     * @return
     */
    @RequestMapping(value = "/image-view")
    public String view(ModelMap map, ImageViewSO vo) {
        String path;
        
        switch (vo.getType()) {
        case UploadConstants.TYPE_TEMP:
            path = FileUtil.getCombinedPath(UploadConstants.PATH_TEMP, vo.getPath());
            setImageMap(map, path, vo.getId1());
            break;
        case UploadConstants.TYPE_DISPLAY:
            path = fileService.getDisplayImage(vo);
            map.put(AdminConstants.FILE_PARAM_NAME, path);
            setEditorImageMap(map, path, vo.getId1());
            break;
        case UploadConstants.TYPE_GOODS:
            path = fileService.getFaviconImage();
            break;
        case UploadConstants.TYPE_GOODS_ITEM:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS_ITEM, vo.getId1());
            break;
        case UploadConstants.TYPE_TAXBILL:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_TAXBILL, vo.getId1());
            break;
        case UploadConstants.TYPE_NAVERLOGO:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_NAVERLOGO, vo.getId1());
            break;
        case UploadConstants.TYPE_FAVICON:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_FAVICON, vo.getId1());
            break;
        case UploadConstants.TYPE_LOGO:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_LOGO, vo.getId1());
            break;
        case UploadConstants.TYPE_ICON:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_ICON, FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_SAFEBUY:
            // 구매안전표시 이미지는 별도의 경로에 관리될 예정임(업로드 안함)
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_SAFEBUY, vo.getPath(), "img_safety.png");
            break;
        case UploadConstants.TYPE_BBS:
            log.debug("===vo.getPath() : {}", vo.getPath());
            log.debug("===vo.getId1() : {}", vo.getId1());
            setImageMap(map, UploadConstants.PATH_BBS, vo.getPath(),vo.getId1() + "_" + UploadConstants.BBS_IMG_SIZE_TYPE);
            break;
        case UploadConstants.TYPE_BBS_DTL:
        	setImageMap(map, UploadConstants.PATH_BBS, vo.getPath(), vo.getId1());
        	break;
        case UploadConstants.TYPE_GOODS_DTL:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS, FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_FREEBIE_DTL:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE,FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_BANNER:
            // 쇼핑몰 생성시 기본 배너로 등록한 공통 이미지 처리
            if(vo.getId1().startsWith("frontimgcommonmain_banner_")) {
                // 메인 배너
                String fileName = vo.getId1().replace("frontimgcommonmain_banner_", "");
                return View.redirect("/front/img/common/main_banner/" + fileName);
            } else if(vo.getId1().startsWith("frontimgcommonleft_banner_")) {
                // 레프트 윙배너
                String fileName = vo.getId1().replace("frontimgcommonleft_banner_", "");
                return View.redirect("/front/img/common/left_banner/" + fileName);
            } else {
                setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_BANNER,FileUtil.getDatePath(vo.getId1()));
            }
            break;
        case UploadConstants.TYPE_POPUP:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_POPUP, FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_MAIN_DISPLAY:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_MAIN_DISPLAY,FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_BRAND:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_BRAND, FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_COUPON:
            setImageMap(map, UploadConstants.PATH_COUPON, vo.getPath(), FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_EVENT:
            setImageMap(map, UploadConstants.PATH_EVENT, vo.getPath(), vo.getId1());
            break;
        case UploadConstants.TYPE_EXHIBITION:
            setImageMap(map, UploadConstants.PATH_EXHIBITION, vo.getPath(), FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_CTG:
            setImageMap(map, UploadConstants.PATH_CTG, vo.getPath(), vo.getId1());
            break;
        case UploadConstants.TYPE_PRESCRIPTION:
        	setImageMap(map, UploadConstants.PATH_ATTACH, UploadConstants.PATH_PRESCRIPTION, FileUtil.getDatePath(vo.getId1()));
        	break;
        case UploadConstants.TYPE_SPLASH:
        	setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_SPLASH, FileUtil.getDatePath(vo.getId1()));
        	break;
        case UploadConstants.TYPE_PUSH:
        	setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_PUSH, FileUtil.getDatePath(vo.getId1()));
        	break;
        case UploadConstants.TYPE_VISION:
        	setImageMap(map, UploadConstants.PATH_VISION, vo.getPath(),vo.getId1());
        	break;
        case UploadConstants.TYPE_PROFILE:
            setImageMap(map, UploadConstants.PATH_PROFILE, vo.getPath(), vo.getId1());
            break;
        case UploadConstants.TYPE_FILTER:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_FILTER, FileUtil.getDatePath(vo.getId1()));
            break;
        case UploadConstants.TYPE_KEYWORD:
            setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_KEYWORD, FileUtil.getDatePath(vo.getId1()));
            break;
        }

        return View.imageView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 에디터 첨부 이미지 미리보기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileName
     * @return
     */
    @RequestMapping(value = "/preview")
    public String viewTempImage(ModelMap map, @RequestParam("id") String fileName) {

        setEditorImageMap(map, FileUtil.getTempPath(), fileName);

        return View.imageView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 에디터 첨부이미지 보기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileName
     * @return
     */
    @RequestMapping(value = "/editor-image-view")
    public String viewImage(ModelMap map, @RequestParam("id") String fileName) {

        setEditorImageMap(map, FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_EDITOR), fileName);

        return View.imageView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 상품 첨부 이미지 미리보기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileName
     * @return
     */
    @RequestMapping(value = "/preview-goods-image")
    public String viewTempGoodsImage(ModelMap map, @RequestParam("id") String fileName) {

        setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_GOODS, FileUtil.getDatePath(fileName));

        return View.imageView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 25.
     * 작성자 : dong
     * 설명   : 사은품 첨부 이미지 미리보기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 25. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileName
     * @return
     */
    @RequestMapping(value = "/preview-freebie-image")
    public String viewTempFreebieImage(ModelMap map, @RequestParam("id") String fileName) {
        setImageMap(map, UploadConstants.PATH_IMAGE, UploadConstants.PATH_FREEBIE, FileUtil.getDatePath(fileName));

        return View.imageView();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : map에 입력받은 파일 경로와 파일 명으로 에디터 첨부 이미지 경로를 세팅한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param filePath
     * @param fileName
     */
    private void setEditorImageMap(ModelMap map, String filePath, String fileName) {

        FileViewParam fileView = new FileViewParam();
//        fileView.setFilePath(filePath + File.separator + FileUtil.getDatePath(fileName));
        fileView.setFilePath(FileUtil.getAllowedFilePath(filePath + File.separator + FileUtil.getDatePath(fileName)));
        map.put(AdminConstants.FILE_PARAM_NAME, fileView);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : map에 입력받은 파일 경로와 파일 명으로 에디터 첨부 이미지 경로를 세팅한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param path
     */
    private void setImageMap(ModelMap map, String... path) {
        String filePath = FileUtil.getPath(path);
        FileViewParam fileView = new FileViewParam();
        fileView.setFilePath(FileUtil.getAllowedFilePath(filePath));
        map.put(AdminConstants.FILE_PARAM_NAME, fileView);
    }
}
