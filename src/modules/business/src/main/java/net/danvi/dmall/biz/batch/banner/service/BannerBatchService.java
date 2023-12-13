package net.danvi.dmall.biz.batch.banner.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

public interface BannerBatchService {

    /**
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. dong - 최초생성
     * </pre>
     *
     * @param param
     * @param domain
     * @throws InvocationTargetException
     * @throws NoSuchMethodException
     * @throws IllegalAccessException
     * @throws IOException
     */
    public void bannerAutoDispNone() throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

}
