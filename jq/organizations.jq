include "resources";

organization_users   as $organization_users   |
organization_tickets as $organization_tickets |

.[] | select(._id==$value) +
{
  users:     $organization_users[._id|tostring],
  tickets: $organization_tickets[._id|tostring]
}
