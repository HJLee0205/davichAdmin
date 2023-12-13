import org.junit.runners.model.InitializationError;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jndi.JndiTemplate;
import org.springframework.mock.jndi.SimpleNamingContextBuilder;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by dong on 2016-03-16.
 */
public class SpringJUnit4ClassRunnerWithDatasource extends SpringJUnit4ClassRunner {

    public SpringJUnit4ClassRunnerWithDatasource(Class clazz) throws InitializationError {
        super(clazz);
        try {
            bindJndi();
        } catch (Exception e) {
        }
    }

    /**
     * datasource를 JNDI에 바인드
     *
     * @throws Exception
     */

    private void bindJndi() throws Exception {

        // mock으로된 contextFactory를 구현
        SimpleNamingContextBuilder builder = new SimpleNamingContextBuilder();
        builder.activate();

        // jndi를 bind합니다.
        JndiTemplate jt = new JndiTemplate();
        DriverManagerDataSource ds = new DriverManagerDataSource();
//        SimpleDriverDataSource ds = new SimpleDriverDataSource();
        ds.setDriverClassName(com.mysql.jdbc.Driver.class.getName());
        ds.setUrl("jdbc:mysql://localhost:3306/veci");
        ds.setUsername("test");
        ds.setPassword("test");
        jt.bind("jdbc/testDB", ds);
    }
}
