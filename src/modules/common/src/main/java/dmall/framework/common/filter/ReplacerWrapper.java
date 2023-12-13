package dmall.framework.common.filter;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * Created by dong on 2016-06-16.
 */
public class ReplacerWrapper extends HttpServletResponseWrapper {

    private StringWriter sw = new StringWriter();

    public ReplacerWrapper(HttpServletResponse response) {
        super(response);
    }

    @Override
    public PrintWriter getWriter() throws IOException {
//        return getResponse().getWriter();
        return new PrintWriter(sw);
    }

    @Override
    public ServletOutputStream getOutputStream() throws IOException {
        return this.getResponse().getOutputStream();
/*        throw new UnsupportedOperationException();*/
    }

    @Override
    public String toString() {
        return sw.toString();
    }
}
