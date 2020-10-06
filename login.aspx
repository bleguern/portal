<%@ Page Language="C#" %>
<!-- #Include file="config/util.cs" -->
<html>
<head>
<title>DELIA SYSTEMS PORTAL - Login</title>
<link href="css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void ConnectButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		string login = LoginTextField.Value;
		string password = PasswordTextField.Value;
		
		switch(Login(login, password))
		{
			case 1:
			{
				FormsAuthenticationTicket authTicket = new FormsAuthenticationTicket(1, login, DateTime.Now, DateTime.Now.AddMinutes(120), false, null);
				
				string encryptedTicket = FormsAuthentication.Encrypt(authTicket);
				HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
				Response.Cookies.Add(authCookie);
				
				FormsAuthentication.RedirectFromLoginPage(login, false);
				break;
			}
			case 0:
			{
				InformationTextField.Value = "Bad login or password!";
				break;
			}
			case -1:
			{
				InformationTextField.Value = "Server connection error, please contact administrator!";
				break;
			}
			case -2:
			{
				InformationTextField.Value = "User not allowed!";
				break;
			}
			case -3:
			{
				InformationTextField.Value = "Xml error, please contact administrator!";
				break;
			}
			default:
			{
				InformationTextField.Value = "Unknown error, please contact administrator!";
				break;
			}
		}
	}
	
	int Login(string suppliedUserName, string suppliedPassword)
	{
		int success = 0;
		
		string defaultConnectionString = GetDefaultConnectionString();
		
		if(defaultConnectionString != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(defaultConnectionString);
			
			try
			{
				string [] values = sqlClient.GetValuesWithStoredProcedure("portal_get_password",
					"@login", suppliedUserName);
		
				string passwordHash = values[0];
				string passwordSalt = values[1];
				
				string passwordAndSalt = String.Concat(suppliedPassword, passwordSalt);
				string passwordHashAndSalt = FormsAuthentication.HashPasswordForStoringInConfigFile(passwordAndSalt, "SHA1");
				
				if(passwordHashAndSalt.Equals(passwordHash))
				{
					string active = sqlClient.ExecuteStoredProcedure("portal_login",
						"@login", suppliedUserName,
						"@password_hash", passwordHash);
			
					if(active.Equals("1"))
					{
						string [] sqlCredentials = sqlClient.GetValuesWithStoredProcedure("portal_get_sql_credentials",
							"@login", suppliedUserName,
							"@password_hash", passwordHash);
							
						string sqlLogin = sqlCredentials[0];
						string sqlPassword = sqlCredentials[1];
						
						string connectionString = GetConnectionString(sqlLogin, sqlPassword);
						
						if(connectionString != null)
						{
							Session.Add("sql_connection_string", connectionString);
							success = 1;
						}
						else
						{
							success = -1;
						}
					}
					else
					{
						success = -2;
					}
				}
			}
			catch(SqlException)
			{
				success = -1;
			}
			catch(Exception)
			{
				success = 0;
			}
		}
		else
		{
			success = -3;
		}
	  
	  	return success;
	}
</script>
<body class="index_body">
<form action="login.aspx" method="post" name="MainForm" runat="server">
<table width="750" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="160"></td>
  </tr>
  <tr>
  	<td>
		<table width="750" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="300" height="30"></td>
    			<td width="450" height="30" class="main_title">DELIA SYSTEMS PORTAL</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
		<table width="750" height="30" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td width="340" height="30" class="text"><div align="right">login :</div></td>
    			<td width="5" height="30"></td>
   			    <td width="150"><input type="text" class="text" id="LoginTextField" style="width:150px" maxlength="20" runat="server"></td>
   			    <td width="2"></td>
				<td width="253" height="30"><asp:RequiredFieldValidator CssClass="red" ControlToValidate="LoginTextField" Display="Static" ID="LoginRequiredFieldValidator" runat="server" Text="*"/></td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td>
		<table width="750" height="30" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td width="340" height="30" class="text"><div align="right">password :</div></td>
    			<td width="5" height="30"></td>
   			    <td width="150"><input type="password" class="text" id="PasswordTextField" style="width:150px" maxlength="20" runat="server"></td>
   			    <td width="2"></td>
				<td width="253" height="30"><asp:RequiredFieldValidator CssClass="red" ControlToValidate="PasswordTextField" Display="Static" ID="PasswordRequiredFieldValidator" runat="server" Text="*"/></td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td>
		<table width="750" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="370"></td>
    			<td height="25" width="380"><input type="submit" class="text" runat="server" style="width:100px" id="ConnectButton" name="ConnectButton" alt="Connect to Portal" value="Connect" onServerClick="ConnectButton_Click"></td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td height="35"></td>
  </tr>
  <tr>
  	<td>
		<table width="750" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td width="300" height="30"></td>
   			    <td width="280"><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:280px;border-width:0px" readonly="true" runat="server"></td>
				<td width="170"></td>
    		</tr>
		</table>
	</td>
  </tr>
  <tr>
    <td height="50"></td>
  </tr>
  <tr>
  	<td>
		<table width="750" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="130" height="30"></td>
    			<td width="450" class="red"><%= GetApplicationVersionLogin() %></td>
				<td width="170"></td>
			</tr>
		</table>
	</td>
  </tr>
</table>
</form>
</body>
</html>
