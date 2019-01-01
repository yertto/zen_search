#!/bin/bash

. ./lib/repository.sh

strip_color() {
   sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g"
}

describe "repository"
  describe "keys_for <resource>"
    subject() {
      keys_for $resource
    }

    it_returns_unsorted_keys() {
      it "returns unsorted ${resource} keys"
        assert equal "$(subject)" "${expected}"
      end
    }

    describe "users"
      resource="users"
      expected="_id url external_id name alias created_at active verified shared locale timezone last_login_at email phone signature organization_id tags suspended role"

      it_returns_unsorted_keys
    end

    describe "tickets"
      resource="tickets"
      expected="_id url external_id created_at type subject description priority status submitter_id assignee_id organization_id tags has_incidents due_at via"

      it_returns_unsorted_keys
    end

    describe "organizations"
      resource="organizations"
      expected="_id url external_id name domain_names created_at details shared_tickets tags"

      it_returns_unsorted_keys
    end
  end

  describe "values_for <resource>"
    subject() {
      values_for $resource $key
    }

    it_returns_unique_values() {
      it "returns unique values"
        assert blank "$(diff --ignore-all-space --unified <(subject | strip_color) <(echo "$expected"))"
      end
    }

    describe "for boolean keys"
      resource="organizations"
      key="shared_tickets"
      read -d '' expected <<EOF
false
true
EOF

      it_returns_unique_values
    end

    describe "for string keys"
      resource="tickets"
      key="status"
      read -d '' expected <<EOF
closed
hold
open
pending
solved
EOF

      it_returns_unique_values
    end

    describe "for array keys"
      resource="tickets"
      key="tags"
      read -d '' expected <<EOF
Alabama
Alaska
American Samoa
Arizona
Arkansas
California
Colorado
Connecticut
Delaware
District Of Columbia
Florida
Fédératéd Statés Of Micronésia
Georgia
Guam
Hawaii
Idaho
Illinois
Indiana
Iowa
Kansas
Kentucky
Louisiana
Maine
Marshall Islands
Maryland
Massachusetts
Michigan
Minnesota
Mississippi
Missouri
Montana
Nebraska
Nevada
New Hampshire
New Jersey
New Mexico
New York
North Carolina
North Dakota
Northern Mariana Islands
Ohio
Oklahoma
Oregon
Palau
Pennsylvania
Puerto Rico
Rhode Island
Rhodé Island
South Carolina
South Dakota
Tennessee
Texas
Utah
Virgin Islands
Virginia
Washington
West Virginia
Wisconsin
Wyoming
Şouth Carolina
Şouth Dakota
EOF

      it_returns_unique_values
    end
  end

  describe "show <resource> <_id>"
    subject() {
      show ${resource} ${_id}
    }

    it_returns_expected_json() {
      it "returns augmented human readable json for ${resource}"
        assert blank "$(diff --ignore-all-space --unified <(subject | strip_color) <(echo "$expected"))"
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
  "tickets": {
    "submitted": {
      "fc5a8a70-3814-4b17-a6e9-583936fca909": "A Nuisance in Kiribati",
      "cb304286-7064-4509-813e-edc36d57623d": "A Nuisance in Saint Lucia"
    },
    "assigned": {
      "1fafaa2a-a1e9-4158-aeb4-f17e64615300": "A Problem in Russian Federation",
      "13aafde0-81db-47fd-b1a2-94b0015803df": "A Problem in Malawi"
    }
  }
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
  "via": "web",
  "submitter": "Elma Castro",
  "assignee": "Harris Côpeland",
  "organization_name": "Zentry"
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
  ],
  "users": {
    "8": "Lolita Herring",
    "51": "Green Buckley"
  },
  "tickets": {
    "25d9edca-7756-4d28-8fdd-f16f1532f6ab": "A Problem in Cyprus",
    "ed3432e1-8cb7-40a1-be6a-6f69cbc911f1": "A Drama in Viet Nam",
    "31e7f6d7-f6cb-4781-b4e7-2f552941e1f5": "A Nuisance in Poland",
    "d9448e74-4a7d-45c5-9548-8b4fee714b29": "A Nuisance in Honduras",
    "dae7a200-89b8-4a43-a17d-93c8f33a2aaa": "A Problem in Ukraine",
    "50f3fdbd-f8a6-481d-9bf7-572972856628": "A Nuisance in Namibia"
  }
}
EOF

      it_returns_expected_json
    end
  end

  describe "index <resource> <key> <value>"
    subject() {
      index "${resource}" "${key}" "${value}"
    }

    it_returns_expected_ids() {
      it "returns a list of _ids for ${resource}"
        assert blank "$(diff --ignore-all-space --unified <(subject) <(echo "$expected"))"
      end
    }

    describe "searching for string values"
      resource="users"
      key="locale"
      value="en-AU"
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

      it_returns_expected_ids
    end

    describe "searching for boolean values"
      resource="users"
      key="active"
      value=true
      read -d '' expected <<EOF
1
2
4
5
9
10
11
13
15
16
17
18
21
22
23
30
31
32
34
37
40
42
43
45
49
50
51
54
55
56
57
61
62
65
66
67
68
69
71
EOF

      it_returns_expected_ids
    end

    describe "searching for integer values"
      resource="tickets"
      key="organization_id"
      value=116
      read -d '' expected <<EOF
"436bf9b0-1147-4c0a-8439-6f79833bff5b"
"d318011c-5325-4d48-9766-953fd16a44a7"
"35072cd7-e343-4d8e-a967-bbe32eb019cb"
"2e60886f-789f-4a00-8b43-e913facb6d78"
"4271c15f-ade8-45b0-a31d-63cfee61adbf"
"828c158a-91e3-42b9-8aed-ac97407a150f"
"6a075290-6f77-4d70-87f2-e4867591772c"
"55135930-9f1f-43df-a9fd-2105fff74578"
"e75e6904-6536-43ea-9081-1c9f787f8682"
EOF

      it_returns_expected_ids
    end

    describe "searching for empty values"
      resource="tickets"
      key="description"
      value=""
      read -d '' expected <<EOF
"4cce7415-ef12-42b6-b7b5-fb00e24f9cc1"
EOF

      it_returns_expected_ids
    end

    describe "searching for null values"
      resource="tickets"
      key="description"
      value="null"
      read -d '' expected <<EOF
"4cce7415-ef12-42b6-b7b5-fb00e24f9cc1"
EOF

      it_returns_expected_ids
    end

    describe "searching for array items"
      resource="tickets"
      key="tags"
      value="Utah"
      read -d '' expected <<EOF
"4cce7415-ef12-42b6-b7b5-fb00e24f9cc1"
"25c518a8-4bd9-435a-9442-db4202ec1da4"
"dd2ed540-0720-4f2b-bb76-dbcb2c0ca25b"
"1c17f9a3-9ff2-4974-ae34-01959dbf64c6"
"027e95b2-f8de-43a8-86b0-c688525b3612"
"bc736a06-eeb0-4271-b4a8-c66f61b5df1f"
"703d347c-eaeb-402b-9890-b4736649b9ce"
"cf0d4a27-0dcb-49a9-a4fd-beec25742799"
"5c66cef0-7abc-46df-b487-5f8eb6208422"
"05291c66-f705-45a9-834d-4f594b236ff6"
"fa3a37e3-942e-4048-81bc-d0d7e79cb686"
"55135930-9f1f-43df-a9fd-2105fff74578"
"6e146832-0c37-4fb5-b173-a7e89bce4aff"
"53867869-0db0-4b8d-9d6c-9d1c0af4e693"
EOF

      it_returns_expected_ids
    end
  end
end

