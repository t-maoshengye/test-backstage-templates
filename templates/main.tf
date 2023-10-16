terraform {
  required_version = ">= 1.0.0"

  required_providers {
    github = "= 5.32.0"
  }
}

provider "github" {
  owner = "Pay-Baymax"
}

locals {
  teams = yamldecode(file("${path.module}/teams.yaml")).teams
}

module "github_teams" {
  source   = "git@github.com:PP/terraform-module-github.git//github-team-repository?ref=v0.2.0"
  for_each = local.teams

  team_name   = each.key
  description = lookup(each.value, "description", "")
  privacy     = lookup(each.value, "privacy", "closed")
  parent      = lookup(each.value, "parent", "")

  members      = lookup(each.value, "member", [])
  maintainers  = lookup(each.value, "maintainer", [])
  repositories = lookup(each.value, "repositories", [])
}
