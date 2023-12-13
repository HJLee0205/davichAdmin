package dmall.framework.spring.yamlProperties;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.YamlProcessor.DocumentMatcher;
import org.springframework.beans.factory.config.YamlProcessor.MatchStatus;
import org.springframework.beans.factory.config.YamlPropertiesFactoryBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.util.StringUtils;

import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.util.*;


@Slf4j
public class SpringProfileDocumentMatcher implements DocumentMatcher, EnvironmentAware, ApplicationContextAware {

    private ApplicationContext ctx;
    private final static String DEFAULT_PROFILE = "stage";
    private String[] activeProfiles = new String[0];
    private final static String MATCHER = "spring.profile";

    public SpringProfileDocumentMatcher() {}

    @Override
    public void setEnvironment(Environment environment) {
        if (environment != null) {
            addActiveProfiles(environment.getActiveProfiles());
        }
    }

    public void addActiveProfiles(String... profiles) {
        LinkedHashSet<String> set = new LinkedHashSet<>(Arrays.asList(this.activeProfiles));
        Collections.addAll(set, profiles);
        this.activeProfiles = set.toArray(new String[set.size()]);
    }

    @Bean(name = "dmall/framework/spring/yamlProperties")
    public YamlPropertiesFactoryBean yamlPropertiesFactoryBean() throws IOException {
        YamlPropertiesFactoryBean yamlPropertiesFactoryBean = new YamlPropertiesFactoryBean();
        yamlPropertiesFactoryBean.setResources(ctx.getResources("classpath:application.yml"));
        return yamlPropertiesFactoryBean;
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.ctx = applicationContext;
    }

    @Override
    public MatchStatus matches(Properties properties) {
        String[] profiles = this.activeProfiles;
        MatchStatus matchStatus = MatchStatus.NOT_FOUND;;

        if (profiles.length == 0) {
            String activeProfile;
            activeProfile =  System.getenv().getOrDefault("SPRING_PROFILES_ACTIVE", null);
            activeProfile =  System.getProperty("spring.profiles.active", activeProfile);
            activeProfile = activeProfile == null || "".equals(activeProfile)? DEFAULT_PROFILE: activeProfile;
            profiles = new String[] { activeProfile };
        }

        System.out.println("Profiles : "  + Arrays.toString(profiles));

        matchStatus = !properties.containsKey(MATCHER)? MatchStatus.ABSTAIN: matchStatus;

        if (matchStatus == MatchStatus.NOT_FOUND){
            Set<String> values = StringUtils.commaDelimitedListToSet(properties.getProperty(MATCHER));
            values = values.isEmpty()? Collections.singleton(""): values;
            for (String profile : profiles) for (String value : values) {
                matchStatus = value.matches(profile)? MatchStatus.FOUND: matchStatus;
                if (matchStatus == MatchStatus.FOUND) break;
            }
        }
        return matchStatus;
    }
}
