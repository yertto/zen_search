#!/bin/bash shpec

describe "zen_search"
  describe "show users 1"
    subject() {
      echo -e "1\n1\n2\n" | ./zen_search
    }

    it "returns human readable json"
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
      assert blank "$(diff -u <(subject 2>&1) <(echo "$expected"))"
    end
  end
end

