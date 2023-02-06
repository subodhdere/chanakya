resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  alarm_name          = "rds_cpu_utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]

  dimensions = {
    DBInstanceIdentifier = "database-identifier"
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  alarm_name          = "rds_freeable_memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "256000000" // 256 MB
  alarm_description   = "Average database freeable memory over last 10 minutes too low, performance may suffer"
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]

  dimensions = {
    DBInstanceIdentifier = "database-identifier"
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "rds_free_storage_space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "10000000000" // 10 GB
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]

  dimensions = {
    DBInstanceIdentifier = "database-identifier"
  }
}

resource "aws_cloudwatch_metric_alarm" "ReadIOPS" {
  alarm_name          = "rds_ReadIOPS"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "150"
  alarm_description   = "DB usually gets a ReadIOPS count of 150 , and anything above 150 should be considered as anomaly."
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]

  dimensions = {
    DBInstanceIdentifier = "database-identifier"
  }
}


resource "aws_cloudwatch_metric_alarm" "WriteIOPS" {
  alarm_name          = "rds_WriteIOPS"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "300"
  alarm_description   = "DB usually gets a WriteIOPS count of 250 , and anything above 300 should be considered as anomaly."
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]

  dimensions = {
    DBInstanceIdentifier = "database-identifier"
  }
}