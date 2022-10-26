import std/tables

# Default API routes for supported git platforms

const github * = {
  "url": "https://api.github.com",
  "token": "false",
  "user": "/users/{{user}}", # https://docs.github.com/en/rest/users/users
  "keys": "/users/{{user}}/keys", # https://docs.github.com/en/rest/users/keys
  "org": "/orgs/{{org}}", # https://docs.github.com/en/rest/orgs/orgs
  "team": "/orgs/{{org}}/teams/{{team}}", # https://docs.github.com/en/rest/teams/teams
}.toTable()

const gitlab * = {
  "url": "https://gitlab.com",
  "token": "false",
  "user": "/api/v4/users?username={{user}}", # https://docs.gitlab.com/ee/api/users.html
  "keys": "/{{user}}.keys",
  "org": "/orgs/{{org}}",
  "team": "/teams/{{team}}",
}.toTable()

const bitbucket * = {
  "url": "https://api.bitbucket.org/2.0",
  "token": "false",
  "user": "/users/{{user}",
  "keys": "/users/{{user}/ssh-keys",
  "org": "/orgs/{{org}",
  "team": "/teams/{{team}",
}.toTable()

const gitea * = {
  "url": "required",
  "token": "false",
  "user": "/users/{{user}}",
  "keys": "/users/{{user}}/keys",
  "org": "/orgs/{{org}}",
  "team": "/teams/{{team}}",
}.toTable()

const git * = {
  "url": "required",
  "token": "false",
  "user": "required",
  "keys": "false",
  "org": "false",
  "team": "false",
}.toTable()
