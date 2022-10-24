
proc addGitGroup (
  org: string,
  team: seq[string] = @[],
  provider: string = "",
  token: string = "",
) =
  echo "Add git group"

proc removeGitGroup (org: string) =
  echo "Remove git group"

proc updateGitGroup () =
  echo "Update git group"

# IAM

proc addIAMGroup () =
  echo "Add IAM group"

proc removeIAMGroup (org: string) =
  echo "Remove IAM group"

proc updateIAMGroup () =
  echo "Update IAM group"

# S3 bucket

proc addS3Group () =
  echo "Add S3 group"

proc removeS3Group (org: string) =
  echo "Remove S3 group"

proc updateS3Group () =
  echo "Update S3 group"

# Exported functions

proc addGroup * () =
  echo "Add generic group"

proc removeGroup * () =
  echo "Remove generic group"

proc updateGroup * () =
  echo "Update generic group"
