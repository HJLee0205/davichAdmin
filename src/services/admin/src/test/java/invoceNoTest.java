import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.*;

/**
 * @Package Name   : PACKAGE_NAME
 * @FileName  : ${FILE_NAME}
 * @작성일       : 2019. 01. 22. 
 * @작성자       : 김동엽
 * @프로그램 설명 : 

 */

public class invoceNoTest {
    @Test
    public void test() throws Exception {
        long a = ((Long.parseLong("90303883622".substring(0, 10))) % 7);
        long b =Long.parseLong("90303883622".substring(10, 11));
        System.out.println("a :: "+a);
        System.out.println("b :: "+b);
        //로젠텍배
        if ((Long.parseLong("90303883622".substring(0, 10))) % 7 == Long.parseLong("90303883622".substring(10, 11))) {
            System.out.println("result :: "+true);
        }
    }

}