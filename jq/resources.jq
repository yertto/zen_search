def organizations:
  [ $organizations_array[0] | .[] | { key: (._id|tostring), value: .name } ] | from_entries;

def users:
  [         $users_array[0] | .[] | { key: (._id|tostring), value: .name } ] | from_entries;


def submitter_tickets:
  $tickets_array[0] |
  [
    group_by(.submitter_id)[] |
    { (.[0].submitter_id|tostring): [.[] | { key: ._id, value: .subject }] | from_entries }
  ] |
  add;

def assignee_tickets:
  $tickets_array[0] |
  [
    group_by(.assignee_id)[] |
    { (.[0].assignee_id|tostring): [.[] | { key: ._id, value: .subject }] | from_entries }
  ] |
  add;

def organization_users:
  $users_array[0] |
  [
    group_by(.organization_id)[] |
    { (.[0].organization_id|tostring): [.[] | { key: (._id|tostring), value: .name }] | from_entries }
  ] |
  add;

def organization_tickets:
  $tickets_array[0] |
  [
    group_by(.organization_id)[] |
    { (.[0].organization_id|tostring): [.[] | { (._id): .subject }] | add }
  ] |
  add;
