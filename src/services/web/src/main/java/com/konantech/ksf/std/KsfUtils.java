package com.konantech.ksf.std;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.konantech.ksf.client.KsfClient;

public class KsfUtils {
	
	private static Logger log = Logger.getLogger(KsfUtils.class);
	
	public static String suggest(HttpSession session, String url, int domain,
			String query) {
		session.removeAttribute("censored");
		session.removeAttribute("spell");
		session.removeAttribute("suggestions");

		if (StringUtils.isEmpty(query)) {
			return query;
		}

		try {
			KsfClient ksfclient = new KsfClient(url);
			if (Config.isRunning("csw")) {
				// filter censored words
				String[] censored = ksfclient.getCensoredWords(domain, query);
				if (censored.length > 0) {
					for (int i = 0; i < censored.length; i++) {
						// remove censored words from query string
						query = StringUtils.remove(query, censored[i]);
					}
					query = query.trim();
					session.setAttribute("censored",
							StringUtils.join(censored, ','));
				}
			}
			if (Config.isRunning("spc")) {
				boolean misspell = false;
				// spelling check
				String tokens[] = StringUtils.split(query);
				for (int i = 0; i < tokens.length; i++) {
					String[] spells = ksfclient.suggestSpell(tokens[i]);
					if (spells.length > 0) {
						tokens[i] = spells[0];
						misspell = true;
					}
				}
				if (misspell) {
					session.setAttribute("spell", StringUtils.join(tokens, ' '));
				}
			}
			if (Config.isRunning("kre")) {
				// related keywords suggestion
				String[] suggestions = ksfclient.suggestRelated(domain, query,
						10);
				session.setAttribute("suggestions", suggestions);
			}
		} catch (Exception ex) {
			log.error(ex.getMessage());
		}
		return query;
	}
	
}
