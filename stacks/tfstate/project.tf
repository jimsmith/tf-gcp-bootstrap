resource "google_project" "self" {
  name            = "${var.context}-${var.environment}-tfstate"
  project_id      = "${var.context}-${var.environment}-tfstate"
  org_id          = var.org_id
  billing_account = var.billing_account
  skip_delete     = true
  labels          = local.labels
}
