(
  $users_array[0] |
  [
    group_by(.organization_id)[] |
    { (.[0].organization_id|tostring): [.[] | { key: (._id|tostring), value: .name }] | from_entries }
  ] |
  add
) as $organization_user_names |
(
  $tickets_array[0] |
  [
    group_by(.organization_id)[] |
    { (.[0].organization_id|tostring): [.[] | { (._id): .subject }] | add }
  ] |
  add
) as $organization_ticket_subjects |
.[] | select(._id==$value) +
{
  users:        $organization_user_names[._id|tostring],
  tickets: $organization_ticket_subjects[._id|tostring]
}
