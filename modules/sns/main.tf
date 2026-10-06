# SNS Topic
resource "aws_sns_topic" "this" {
  name = var.topic_name
  # Optional: Add tags if needed
  # tags = {
  #   Name = var.topic_name
  # }
}

# SNS Topic Subscription for email notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.notification_email
  # Note: AWS will send a confirmation email to the endpoint. The subscription will be pending until confirmed.
}
