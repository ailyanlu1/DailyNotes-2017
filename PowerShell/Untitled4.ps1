$xl=New-Object -ComObject excel.application
$xl.visible=$true
$wb=$xl.workbooks.add()
$sheet=$wb.sheets.item(1)
$sheet.cells.item(1,1)="书名"
$sheet.cells.item(1,2)="作者"
$sheet.cells.item(1,3)="译者"
$sheet.cells.item(2,1)="abc"
$sheet.cells.item(2,2)="def"
$sheet.cells.item(2,3)="ghi"


$range=$sheet.Range("A1:D4")
$chart=$sheet.ChartObjects()#创建一个excel图标对象
$chart_t=$chart.Add(100,100,300,200)#设置位置 左上右下偏离
$chart_t.Chart.SetSourceData($range,2)#设置它的原始数据源
 
$chart_t.Chart.ChartType=58#设置图标类型
$chart_t.Chart._ApplyDataLabels(5)#应用标签值
$chart_t.Chart.ChartStyle=2#设置样式
$chart_t.Chart.ChartTitle.gettype() #获取chart类型