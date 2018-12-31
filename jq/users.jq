( [ $organizations_array[0] | .[] | { key: (._id|tostring), value: .name } ] | from_entries) as $organization_names |
(
  $tickets_array[0] |
  [
    group_by(.submitter_id)[] |
    { (.[0].submitter_id|tostring): [.[] | { key: ._id, value: .subject }] | from_entries }
  ] |
  add
) as $submitter_ticket_subjects |
(
  $tickets_array[0] |
  [
    group_by(.assignee_id)[] |
    { (.[0].assignee_id|tostring): [.[] | { key: ._id, value: .subject }] | from_entries }
  ] |
  add
) as $assignee_ticket_subjects |
.[] | select(._id==$value) | . + {
  organization_name: $organization_names[.organization_id|tostring],
  tickets: {
    submitted: $submitter_ticket_subjects[._id|tostring],
    assigned:   $assignee_ticket_subjects[._id|tostring]
  }
}
