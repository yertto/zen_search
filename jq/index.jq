.[] |
select(
  [.[$key]] |
  flatten |
  index($value)
) |
._id
