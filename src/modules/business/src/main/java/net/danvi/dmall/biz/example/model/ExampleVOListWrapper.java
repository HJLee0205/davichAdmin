package net.danvi.dmall.biz.example.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import lombok.Data;

/**
 * Created by dong on 2016-04-20.
 */
@Data
public class ExampleVOListWrapper {
    @Valid
    private List<ExampleVO> list;

    public ExampleVOListWrapper() {
        this.list = new ArrayList<>();
    }
}
