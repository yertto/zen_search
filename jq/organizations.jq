(
    $users_array[0] | [ group_by(.organization_id)[] | { key: (.[0].organization_id|tostring), value: [.[] | [.name   ] ] | add }] | from_entries
) as $organization_user_names |
(
  $tickets_array[0] | [ group_by(.organization_id)[] | { key: (.[0].organization_id|tostring), value: [.[] | [.subject] ] | add }] | from_entries
) as $organization_ticket_subjects |
.[] | select(._id==$value) +
{
  users:        $organization_user_names[._id|tostring],
  tickets: $organization_ticket_subjects[._id|tostring]
}
