package dmall.framework.logback;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.spi.LoggerContextListener;
import ch.qos.logback.core.Context;
import ch.qos.logback.core.spi.ContextAwareBase;
import ch.qos.logback.core.spi.LifeCycle;
import dmall.framework.spring.yamlProperties.SpringProfileDocumentMatcher;
import dmall.framework.spring.yamlProperties.YamlPropertiesBean;
import org.apache.commons.lang.NullArgumentException;
import org.springframework.core.io.ClassPathResource;

import javax.management.*;
import java.io.FileNotFoundException;
import java.util.Properties;
import java.util.Set;

public class LoggerStartupListener extends ContextAwareBase implements LoggerContextListener, LifeCycle {
    private boolean started = false;

    private void putContextProperty(String k, Object v){
        Context context = getContext();

        if (k.matches("log[.].+")){
            System.out.println(k + " : " + v.toString());
            context.putProperty(k, (String) v);
        }
    }

    public static String getBaseName(){
        String basePath = System.getenv("CATALINA_BASE");
        basePath = basePath.replaceAll("/$", "");
        String[] path = basePath.split("/");
        return path[path.length-1];
    }

    @Override
    public void start() {
        if (started) return;
        YamlPropertiesBean factory = new YamlPropertiesBean();
        ClassLoader classLoader =  getClass().getClassLoader();
        ClassPathResource resource = new ClassPathResource("config/properties/logback.yml", classLoader);
        ClassPathResource appResource = new ClassPathResource("config/properties/application.yml", classLoader);

        Context context = getContext();
        factory.setDocumentMatchers(new SpringProfileDocumentMatcher());
        factory.setResources(resource, appResource);
        Properties properties = factory.getObject();
        properties.forEach((k, v) -> putContextProperty((String) k, v));
        String logName = System.getProperty("log.name", properties.getProperty("log.name", getBaseName()));
        logName = logName == null || "".equals(logName)? getBaseName(): logName;
        context.putProperty("log.name", logName);
        started = true;
    }

    @Override
    public void stop() {
    }

    @Override
    public boolean isStarted() {
        return started;
    }

    @Override
    public boolean isResetResistant() {
        return false;
    }

    @Override
    public void onStart(LoggerContext context) {

    }

    @Override
    public void onReset(LoggerContext context) {

    }

    @Override
    public void onStop(LoggerContext context) {

    }

    @Override
    public void onLevelChange(Logger logger, Level level) {

    }
}