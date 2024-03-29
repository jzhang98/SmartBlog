package guestbook;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class GuestbookServlet extends HttpServlet{
	
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		if(user != null) {
			resp.setContentType("text/plain");
			resp.getWriter().println("Hello, world");
			resp.sendRedirect(userService.createLogoutURL(req.getRequestURL().toString()));
		}else {
			resp.sendRedirect(userService.createLoginURL(req.getRequestURL().toString()));
		}
		
	}
	
	
	
}