package dmall.framework.common.util.image;

import java.io.File;
import java.util.List;

import lombok.Data;

@Data
public class ImageInfoData {

    /** 원본 이미지 */
    private String orgImgPath;
    /** 이미지 타입 */
    private ImageType imageType;
    /** 생성File List */
    private List<File> destFileList;

}
