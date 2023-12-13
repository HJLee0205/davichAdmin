package net.danvi.dmall.biz.batch.common.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

public interface TempFileService {

    /**
     * <pre>
     * 작성일 : 2016. 10. 18.
     * 작성자 :
     * 설명   : 템프파일 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 18.        - 최초생성
     * </pre>
     *
     * @param param
     * @param domain
     */
    // 1.템프 파일 삭제
    public void tempFileDel()
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

}
