
//MAIN FUNCTIONS//
function showCalendar(field, linkName)
{
	var calendar = new CalendarPopup()
	calendar.showNavigationDropdowns()
	calendar.select(field,linkName,'dd/MM/yyyy')
	return false
}
	
function sendMail(email)
{
	if (email.length > 0)
 	{
		window.open("mailto:" + email)
 	}
}

function clearHtmlSelect(htmlSelect)
{
	htmlSelect.options.length = 0
	htmlSelect.options[0] = new Option("", "")
}

function setSingleSelected(htmlSelect)
{
	if(htmlSelect.options.length == 2)
	{
		htmlSelect.selectedIndex = 1
		return 1
	}
	
	return 0
}


//HTML SELECT CUSTOMER FILE

function onCustomerTypeSelectChange(value, partnerSelect)
{
	if(value == "0")
	{
		partnerSelect.disabled = false
	}
	else
	{
		partnerSelect.selectedIndex = 0
		partnerSelect.disabled = true
	}
}

//HTML SELECT ADD AND UPDATE ACCOUNT

function onAccountCustomerSelectChange(value, trigIdTextField, contractSelect)
{
	trigIdTextField.value = ""
	
	for (i = 0; i < Table2.length; i++)
	{
		if(Table2[i][0] == value)
		{
			trigIdTextField.value = Table2[i][2]
			break
		}
	}
	
	if(contractSelect != null)
	{
		clearHtmlSelect(contractSelect)
	
		for (i = 0, j = 1; i < Table3.length; i++)
		{
			if(Table3[i][2] == value)
			{
				contractSelect.options[j] = new Option(Table3[i][1], Table3[i][0])
				j++
			}
		}
	}
}
									
function onAccountUseSelectChange(value, useIdTextField)
{
	useIdTextField.value = ""
	
	for (i = 0; i < Table1.length; i++)
	{
		if(Table1[i][0] == value)
		{
			useIdTextField.value = Table1[i][2]
			break
		}
	}
}

function onAccountContractSelectChange(value, contractHiddenField)
{
	contractHiddenField.value = value
}

//TIME REPORT

function onTimeReportFormClick(value, informationTextField)
{
	var total = new Array(0, 0, 0, 0, 0, 0, 0)
	informationTextField.value = ""
	
	for(i = 0; i < value; i++)
	{
		for(j = 0; j < 7; j++)
		{
			var timeTextField = self.document.all("TimeReportDataGrid__ctl" + (2+i) + "_TimeTextField_" + j)
			
			if(timeTextField.value != "")
			{
				total[j] = parseInt(timeTextField.value) + total[j]
			}
		}
	}
	
	for(k = 0; k < 7; k++)
	{
		var overTimeTextField = self.document.all("OverTimeTextField_" + k)
		
		if(k < 5)
		{
			var totalTextField = self.document.all("TotalTextField_" + k)
		
			if((total[k] >= 0) && (total[k] <= 8))
			{
				totalTextField.value = total[k]
				overTimeTextField.value = 0
			}
			else if((total[k] >= 9) && (total[k] <= 24))
			{
				totalTextField.value = 8
				overTimeTextField.value = total[k] - 8
			}
			else
			{
				totalTextField.value = '#'
				overTimeTextField.value = '#'
				informationTextField.value = "Time incorrect!"
			}
		}
		else
		{
			if((total[k] >= 0) && (total[k] <= 24))
			{
				overTimeTextField.value = total[k]
			}
			else
			{
				overTimeTextField.value = '#'
				informationTextField.value = "Time incorrect!"
			}
		}
	}
}


function onTimeReportClearButtonClick(clearButton)
{
	var index = parseInt(clearButton.id.substr(23,2))
	var accountSelect = self.document.all("TimeReportDataGrid__ctl" + (index) + "_AccountSelect")
	accountSelect.selectedIndex = 0
	
	for(i = 0; i < 7; i++)
	{
		var timeTextField = self.document.all("TimeReportDataGrid__ctl" + (index) + "_TimeTextField_" + i)
		var typeSelect = self.document.all("TimeReportDataGrid__ctl" + (index) + "_TypeSelect_" + i)
		
		timeTextField.value = ""
		typeSelect.selectedIndex = 0
	}
}

