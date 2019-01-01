def organization_str:
  .name + " (details: " + .details + ")" ;

def organizations:
  [ $organizations_array[0][] | { (._id|tostring): organization_str } ] | add;

def user_str:
  .name + " (organization: " + organizations[.organization_id|tostring] + ")" ;

def users:
  [         $users_array[0][] | { (._id|tostring): user_str } ] | add;

def ticket_str:
  .subject + " (created_at: " + .created_at + ")" ;

def submitter_tickets:
  $tickets_array[0] |
  [
    group_by(.submitter_id)[] |
    { (.[0].submitter_id|tostring): [.[] | { (._id): ticket_str }] | add }
  ] |
  add;

def assignee_tickets:
  $tickets_array[0] |
  [
    group_by(.assignee_id)[] |
    { (.[0].assignee_id|tostring): [.[] | { (._id): ticket_str }] | add }
  ] |
  add;

def organization_tickets:
  $tickets_array[0] |
  [
    group_by(.organization_id)[] |
    { (.[0].organization_id|tostring): [.[] | { (._id): .subject }] | add }
  ] |
  add;

def organization_users:
  $users_array[0] |
  [
    group_by(.organization_id)[] |
    { (.[0].organization_id|tostring): [.[] | { (._id|tostring): .name }] | add }
  ] |
  add;

