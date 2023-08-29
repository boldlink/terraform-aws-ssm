module "minimum_example_session" {
  source                     = "../../"
  name                       = var.name
  create_session_preferences = var.create_session_preferences
}
