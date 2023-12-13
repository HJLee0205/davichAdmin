package dmall.framework.common.view;

import dmall.framework.common.constants.CommonConstants;

/**
 * <pre>
 * - 프로젝트명	: 41.admin.web
 * - 패키지명	: admin.web.config.view
 * - 파일명		: View.java
 * - 작성일		: 2016. 3. 3.
 * - 작성자		: dykim
 * - 설명		:
 * </pre>
 */
public class View {

    /**
     * <pre>
     * - 프로젝트명	: 41.admin.web
     * - 파일명		: View.java
     * - 작성일		: 2016. 3. 3.
     * - 작성자		: dykim
     * - 설명		: Redirect 처리하는 경우
     * </pre>
     * @param url
     * @return
     */
    public static String redirect(String url) {
        return "redirect:" + url;
    }

    public static String forward(String url) {
        return "forward:" + url;
    }

    /**
     * <pre>
     * - 프로젝트명	: 41.admin.web
     * - 파일명		: View.java
     * - 작성일		: 2016. 3. 3.
     * - 작성자		: dykim
     * - 설명		: 파일 다운로드 일 경우
     * </pre>
     * @return
     */
    public static String fileDownload() {
        return CommonConstants.FILE_VIEW_NAME;
    }

    /**
     * <pre>
     * - 프로젝트명	: 41.admin.web
     * - 파일명		: View.java
     * - 작성일		: 2016. 3. 17.
     * - 작성자		: dykim
     * - 설명		: 파일 이미지 뷰
     * </pre>
     * @return
     */
    public static String imageView() {
        return CommonConstants.IMAGE_VIEW_NAME;
    }

    /**
     * <pre>
     * - 프로젝트명	: 41.admin.web
     * - 파일명		: View.java
     * - 작성일		: 2016. 3. 3.
     * - 작성자		: dykim
     * - 설명			: jsonView 호출
     * </pre>
     * @return
     */
    public static String jsonView() {
        return CommonConstants.JSON_VIEW_NAME;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : 뷰가 없는 요청을 위한 뷰
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public static String voidView() {return CommonConstants.VOID_VIEW_NAME;}

}
