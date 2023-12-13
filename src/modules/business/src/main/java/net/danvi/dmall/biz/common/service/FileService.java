package net.danvi.dmall.biz.common.service;

import net.danvi.dmall.biz.common.model.ImageViewSO;

/**
 * Created by dong on 2016-05-27.
 */

public interface FileService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 전시 관리에서 등록한 이미지의 경로를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    public String getDisplayImage(ImageViewSO vo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 사이트 설정의 파비콘 이미지의 경로를 반환한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public String getFaviconImage();

}
