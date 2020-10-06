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
<title>EXPENSES - Main Show</title>
<link href="../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			string headerScript = "";
			DataSet pageData = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "expenses_saved_page_data",
				"@login", User.Identity.Name.ToUpper(),
				"@id_expense", GetValueFromRequest(Request["expense_id"]));
			
			headerScript = GetHeaderScriptWithDataSet(pageData);
			
			Session["currentExpensesPageData"] = pageData;
		
			WriteJavaScript(headerScript);
			
			if(!IsPostBack)
			{
				////STATUS
				string status = pageData.Tables[0].Rows[0][0].ToString();
				StatusTextField.Value = status;
				
				LoadExpensesDataGrid();
				
				UpdateAccountListDataGrid();
			}
		}
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
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref AccountListDataGrid, "expenses_get_account_list_with_expense_id",
				"@expense_id", GetValueFromRequest(Request["expense_id"]));
		}
    }
	
	
	void LoadExpensesDataGrid()
	{
		if(Session["currentExpensesPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentExpensesPageData"];
			
			IdTextField.Value = pageData.Tables[1].Rows[0][0].ToString();
			CoefficientTextField.Value = pageData.Tables[1].Rows[0][1].ToString();
			ExpensesDateTextField.Value = pageData.Tables[1].Rows[0][2].ToString();
			AdvanceCurrencyTextField.Value = pageData.Tables[1].Rows[0][3].ToString();
			AdvanceCurrencyAmountTextField.Value = pageData.Tables[1].Rows[0][4].ToString();
			AdvanceTotalTextField.Value = pageData.Tables[1].Rows[0][5].ToString();
			CommentTextArea.Value = pageData.Tables[1].Rows[0][6].ToString();
			
			UpdateDataGridWithDataTable(ref ExpensesDataGrid, pageData.Tables[2]);
		}
		
		UpdateTotalFields();
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
<form id="MainForm" method="post" runat="server">
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
					<td width="100"><input name="IdTextField" type="text" class="text_bold" id="IdTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
					<td width="100" class="text_bold" align="right">saved date : </td>
					<td width="5"></td>
					<td width="100"><input name="ExpensesDateTextField" type="text" class="text_bold" id="ExpensesDateTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
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
    >
	
      <Columns>
	  	 <asp:BoundColumn HeaderText="ID" SortExpression="ID" Visible="false" DataField="ID"/>
		 <asp:TemplateColumn HeaderText="DATE" HeaderStyle-Width="60" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center" ItemStyle-VerticalAlign="middle">
          <ItemTemplate>
		  	<input name="DateTextField" type="text" class="text" id="DateTextField" style="width:58px" maxlength="10" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "DATE") %>' readonly="true">
          </ItemTemplate>
         </asp:TemplateColumn>
		 <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="124" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="AccountTextField" name="AccountTextField" type="text" class="text"  style="width:122px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "ACCOUNT") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Description" HeaderStyle-Width="160" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="DescriptionTextField" name="DescriptionTextField" type="text" class="text"  style="width:158px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "DESCRIPTION") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Km" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="KmTextField" name="KmTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "KM") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="KmValueTextField" name="KmValueTextField" type="text" class="text"  style="width:48px" runat="server" readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Transp." HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TransportTextField" name="TransportTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "TRANSPORT") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Mission" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="MissionTextField" name="MissionTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "MISSION") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Recept." HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="ReceptionTypeTextField" name="ReceptionTypeTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "RECEPTION_TYPE") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderStyle-Width="50" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="ReceptionTextField" name="ReceptionTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "RECEPTION") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Other" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="OtherTextField" name="OtherTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "OTHER") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Dev" HeaderStyle-Width="30" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="CurrencyTextField" name="CurrencyTextField" type="text" class="text"  style="width:28px" maxlength="3" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "CURRENCY") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Curr." HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="CurrencyAmountTextField" name="CurrencyAmountTextField" type="text" class="text"  style="width:48px" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "CURRENCY_AMOUNT") %>' readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Total" HeaderStyle-Width="50" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TotalTextField" name="TotalTextField" type="text" class="text"  style="width:48px" runat="server" readonly="true">
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </ASP:DataGrid>
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
		<td><textarea name="CommentTextArea" cols="0" rows="0" class="text" id="CommentTextArea" style="width:900px;height:50px" runat="server" readonly="true"></textarea></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td>
			<table width="900" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="header" width="695">RECEIVED ADVANCES</td>
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
					<td width="100"><input name="AdvanceCurrencyTextField" type="text" class="text" id="AdvanceCurrencyTextField"  style="width:30px" maxlength="3" runat="server" readonly="true">
		  	<input name="AdvanceCurrencyAmountTextField" type="text" class="text" id="AdvanceCurrencyAmountTextField"  style="width:65px" runat="server" readonly="true"></td>
					<td width="5"></td>
					<td width="100"><input name="AdvanceTotalTextField" type="text" class="text_bold" id="AdvanceTotalTextField" style="width:100px;text-align:right" runat="server" readonly="true"></td>
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
	 <td height="5"></td>
	</tr>
	<tr>
		<td>
			<table width="900" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="60" class="text_bold">Status :</td>
					<td width="100"><input name="StatusTextField" type="text" class="red_bold" id="StatusTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
					<td width="740"><input type="hidden" name="LineNumberHiddenField" id="LineNumberHiddenField" value="5" runat="server"></td>
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
