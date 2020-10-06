<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../../not_allowed.aspx");
	}
%>
<html>
<head>
<title>ADMINISTRATION - Update a password</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			if(Session["sql_connection_string"] != null)
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref UserSelect, "admin_get_user_list_to_html_select");
			}
		}
	}
	
	void UpdatePasswordButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((NewPasswordTextField.Value == "")
		|| (ReNewPasswordTextField.Value == "")
		|| (UserSelect.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(NewPasswordTextField.Value.Equals(ReNewPasswordTextField.Value))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
						
						string salt = CreateSalt(5);
						string passwordHash = CreatePasswordHash(NewPasswordTextField.Value, salt);
					
						string result = sqlClient.ExecuteStoredProcedure("admin_update_password",
							"@id_user", UserSelect.Value,
							"@password_hash", passwordHash,
							"@password_salt", salt);
							
						InformationTextField.Value = result;
					}
					catch(PortalException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while updating a password!&message=" + ex.Message);
					}
				}
			}
			else
			{
				InformationTextField.Value = "WARNING : New passwords are not the same!";
			}
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">UPDATE A PASSWORD</td>
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
				<td width="60" class="text" align="left">User : </td>
			    <td width="5"></td>
			    <td width="400"><select id="UserSelect" name="UserSelect" size="1" class="text" style="width:400px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="23"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="UpdatePasswordButton" name="UpdatePasswordButton" alt="Update password" value="Update" onServerClick="UpdatePasswordButton_Click"></td>
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
</table>
</form>
</body>
</html>
