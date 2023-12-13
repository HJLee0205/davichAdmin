package net.danvi.dmall.biz.batch.goods.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import net.danvi.dmall.biz.batch.goods.salestatus.model.GoodsBatchVO;

public interface GoodsBatchService {

    // 1. 상품 판매여부 변경
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
    public void updateGoodsSaleStatus(GoodsBatchVO param) throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 2. 상품 정렬 데이터 변경
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
    public void updateGoodsSortInfo(GoodsBatchVO param) throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;


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
    public void createEpGoodsInfo() throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

}
