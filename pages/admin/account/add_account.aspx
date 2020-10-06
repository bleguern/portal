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
<title>ADMINISTRATION - Add an account</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			string headerScript = "";
			DataSet pageData = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "admin_account_page_data");
			
			headerScript = GetHeaderScriptWithDataSet(pageData);
		
			WriteJavaScript(headerScript);
		
			if(!IsPostBack)
			{
				UpdateHmltSelectWithDataTable(ref SectorSelect, pageData.Tables[0]);
				UpdateHmltSelectWithDataTable(ref UseSelect, pageData.Tables[1]);
				UpdateHmltSelectWithDataTable(ref CustomerSelect, pageData.Tables[2]);
				ClearHmltSelect(ref ContractSelect);
				
				SetHmltSelectSelectedIndexByString(ref MonthIdSelect, DateTime.Now.Month.ToString());
				SetHmltSelectSelectedIndexByString(ref YearIdSelect, DateTime.Now.Year.ToString());
			}
			
			UpdateContractSelect(pageData.Tables[3]);
		}
	}
	
	void SaveAccountButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		
		if((NameTextField.Value == "")
		|| (SectorSelect.Value == "")
		|| (UseSelect.Value == "")
		|| (CustomerSelect.Value == "")
		|| (NumberIdTextField.Value == "")
		|| (ActiveSelect.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					string id = TrigIdTextField.Value
						+ YearIdSelect.Items[YearIdSelect.SelectedIndex].Text
						+ MonthIdSelect.Items[MonthIdSelect.SelectedIndex].Text
						+ UseIdTextField.Value
						+ NumberIdTextField.Value;
						
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
					string result = sqlClient.ExecuteStoredProcedure("admin_add_account",
						"@active", GetValueFromHtmlSelect(ActiveSelect),
						"@id", id,
						"@id_account_use", GetValueFromHtmlSelect(UseSelect),
						"@id_sector", GetValueFromHtmlSelect(SectorSelect),
						"@name", GetValueFromHtmlInputText(NameTextField, true),
						"@id_support", GetValueFromHtmlInputHidden(ContractHiddenField),
						"@is_rd", GetValueFromHtmlInputCheckBox(RdCheckBox),
						"@is_cir", GetValueFromHtmlInputCheckBox(CirCheckBox),
						"@is_billable", GetValueFromHtmlInputCheckBox(BillableCheckBox),
						"@is_use", GetValueFromHtmlInputCheckBox(UseCheckBox),
						"@is_allowance", GetValueFromHtmlInputCheckBox(AllowanceCheckBox),
						"@num_client", GetValueFromHtmlSelect(CustomerSelect),
						"@comment", GetValueFromHtmlTextArea(CommentTextArea, true),
						"@extra", GetValueFromHtmlInputText(ExtraTextField, true),
						"@no_accountable", GetValueFromHtmlInputCheckBox(NoAccountableCheckBox));
						
					InformationTextField.Value = result;
					
					SaveAccountButton.Disabled = true;
				}
				catch(PortalSqlErrorException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding an account!&message=" + ex.Message);
				}
				catch(PortalSqlConstraintsException ex)
				{
					InformationTextField.Value = "WARNING : ID already exist!";
				}
			}
		}
	}
	
	void UpdateContractSelect(DataTable contractTable)
	{
		ClearHmltSelect(ref ContractSelect);
		
		if(contractTable != null)
		{
			string value = CustomerSelect.Value;
			
			if(value != "")
			{
				for(int i = 0; i < contractTable.Rows.Count; i++)
				{
					if(value.Equals(contractTable.Rows[i][2].ToString()))
					{
						ListItem tmp = new ListItem(contractTable.Rows[i][1].ToString(), contractTable.Rows[i][0].ToString());
						ContractSelect.Items.Add(tmp);
					}
				}
				
				if(ContractHiddenField.Value != "")
				{
					SetHmltSelectSelectedIndexByString(ref ContractSelect, ContractHiddenField.Value);
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
    			<td class="header">ADD AN ACCOUNT </td>
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
				<td width="80" class="text_bold">ID : </td>
			    <td width="5"></td>
			    <td width="190">
				<input name="TrigIdTextField" type="text" class="text_bold" id="TrigIdTextField" style="width:30px" maxlength="3" runat="server" readonly="true">
				<select id="YearIdSelect" name="YearIdSelect" size="1" class="text_bold" style="width:40px"
										runat="server">
				  <option value="1998">98</option>
				  <option value="1999">99</option>
				  <option value="2000">00</option>
				  <option value="2001">01</option>
				  <option value="2002">02</option>
				  <option value="2003">03</option>
				  <option value="2004">04</option>
				  <option value="2005">05</option>
				  <option value="2006">06</option>
				  <option value="2007">07</option>
				  <option value="2008">08</option>
				  <option value="2009">09</option>
			    </select>
				<select id="MonthIdSelect" name="MonthIdSelect" size="1" class="text_bold" style="width:40px"
										runat="server">
				  <option value="1">01</option>
				  <option value="2">02</option>
				  <option value="3">03</option>
				  <option value="4">04</option>
				  <option value="5">05</option>
				  <option value="6">06</option>
				  <option value="7">07</option>
				  <option value="8">08</option>
				  <option value="9">09</option>
				  <option value="10">10</option>
				  <option value="11">11</option>
				  <option value="12">12</option>
			    </select>
				<input name="UseIdTextField" type="text" class="text_bold" id="UseIdTextField" style="width:30px" maxlength="3" runat="server" readonly="true">
				<input name="NumberIdTextField" type="text" class="text_bold" id="NumberIdTextField" style="width:30px" maxlength="3" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="213"></td>
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
				<td width="80" class="text">Chargeable : </td>
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
				<td width="80" class="text">Use : </td>
			    <td width="5"></td>
			    <td width="150"><select id="UseSelect" name="UseSelect" size="1" class="text" style="width:150px" onChange="onAccountUseSelectChange(this.value, UseIdTextField)" runat="server"></select></td>
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
				<td width="80" class="text">Customer : </td>
			    <td width="5"></td>
			    <td width="200"><select id="CustomerSelect" name="CustomerSelect" size="1" class="text" style="width:200px" onChange="onAccountCustomerSelectChange(this.value, TrigIdTextField, ContractSelect)"
										runat="server">
			    </select></td>
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
				<td width="80" class="text">Contract : </td>
			    <td width="5"></td>
			    <td width="200"><select id="ContractSelect" name="ContractSelect" size="1" class="text" style="width:200px" onChange="onAccountContractSelectChange(this.value, ContractHiddenField)"
										runat="server">
			    </select></td>
				<td width="215"><input name="ContractHiddenField" type="hidden" id="ContractHiddenField" runat="server"></td>
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
				<td width="80" class="text">R&amp;D : </td>
			    <td width="5"></td>
			    <td width="20"><input type="checkbox" id="RdCheckBox" name="RdCheckBox" value="" runat="server"></td>
				<td width="5"></td>
				<td width="65" align="center" class="text">CIR : </td>
			    <td width="5"></td>
			    <td width="20"><input type="checkbox" id="CirCheckBox" name="CirCheckBox" value="" runat="server"></td>
				<td width="5"></td>
				<td width="65" align="center" class="text">Billable :</td>
			    <td width="5"></td>
			    <td width="20"><input type="checkbox" id="BillableCheckBox" name="BillableCheckBox" value="" runat="server"></td>
				<td width="5"></td>
				<td width="65" align="center" class="text">Use :</td>
			    <td width="5"></td>
			    <td width="20"><input type="checkbox" id="UseCheckBox" name="UseCheckBox" value="" runat="server"></td>
				<td width="110"></td>
				
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
				<td width="80" class="text">Allowance :</td>
			    <td width="5"></td>
			    <td width="20"><input type="checkbox" id="AllowanceCheckBox" name="AllowanceCheckBox" value="" runat="server"></td>
				<td width="5"></td>
				<td width="100" align="center" class="text">No accountable :</td>
			    <td width="5"></td>
			    <td width="20"><input type="checkbox" id="NoAccountableCheckBox" name="NoAccountableCheckBox" value="" runat="server"></td>
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
				<td width="80" class="text">Extra : </td>
			    <td width="5"></td>
			    <td width="300"><input name="ExtraTextField" type="text" class="text" id="ExtraTextField" style="width:300px" maxlength="100" runat="server"></td>
				<td width="115"></td>
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
				<td width="80" class="text">Comment : </td>
			    <td width="5"></td>
			    <td width="415"><textarea name="CommentTextArea" cols="0" rows="0" class="text" id="CommentTextArea"
										style="width:415px;height:50px" runat="server"></textarea></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr align="center">
	  <td><input type="submit" class="text" runat="server" style="width:100px" id="SaveAccountButton" name="SaveAccountButton" alt="Save account" value="Save" onServerClick="SaveAccountButton_Click"></td>
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
