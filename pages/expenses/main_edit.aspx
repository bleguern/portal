<%@ Page Language="C#" %>
<!-- #Include File="../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../not_allowed.aspx");
	}
%>
<html>
<head>
<title>EXPENSES - Main Head</title>
<link href="../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../scripts/calendar/CalendarPopup.js"></script>
<script type="text/javascript" src="../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		RegisterHiddenField("__EVENTTARGET", "SaveButton");
	    
		if(Session["sql_connection_string"] != null)
		{
			string headerScript = "";
			DataSet pageData = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "expenses_page_data",
				"@login", User.Identity.Name.ToUpper(),
				"@id_expense", GetValueFromRequest(Request["expense_id"]));
			
			headerScript = GetHeaderScriptWithDataSet(pageData);
			
			Session["currentExpensesPageData"] = pageData;
		
			WriteJavaScript(headerScript);
			
			if(!IsPostBack)
			{
				////STATUS
				string status = pageData.Tables[3].Rows[0][0].ToString();
				StatusHiddenField.Value = status;
				
				if(status.Equals("SAVABLE"))
				{
					LoadDefaultExpenses();
				}
				else if(status.Equals("SAVED"))
				{
					LoadExpenses();
				}
				else
				{
					Response.Redirect("main_show.aspx?expense_id=" + GetValueFromPageRequest(Request["expense_id"]));
				}
				
				UpdateAccountListDataGrid();
			}
			
			Init();
		}
	}
	
	void Init()
	{
		string status = StatusHiddenField.Value;
		
		if(status.Equals("SAVABLE"))
		{
			SaveButton.Disabled = false;
			SubmitButton.Disabled = true;
		}
		else if(status.Equals("SAVED"))
		{
			SaveButton.Disabled = false;
			SubmitButton.Disabled = false;
		}
		else
		{
			SaveButton.Disabled = true;
			SubmitButton.Disabled = true;
		}
		
		UpdateTotalFields();
	}
	
	void SaveButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			UpdateCurrentDataTable();
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());

			DataTable currentExpenses = (DataTable) Session["currentExpenses"];
			
			string status = GetValueFromHtmlInputHidden(StatusHiddenField);
			string idExpense = IdTextField.Value;
			string result = null;
			
			if(status.Equals("SAVED"))
			{
				try
				{
					sqlClient.ExecuteStoredProcedure("expenses_update_expense",
						"@id_expense", idExpense,
						"@coefficient", GetDoubleFromHtmlInputText(CoefficientTextField),
						"@advance_currency", GetValueFromHtmlInputText(AdvanceCurrencyTextField, true),
						"@advance_currency_amount", GetDoubleFromHtmlInputText(AdvanceCurrencyAmountTextField),
						"@advance_value", GetDoubleFromHtmlInputText(AdvanceTotalTextField),
						"@comment", GetValueFromHtmlTextArea(CommentTextArea, true));
				}
				catch(PortalException ex)
				{
					Response.Redirect("../error/Default.aspx?error=Internal error while updating expenses!&message=" + ex.Message);
					return;
				}
			}
			else
			{
				try
				{
					result = sqlClient.ExecuteStoredProcedure("expenses_add_expense",
						"@login", User.Identity.Name.ToUpper(),
						"@coefficient", GetDoubleFromHtmlInputText(CoefficientTextField),
						"@advance_currency", GetValueFromHtmlInputText(AdvanceCurrencyTextField, true),
						"@advance_currency_amount", GetDoubleFromHtmlInputText(AdvanceCurrencyAmountTextField),
						"@advance_value", GetDoubleFromHtmlInputText(AdvanceTotalTextField),
						"@comment", GetValueFromHtmlTextArea(CommentTextArea, true));
						
					idExpense = result;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../error/Default.aspx?error=Internal error while saving expenses!&message=" + ex.Message);
					return;
				}
			}
			
			bool success = false;
					
			foreach(DataRow row in currentExpenses.Rows)
			{
				if(!(row[1].ToString().Equals("")) && !(row[2].ToString().Equals("")))
				{
					try
					{
						string newId = sqlClient.ExecuteStoredProcedure("expenses_add_expense_line",
							"@id_expense", idExpense,
							"@expense_date", GetValueFromRequest(row[1]),
							"@id_account", GetValueFromRequest(row[2]),
							"@description", GetValueFromRequest(row[3]),
							"@km", GetDoubleFromRequest(row[4]),
							"@transport", GetDoubleFromRequest(row[5]),
							"@mission", GetDoubleFromRequest(row[6]),
							"@id_reception_type", GetValueFromRequest(row[7]),
							"@reception", GetDoubleFromRequest(row[8]),
							"@other", GetDoubleFromRequest(row[9]),
							"@currency", GetValueFromRequest(row[10]),
							"@currency_amount", GetDoubleFromRequest(row[11]));
				
						if(newId == null)
						{
							success = false;
							break;
						}
						else
						{
							success = true;
						}
					}
					catch(PortalException ex)
					{
						Response.Redirect("../error/Default.aspx?error=Internal error while adding expense line!&message=" + ex.Message);
						return;
					}
				}
			}
			
			if(success)
			{
				InformationTextField.Value = "Expenses saved!";
				StatusHiddenField.Value = "SAVED";
				
				Init();
			}
		}
	}
	
	void SubmitButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			UpdateCurrentDataTable();
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			DataTable currentExpenses = (DataTable) Session["currentExpenses"];
			
			string status = GetValueFromHtmlInputHidden(StatusHiddenField);
			string idExpense = IdTextField.Value;
			string result = null;
			
			if(status.Equals("SAVED"))
			{
				try
				{
					sqlClient.ExecuteStoredProcedure("expenses_update_expense",
						"@id_expense", idExpense,
						"@coefficient", GetDoubleFromHtmlInputText(CoefficientTextField),
						"@advance_currency", GetValueFromHtmlInputText(AdvanceCurrencyTextField, true),
						"@advance_currency_amount", GetDoubleFromHtmlInputText(AdvanceCurrencyAmountTextField),
						"@advance_value", GetDoubleFromHtmlInputText(AdvanceTotalTextField),
						"@comment", GetValueFromHtmlTextArea(CommentTextArea, true));
				}
				catch(PortalException ex)
				{
					Response.Redirect("../error/Default.aspx?error=Internal error while updating expenses!&message=" + ex.Message);
					return;
				}
			}
			else
			{
				try
				{
					result = sqlClient.ExecuteStoredProcedure("expenses_add_expense",
						"@login", User.Identity.Name.ToUpper(),
						"@coefficient", GetDoubleFromHtmlInputText(CoefficientTextField),
						"@advance_currency", GetValueFromHtmlInputText(AdvanceCurrencyTextField, true),
						"@advance_currency_amount", GetDoubleFromHtmlInputText(AdvanceCurrencyAmountTextField),
						"@advance_value", GetDoubleFromHtmlInputText(AdvanceTotalTextField),
						"@comment", GetValueFromHtmlTextArea(CommentTextArea, true));
						
					idExpense = result;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../error/Default.aspx?error=Internal error while saving expenses!&message=" + ex.Message);
					return;
				}
			}
			
			bool success = false;
					
			foreach(DataRow row in currentExpenses.Rows)
			{
				if(!(row[1].ToString().Equals("")) && !(row[2].ToString().Equals("")))
				{
					try
					{
						string newId = sqlClient.ExecuteStoredProcedure("expenses_add_expense_line",
							"@id_expense", idExpense,
							"@expense_date", GetValueFromRequest(row[1]),
							"@id_account", GetValueFromRequest(row[2]),
							"@description", GetValueFromRequest(row[3]),
							"@km", GetDoubleFromRequest(row[4]),
							"@transport", GetDoubleFromRequest(row[5]),
							"@mission", GetDoubleFromRequest(row[6]),
							"@id_reception_type", GetValueFromRequest(row[7]),
							"@reception", GetDoubleFromRequest(row[8]),
							"@other", GetDoubleFromRequest(row[9]),
							"@currency", GetValueFromRequest(row[10]),
							"@currency_amount", GetDoubleFromRequest(row[11]));
				
						if(newId == null)
						{
							success = false;
							break;
						}
						else
						{
							success = true;
						}
					}
					catch(PortalException ex)
					{
						Response.Redirect("../error/Default.aspx?error=Internal error while adding expense line!&message=" + ex.Message);
						return;
					}
				}
			}
			
			if(success)
			{
				try
				{
					result = sqlClient.ExecuteStoredProcedure("expenses_submit_expense",
						"@id_expense", idExpense);
					
					InformationTextField.Value = result;
					StatusHiddenField.Value = "SUBMITTED";
					
					Init();
				}
				catch(PortalException ex)
				{
					Response.Redirect("../error/Default.aspx?error=Internal error while submitting expenses!&message=" + ex.Message);
					return;
				}
			}
		}
	}
	
	int GetReceptionTypeIndex(string dataValue)
	{
		DataSet pageData = (DataSet) Session["currentExpensesPageData"];
		
		for(int i = 0; i < pageData.Tables[0].Rows.Count; i++)
		{
			DataRow row = pageData.Tables[0].Rows[i];
			
			if(row[0].ToString().Equals(dataValue))
			{
				return i+1;
			}
		}
		
		return 0;
	}

	int GetAccountIndex(string dataValue)
	{
		DataSet pageData = (DataSet) Session["currentExpensesPageData"];
		
		for(int i = 0; i < pageData.Tables[2].Rows.Count; i++)
		{
			DataRow row = pageData.Tables[2].Rows[i];
			
			if(row[0].ToString().Equals(dataValue))
			{
				return i+1;
			}
		}
		
		return 0;
	}
	
	void AddLineButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			try
			{
				UpdateCurrentDataTable();
				
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				string newId = sqlClient.ExecuteStoredProcedure("expenses_get_next_expense_id");
				
				DataTable currentExpenses = (DataTable) Session["currentExpenses"];
				
				DataRow row = currentExpenses.NewRow();
				
				row[0] = GetIntDbTypeFromString(newId);
				row[10] = "EUR";
				row[11] = 1.0000;
				currentExpenses.Rows.Add(row);
			
				Session["currentExpenses"] = currentExpenses;
				
				LineNumberHiddenField.Value = currentExpenses.Rows.Count.ToString();
			
				UpdateExpensesDataGrid();
			
				InformationTextField.Value = "Line added!";
			}
			catch(PortalException ex)
			{
				Response.Redirect("../error/Default.aspx?error=Internal error while adding a new line!&message=" + ex.Message);
			}
		}
	}
	
	void UpdateCurrentDataTable()
	{
		DataTable currentExpenses = (DataTable) Session["currentExpenses"];

		currentExpenses.Rows.Clear();

		for(int i = 0; i < ExpensesDataGrid.Items.Count; i++)
		{
			DataGridItem dataGridItem = ExpensesDataGrid.Items[i];

			HtmlInputText dateTextField = (HtmlInputText) dataGridItem.FindControl("DateTextField");
			DropDownList accountSelect = (DropDownList) dataGridItem.FindControl("AccountSelect");
			HtmlInputText descriptionTextField = (HtmlInputText) dataGridItem.FindControl("DescriptionTextField");
			HtmlInputText kmTextField = (HtmlInputText) dataGridItem.FindControl("kmTextField");
			HtmlInputText transportTextField = (HtmlInputText) dataGridItem.FindControl("TransportTextField");
			HtmlInputText missionTextField = (HtmlInputText) dataGridItem.FindControl("MissionTextField");
			DropDownList receptionTypeSelect = (DropDownList) dataGridItem.FindControl("ReceptionTypeSelect");
			HtmlInputText receptionTextField = (HtmlInputText) dataGridItem.FindControl("ReceptionTextField");
			HtmlInputText otherTextField = (HtmlInputText) dataGridItem.FindControl("OtherTextField");
			HtmlInputText currencyTextField = (HtmlInputText) dataGridItem.FindControl("CurrencyTextField");
			HtmlInputText currencyAmountTextField = (HtmlInputText) dataGridItem.FindControl("CurrencyAmountTextField");
	
			DataRow newRow = currentExpenses.NewRow();
			newRow[0] = ExpensesDataGrid.DataKeys[i];
			newRow[1] = GetDateFromHtmlInputText(dateTextField, "dd/MM/yy");
			newRow[2] = GetIntDbTypeFromString(accountSelect.SelectedValue);
			newRow[3] = GetValueFromHtmlInputText(descriptionTextField, false);
			newRow[4] = GetDoubleFromHtmlInputText(kmTextField);
			newRow[5] = GetDoubleFromHtmlInputText(transportTextField);
			newRow[6] = GetDoubleFromHtmlInputText(missionTextField);
			newRow[7] = GetIntDbTypeFromString(receptionTypeSelect.SelectedValue);
			newRow[8] = GetDoubleFromHtmlInputText(receptionTextField);
			newRow[9] = GetDoubleFromHtmlInputText(otherTextField);
			newRow[10] = GetValueFromHtmlInputText(currencyTextField, false);
			newRow[11] = GetDoubleFromHtmlInputText(currencyAmountTextField);

			currentExpenses.Rows.Add(newRow);
		}
		
		Session["currentExpenses"] = currentExpenses;
	}

	void UpdateExpensesDataGrid()
	{
		DataTable currentExpenses = (DataTable) Session["currentExpenses"];

		ExpensesDataGrid.DataSource = currentExpenses;
		ExpensesDataGrid.DataBind();
	}
	
	void UpdateAccountListDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			try
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataGridWithStoredProcedure(ref AccountListDataGrid, "expenses_get_account_list_with_user",
					"@login", User.Identity.Name.ToUpper());
			}
			catch(PortalException ex)
			{
				Response.Redirect("../error/Default.aspx?error=Internal error while getting account list!&message=" + ex.Message);
			}
		}
    }
	
	void LoadExpenses()
	{
		if(Session["currentExpensesPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentExpensesPageData"];
			
			IdTextField.Value = pageData.Tables[4].Rows[0][0].ToString();
			CoefficientTextField.Value = pageData.Tables[4].Rows[0][1].ToString();
			ExpensesDateTextField.Value = pageData.Tables[4].Rows[0][2].ToString();
			AdvanceCurrencyTextField.Value = pageData.Tables[4].Rows[0][3].ToString();
			AdvanceCurrencyAmountTextField.Value = pageData.Tables[4].Rows[0][4].ToString();
			AdvanceTotalTextField.Value = pageData.Tables[4].Rows[0][5].ToString();
			CommentTextArea.Value = pageData.Tables[4].Rows[0][6].ToString();
			
			LoadExpensesDataGrid();
		}
	}
	
	
	void LoadExpensesDataGrid()
	{
		if(Session["currentExpensesPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentExpensesPageData"];
			
			if(pageData.Tables[5].Rows.Count > 0)
			{
				Session["currentExpenses"] = pageData.Tables[5];
				LineNumberHiddenField.Value = pageData.Tables[5].Rows.Count.ToString();
			}
			else
			{
				LineNumberHiddenField.Value = "5";
				LoadDefaultExpensesDataGrid();
			}
			
			UpdateExpensesDataGrid();
		}
	}
	
	void LoadDefaultExpenses()
	{
		if(Session["currentExpensesPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentExpensesPageData"];
			
			////ID
			IdTextField.Value = "?";
			ExpensesDateTextField.Value = "?";
			
			///COEFFICIENT
			CoefficientTextField.Value = pageData.Tables[4].Rows[0][1].ToString();
			
			LoadDefaultExpensesDataGrid();
			
			UpdateExpensesDataGrid();
		}
	}

	void LoadDefaultExpensesDataGrid()
	{
		int lineNumber = 0;

		try
		{
			lineNumber = Convert.ToInt32(LineNumberHiddenField.Value);
		}
		catch(FormatException)
		{
			
		}
		catch(OverflowException)
		{
			
		}

		DataTable dataTable = new DataTable();
		DataColumn dataColumn = new DataColumn("ID");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("DATE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("ACCOUNT");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("DESCRIPTION");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("KM");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("TRANSPORT");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("MISSION");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("RECEPTION_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("RECEPTION");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("OTHER");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("CURRENCY");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("CURRENCY_AMOUNT");
		dataTable.Columns.Add(dataColumn);

		for(int i = 0; i < lineNumber; i++)
		{
			DataRow row = dataTable.NewRow();
			row[0] = i;
			row[10] = "EUR";
			row[11] = 1.0000;
			dataTable.Rows.Add(row);
		}
		
		Session["currentExpenses"] = dataTable;
	}
	
	void ExpensesDataGrid_ItemCreated(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
	{
		if((e.Item.ItemType != ListItemType.Header) && (e.Item.ItemType != ListItemType.Footer))
		{
			if(Session["currentExpensesPageData"] != null)
			{
				DataSet pageData = (DataSet) Session["currentExpensesPageData"];
				
				DropDownList accountSelect = (DropDownList) e.Item.FindControl("AccountSelect");
				DropDownList receptionTypeSelect = (DropDownList) e.Item.FindControl("ReceptionTypeSelect");
				
				UpdateDropDownListWithDataTable(ref accountSelect, pageData.Tables[2]);
				UpdateDropDownListWithDataTable(ref receptionTypeSelect, pageData.Tables[0]);
			}
		}
	}
	
	void UpdateTotalFields()
	{
		InformationTextField.Value = "";
		double total = 0;
		double coef = 0;
		
		try
		{
			coef = Convert.ToDouble(CoefficientTextField.Value);
		}
		catch(Exception)
		{
			return;
		}
		
		for(int i = 0; i < ExpensesDataGrid.Items.Count; i++)
		{
			DataGridItem dataGridItem = ExpensesDataGrid.Items[i];
			double lineTotal = 0;
			
			HtmlInputText kmTextField = (HtmlInputText) dataGridItem.FindControl("KmTextField");
			HtmlInputText kmValueTextField = (HtmlInputText) dataGridItem.FindControl("KmValueTextField");
			HtmlInputText transportTextField = (HtmlInputText) dataGridItem.FindControl("TransportTextField");
			HtmlInputText missionTextField = (HtmlInputText) dataGridItem.FindControl("MissionTextField");
			HtmlInputText receptionTextField = (HtmlInputText) dataGridItem.FindControl("ReceptionTextField");
			HtmlInputText otherTextField = (HtmlInputText) dataGridItem.FindControl("OtherTextField");
			
			HtmlInputText currencyAmountTextField = (HtmlInputText) dataGridItem.FindControl("CurrencyAmountTextField");
			
			HtmlInputText totalLineTextField = (HtmlInputText) dataGridItem.FindControl("TotalTextField");
			
			if(!kmTextField.Value.Equals(""))
			{
				try
				{
					double km = (Double.Parse(kmTextField.Value) * coef);
					
					kmValueTextField.Value = km.ToString();
					lineTotal += km;
				}
				catch(Exception)
				{
					kmTextField.Value = "#";
					InformationTextField.Value = "Km incorrect!";
				}
			}
			
			if(!transportTextField.Value.Equals(""))
			{
				try
				{
					double transport = Double.Parse(transportTextField.Value);
					
					lineTotal += transport;
				}
				catch(Exception)
				{
					transportTextField.Value = "#";
					InformationTextField.Value = "Transport incorrect!";
				}
			}
			
			if(!missionTextField.Value.Equals(""))
			{
				try
				{
					double mission = Double.Parse(missionTextField.Value);
					
					lineTotal += mission;
				}
				catch(Exception)
				{
					missionTextField.Value = "#";
					InformationTextField.Value = "Mission incorrect!";
				}
			}
			
			if(!receptionTextField.Value.Equals(""))
			{
				try
				{
					double reception = Double.Parse(receptionTextField.Value);
					
					lineTotal += reception;
				}
				catch(Exception)
				{
					receptionTextField.Value = "#";
					InformationTextField.Value = "Reception incorrect!";
				}
			}
			
			if(!otherTextField.Value.Equals(""))
			{
				try
				{
					double other = Double.Parse(otherTextField.Value);
					
					lineTotal += other;
				}
				catch(Exception)
				{
					otherTextField.Value = "#";
					InformationTextField.Value = "Other incorrect!";
				}
			}
			
			if(!currencyAmountTextField.Value.Equals(""))
			{
				try
				{
					double currencyAmount = Double.Parse(currencyAmountTextField.Value);
					
					lineTotal *= currencyAmount;
				}
				catch(Exception)
				{
					currencyAmountTextField.Value = "#";
					InformationTextField.Value = "Currency amount incorrect!";
				}
			}
		
			totalLineTextField.Value = lineTotal.ToString("F2");
			total += lineTotal;
		}
		
		if(!AdvanceTotalTextField.Value.Equals(""))
		{
			try
			{
				double advanceTotal = Double.Parse(AdvanceTotalTextField.Value);
				
				if(!AdvanceCurrencyAmountTextField.Value.Equals(""))
				{
					try
					{
						double advanceCurrencyAmount = Double.Parse(AdvanceCurrencyAmountTextField.Value);
						
						advanceTotal *= advanceCurrencyAmount;
					}
					catch(Exception)
					{
						AdvanceCurrencyAmountTextField.Value = "#";
						InformationTextField.Value = "Advance currency amount incorrect!";
					}
				}
				
				total -= advanceTotal;
			}
			catch(Exception)
			{
				AdvanceTotalTextField.Value = "#";
				InformationTextField.Value = "Advance total incorrect!";
			}
		}
		
		TotalTextField.Value = total.ToString("F2");
	}
</script>
<body>
<form id="MainForm" method="post" runat="server" onClick="onExpensesFormClick(LineNumberHiddenField.value, CoefficientTextField.value, InformationTextField)">
<table width="900" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="header">EXPENSES</td>
	</tr>
	<tr>
		<td height="10"></td>
	</tr>
	<tr>
		<td>
			<table width="900" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="25" class="text_bold">ID : </td>
					<td width="100"><input name="IdTextField" type="text" class="text_bold" id="IdTextField" style="width:100px;border-width:0px" runat="server" value="?" readonly="true"></td>
					<td width="100" class="text_bold" align="right">saved date : </td>
					<td width="5"></td>
					<td width="100"><input name="ExpensesDateTextField" type="text" class="text_bold" id="ExpensesDateTextField" style="width:100px;border-width:0px" runat="server" value="?" readonly="true"></td>
					<td width="315" class="text_bold" align="right">applied coefficient :</td>
					<td width="5"></td>
					<td width="100"><input name="CoefficientTextField" type="text" class="text_bold" id="CoefficientTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
					<td width="50"></td>
					<td width="100"><input name="CurrencyButton" class="text" type="button" id="CurrencyButton" value="Currency info" onClick="javascript:window.open('../help/currency.aspx')" alt="Show currency code information" style="width:100px" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10"></td>
	</tr>
<tr>
  	<td>
	<ASP:DataGrid id="ExpensesDataGrid" runat="server"
      Width="900"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding="1"
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
      DataKeyField="ID"
      AutoGenerateColumns="false"
	  OnItemCreated="ExpensesDataGrid_ItemCreated"
    >
	
      <Columns>
	  	 <asp:BoundColumn HeaderText="ID" SortExpression="ID" Visible="false" DataField="ID"/>
		 <asp:TemplateColumn HeaderStyle-Width="20" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<img id="DateImageLink" name="DateImageLink" src="../../images/cal_2.gif" alt="Pick a date" width="18" height="20" onClick="showExpensesCalendar(this)" runat="server">
          </ItemTemplate>
         </asp:TemplateColumn>
		 <asp:TemplateColumn HeaderText="DATE" HeaderStyle-Width="60" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="middle">
          <ItemTemplate>
		  	<input name="DateTextField" type="text" class="text" id="DateTextField" style="width:58px" maxlength="10" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "DATE") %>'>
          </ItemTemplate>
         </asp:TemplateColumn>
		 <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="134" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<asp:DropDownList runat="server" Width="132" id="AccountSelect" SelectedIndex='<%# GetAccountIndex(DataBinder.Eval(Container.DataItem, "ACCOUNT").ToString()) %>'></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Description" HeaderStyle-Width="120" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="DescriptionTextField" name="DescriptionTextField" type="text" class="text"  style="width:118px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "DESCRIPTION") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Km" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="KmTextField" name="KmTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "KM") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="KmValueTextField" name="KmValueTextField" type="text" class="text"  style="width:48px" runat="server" readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Transp." HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TransportTextField" name="TransportTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "TRANSPORT") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Mission" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="MissionTextField" name="MissionTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "MISSION") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Recept." HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<asp:DropDownList runat="server" Width="48" id="ReceptionTypeSelect" SelectedIndex='<%# GetReceptionTypeIndex(DataBinder.Eval(Container.DataItem, "RECEPTION_TYPE").ToString()) %>'></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="ReceptionTextField" name="ReceptionTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "RECEPTION") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Other" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="OtherTextField" name="OtherTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "OTHER") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Dev" HeaderStyle-Width="30" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="CurrencyTextField" name="CurrencyTextField" type="text" class="text"  style="width:28px" maxlength="3" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "CURRENCY") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Curr." HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="CurrencyAmountTextField" name="CurrencyAmountTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "CURRENCY_AMOUNT") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Total" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TotalTextField" name="TotalTextField" type="text" class="text"  style="width:48px" runat="server" readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="" HeaderStyle-Width="30" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input name="ClearButton" type="button" class="text" id="ClearButton" style="width:30px" onClick="onExpensesClearButtonClick(this)" value="Del" runat="server">
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
		<td>
			<table width="900" border="0" cellspacing="0" cellpadding="0">
				<tr>
	 				<td width="100"><input name="AddLineButton" class="text" type="submit" id="AddLineButton" value="Add a line" runat="server" onServerClick="AddLineButton_Click" alt="Add a line to expenses" style="width:100px" /></td>
					<td width="100"><input type="hidden" name="LineNumberHiddenField" id="LineNumberHiddenField" value="5" runat="server"><input type="hidden" name="StatusHiddenField" id="StatusHiddenField" runat="server"></td>
	  				<td width="700"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="5"></td>
	</tr>
	<tr>
  	<td class="header">COMMENT</td>
   </tr>
   <tr>
		<td height="5"></td>
	</tr>
	<tr>
		<td><textarea name="CommentTextArea" cols="0" rows="0" class="text" id="CommentTextArea" style="width:900px;height:50px" runat="server"></textarea></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td>
			<table width="900" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="header" width="695">RECEIVED CASH ADVANCES</td>
					<td class="header" width="100" align="center">Currency</td>
					<td class="header" width="5"></td>
					<td class="header" width="100" align="center">Total</td>
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
					<td width="695"></td>
					<td width="100"><input name="AdvanceCurrencyTextField" type="text" class="text" id="AdvanceCurrencyTextField"  style="width:30px" value="EUR" maxlength="3" runat="server">
		  	<input name="AdvanceCurrencyAmountTextField" type="text" class="text" id="AdvanceCurrencyAmountTextField"  style="width:65px" value="1" runat="server"></td>
					<td width="5"></td>
					<td width="100"><input name="AdvanceTotalTextField" type="text" class="text_bold" id="AdvanceTotalTextField" style="width:100px;text-align:right" runat="server"></td>
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
					<td class="header" width="800">TOTAL</td>
					<td class="header" width="100" align="center">TOTAL</td>
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
					<td width="800"></td>
					<td width="100"><input name="TotalTextField" type="text" class="text_bold" id="TotalTextField" style="width:100px;text-align:right" runat="server" readonly="true"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
		<td>
			<table width="900" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="695"></td>
					<td width="100"><input name="SaveButton" class="text" type="submit" id="SaveButton" value="Save" runat="server" onServerClick="SaveButton_Click" alt="Save current expenses report" style="width:100px" /></td>
					<td width="5"></td>
					<td width="100"><input name="SubmitButton" class="text" type="submit" id="SubmitButton" value="Submit" runat="server" onClick="return validateExpenses();" onServerClick="SubmitButton_Click" alt="Submit current expenses report" style="width:100px" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:900px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td class="header">ACCOUNT LIST INFORMATION</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="AccountListDataGrid" runat="server"
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
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="150">
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
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
</table>
</form>
</body>
</html>
