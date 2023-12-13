package dmall.framework.common.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.nio.charset.Charset;

/**
 * Created by dong on 2016-08-12.
 */
@Slf4j
@Component("executeExtCmdUtil")
public class ExecuteExtCmdUtil {

    private static String CHARSET;

    private static String QUOTA_SHELL_SCRIPT;
    private static String CHOWN_SHELL_SCRIPT;
    private static String COPY_SHELL_SCRIPT;

    @Value("#{system['system.charset']}")
    private String _charset;

    @Value("#{system['system.quota.script']}")
    private String _quotaScript;

    @Value("#{system['system.chown.script']}")
    private String _chownScript;

    @Value("#{system['system.copy.script']}")
    private String _cpScript;

    @PostConstruct
    public void init() {
        CHARSET = _charset;
        QUOTA_SHELL_SCRIPT = _quotaScript;
        CHOWN_SHELL_SCRIPT = _chownScript;
        COPY_SHELL_SCRIPT = _cpScript;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 외부 명령 실행, 기본 캐릭터셋으로 결과를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @param cmd
     * @return
     * @throws IOException
     */
    public static String executeExtCmd(String... cmd) throws IOException {
        return ExecuteExtCmdUtil.executeExtCmd(Charset.forName(CHARSET), cmd);
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 14.
     * 작성자 : dong
     * 설명   : 외무 명령실행, 정의된 캐릭터셋으로 결과를 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 14. dong - 최초생성
     * </pre>
     *
     * @param charset
     * @param cmd
     * @return
     * @throws IOException
     */
    public static String executeExtCmd(Charset charset, String... cmd) throws IOException {
        String resultString;
        DefaultExecutor executor = new DefaultExecutor();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PumpStreamHandler streamHandler = new PumpStreamHandler(baos);
        executor.setStreamHandler(streamHandler);

        CommandLine cmdLine = CommandLine.parse(cmd[0]);
        for (int i = 1, n = cmd.length; i < n; i++) {
            cmdLine.addArgument(cmd[i]);
        }
        log.debug(cmdLine.toString());
        int exitValue = executor.execute(cmdLine);
        resultString = baos.toString(charset);

        log.debug("실행결과: {}", resultString);
        return resultString;
    }

    /**
     * 쿼타 kb 반환
     * 
     * @param siteId
     * @return
     */
    public static Long getFreeDisk(String siteId) {
        try {
            String resultString = ExecuteExtCmdUtil.executeExtCmd(QUOTA_SHELL_SCRIPT, siteId).trim();
            log.debug("result : {}", resultString);
            String[] quota = resultString.split(" ");
            if (quota.length != 2) {
                throw new Exception("쿼타 결과 오류");
            }
            if (quota[0].contains("*")) {
                log.debug("디스크 쿼터 오버, 업로드 불가");
                return 0L;
            } else {
                return Long.parseLong(quota[1].trim()) - Long.parseLong(quota[0].trim());
            }
        } catch (Exception e) {
            log.error("셀 스크립트 실행 오류", e);
        }
        return 0L;
    }

    public static String getDiskQuota(String siteId) {
        try {
            return ExecuteExtCmdUtil.executeExtCmd(QUOTA_SHELL_SCRIPT, siteId).trim();
        } catch (Exception e) {
            log.error("셀 스크립트 실행 오류", e);
            return "";
        }
    }

    public static boolean chown(String siteId) {
        try {
            ExecuteExtCmdUtil.executeExtCmd(CHOWN_SHELL_SCRIPT, siteId).trim();
            return true;
        } catch (Exception e) {
            log.error("셀 스크립트 실행 오류", e);
            return false;
        }
    }

    public static boolean copy(String siteId, String source, String target) {
        try {
            ExecuteExtCmdUtil.executeExtCmd(COPY_SHELL_SCRIPT, siteId, source, target).trim();
            return true;
        } catch (Exception e) {
            log.error("셀 스크립트 실행 오류", e);
            return false;
        }
    }
}
