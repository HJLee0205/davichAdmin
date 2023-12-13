package dmall.framework.common.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-05-25.
 */
@Data
public class EditorBaseVO<T> extends BaseModel<T> {
    private List<EditorImageVO> attachImages = new ArrayList<>(); // 업로드 하여 에디터에서 사용하는 이미지 정보 목록(저장 대상)
}
