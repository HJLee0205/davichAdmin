package dmall.framework.common.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-05-25.
 */
@Data
public class MappingVO<T> extends BaseModel<T> {
    private static final long serialVersionUID = 1434498214435377403L;

    public MappingVO(String itemNmEng, String itemNmKo, String targetItemNm) {
        this.itemNmEng = itemNmEng;
        this.itemNmKo = itemNmKo;
        this.targetItemNm = targetItemNm;
    }

    public MappingVO(String itemNmKo, String targetItemNm) {
        this.itemNmKo = itemNmKo;
        this.targetItemNm = targetItemNm;
    }
    /* 업로드 하여 에디터에서 사용하는 이미지 정보 목록(저장 대상) */
    private String erpCode;
    private String itemNmEng;
    private String itemNmKo;
    private String targetItemNm;
}
