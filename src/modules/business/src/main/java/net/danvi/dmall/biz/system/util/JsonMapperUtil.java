package net.danvi.dmall.biz.system.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.danvi.dmall.biz.system.security.SimpleGrantedAuthorityMixin;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.DmallSessionDetailsMixin;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

/**
 * Created by dong on 2016-04-27.
 */
public class JsonMapperUtil {

    private static ObjectMapper mapper;

    private JsonMapperUtil(){}

    public static ObjectMapper getMapper() {
        if(mapper == null) {
            mapper = new ObjectMapper();
            mapper.addMixIn(SimpleGrantedAuthority.class, SimpleGrantedAuthorityMixin.class);
            mapper.addMixIn(DmallSessionDetails.class, DmallSessionDetailsMixin.class);
        }

        return mapper;
    }
}
