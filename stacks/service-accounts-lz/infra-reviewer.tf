# For planning we need to view stuff in terraform
resource "google_service_account" "infra_reviewer" {
  account_id   = "${var.environment}-reviewer"
  display_name = "${var.environment} Infrastructure Viewer"
  project      = var.project
}

# Binding to the Github Repositories to assume this role.
resource "google_service_account_iam_binding" "infra_reviewer_workload_identity_user" {
  service_account_id = google_service_account.infra_reviewer.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    for repo in toset(var.repositories) :
    "principalSet://iam.googleapis.com/${var.github_workload_identity_pool}/attribute.repository_ref_workflow_environment/${repo}/refs/heads/${var.main_branch}/${var.review_workflow}/${var.environment}"
  ]
}

resource "google_service_account_iam_binding" "infra_reviewer_token_creator" {
  service_account_id = google_service_account.infra_reviewer.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = var.reviewers
}

resource "google_organization_iam_member" "infra_reviewer" {
  org_id = var.org_id
  role   = "roles/viewer"
  member = "serviceAccount:${google_service_account.infra_reviewer.email}"
}

resource "google_organization_iam_member" "infra_reviewer_folder_viewer" {
  org_id = var.org_id
  role   = "roles/resourcemanager.folderViewer"
  member = "serviceAccount:${google_service_account.infra_reviewer.email}"
}

resource "google_organization_iam_member" "infra_reviewer_security_reviewer" {
  org_id = var.org_id
  role   = "roles/iam.securityReviewer"
  member = "serviceAccount:${google_service_account.infra_reviewer.email}"
}

resource "google_organization_iam_member" "infra_reviewer_billing_viewer" {
  org_id = var.org_id
  role   = "roles/billing.viewer"
  member = "serviceAccount:${google_service_account.infra_reviewer.email}"
}

resource "google_project_iam_member" "infra_reviewer_tfstate" {
  project = "${var.context}-lz-tfstate"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.infra_reviewer.email}"
}
