<%@ Page Language="C#" %>
<!-- #Include File="../../config/util.cs" -->
<html>
<head>
<title>EXPENSES - Main List</title>
<link href="../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			UpdateExpensesListDataGrid();
		}
	}
	
	void UpdateExpensesListDataGrid()
    {
		int number = 0;
		int count = 0;
		PrevButton.Disabled = true;
		
		if(Request["number"] != null)
		{
			try
			{
				number = Convert.ToInt32(Request["number"].ToString());
				
				if(number > 0)
				{
					PrevButton.Disabled = false;
				}
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}
		
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			count = sqlClient.UpdateDataGridWithStoredProcedure(ref ExpensesListDataGrid, "expenses_get_expense_list",
				"@row_begin", number,
				"@login", User.Identity.Name.ToUpper());
		}
		
		if(count == 5)
		{
			NextButton.Disabled = false;
		}
		else
		{
			NextButton.Disabled = true;
		}
    }
	
	void PrevButton_Click(Object sender, EventArgs e)
	{
		int number = 0;
		
		if(Request["number"] != null)
		{
			try
			{
				number = Convert.ToInt32(Request["number"].ToString());
				number -= 5;
				
				if(number < 0)
				{
					number = 0;
				}
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}
	
		Response.Redirect("list.aspx?number=" + number.ToString() + "&expense_id=" + GetValueFromPageRequest(Request["expense_id"]));
	}
	
	void NextButton_Click(Object sender, EventArgs e)
	{
		int number = 5;
		
		if(Request["number"] != null)
		{
			try
			{
				number = Convert.ToInt32(Request["number"].ToString());
				number += 5;
				
				if(number < 0)
				{
					number = 0;
				}
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}
	
		Response.Redirect("list.aspx?number=" + number.ToString() + "&expense_id=" + GetValueFromPageRequest(Request["expense_id"]));
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="900" border="0" cellspacing="0" cellpadding="0">
	<tr>
  	<td>
		<table width="400" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header" width="300">EXPENSES LIST</td>
				<td width="50"><input name="PrevButton" type="submit" id="PrevButton" value="Prev" runat="server" onServerClick="PrevButton_Click" alt="Show previous list" style="width:50px;height:13px;background-color:#DE0029;color:#FFFFFF;border-width:0px;font-weight:bold;" /></TD>
  				<td width="50"><input name="NextButton" type="submit" id="NextButton" value="Next" runat="server" onServerClick="NextButton_Click" alt="Show next list" style="width:50px;height:13px;background-color:#DE0029;color:#FFFFFF;border-width:0px;font-weight:bold;" /></TD>
			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="ExpensesListDataGrid" runat="server"
	  Width="400"
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
		<asp:HyperLinkColumn Target="main_head" HeaderStyle-Width="100" DataNavigateUrlField="ID_EXPENSE" DataNavigateUrlFormatString="main_edit.aspx?expense_id={0}" DataTextField="ID_EXPENSE" HeaderText="ID"><ItemStyle Font-Bold="True"></ItemStyle></asp:HyperLinkColumn>
		<asp:TemplateColumn HeaderText="DATE" HeaderStyle-Width="100">
		  <ItemTemplate>
			<asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "DATE") %>'/>
		  </ItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="STATUS" HeaderStyle-Width="200">
		  <ItemTemplate>
			<asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "STATUS") %>' Font-Bold="true"/>
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
