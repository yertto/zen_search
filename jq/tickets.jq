( [         $users_array[0] | .[] | { key: (._id|tostring), value: .name } ] | from_entries) as $user_names         |
( [ $organizations_array[0] | .[] | { key: (._id|tostring), value: .name } ] | from_entries) as $organization_names |
.[] | select(._id==$value) | . + {
  submitter:                 $user_names[.submitter_id   |tostring],
  assignee:                  $user_names[.assignee_id    |tostring],
  organization_name: $organization_names[.organization_id|tostring]
}
