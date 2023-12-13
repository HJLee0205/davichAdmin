package net.danvi.dmall.admin.web.common.view;

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
public class View extends dmall.framework.common.view.View {

    /**
     * <pre>
     * - 프로젝트명	: 41.admin.web
     * - 파일명		: View.java
     * - 작성일		: 2016. 3. 3.
     * - 작성자		: dykim
     * - 설명			: 엑셀 다운로드 일 경우
     * </pre>
     * @return
     */
    public static String excelDownload() {
        return CommonConstants.EXCEL_VIEW_NAME;
    }
}
