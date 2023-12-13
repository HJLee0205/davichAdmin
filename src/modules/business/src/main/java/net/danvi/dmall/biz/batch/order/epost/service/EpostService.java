package net.danvi.dmall.biz.batch.order.epost.service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import net.danvi.dmall.biz.batch.link.sabangnet.model.ProcRunnerVO;

public interface EpostService {

    /**
     * <pre>
     * 작성일 : 2016. 7. 13.
     * 작성자 : dong
     * 설명   : 우체국 택배 인터페이스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 13.        - 최초생성
     * </pre>
     *
     * @param param
     * @param domain
     */
    // 1. 우체국 택배 수신
    public void epostReceive(ProcRunnerVO param, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 2. 우체국 택배 송신
    public void epostSend(ProcRunnerVO param, String domain)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 파일생성
    public void epostWriteFile(String sendText)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException;

    // 파일읽기
    public void epostReadFile();
}
