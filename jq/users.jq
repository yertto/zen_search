( [ $organizations_array[0] | .[] | { key: (._id         |tostring), value: .name    }] | from_entries) as $organization_names        |
( [       $tickets_array[0] | .[] | { key: (.submitter_id|tostring), value: .subject }] | from_entries) as $submitter_ticket_subjects |
( [       $tickets_array[0] | .[] | { key: (.assignee_id |tostring), value: .subject }] | from_entries) as $assignee_ticket_subjects  |
.[] | select(._id==$value) | . + {
  organization_name:        $organization_names[.organization_id|tostring],
  submitter_tickets: $submitter_ticket_subjects["1"],
  assignee_tickets:   $assignee_ticket_subjects["2"]
}
