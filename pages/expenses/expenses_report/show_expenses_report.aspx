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
<title>EXPENSES - Expenses report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		string year = Request["year"];
		string beginMonth = Request["begin_month"];
		string endMonth = Request["end_month"];
		
		if(year.Equals("") || beginMonth.Equals("") || endMonth.Equals(""))
		{
			Response.Redirect("select_expenses_report.aspx");
		}
		else
		{
			Load();
		}
	}
	
	void Load()
	{
		if(Session["sql_connection_string"] != null)
		{
			DataSet pageData = null;
			string year = Request["year"];
			string beginMonth = Request["begin_month"];
			string endMonth = Request["end_month"];
		
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "expenses_get_expense_report_page_data",
				"@login", User.Identity.Name.ToUpper(),
				"@year", year,
				"@begin_month", beginMonth,
				"@end_month", endMonth);
			
			if(pageData != null)
			{
				BeginDateTextField.Value = pageData.Tables[0].Rows[0][0].ToString();
				EndDateTextField.Value = pageData.Tables[1].Rows[0][0].ToString();
	
				ExpensesDataGrid.DataSource = pageData.Tables[3];
				ExpensesDataGrid.DataBind();
				
				string status = pageData.Tables[2].Rows[0][0].ToString();
				
				if(status.Equals("PAYABLE"))
				{
					((DataGridColumn) ExpensesDataGrid.Columns[5]).Visible = false;
					((DataGridColumn) ExpensesDataGrid.Columns[6]).Visible = true;
				}
				else if(status.Equals("VALIDABLE"))
				{
					((DataGridColumn) ExpensesDataGrid.Columns[5]).Visible = true;
					((DataGridColumn) ExpensesDataGrid.Columns[6]).Visible = false;
				}
				else
				{
					((DataGridColumn) ExpensesDataGrid.Columns[5]).Visible = false;
					((DataGridColumn) ExpensesDataGrid.Columns[6]).Visible = false;
				}
				
				foreach(DataGridItem dataGridItem in ExpensesDataGrid.Items)
				{
					HtmlInputButton htmlInputButton;
					HtmlInputButton cancelInputButton = (HtmlInputButton) dataGridItem.FindControl("CancelButton");
					string currentStatus = ((Label) dataGridItem.FindControl("Status")).Text;
					
					if(status.Equals("PAYABLE"))
					{
						htmlInputButton = (HtmlInputButton) dataGridItem.FindControl("PayButton");
						
						if(currentStatus.Equals("VALIDATED"))
						{
							htmlInputButton.Disabled = false;
						}
						else
						{
							htmlInputButton.Disabled = true;
						}
						
						if(currentStatus.Equals("PAID"))
						{
							cancelInputButton.Disabled = true;
						}
						else
						{
							cancelInputButton.Disabled = false;
						}
					}
					else if(status.Equals("VALIDABLE"))
					{
						htmlInputButton = (HtmlInputButton) dataGridItem.FindControl("ValidateButton");
						
						if(currentStatus.Equals("SUBMITTED"))
						{
							htmlInputButton.Disabled = false;
						}
						else
						{
							htmlInputButton.Disabled = true;
						}
						
						if(currentStatus.Equals("VALIDATED") || currentStatus.Equals("PAID"))
						{
							cancelInputButton.Disabled = true;
						}
						else
						{
							cancelInputButton.Disabled = false;
						}
					}
				}
			}
		}
	}
	
	
	void ValidateButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			int index = getIndex(((HtmlInputButton) sender).Name);
			
			try
			{
				sqlClient.ExecuteStoredProcedure("expenses_validate_expense",
					"@id_expense", ExpensesDataGrid.DataKeys[index]);
				
				Load();
			}
			catch(PortalException ex)
			{
				Response.Redirect("../error/Default.aspx?error=Internal error while validating expenses!&message=" + ex.Message);
				return;
			}
			
		}
	}
	
	void CancelButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			int index = getIndex(((HtmlInputButton) sender).Name);
			
			try
			{
				sqlClient.ExecuteStoredProcedure("expenses_cancel_expense",
					"@id_expense", ExpensesDataGrid.DataKeys[index]);
				
				Load();
			}
			catch(PortalException ex)
			{
				Response.Redirect("../error/Default.aspx?error=Internal error while cancelling expenses!&message=" + ex.Message);
				return;
			}
			
		}
	}
	
	void PayButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			int index = getIndex(((HtmlInputButton) sender).Name);
			
			try
			{
				sqlClient.ExecuteStoredProcedure("expenses_pay_expense",
					"@id_expense", ExpensesDataGrid.DataKeys[index]);
				
				Load();
			}
			catch(PortalException ex)
			{
				Response.Redirect("../error/Default.aspx?error=Internal error while paying expenses!&message=" + ex.Message);
				return;
			}
			
		}
	}
	
	int getIndex(string name)
	{
		name = name.Substring(21);
		name = name.Split(":".ToCharArray())[0];
		
		return Int32.Parse(name)-2;
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="900" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td class="header">EXPENSES LIST</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="900" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text" align="left">Begin date  : </td>
			    <td width=""><input name="BeginDateTextField" type="text" class="text_bold" id="BeginDateTextField" style="width:150px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="900" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text" align="left">End date  : </td>
			    <td width=""><input name="EndDateTextField" type="text" class="text_bold" id="EndDateTextField" style="width:150px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
	 <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="ExpensesDataGrid" runat="server"
	  Width="900"
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
	  DataKeyField="ID_EXPENSE"
	  AutoGenerateColumns="false"
	>

	  <Columns>
		<asp:HyperLinkColumn Target="_blank" HeaderStyle-Width="100" DataNavigateUrlField="ID_EXPENSE" DataNavigateUrlFormatString="show.aspx?expense_id={0}" DataTextField="ID_EXPENSE" HeaderText="ID"><ItemStyle Font-Bold="True"></ItemStyle></asp:HyperLinkColumn>
		<asp:TemplateColumn HeaderText="DATE" HeaderStyle-Width="100">
		  <ItemTemplate>
			<asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DATE") %>'/>
		  </ItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="USER" HeaderStyle-Width="200">
		  <ItemTemplate>
			<asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "USER") %>'/>
		  </ItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="SECTOR" HeaderStyle-Width="150">
		  <ItemTemplate>
			<asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SECTOR") %>'/>
		  </ItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="STATUS" HeaderStyle-Width="150" ItemStyle-Font-Bold="true">
		  <ItemTemplate>
			<asp:Label ID="Status" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "STATUS") %>'/>
		  </ItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input name="ValidateButton" type="button" class="text" id="ValidateButton" style="width:100px" value="Validate" runat="server" onServerClick="ValidateButton_Click">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input name="PayButton" type="button" class="text" id="PayButton" style="width:100px" value="Pay" runat="server" onServerClick="PayButton_Click">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input name="CancelButton" type="button" class="text" id="CancelButton" style="width:100px" value="Cancel" runat="server" onServerClick="CancelButton_Click">
          </ItemTemplate>
        </asp:TemplateColumn>
	  </Columns>
	</ASP:DataGrid>
	</td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:900px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
</table>
</form>
</body>
</html>