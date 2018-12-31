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
    subject() {
      show ${resource} ${value}
    }

    describe "users"
      resource=users
      value=1

      it "returns human readable json"
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
        assert equal "$(subject)" "$expected"
      end
    end

    describe "tickets"
      resource=tickets
      value="436bf9b0-1147-4c0a-8439-6f79833bff5b"

      it "returns human readable json"
        expected=$(cat <<EOF
{
  "_id": "436bf9b0-1147-4c0a-8439-6f79833bff5b",
  "url": "http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json",
  "external_id": "9210cdc9-4bee-485f-a078-35396cd74063",
  "created_at": "2016-04-28T11:19:34 -10:00",
  "type": "incident",
  "subject": "A Catastrophe in Korea (North)",
  "description": "Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.",
  "priority": "high",
  "status": "pending",
  "submitter_id": 38,
  "assignee_id": 24,
  "organization_id": 116,
  "tags": [
    "Ohio",
    "Pennsylvania",
    "American Samoa",
    "Northern Mariana Islands"
  ],
  "has_incidents": false,
  "due_at": "2016-07-31T02:37:50 -10:00",
  "via": "web"
}
EOF)
        assert equal "$(subject)" "$expected"
      end
    end

    describe "organizations"
      resource=organizations
      value=125

      it "returns human readable json"
        expected=$(cat <<EOF
{
  "_id": 125,
  "url": "http://initech.zendesk.com/api/v2/organizations/125.json",
  "external_id": "42a1a845-70cf-40ed-a762-acb27fd606cc",
  "name": "Strezzö",
  "domain_names": [
    "techtrix.com",
    "teraprene.com",
    "corpulse.com",
    "flotonic.com"
  ],
  "created_at": "2016-02-21T06:11:51 -11:00",
  "details": "MegaCorp",
  "shared_tickets": false,
  "tags": [
    "Vance",
    "Ray",
    "Jacobs",
    "Frank"
  ]
}
EOF)
        assert equal "$(subject)" "$expected"
      end
    end
  end
end

