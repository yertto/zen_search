describe "zen_search"
  subject() {
    echo -e "$user_input" | ./zen_search 2>&1
  }

  it_matches_expected_output() {
    it "matches matches expected output"
      assert blank "$(diff --ignore-all-space --unified <(subject) <(echo "$expected"))"
    end
  }

  describe "users show 1"
    user_input="1\n1\n2"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Select resource: 1) _id		      8) verified	  15) signature
2) url		      9) shared		  16) organization_id
3) external_id	     10) locale		  17) tags
4) name		     11) timezone	  18) suspended
5) alias	     12) last_login_at	  19) role
6) created_at	     13) email
7) active	     14) phone
Select users key: {
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
  "role": "admin",
  "organization_name": "Qualitern",
  "tickets": {
    "submitted": null,
    "assigned": {
      "6fed7d01-15dd-4b59-94f9-1093b4bc0995": "A Catastrophe in Bermuda",
      "dcb9143e-cb17-49ea-a9be-abf6989bd2d4": "A Problem in Svalbard and Jan Mayen Islands"
    }
  }
}
Select resource:
EOF

    it_matches_expected_output
  end

  describe "organizations index details MegaCorp"
    user_input="3\n7\nMegaCorp"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Select resource: 1) _id		   4) name	      7) details
2) url		   5) domain_names    8) shared_tickets
3) external_id	   6) created_at      9) tags
Select organizations key: 101
105
109
112
118
120
121
123
125
Select resource:
EOF

    it_matches_expected_output
  end
end

