resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "Jenkins-Ec2"
  dashboard_body = jsonencode({
    "widgets" = [
      {
        "type" : "explorer",
        "x" : 0,
        "y" : 0,
        "width" : 24,
        "height" : 15,
        "properties" : {
          "metrics" : [
            {
              "metricName" : "mem_used_percent",
              "resourceType" : "AWS::EC2::Instance",
              "stat" : "Average"
            },
            {
              "metricName" : "CPUUtilization",
              "resourceType" : "AWS::EC2::Instance",
              "stat" : "Average"
            },
            {
              "metricName" : "disk_used_percent",
              "resourceType" : "AWS::EC2::Instance",
              "stat" : "Average"
            }
          ],
          "labels" : [
            # {
            #     "key": "Name",
            #     "value": "terraform-Jenkins-instance"
            # }
            {
              "key" : "aws:ec2launchtemplate:id",
              "value" : "${aws_launch_template.terraform-Jenkins-lt.id}"
            }
          ],
          "widgetOptions" : {
            "legend" : {
              "position" : "bottom"
            },
            "view" : "timeSeries",
            "stacked" : false,
            "rowsPerPage" : 50,
            "widgetsPerRow" : 2
          },
          "period" : 300,
          "splitBy" : "",
          "region" : "us-west-2"
        }
      }
    ]
  })
}