function onCustomerReportCustomerTrigChange(value, customerSelect)
{
	if(value == "")
	{
		customerSelect.selectedIndex = 0
	}
	else
	{
		for (i = 0; i < Table.length; i++)
		{
			if(Table[i][2] == value.toUpperCase())
			{
				customerSelect.selectedIndex = i+1;
				break
			}
		}
	}
}


function validateReport()
{
	var value = confirm("Are you sure you want to validate the current report?")

	if (value !== true)
	{
		return false
	}
}

///EXPENSES


function validateExpenses()
{
	var value = confirm("You can't modify the current expenses if it is submitted.\nAre you sure you want to submit the current expenses?")

	if (value !== true)
	{
		return false
	}
}


function showExpensesCalendar(calendarButton)
{
	var index = parseInt(calendarButton.id.substr(21,2))
	var dateTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_DateTextField")
	
	var calendar = new CalendarPopup()
	calendar.showNavigationDropdowns()
	calendar.select(dateTextField,"ExpensesDataGrid__ctl" + (index) + "_DateImageLink",'dd/MM/yy')
	return false
}


function onExpensesClearButtonClick(clearButton)
{
	var index = parseInt(clearButton.id.substr(21,2))
	
	var dateTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_DateTextField")
	var accountSelect = self.document.all("ExpensesDataGrid__ctl" + (index) + "_AccountSelect")
	var descriptionTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_DescriptionTextField")
	var kmTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_KmTextField")
	var kmValueTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_KmValueTextField")
	var transportTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_TransportTextField")
	var missionTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_MissionTextField")
	var receptionTypeSelect = self.document.all("ExpensesDataGrid__ctl" + (index) + "_ReceptionTypeSelect")
	var receptionTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_ReceptionTextField")
	var otherTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_OtherTextField")
	var currencyTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_CurrencyTextField")
	var currencyAmountTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_CurrencyAmountTextField")
	var totalTextField = self.document.all("ExpensesDataGrid__ctl" + (index) + "_TotalTextField")
	
	
	dateTextField.value = ""
	accountSelect.selectedIndex = 0
	descriptionTextField.value = ""
	kmTextField.value = ""
	kmValueTextField.value = ""
	transportTextField.value = ""
	missionTextField.value = ""
	receptionTypeSelect.selectedIndex = 0
	receptionTextField.value = ""
	otherTextField.value = ""
	currencyTextField.value = "EUR"
	currencyAmountTextField.value = "1"
	totalTextField.value = ""
}


