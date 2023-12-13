package dmall.framework.common.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
 * Created by dong on 2016-05-25.
 */
@Data
public class MultiEditorBasePO<T> extends BaseModel<T> {

    private static final long serialVersionUID = -1012357828840557281L;

    /* 업로드 하여 에디터에서 사용하는 이미지 정보 목록(저장 대상) */
    private List<List<CmnAtchFilePO>> attachImages = new ArrayList<>();
    /* 업로드 하였지만 에디터에서 사용하지 않는 이미지 정보 목록(임시파일 삭제 대상) */
    private List<List<CmnAtchFilePO>> deletedImages = new ArrayList<>();
}
