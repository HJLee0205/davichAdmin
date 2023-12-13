package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode
public class DeptVo implements Serializable {
    private int deptNo;
    private String deptName;
    private String location;

}