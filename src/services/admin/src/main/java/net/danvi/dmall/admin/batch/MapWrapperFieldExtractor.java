package net.danvi.dmall.admin.batch;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;

import org.springframework.batch.item.file.transform.FieldExtractor;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.util.Assert;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 19.
 * 작성자     : dong
 * 설명       : Map 에서 정의된 항목을 추출하기 위한 추출자 클래스
 * </pre>
 */
public class MapWrapperFieldExtractor<T> implements FieldExtractor<T>, InitializingBean {
    private String[] names;

    public MapWrapperFieldExtractor() {
    }

    public void setNames(String[] names) {
        Assert.notNull(names, "Names must be non-null");
        this.names = (String[]) Arrays.asList(names).toArray(new String[names.length]);
    }

    public Object[] extract(T item) {
        ArrayList<Object> values = new ArrayList<>();
        Map<String, Object> map = (Map<String, Object>) item;
        String[] arr$ = this.names;
        int len$ = arr$.length;

        for (int i$ = 0; i$ < len$; ++i$) {
            String propertyName = arr$[i$];
            values.add(map.get(propertyName));
        }

        return values.toArray();
    }

    public void afterPropertiesSet() {
        Assert.notNull(this.names, "The \'names\' property must be set.");
    }
}