function onExpensesFormClick(value, coefficient, informationTextField)
{
	informationTextField.value = ""
	
	var coef = getFloat(coefficient)
	
	if(isNaN(coef))
	{
		return
	}
	
	var total = 0
	
	var totalTextField = self.document.all("TotalTextField")
	var advanceCurrencyAmountTextField = self.document.all("AdvanceCurrencyAmountTextField")
	var advanceTotalTextField = self.document.all("AdvanceTotalTextField")
	
	for(i = 0; i < value; i++)
	{
		var lineTotal = 0
		
		var kmTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_KmTextField")
		var kmValueTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_KmValueTextField")
		var totalLineTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_TotalTextField")
		var transportTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_TransportTextField")
		var missionTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_MissionTextField")
		var receptionTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_ReceptionTextField")
		var otherTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_OtherTextField")
		var currencyAmountTextField = self.document.all("ExpensesDataGrid__ctl" + (2+i) + "_CurrencyAmountTextField")
		
		if(kmTextField.value != "")
		{
			var km = (getFloat(kmTextField.value) * coef)
			
			if(isNaN(km))
			{
				kmTextField.value = "#"
				informationTextField.value = "Km incorrect!"
			}
			else
			{
				kmValueTextField.value = km
				lineTotal += km
			}
		}
		
		if(transportTextField.value != "")
		{
			var transport = getFloat(transportTextField.value)
			
			if(isNaN(transport))
			{
				transportTextField.value = "#"
				informationTextField.value = "Transport incorrect!"
			}
			else
			{
				lineTotal += transport
			}
		}
		
		if(missionTextField.value != "")
		{
			var mission = getFloat(missionTextField.value)
			
			if(isNaN(mission))
			{
				missionTextField.value = "#"
				informationTextField.value = "Mission incorrect!"
			}
			else
			{
				lineTotal += mission
			}
		}
		
		if(receptionTextField.value != "")
		{
			var reception = getFloat(receptionTextField.value)
			
			if(isNaN(reception))
			{
				receptionTextField.value = "#"
				informationTextField.value = "Reception incorrect!"
			}
			else
			{
				lineTotal += reception
			}
		}
		
		if(otherTextField.value != "")
		{
			var other = getFloat(otherTextField.value)
			
			if(isNaN(other))
			{
				otherTextField.value = "#"
				informationTextField.value = "Reception incorrect!"
			}
			else
			{
				lineTotal += other
			}
		}
		
		if(currencyAmountTextField.value != "")
		{
			var currencyAmount = getFloat(currencyAmountTextField.value)
			
			if(isNaN(currencyAmount))
			{
				currencyAmountTextField.value = "#"
				informationTextField.value = "Currency amount incorrect!"
			}
			else
			{
				lineTotal *= currencyAmount
			}
		}
		
		totalLineTextField.value = (Math.round(lineTotal*100)/100)
		total += lineTotal
	}
	
	if(advanceTotalTextField.value != "")
	{
		var advanceTotal = getFloat(advanceTotalTextField.value)
		
		if(isNaN(advanceTotal))
		{
			advanceTotalTextField.value = "#"
			informationTextField.value = "Advance total incorrect!"
		}
		else
		{
			if(advanceCurrencyAmountTextField.value != "")
			{
				var advanceCurrencyAmount = getFloat(advanceCurrencyAmountTextField.value)
				
				if(isNaN(advanceCurrencyAmount))
				{
					advanceCurrencyAmountTextField.value = "#"
					informationTextField.value = "Advance currency amount incorrect!"
				}
				else
				{
					advanceTotal *= advanceCurrencyAmount
				}
			}
			
			total -= advanceTotal
		}
	}
	
	totalTextField.value = (Math.round(total*100)/100)
}

function getFloat(value)
{
	return parseFloat(value.replace(',', '.'))
}



//OTHER

function updateFileOnServerStatus(file_on_server)
{
	if(file_on_server == "1")
	{
		window.opener.document.getElementById("FileTextField").value="(1 file)"
	}
	else
	{
		window.opener.document.getElementById("FileTextField").value="(0 file)"
	}
}


//HTML SELECT ADD AND UPDATE CUSTOMER INCIDENT FILE

function onCustomerIncidentCompanySelectChange(value, contactSelect, contactButton, projectSelect, projectLeaderSelect, contactHiddenField, projectHiddenField, projectLeaderHiddenField, configsButton, contractButton, levelSelect, levelHiddenField)
{
	clearHtmlSelect(contactSelect)
	clearHtmlSelect(projectSelect)
	clearHtmlSelect(projectLeaderSelect)
	clearHtmlSelect(levelSelect)
	contactButton.value = "Add contact"
	contactHiddenField.value = ""
	projectHiddenField.value = ""
	projectLeaderHiddenField.value = ""
	levelHiddenField.value = ""
	contractButton.disabled = true
	
	if(value != "")
	{
		configsButton.disabled = false
		contactButton.disabled = false
	}
	else 
	{
		configsButton.disabled = true
		contactButton.disabled = true
	}
	
	for (i = 0, j = 1; i < Table8.length; i++)
	{
		if(Table8[i][2] == value)
		{
			contactSelect.options[j] = new Option(Table8[i][1], Table8[i][0])
			j++
		}
	}
	
	for (i = 0, j = 1; i < Table9.length; i++)
	{
		if(Table9[i][2] == value)
		{
			projectSelect.options[j] = new Option(Table9[i][1], Table9[i][0])
			j++
		}
	}
	
	if(setSingleSelected(projectSelect) == 1)
	{
		onCustomerIncidentProjectSelectChange(projectSelect.value, projectLeaderSelect, projectHiddenField, projectLeaderHiddenField, contractButton, levelSelect, levelHiddenField)
	}
}

function onCustomerIncidentContactSelectChange(contactSelect, contactButton, contactHiddenField)
{
	contactHiddenField.value = contactSelect.value
	
	if(contactSelect.selectedIndex == 0)
	{
		contactButton.value = "Add contact"
	}
	else
	{
		contactButton.value = "Edit contact"
	}
}

