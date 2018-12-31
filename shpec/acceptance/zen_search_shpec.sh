#!/bin/bash shpec

describe "zen_search"
  subject() {
    echo -e "$user_input" | ./zen_search 2>&1
  }

  it_matches_expected_output() {
    it "matches matches expected output"
      assert blank "$(diff -u <(subject) <(echo "$expected"))"
    end
  }

  describe "users show 1"
    user_input="1\n1\n2"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Your choice: 1) show
2) index
3) list_fields
Your choice: Enter _id: {
  "_id": 2,
  "url": "http://initech.zendesk.com/api/v2/users/2.json",
  "external_id": "c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2",
  "name": "Cross Barlow",
  "alias": "Miss Joni",
  "created_at": "2016-06-23T10:31:39 -10:00",
  "active": true,
  "verified": true,
  "shared": false,
  "locale": "zh-CN",
  "timezone": "Armenia",
  "last_login_at": "2012-04-12T04:03:28 -10:00",
  "email": "jonibarlow@flotonic.com",
  "phone": "9575-552-585",
  "signature": "Don't Worry Be Happy!",
  "organization_id": 106,
  "tags": [
    "Foxworth",
    "Woodlands",
    "Herlong",
    "Henrietta"
  ],
  "suspended": false,
  "role": "admin"
}
EOF
    it_matches_expected_output
  end

  describe "organizations index details MegaCorp"
    user_input="3\n2\ndetails\nMegaCorp"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Your choice: 1) show
2) index
3) list_fields
Your choice: Enter key: Enter value: 101
105
109
112
118
120
121
123
125
EOF
    it_matches_expected_output
  end

  describe "tickets list_fields"
    user_input="2\n3"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Your choice: 1) show
2) index
3) list_fields
Your choice: _id url external_id created_at type subject description priority status submitter_id assignee_id organization_id tags has_incidents due_at via
EOF
    it_matches_expected_output
  end
end

