include "resources";

organizations as $organizations |
users         as $users         |

.[] | select(._id==$value) + {
  submitter:            $users[.submitter_id   |tostring],
  assignee:             $users[.assignee_id    |tostring],
  organization: $organizations[.organization_id|tostring]
}
