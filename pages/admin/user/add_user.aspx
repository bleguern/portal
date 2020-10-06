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
<title>ADMINISTRATION - Add an user</title>
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
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref RoleSelect, "admin_get_role_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref SectorSelect, "admin_get_sector_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref CompanySelect, "admin_get_customer_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref TeamSelect, "admin_get_team_list_to_html_select");
			}
		}
	}
	
	void SaveUserButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((TrigramTextField.Value == "")
		|| (ActiveSelect.Value == "")
		|| (RoleSelect.Value == "")
		|| (SectorSelect.Value == "")
		|| (CompanySelect.Value == "")
		|| (LoginTextField.Value == "")
		|| (PasswordTextField.Value == "")
		|| (EmailTextField.Value == "")
		|| (FirstNameTextField.Value == "")
		|| (LastNameTextField.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
					string salt = CreateSalt(5);
					string passwordHash = CreatePasswordHash(PasswordTextField.Value, salt);
	
					string result = sqlClient.ExecuteStoredProcedure("admin_add_user",
						"@trigram", GetValueFromHtmlInputText(TrigramTextField, true),
						"@active", GetValueFromHtmlSelect(ActiveSelect),
						"@id_role", GetValueFromHtmlSelect(RoleSelect),
						"@id_sector", GetValueFromHtmlSelect(SectorSelect),
						"@team", GetValueFromHtmlSelect(TeamSelect),
						"@num_client", GetValueFromHtmlSelect(CompanySelect),
						"@login", GetValueFromHtmlInputText(LoginTextField, true),
						"@password_hash", passwordHash,
						"@password_salt", salt,
						"@email", GetValueFromHtmlInputText(EmailTextField, true),
						"@first_name", GetValueFromHtmlInputText(FirstNameTextField, true),
						"@last_name",GetValueFromHtmlInputText(LastNameTextField, true),
						"@phone", GetValueFromHtmlInputText(PhoneTextField, true),
						"@cellular", GetValueFromHtmlInputText(CellularTextField, true));
				
					InformationTextField.Value = result;
					SaveUserButton.Disabled = true;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding an user!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : TRIGRAM or LOGIN already exist!";
				}
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
    			<td class="header">ADD AN USER</td>
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
				<td width="80" class="text">Trigram : </td>
			    <td width="5"></td>
			    <td width="100"><input name="TrigramTextField" type="text" class="text" id="TrigramTextField" style="width:100px" maxlength="3" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="303"></td>
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
				<td width="80" class="text">Active : </td>
			    <td width="5"></td>
			    <td width="100"><select id="ActiveSelect" name="ActiveSelect" size="1" class="text" style="width:100px"
										runat="server">
				  <option value=""></option>
			      <option value="1" selected>Yes</option>
			      <option value="0">No</option>
			    </select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="303"></td>
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
				<td width="80" class="text">Role : </td>
			    <td width="5"></td>
			    <td width="150"><select id="RoleSelect" name="RoleSelect" size="1" class="text" style="width:150px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="253"></td>
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
				<td width="80" class="text">Division : </td>
			    <td width="5"></td>
			    <td width="150"><select id="SectorSelect" name="SectorSelect" size="1" class="text" style="width:150px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="253"></td>
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
				<td width="80" class="text">Team : </td>
			    <td width="5"></td>
			    <td width="150"><select id="TeamSelect" name="TeamSelect" size="1" class="text" style="width:150px"
										runat="server"></select></td>
				<td width="265"></td>
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
				<td width="80" class="text">Company : </td>
			    <td width="5"></td>
			    <td width="200"><select id="CompanySelect" name="CompanySelect" size="1" class="text" style="width:200px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="203"></td>
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
				<td width="80" class="text">Login : </td>
			    <td width="5"></td>
			    <td width="200"><input name="LoginTextField" type="text" class="text" id="LoginTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="203"></td>
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
				<td width="80" class="text">Password : </td>
			    <td width="5"></td>
			    <td width="200"><input name="PasswordTextField" type="password" class="text" id="PasswordTextField" style="width:200px" maxlength="20" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="203"></td>
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
				<td width="80" class="text">Email : </td>
			    <td width="5"></td>
			    <td width="300"><input name="EmailTextField" type="text" class="text" id="EmailTextField" style="width:300px" maxlength="100" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="103"></td>
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
				<td width="80" class="text">First name : </td>
			    <td width="5"></td>
			    <td width="300"><input name="FirstNameTextField" type="text" class="text" id="FirstNameTextField" style="width:300px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="103"></td>
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
				<td width="80" class="text">Last name : </td>
			    <td width="5"></td>
			    <td width="300"><input name="LastNameTextField" type="text" class="text" id="LastNameTextField" style="width:300px" maxlength="50" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="103"></td>
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
				<td width="80" class="text">Phone : </td>
			    <td width="5"></td>
			    <td width="415"><input name="PhoneTextField" type="text" class="text" id="PhoneTextField" style="width:200px" maxlength="20" runat="server"></td>
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
				<td width="80" class="text">Cellular : </td>
			    <td width="5"></td>
			    <td width="415"><input name="CellularTextField" type="text" class="text" id="CellularTextField" style="width:200px" maxlength="20" runat="server"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="SaveUserButton" name="SaveUserButton" alt="Save user" value="Save" onServerClick="SaveUserButton_Click"></td>
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