function onCustomerIncidentProjectSelectChange(value, projectLeaderSelect, projectHiddenField, projectLeaderHiddenField, contractButton, levelSelect, levelHiddenField)
{
	clearHtmlSelect(projectLeaderSelect)
	projectHiddenField.value = value
	projectLeaderHiddenField.value = ""
	
	if(value != "")
	{
		contractButton.disabled = false
	}
	else 
	{
		contractButton.disabled = true
	}

	for (i = 0; i < Table9.length; i++)
	{
		if(Table9[i][0] == value)
		{
			if(Table9[i][3] != "")
			{
				for(j = 0, k = 1; j < Table.length; j++)
				{
					if(Table[j][0] == Table9[i][3])
					{
						projectLeaderSelect.options[k] = new Option(Table[j][1], Table[j][0])
						setSingleSelected(projectLeaderSelect)
						projectLeaderHiddenField.value = projectLeaderSelect.value
						//updateLevelSelect(value, levelSelect, levelHiddenField)
						return
					}
				}
			}
		}
	}
}

function onCustomerIncidentLevelSelectChange(value, levelHiddenField)
{
	levelHiddenField.value = value;
}

function onCustomerIncidentProjectLeaderSelectChange(value, projectLeaderHiddenField)
{
	projectLeaderHiddenField.value = value
}

function onCustomerIncidentProductSelectChange(value, productVersionSelect, productVersionHiddenField)
{
	clearHtmlSelect(productVersionSelect)
	
	for (i = 0, j = 1; i < Table5.length; i++)
	{
		if(Table5[i][2] == value)
		{
			productVersionSelect.options[j] = new Option(Table5[i][1], Table5[i][0])
			j++
		}
	}
	
	setSingleSelected(productVersionSelect)
	productVersionHiddenField.value = productVersionSelect.value
}

function onCustomerIncidentProductVersionSelectChange(value, productVersionHiddenField)
{
	productVersionHiddenField.value = value
}

function onCustomerIncidentStatusSelectChange(value, closingDateTextField)
{
	if(value == "2")
	{
		var d = new Date()
		closingDateTextField.value = d.getDate() + "/" + (d.getMonth()+1) + "/" + d.getFullYear()
	}
	else
	{
		closingDateTextField.value = "?"
	}
}

//HTML SELECT SEARCH CUSTOMER INCIDENT FILE

function onSearchCustomerIncidentCompanySelectChange(value, contactSelect, projectSelect, projectLeaderSelect, contactHiddenField, projectHiddenField, projectLeaderHiddenField, levelSelect, levelHiddenField)
{
	clearHtmlSelect(contactSelect)
	clearHtmlSelect(projectSelect)
	clearHtmlSelect(projectLeaderSelect)
	clearHtmlSelect(levelSelect)
	contactHiddenField.value = ""
	projectHiddenField.value = ""
	projectLeaderHiddenField.value = ""
	levelHiddenField.value = ""
	
	for (i = 0, j = 1; i < contact.length; i++)
	{
		if(contact[i][2] == value)
		{
			contactSelect.options[j] = new Option(contact[i][1], contact[i][0])
			j++
		}
	}
	
	for (i = 0, j = 1; i < project.length; i++)
	{
		if(project[i][2] == value)
		{
			projectSelect.options[j] = new Option(project[i][1], project[i][0])
			j++
		}
	}
}

function onSearchCustomerIncidentContactSelectChange(value, contactHiddenField)
{
	contactHiddenField.value = value
}

function onSearchCustomerIncidentProjectSelectChange(value, projectLeaderSelect, projectHiddenField, projectLeaderHiddenField, levelSelect, levelHiddenField)
{
	clearHtmlSelect(projectLeaderSelect)
	projectHiddenField.value = value
	projectLeaderHiddenField.value = ""

	for (i = 0; i < project.length; i++)
	{
		if(project[i][0] == value)
		{
			if(project[i][3] != "")
			{
				for(j = 0, k = 1; j < writer.length; j++)
				{
					if(writer[j][0] == project[i][3])
					{
						projectLeaderSelect.options[k] = new Option(writer[j][1], writer[j][0])
						projectLeaderHiddenField.value = projectLeaderSelect.value
						//updateLevelSelect(value, levelSelect, levelHiddenField)
						return
					}
				}
			}
		}
	}
}

