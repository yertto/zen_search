. ./lib/repository.sh

describe "repository"
  describe "keys_for <resource>"
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

  describe "show <resource> <_id>"
    subject() {
      show ${resource} ${_id}
    }

    it_returns_expected_json() {
      it "returns augmented human readable json for ${resource}"
        assert blank "$(diff -u <(subject) <(echo "$expected"))"
      end
    }

    describe "users"
      resource="users"
      _id=1
      read -d '' expected <<EOF
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
  "role": "admin",
  "organization_name": "Multron",
  "submitter_tickets": "A Nuisance in Saint Lucia",
  "assignee_tickets": "A Problem in Malawi"
}
EOF

      it_returns_expected_json
    end

    describe "tickets"
      resource="tickets"
      _id="436bf9b0-1147-4c0a-8439-6f79833bff5b"
      read -d '' expected <<EOF
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
EOF

      it_returns_expected_json
    end

    describe "organizations"
      resource="organizations"
      _id=125
      read -d '' expected <<EOF
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
EOF

      it_returns_expected_json
    end
  end

  describe "index <resource> <key> <value>"
    subject() {
      index "${resource}" "${key}" "${value}"
    }

    describe "users"
      resource="users"
      key="locale"
      value="en-AU"

      it "returns a list of resource _ids"
        read -d '' expected <<EOF
1
3
7
10
12
13
14
20
22
23
27
29
33
35
38
39
41
43
45
47
48
52
53
55
56
58
66
68
69
70
73
74
EOF
        assert equal "$(subject)" "$expected"
      end
    end
  end
end

