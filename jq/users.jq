include "resources";

organizations     as $organizations     |
submitter_tickets as $submitter_tickets |
assignee_tickets  as $assignee_tickets  |

.[] | select(._id==$value) + {
  organization: $organizations[.organization_id|tostring],
  tickets: {
    submitted: $submitter_tickets[._id|tostring],
    assigned:   $assignee_tickets[._id|tostring]
  }
}
