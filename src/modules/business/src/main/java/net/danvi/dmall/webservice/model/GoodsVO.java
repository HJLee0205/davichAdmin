package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode
public class GoodsVO implements Serializable {
    private String STATUS;
    private String MESSAGE;
    private String GOODSNO;

}