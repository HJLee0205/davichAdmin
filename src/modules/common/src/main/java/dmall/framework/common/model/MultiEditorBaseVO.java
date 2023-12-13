package dmall.framework.common.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

/**
 * Created by dong on 2016-05-25.
 */
@Data
public class MultiEditorBaseVO<T> extends BaseModel<T> {
    private static final long serialVersionUID = -9099424723085595389L;

    /* 업로드 하여 에디터에서 사용하는 이미지 정보 목록(저장 대상) */
    private List<List<EditorImageVO>> attachImages = new ArrayList<>();
}
