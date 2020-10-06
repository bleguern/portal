<%@ Page Language="C#" %>
<!-- #Include file="../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../not_allowed.aspx");
	}
%>
<html>
<head>
<title>DELIA SYSTEMS PORTAL - Update your password</title>
<LINK href="../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			LoginTextField.Value = User.Identity.Name.ToUpper();
		}
	}
	
	void ValidatePasswordButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((OldPasswordTextField.Value == "")
		|| (NewPasswordTextField.Value == "")
		|| (ReNewPasswordTextField.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(NewPasswordTextField.Value.Equals(ReNewPasswordTextField.Value))
			{
				if(VerifyPassword(User.Identity.Name, OldPasswordTextField.Value))
				{
					if(Session["sql_connection_string"] != null)
					{
						try
						{
							PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
							
							string salt = CreateSalt(5);
							string passwordHash = CreatePasswordHash(NewPasswordTextField.Value, salt);
			
							string result = sqlClient.ExecuteStoredProcedure("portal_update_password",
								"@login", User.Identity.Name,
								"@password_hash", passwordHash,
								"@password_salt", salt);
								
							InformationTextField.Value = result;
						}
						catch(PortalException ex)
						{
							Response.Redirect("../error/Default.aspx?error=Internal error while updating your password!&message=" + ex.Message);
						}
					}
				}
				else
				{
					InformationTextField.Value = "WARNING : Your old password is incorrect!";
				}
			}
			else
			{
				InformationTextField.Value = "WARNING : New passwords are not the same!";
			}
		}
	}
	
	bool VerifyPassword(string suppliedUserName, string suppliedPassword)
	{
		bool success = false;
		
		PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
		
		try
		{
			string [] values = sqlClient.GetValuesWithStoredProcedure("portal_get_password",
				"@login", suppliedUserName);
	
			string passwordHash = values[0];
			string passwordSalt = values[1];
			
			string passwordAndSalt = String.Concat(suppliedPassword, passwordSalt);
			string passwordHashAndSalt = FormsAuthentication.HashPasswordForStoringInConfigFile(passwordAndSalt, "SHA1");
			
			success = passwordHashAndSalt.Equals(passwordHash);
		}
		catch(Exception)
		{
			success = false;
		}
	  
	  	return success;
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<center>
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">UPDATE YOUR PASSWORD</td>
  			</tr>
		</table>
	</td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="150" class="text_bold" align="right">Login : </td>
			    <td width="5"></td>
			    <td width="345"><input name="LoginTextField" type="text" class="text_bold" id="LoginTextField" style="width:200px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="20"></td>
	</tr>
    <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="150" class="text" align="right">Old password : </td>
			    <td width="5"></td>
			    <td width="200"><input name="OldPasswordTextField" type="password" class="text" id="OldPasswordTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="133"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="20"></td>
	</tr>
    <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="150" class="text" align="right">New password : </td>
			    <td width="5"></td>
			    <td width="200"><input name="NewPasswordTextField" type="password" class="text" id="NewPasswordTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="133"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="150" class="text" align="right">Retype new password : </td>
			    <td width="5"></td>
			    <td width="200"><input name="ReNewPasswordTextField" type="password" class="text" id="ReNewPasswordTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="133"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr>
	  <td>
	  <table width="500" border="0" cellspacing="0" cellpadding="0">
		<tr align="center">
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="ValidatePasswordButton" name="ValidatePasswordButton" alt="Validate your new password" value="Validate" onServerClick="ValidatePasswordButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:500px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td class="red">* : Mandatory fields</td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
  <tr>
   <td align="center" class="text"><a href="../../Default.aspx">Return to portal</a></td>
  </tr>
</table>
</center>
</form>
</body>
</html>
