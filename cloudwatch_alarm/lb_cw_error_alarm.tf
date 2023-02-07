resource "aws_cloudwatch_metric_alarm" "kasm" {
  alarm_name                = "kasm-error-count"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  threshold                 = "5"
  alarm_description         = "Request error rate has exceeded 5%"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.kasm.arn]
  ok_actions                = [aws_sns_topic.kasm.arn]


  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_lb.kasm.arn_suffix
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_lb.kasm.arn_suffix
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "elb_latency" {
  alarm_name          = "elb_latency"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Latency"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = 100
  alarm_description   = "Alarm when Latency exceeds 100s"
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]

  dimensions = {
    LoadBalancer = aws_lb.kasm.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_healthyhosts" {
  alarm_name          = "alb-alarm-for-healthy-hosts-count"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1" #mins
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.kasm.arn]
  ok_actions          = [aws_sns_topic.kasm.arn]
  dimensions = {
    TargetGroup  = aws_lb_target_group.kasm.arn_suffix
    LoadBalancer = aws_lb.kasm.arn_suffix
  }
}