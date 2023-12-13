package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.List;

@Data
@EqualsAndHashCode
@XmlRootElement(name="CtgVO")
public class CtgVO implements Serializable {
    private String ctgNo;
    private String upCtgNo;
    private String ctgNm;
    private String ctgLvl;

    private String STATUS;
    private String MESSAGE;

    private List<CtgVO> CTG_LIST;
}