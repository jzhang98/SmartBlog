<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="com.googlecode.objectify.Key"%>
<%@ page import=" com.googlecode.objectify.annotation.Entity" %>
<%@ page import=" com.googlecode.objectify.annotation.Id" %>
<%@ page import=" com.googlecode.objectify.annotation.Index" %>
<%@ page import=" com.googlecode.objectify.annotation.Parent" %>

<%@ page import=" com.googlecode.objectify.Objectify " %>

<%@ page import=" com.googlecode.objectify.ObjectifyService " %>

<%@ page import="java.util.Collections" %>

<%@ page import ="guestbook.Greeting" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

  <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>

 

  <body>

 

<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to include your name with greetings you post.</p>

<%

    }

%>

 <a href="blog.jsp">Return to main</a>


<%



    // Run an ancestor query to ensure we see the most up-to-date

    // view of the Greetings belonging to the selected Guestbook.

ObjectifyService.register(Greeting.class);

List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   

Collections.sort(greetings); 
        for (Greeting greeting : greetings) {
        	if(!greeting.getId().toString().equals(request.getParameter("id"))){
        		continue;
        	}
        	pageContext.setAttribute("greeting_title",

                    greeting.getTitle());

            pageContext.setAttribute("greeting_content",

                                     greeting.getContent());
            String guser;
            Long gid = greeting.getId();

            if (greeting.getUser() == null) {
            	guser = "anonymous";

            } else {

                pageContext.setAttribute("greeting_user",

                                         greeting.getUser() );
                guser = greeting.getUser().getNickname();

            }

            %>
			<p> <b><%= request.getParameter("title") %> </b> by ${fn:escapeXml(greeting_user.nickname)}</p>
			<p> <%= greeting.getContent() %> </p>
			<br>

            <%

        }

%>

 

  </body>

</html>
