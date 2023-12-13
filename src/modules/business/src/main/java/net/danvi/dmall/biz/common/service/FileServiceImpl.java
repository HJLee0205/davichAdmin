package net.danvi.dmall.biz.common.service;

import net.danvi.dmall.biz.app.design.model.DisplayVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.common.model.ImageViewSO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;

import java.io.File;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 27.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Service("fileService")
public class FileServiceImpl extends BaseService implements FileService {

    /** 사이트 파비콘 경로 */
    @Value("#{system['system.upload.favicon.path']}")
    private String faviconPath;

    /** 상품 업로드 경로 */
    @Value("#{system['system.upload.temp.image.path']}")
    private String goodsFilPath;

    /** 전시 업로드 경로 */
    @Value("#{system['system.upload.display.image.path']}")
    private String displayPath;

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 업로드 루트와 사이트 번호, 파일 경로, 파일명을 합쳐서 전체(절대) 파일경로를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param root
     * @param siteNo
     * @param filePath
     * @param fileName
     * @return
     */
    private String getFullFilePath(String root, Long siteNo, String filePath, String fileName) {
        return root + File.separator + siteNo + File.separator + filePath + File.separator + fileName;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 업로드 루트와 사이트 번호, 파일 경로를 합쳐서 전체(절대) 파일경로를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param root
     * @param siteNo
     * @param filePath
     * @return
     */
    private String getFullFilePath(String root, Long siteNo, String filePath) {
        return root + File.separator + siteNo + File.separator + filePath;
    }

    @Override
    public String getDisplayImage(ImageViewSO vo) {
        DisplayVO displayVO = new DisplayVO();
        displayVO.setSiteNo(vo.getSiteNo());
        displayVO.setDispNo(vo.getId1());
        displayVO = proxyDao.selectOne(MapperConstants.DESIGN_DISPLAY + "selectDisplay", displayVO);

        return getFullFilePath(displayPath, vo.getSiteNo(), displayVO.getFilePath(), displayVO.getFileNm());
    }

    @Override
    public String getFaviconImage() {
        SiteVO siteVO = new SiteVO();
        siteVO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", siteVO);
        return getFullFilePath(displayPath, siteVO.getSiteNo(), siteVO.getFvcPath());
    }

}
