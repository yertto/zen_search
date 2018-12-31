#!/bin/bash shpec
set -a

. ./lib/zen_search.sh

describe "zen_search"
  describe "keys_for"
    it "returns unsorted keys users"
      assert equal "$(keys_for users)" "_id url external_id name alias created_at active verified shared locale timezone last_login_at email phone signature organization_id tags suspended role"
    end

    it "returns unsorted keys tickets"
      assert equal "$(keys_for tickets)" "_id url external_id created_at type subject description priority status submitter_id assignee_id organization_id tags has_incidents due_at via"
    end

    it "returns unsorted keys organizations"
      assert equal "$(keys_for organizations)" "_id url external_id name domain_names created_at details shared_tickets tags"
    end
  end

  describe "show"
    describe "users"
      it "returns human readable json"
        actual="$(show users 1)"
        expected=$(cat <<EOF
{
  "_id": 1,
  "url": "http://initech.zendesk.com/api/v2/users/1.json",
  "external_id": "74341f74-9c79-49d5-9611-87ef9b6eb75f",
  "name": "Francisca Rasmussen",
  "alias": "Miss Coffey",
  "created_at": "2016-04-15T05:19:46 -10:00",
  "active": true,
  "verified": true,
  "shared": false,
  "locale": "en-AU",
  "timezone": "Sri Lanka",
  "last_login_at": "2013-08-04T01:03:27 -10:00",
  "email": "coffeyrasmussen@flotonic.com",
  "phone": "8335-422-718",
  "signature": "Don't Worry Be Happy!",
  "organization_id": 119,
  "tags": [
    "Springville",
    "Sutton",
    "Hartsville/Hartley",
    "Diaperville"
  ],
  "suspended": true,
  "role": "admin"
}
EOF)
        assert equal "$actual" "$expected"
      end
    end
  end
end