function onSearchCustomerIncidentLevelSelectChange(value, levelHiddenField)
{
	levelHiddenField.value = value;
}

function onSearchCustomerIncidentProjectLeaderSelectChange(value, projectLeaderHiddenField)
{
	projectLeaderHiddenField.value = value
}

function onSearchCustomerIncidentProductSelectChange(value, productVersionSelect, productVersionHiddenField)
{
	clearHtmlSelect(productVersionSelect)
	
	for (i = 0, j = 1; i < productVersion.length; i++)
	{
		if(productVersion[i][2] == value)
		{
			productVersionSelect.options[j] = new Option(productVersion[i][1], productVersion[i][0])
			j++
		}
	}
	
	productVersionHiddenField.value = productVersionSelect.value
}

function onSearchCustomerIncidentProductVersionSelectChange(value, productVersionHiddenField)
{
	productVersionHiddenField.value = value
}


//HTML SELECT ANSWER CLIENT INCIDENT FILE

function onAnswerCustomerIncidentTypeSelectChange(value, mailCheckBox)
{
	mailCheckBox.checked = false
	
	if(value == "")
	{
		mailCheckBox.disabled = true
	}
	else
	{
		mailCheckBox.disabled = false
		mailCheckBox.checked = true
	}
}

///OPEN WINDOW FUNCTION CUSTOMER INCIDENT

function openCustomerIncidentContactWindow(contact_id, company_id) 
{
	window.open("../info/contact_info.aspx?contact_id=" + contact_id + "&company_id=" + company_id,"","width=580,height=140")
}

function openCustomerIncidentConfigsWindow(company_id) 
{
	window.open("../info/configs_info.aspx?company_id=" + company_id,"","scrollbars=yes,width=890,height=500")
}

function openCustomerIncidentContractWindow(project_id) 
{
	window.open("../info/contract_info.aspx?project_id=" + project_id,"","width=580,height=195")
}

function openCustomerIncidentFilesAttachmentsWindow(client_incident_id, rd_incident_id, origin)
{
	window.open("../../files.aspx?client_incident_id=" + client_incident_id + "&rd_incident_id=" + rd_incident_id + "&origin=" + origin,"","width=580,height=160")
}

function openCustomerIncidentAnswerWindow(client_incident_id, writer_id, contact_id)
{
	window.open("answer_customer_incident.aspx?client_incident_id=" + client_incident_id + "&writer_id=" + writer_id + "&contact_id=" + contact_id,"","width=580,height=200")
}

function openCustomerIncidentRdIncidentWindow(rd_incident_id)
{
	window.open("../info/rd_incident_info.aspx?rd_incident_id=" + rd_incident_id,"","width=580,height=350")
}


///GET SEARCH RESULT CUSTOMER INCIDENT

function getSearchCustomerIncidentResults(client_incident_id, start_opening_date, end_opening_date, writer_id, 
										client_reference_id, company_id, project_id, contact_id, project_leader_id, 
										product_id, product_version_id, name, server_version_id, status_id, level_id,
										type_id, description, client_answer, answer, start_solving_date, end_solving_date,
										files_attachments, leader_id, priority_id, start_closing_date, end_closing_date, row_count)
{
	parent.window.bottom.location="result_client_incident.aspx?client_incident_id=" + client_incident_id + "&start_opening_date=" + start_opening_date + "&end_opening_date=" + end_opening_date
						+ "&writer_id=" + writer_id + "&client_reference_id=" + client_reference_id + "&company_id=" + company_id + "&project_id=" + project_id + "&contact_id=" + contact_id + "&project_leader_id=" + project_leader_id
						+ "&product_id=" + product_id + "&product_version_id=" + product_version_id + "&name=" + name + "&server_version_id=" + server_version_id + "&status_id=" + status_id + "&level_id=" + level_id
						+ "&type_id=" + type_id + "&description=" + description + "&client_answer=" + client_answer + "&answer=" + answer + "&start_solving_date=" + start_solving_date + "&end_solving_date=" + end_solving_date
						+ "&files_attachments=" + files_attachments + "&leader_id=" + leader_id + "&priority_id=" + priority_id + "&start_closing_date=" + start_closing_date + "&end_closing_date=" + end_closing_date + "&row_begin=0&row_count=" + row_count
}

