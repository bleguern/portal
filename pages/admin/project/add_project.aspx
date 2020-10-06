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
<title>ADMINISTRATION - Add a project</title>
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
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref CustomerSelect, "admin_get_customer_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref ProjectLeaderSelect, "admin_get_user_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref IntegratorSelect, "admin_get_user_list_to_html_select");
			}
		}
	}
	
	void SaveProjectButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((NameTextField.Value == "")
		|| (CustomerSelect.Value == "")
		|| (ProjectLeaderSelect.Value == "")
		|| (IntegratorSelect.Value == ""))
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
						
					string result = sqlClient.ExecuteStoredProcedure("admin_add_project",
						"@num_client", GetValueFromHtmlSelect(CustomerSelect),
						"@nom_projet_client", GetValueFromHtmlInputText(NameTextField, true),
						"@resp_projet_client", GetValueFromHtmlSelect(ProjectLeaderSelect),
						"@integrateur_projet_client", GetValueFromHtmlSelect(IntegratorSelect));
						
					InformationTextField.Value = result;
					SaveProjectButton.Disabled = true;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding a project!&message=" + ex.Message);
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
    			<td class="header">ADD A PROJECT</td>
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
				<td width="80" class="text">Name : </td>
			    <td width="5"></td>
			    <td width="300"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:300px" maxlength="50" runat="server"></td>
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
				<td width="80" class="text">Customer : </td>
			    <td width="5"></td>
			    <td width="200"><select id="CustomerSelect" name="CustomerSelect" size="1" class="text" style="width:200px"
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
				<td width="80" class="text">Project leader : </td>
			    <td width="5"></td>
			    <td width="250"><select id="ProjectLeaderSelect" name="ProjectLeaderSelect" size="1" class="text" style="width:250px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="153"></td>
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
				<td width="80" class="text">Integrator : </td>
			    <td width="5"></td>
			    <td width="250"><select id="IntegratorSelect" name="IntegratorSelect" size="1" class="text" style="width:250px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="153"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="SaveProjectButton" name="SaveProjectButton" alt="Save project" value="Save" onServerClick="SaveProjectButton_Click"></td>
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
