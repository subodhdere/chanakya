resource "aws_sns_topic" "kasm" {
  name = "kasm" 
}

resource "aws_sns_topic_subscription" "kasm" {
  topic_arn = aws_sns_topic.kasm.arn
  protocol  = "email"
  endpoint  = "subodh.dere.7@gmail.com"
}