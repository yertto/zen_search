( [ $organizations_array[0] | .[] | { key: (._id|tostring), value: .name    }] | from_entries) as $organization_names |
( [       $tickets_array[0] | .[] | { key: (._id|tostring), value: .subject }] | from_entries) as $ticket_subjects    |
.[] | select(._id==$value) | . + {
  organization_name: $organization_names[.organization_id|tostring],
  tickets:              $ticket_subjects[.ticket_id      |tostring]
}
