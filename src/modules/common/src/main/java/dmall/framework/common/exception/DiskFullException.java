package dmall.framework.common.exception;

import java.text.NumberFormat;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 10. 13.
 * 작성자     : dong
 * 설명       : 파일 업로드시 디스크 사용량 없을때 발생하는 익셉션
 * </pre>
 */
public class DiskFullException extends RuntimeException {


    public DiskFullException(String msg) {
        super(msg);
    }
    public DiskFullException(Long size) {


        super("디스크에 " + getByte(size)  + "바이트의 파일을 업로드할 빈공간이 없습니다.");
    }

    public DiskFullException(Long size, Throwable t) {
        super("디스크에 " + getByte(size) + "바이트의 파일을 업로드할 빈공간이 없습니다.", t);
    }

    private static String getByte(Long size) {
        NumberFormat nf = NumberFormat.getInstance();
        return nf.format(size);
    }
}
