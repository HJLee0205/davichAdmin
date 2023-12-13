package com.konantech.ksf.std;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;

import com.konantech.ksf.client.CrzClient;

public class Config {
	
	private static final Config instance = new Config();
	static {
		instance.loadProperties();
	}
	
	private Properties properties;
	private String[] modules;

	public void setProperties(Properties properties) {
		this.properties = properties;
	}

	public void setModules(String[] modules) {
		this.modules = modules;
	}
	
	public static Properties getProperties() {
		return instance.properties;
	}

	public static String getProperty(String key, String defaultValue) {
		return instance.properties.getProperty(key, defaultValue);
	}

	public static String getProperty(String key) {
		return instance.properties.getProperty(key);
	}
	
	public static int getPropertyInt(String key, int defaultValue) {
		try {
			String value = getProperty(key);
			return Integer.parseInt(value);
		} catch (Exception e) {
			return defaultValue;
		}
	}

	public static boolean isRunning(String module) {
		return ArrayUtils.contains(instance.modules, module);
	}
	
	public static CrzClient getCrzClient() {
		CrzClient client = new CrzClient(getProperty("SEARCH_ENGINE_IP"), getPropertyInt("SEARCH_ENGINE_PORT", 7577));
		client.setConnectionTimeout(getPropertyInt("SEARCH_ENGINE_TIMEOUT", 0));
		String charset = getProperty("SEARCH_ENGINE_CHARSET");
		if (charset != null) {
			client.setCharset(charset);
		}
		return client;
	}
	
	public void loadProperties() {
		File d = new File(getClass().getProtectionDomain().getCodeSource()
				.getLocation().getFile());
		File f = null;
		while ((d = d.getParentFile()) != null) {
			if ("WEB-INF".equals(d.getName())) {
				f = new File(d, "/classes/config/konan/default.properties");
				break;
			}
		}

		InputStream input = null;
		try {
			properties = new Properties();
			input = (f == null) 
					? getClass().getClassLoader().getResourceAsStream("default.properties")
					: new FileInputStream(f);
			properties.load(input);
			modules = StringUtils.split(properties.getProperty("KSF_MODULES"), ',');
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
				}
			}
		}
	}
	
}
