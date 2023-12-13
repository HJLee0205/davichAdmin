package net.danvi.dmall.biz.system.model;

import lombok.Data;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by dong on 2016-05-10.
 */
@Data
public class Menu extends MenuVO {
    private Map<String, MenuVO> childs;

    public Menu() {
        childs = new LinkedHashMap<>();
    }

    public Boolean hasChildren() {
        return this.childs.size() > 0;
    }
}
