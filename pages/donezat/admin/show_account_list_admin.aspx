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
<title>TIME REPORT ADMINISTRATION FOR USER : <%= Request["name"].ToString() %> - Manage account list</title>
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
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_account_page_data");
			
			headerScript = GetHeaderScriptWithDataSet(pageData);
		
			WriteJavaScript(headerScript);
		
			if(!IsPostBack)
			{
				UpdateHmltSelectWithDataTable(ref SectorSelect, pageData.Tables[0]);
				UpdateHmltSelectWithDataTable(ref UseSelect, pageData.Tables[1]);
				UpdateHmltSelectWithDataTable(ref CustomerSelect, pageData.Tables[2]);
				
				UpdateAccountListDataGrid();
			}
		}
	}
	
	void SearchAccountButton_Click(Object sender, EventArgs e) {
		UpdateWishedAccountListDataGrid();
	}
	
	string GetId()
	{
		string id = "";
			
		if(TrigIdTextField.Value == "")
		{
			id += "%";
		}
		else
		{
			id += TrigIdTextField.Value;
		}
		
		if(YearIdSelect.Items[YearIdSelect.SelectedIndex].Text == "")
		{
			id += "%";
		}
		else
		{
			id += YearIdSelect.Items[YearIdSelect.SelectedIndex].Text;
		}
		
		if(MonthIdSelect.Items[MonthIdSelect.SelectedIndex].Text == "")
		{
			id += "%";
		}
		else
		{
			id += MonthIdSelect.Items[MonthIdSelect.SelectedIndex].Text;
		}
		
		if(UseIdTextField.Value == "")
		{
			id += "%";
		}
		else
		{
			id += UseIdTextField.Value;
		}
		
		if(NumberIdTextField.Value == "")
		{
			id += "%";
		}
		else
		{
			id += NumberIdTextField.Value;
		}
		
		return id;
	}
	
	void UpdateAccountListDataGrid()
    {
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref AccountListDataGrid, "donezat_get_account_list_with_user_id",
				"@user_id", Request["user_id"].ToString());
		}
    }
	
	void AccountListDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
		ListInformationTextField.Value = null;
		
        if(Session["sql_connection_string"] != null)
		{
			try
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
				string result = sqlClient.ExecuteStoredProcedure("donezat_delete_account_from_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@id_account", AccountListDataGrid.DataKeys[(int)e.Item.ItemIndex]);
					
				UpdateAccountListDataGrid();
				ListInformationTextField.Value = result;
			}
			catch(PortalException ex)
			{
				Response.Redirect("../../error/Default.aspx?error=Internal error while removing an account from list!&message=" + ex.Message);
			}
		}
    }
	
	
	void UpdateWishedAccountListDataGrid()
    {
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			int number = sqlClient.UpdateDataGridWithStoredProcedure(ref WishedAccountListDataGrid, "donezat_select_not_account_list_with_user_id",
				"@user_id", Request["user_id"].ToString(),
				"@id", GetId(),
				"@id_account_use", GetValueFromHtmlSelect(UseSelect),
				"@id_sector", GetValueFromHtmlSelect(SectorSelect),
				"@num_client", GetValueFromHtmlSelect(CustomerSelect));
				
			if(number == 0)
			{
				ResultTextField.Value = "ADD AN ACCOUNT TO LIST : No matches found";
			}
			else
			{
				ResultTextField.Value = "ADD AN ACCOUNT TO LIST : " + number.ToString() + " matche(s) found";
			}
		}
	}
	
	void WishedAccountListDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
		AccountInformationTextField.Value = null;
		
		if(Session["sql_connection_string"] != null)
		{
			try
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
				string result = sqlClient.ExecuteStoredProcedure("donezat_add_account_to_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@id_account", WishedAccountListDataGrid.DataKeys[(int)e.Item.ItemIndex]);
					
				UpdateAccountListDataGrid();
				UpdateWishedAccountListDataGrid();
				AccountInformationTextField.Value = result;
			}
			catch(PortalException ex)
			{
				Response.Redirect("../../error/Default.aspx?error=Internal error while adding an account to list!&message=" + ex.Message);
			}
		}
    }
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">MANAGE ACCOUNT LIST FOR USER : <%= Request["name"].ToString() %></td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="AccountListDataGrid" runat="server"
      Width="850"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding=3
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
	  OnDeleteCommand="AccountListDataGrid_Delete"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >
      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="100">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "LABEL") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="300">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="CUSTOMER" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "CUSTOMER") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="USE" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "[USE]") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="CHARGEABLE" HeaderStyle-Width="100">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SECTOR") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:ButtonColumn ButtonType="PushButton" Text="Remove" CommandName="Delete"/>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="ListInformationTextField" type="text" class="red" id="ListInformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
   <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">SEARCH AN ACCOUNT TO ADD </td>
  			</tr>
		</table>
	</td>
   </tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">ID : </td>
			    <td width="5"></td>
			    <td width="190">
				<input name="TrigIdTextField" type="text" class="text" id="TrigIdTextField" style="width:30px" maxlength="3" runat="server">
				<select id="YearIdSelect" name="YearIdSelect" size="1" class="text" style="width:40px"
										runat="server">
				  <option value="" selected></option>
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
				<select id="MonthIdSelect" name="MonthIdSelect" size="1" class="text" style="width:40px"
										runat="server">
				  <option value="" selected></option>
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
				<input name="UseIdTextField" type="text" class="text" id="UseIdTextField" style="width:30px" maxlength="3" runat="server">
				<input name="NumberIdTextField" type="text" class="text" id="NumberIdTextField" style="width:30px" maxlength="3" runat="server"></td>
				<td width="575"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">Chargeable : </td>
			    <td width="5"></td>
			    <td width="150"><select id="SectorSelect" name="SectorSelect" size="1" class="text" style="width:150px"
										runat="server"></select></td>
				<td width="615"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">Use : </td>
			    <td width="5"></td>
			    <td width="150"><select id="UseSelect" name="UseSelect" size="1" class="text" style="width:150px" onChange="onAccountUseSelectChange(this.value, UseIdTextField)" runat="server"></select></td>
				<td width="615"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="5"></td>
	</tr>
    <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text">Customer : </td>
			    <td width="5"></td>
			    <td width="200"><select id="CustomerSelect" name="CustomerSelect" size="1" class="text" style="width:200px" onChange="onAccountCustomerSelectChange(this.value, TrigIdTextField, null)"
										runat="server">
			    </select></td>
				<td width="565"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr align="center">
	  <td><input type="submit" class="text" runat="server" style="width:100px" id="SearchAccountButton" name="SearchAccountButton" alt="Search an account" value="Search" onServerClick="SearchAccountButton_Click"></td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
   <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td><input name="ResultTextField" type="text" class="header" id="ResultTextField" style="width:850px;height:14px;border-width:0px" value="ADD AN ACCOUNT TO LIST : No matches found" runat="server" readonly="true"></td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="WishedAccountListDataGrid" runat="server"
      Width="850"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding=3
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
	  OnDeleteCommand="WishedAccountListDataGrid_Delete"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >
      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" SortExpression="ID" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="100">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "LABEL") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="300">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="CUSTOMER" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "CUSTOMER") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="USE" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "[USE]") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="CHARGEABLE" HeaderStyle-Width="100">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SECTOR") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:ButtonColumn ButtonType="PushButton" Text="Add" CommandName="Delete"/>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
		<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="AccountInformationTextField" type="text" class="red" id="AccountInformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
</table>
</form>
</body>
</html>