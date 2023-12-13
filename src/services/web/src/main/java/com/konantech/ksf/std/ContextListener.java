package com.konantech.ksf.std;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.PropertyConfigurator;

public class ContextListener implements ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent event) {
		// do nothing
	}
	
	/**
	 * Initialize log4j when application is being started 
	 */
	@Override
	public void contextInitialized(ServletContextEvent event) {
		// initialize log4j here
		ServletContext context = event.getServletContext();
		String log4jConfigLocation = context
				.getInitParameter("log4jConfigLocation");
		PropertyConfigurator
				.configure(context.getRealPath(log4jConfigLocation));
	}

}
