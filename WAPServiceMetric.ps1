Import-Module AWSPowerShell
#Set the region of your cloudwatch
Set-DefaultAWSRegion -Region us-east-1

#Feel free to change this to match any existing namespaces you might have.
$Namespace = 'Windows/PerfCounters'

#Update the log path, use this for troubleshooting. 
#$logpath = "C:\Temp\WApServicelog.txt"
Set-DefaultAWSRegion -Region us-east-1

#Use an AWS Service to get this systems Instance ID
$instanceId = (New-Object System.Net.WebClient).DownloadString("http://169.254.169.254/latest/meta-data/instance-id")
#
#$instanceId

# Associate current EC2 instance with your custom cloudwatch metric
$instanceDimension = New-Object -TypeName Amazon.CloudWatch.Model.Dimension;
$instanceDimension.Name = "instanceid";
$instanceDimension.Value = "i-05c3730370a2639fb";

    $metrics = @();

    #Adjust this to  pick up your service or services, this will work fine with multiple services. 
    $runningServices = Get-WMIObject Win32_Service -Computer WAP-Test | Where {$_.Name -eq "appproxysvc"} 
    $runningServices

    # For each running service, add a metric to metrics collection that adds a data point to a CloudWatch Metric named 'Status' with dimensions: instanceid, servicename
        $runningServices | % { 
        $dimensions = @();

        $serviceDimension = New-Object -TypeName Amazon.CloudWatch.Model.Dimension;
        $serviceDimension.Name = "service"
        $serviceDimension.Value = $_.Name;
		
		$dimensions += $instanceDimension;
		$dimensions += $serviceDimension;

        $metric = New-Object -TypeName Amazon.CloudWatch.Model.MetricDatum;
        $metric.Timestamp = [DateTime]::Utcnow;
        $metric.MetricName = 'Status';
        $metric.Value = 1;
        $metric.Dimensions = $dimensions;

        $metrics += $metric;     
		
		Write-Output "SD = $($serviceDimension.Value)"

		Write-Output "Service: $($_.Name) is running"		
		
    }

      Write-CWMetricData -Namespace $Namespace -MetricData $metrics -Verbose