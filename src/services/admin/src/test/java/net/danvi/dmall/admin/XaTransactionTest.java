package net.danvi.dmall.admin;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.example.service.TestService;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {
        "classpath:spring/context/*.xml", "classpath:spring/job/*.xml" , "classpath:config/**/*.xml"})
@FixMethodOrder(value = MethodSorters.NAME_ASCENDING)
public class XaTransactionTest {

    @Autowired
    private TestService service;

    @Test
    public void test1xaInsertTest() {
        // 1 등록
        service.xaInsertTest1();
    }

    @Test(expected = RuntimeException.class)
    public void test2xaInsertErrorTest() {
        // 2 등록
        service.xaInsertErrorTest1();
    }

    @Test
    public void test3xaUpdateTest() {
        // 1을 2로 수정
        service.xaUpdateTest1();
    }

    @Test(expected = RuntimeException.class)
    public void test4xaUpdateErrorTest() {
        // 2를 3으로 수정
        service.xaUpdateErrorTest1();
    }

    @Test
    public void test5xaDeleteTest() {
        // 2 삭제
        service.xaDeleteTest1();
    }

    @Test(expected = RuntimeException.class)
    public void test6xaDeleteErrorTest() {
        // 3등록 3삭제
        service.xaInsertTest2();
        service.xaDeleteErrorTest2();
    }
}
