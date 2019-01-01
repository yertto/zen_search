#!/bin/bash

strip_color() {
  sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g"
}

describe "zen_search"
  subject() {
    echo -e "$user_input" | ./zen_search 2>&1
  }

  it_matches_expected_output() {
    it "matches matches expected output"
      assert blank "$(diff --ignore-all-space --unified <(subject | strip_color) <(echo "$expected"))"
    end
  }

  describe "users show 1"
    user_input="1\n1\n2"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Select resource: 1) _id          8) verified   15) signature
2) url         9) shared     16) organization_id
3) external_id      10) locale     17) tags
4) name         11) timezone   18) suspended
5) alias      12) last_login_at    19) role
6) created_at       13) email
7) active       14) phone
Select users key: 1) 1  9) 9 17) 17  25) 25  33) 33  41) 41  49) 49  57) 57  65) 65  73) 73
2) 2 10) 10  18) 18  26) 26  34) 34  42) 42  50) 50  58) 58  66) 66  74) 74
3) 3 11) 11  19) 19  27) 27  35) 35  43) 43  51) 51  59) 59  67) 67  75) 75
4) 4 12) 12  20) 20  28) 28  36) 36  44) 44  52) 52  60) 60  68) 68
5) 5 13) 13  21) 21  29) 29  37) 37  45) 45  53) 53  61) 61  69) 69
6) 6 14) 14  22) 22  30) 30  38) 38  46) 46  54) 54  62) 62  70) 70
7) 7 15) 15  23) 23  31) 31  39) 39  47) 47  55) 55  63) 63  71) 71
8) 8 16) 16  24) 24  32) 32  40) 40  48) 48  56) 56  64) 64  72) 72
Select users _id value: {
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
  "organization": "Qualitern",
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
    user_input="3\n7\n3"
    read -d '' expected <<EOF
Welcome to Zendesk Search
1) users
2) tickets
3) organizations
Select resource: 1) _id		   4) name	      7) details
2) url		   5) domain_names    8) shared_tickets
3) external_id	   6) created_at      9) tags
Select organizations key: 1) Artisan
2) Artisân
3) MegaCorp
4) MegaCörp
5) Non profit
Select organizations details value: 101
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

