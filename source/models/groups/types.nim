type
  GroupStatus * = enum
    Ghost
    Exists
    Updated
    Created
    Deleted

  Group * = ref object of RootObj
    status*: GroupStatus
    group*: string
    name*: string
    token*: string

  GitGroup * = ref object of Group
    provider*: string
    api*: string
    meta*: string
    members*: string
    teams*: seq[string]

  GroupType * = enum
    Git
    IAM
    S3