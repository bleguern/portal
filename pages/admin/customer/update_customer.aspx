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
<title>ADMINISTRATION - Update a customer</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		string customerId = Request["customer_id"];
					
		if(!customerId.Equals(""))
		{
			if(!IsPostBack)
			{
				if(Session["sql_connection_string"] != null)
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
					sqlClient.UpdateHtmlSelectWithStoredProcedure(ref TypeSelect, "admin_get_customer_type_list_to_html_select");
					sqlClient.UpdateHtmlSelectWithStoredProcedure(ref PartnerSelect, "admin_get_customer_list_to_html_select");
				
					string [] values = sqlClient.GetValuesWithStoredProcedure("admin_get_customer",
						"@num_client", customerId);
				
					SetHmltSelectSelectedIndexByString(ref ActiveSelect, values[0]);
					NameTextField.Value = values[1];
					SetHmltSelectSelectedIndexByString(ref TypeSelect, values[2]);
					TrigTextField.Value = values[3];
					SetHmltSelectSelectedIndexByString(ref LangageSelect, values[4]);
					SetHmltSelectSelectedIndexByString(ref PartnerSelect, values[5]);
				}
			}
			
			UpdatePartnerSelect();
		}
	}
	
	void SaveCustomerButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((NameTextField.Value == "")
		|| (TypeSelect.Value == "")
		|| (TrigTextField.Value == "")
		|| (LangageSelect.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			string customerId = Request["customer_id"];
					
			if(!customerId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
						string result = sqlClient.ExecuteStoredProcedure("admin_update_customer",
							"@num_client", customerId,
							"@active", GetValueFromHtmlSelect(ActiveSelect),
							"@id_type_client", GetValueFromHtmlSelect(TypeSelect),
							"@nom_client", GetValueFromHtmlInputText(NameTextField, true),
							"@trig_client", GetValueFromHtmlInputText(TrigTextField, true),
							"@langage_client", GetValueFromHtmlSelect(LangageSelect),
							"@partenaire_client", GetValueFromHtmlSelect(PartnerSelect));
							
						InformationTextField.Value = result;
					}
					catch(PortalException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while updating a customer!&message=" + ex.Message);
					}
				}
			}
		}
	}
	
	void UpdatePartnerSelect()
	{
		if(TypeSelect.Value == "0")
		{
			PartnerSelect.Disabled = false;
		}
		else
		{
			PartnerSelect.SelectedIndex = 0;
			PartnerSelect.Disabled = true;
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
    			<td class="header">UPDATE A CUSTOMER</td>
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
				<td width="80" class="text">Type : </td>
			    <td width="5"></td>
			    <td width="200"><select id="TypeSelect" name="TypeSelect" size="1" class="text" style="width:200px" onChange="onCustomerTypeSelectChange(this.value, PartnerSelect)"
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
				<td width="80" class="text">Trigram : </td>
			    <td width="5"></td>
			    <td width="100"><input name="TrigTextField" type="text" class="text" id="TrigTextField" style="width:100px" maxlength="3" runat="server"></td>
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
				<td width="80" class="text">Language : </td>
			    <td width="5"></td>
			    <td width="50"><select id="LangageSelect" name="LangageSelect" size="1" class="text" style="width:50px"
										runat="server">
				  <option value=""></option>
			      <option selected value="FR">FR</option>
			      <option value="EN">EN</option>
			    </select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="353"></td>
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
				<td width="80" class="text">Partner : </td>
			    <td width="5"></td>
			    <td width="250"><select name="PartnerSelect" size="1" disabled="true" class="text" id="PartnerSelect" style="width:250px"
										runat="server"></select></td>
				<td width="165"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="SaveCustomerButton" name="SaveCustomerButton" alt="Save customer" value="Save" onServerClick="SaveCustomerButton_Click"></td>
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
