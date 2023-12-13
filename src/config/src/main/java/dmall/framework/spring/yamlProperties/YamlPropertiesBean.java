package dmall.framework.spring.yamlProperties;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.config.YamlPropertiesFactoryBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import java.io.FileNotFoundException;
import java.util.Properties;

@Slf4j
public class YamlPropertiesBean extends YamlPropertiesFactoryBean{

    private Resource[] resources = new Resource[0];

    public YamlPropertiesBean (){
        setDocumentMatchers(new SpringProfileDocumentMatcher());
    }

    public Resource createResource(String path){
        ClassLoader classLoader =  getClass().getClassLoader();
        return new ClassPathResource(path, classLoader);
    }

    public String getProperty(String key){
        Properties properties = getObject();
        return properties.getProperty(key, "");
    };

    @Override
    protected Properties createProperties() {
        Properties result = super.createProperties();
        String[] keys = new String[result.size()];
        keys = result.keySet().toArray(keys);
        for (String key: keys){
            Object value = result.get(key);
            result.remove(key);
            key = key.replace("properties.", "");
            result.put(key, value);
        }
        return result;
    }
}
