package kr.co.smart.common;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

//@Component : @Service, @Resposioty,
@Service
public class CommonUtility {
	public String appURL(HttpServletRequest request) {
		// http://localhost:8080/smart
		// http://127.0.0.1:80/smart
		// http://192.168.0.10:8090/smart
		StringBuffer url = new StringBuffer("http://");
		url.append(request.getServerName() ).append(":"); // http://localhost, http:127.0.0.1
		url.append(request.getServerPort() ); // http://localhost:8080, http://127.0.0.1:80
		url.append(request.getContextPath() ); // http://localhost:8080/iot, http://127.0.0.1:80/smart
		return url.toString();
	}
}
