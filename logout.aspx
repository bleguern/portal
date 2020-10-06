<%@ Page Language="C#" %>
<%
	Session.Clear();
	Session.Abandon();
	FormsAuthentication.SignOut();
	Response.Redirect("Default.aspx");
%>
