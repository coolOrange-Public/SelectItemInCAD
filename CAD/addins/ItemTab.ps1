

Add-Type @"
public class itemData
{
	public string Item {get;set;}
	public string Revision {get;set;}
	public string Title {get;set;}
	
}
"@

function SearchItem()
{
	if($mvparam -eq "") { return } #no searchparameters
	$srchconds = New-Object autodesk.Connectivity.WebServices.SrchCond[] 1
	$srchconds[0] = New-Object autodesk.Connectivity.WebServices.SrchCond
	$srchconds[0].PropDefId = 0
	$srchconds[0].SrchOper = 1
	$srchconds[0].SrchTxt = $mvparam
	$srchconds[0].PropTyp = "AllProperties"
	$srchconds[0].SrchRule = "Must"
	$bookmark = ""
	$status = New-Object autodesk.Connectivity.WebServices.SrchStatus
	$items = $vault.ItemService.FindItemRevisionsBySearchConditions($srchconds, $null, $true, [ref]$bookmark, [ref]$status)
	$results = @()
	foreach($item in $items)
	{
		$row = New-Object itemData
		$row.Item = $item.ItemNum
		$row.Revision = $item.RevNum
		$row.Title = $item.Title
		$results += $row 		
	}
	$dsWindow.FindName("ItemsFound").ItemsSource = $results
}


function SelectItem
{
	$selectedItem = $dsWindow.FindName("ItemsFound").SelectedItem
	$Prop["Part Number"].Value = $selectedItem.Item
	$dsWindow.FindName("DataTab").IsSelected = $true
}

