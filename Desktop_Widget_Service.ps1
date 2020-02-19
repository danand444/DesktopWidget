#Serial Port Detection Based on CH340 CHIP
$serial_port = Get-PnpDevice -Class Ports | where -Property FriendlyName -like *CH340*
$serial_port = $serial_port.ToString()
$serial_port_index = $serial_port.IndexOf("COM")
$serial_port = $serial_port.Substring($serial_port_index + 0)
$serial_port_index = $serial_port.IndexOf(") ")
$serial_port = $serial_port.Substring(0,$serial_port_index + 0)
#Creation of Serial Port object
$port = new-Object System.IO.Ports.SerialPort $serial_port.ToString(),9600,None,8,one
#Open Port
$port.open()
#CPU Core Count
$CpuCores = (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
while ($true) {
#CPU Calculation
$cpu_total = (Get-Counter "\Process(*)\% Processor Time" -ErrorAction SilentlyContinue).CounterSamples | Select InstanceName, @{Name="CPU %";Expression={[Decimal]::Round(($_.CookedValue / $CpuCores), 2)}} | sort *CPU* -Descending | select -First 10
$cpu_total = $cpu_total | where instancename -like idle
$cpu_total = 110 - $cpu_total.'CPU %'
$cpu_total = [Math]::Floor([decimal]($cpu_total))
$cpu_total = $cpu_total.ToString() + "%"
#Memory Calculation
$availMem = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
$total_mem = (Get-WMIObject Win32_ComputerSystem).TotalPhysicalMemory / 1024000
$total_mem = [Math]::Floor([decimal]($total_mem))
$availMem = [Math]::Floor([decimal]($availMem))
$free_mem = $total_mem - $availMem
$availMem = “{0:P0}” -f ($free_mem/$total_mem)
#LCD Read Out
$read_out = "CPU:" + $cpu_total + " " + "RAM:" + $availMem + "   "
$read_out = $read_out.Insert(0,1)
#Green, Yellow Read
$cpu_total = $cpu_total.Replace("%",$null)
$cpu_total = $cpu_total -as [int]
#GREEN
if ($cpu_total -le 40) {
$read_out = $read_out + "#GREEN#"
}
#YELLOW
if ($cpu_total -gt 40 -and $cpu_total -lt 80) {
$read_out = $read_out + "#YELLOW#"
}
#RED
if ($cpu_total -ge 80) {
$read_out = $read_out + "#RED#"
}
#Write to Serial
$port.WriteLine($read_out)
#Error Escape
if ($port.IsOpen -eq $false) {
break
}
Start-Sleep 2
}
