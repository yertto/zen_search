#!/bin/bash shpec
set -a

. ./zen_search.sh

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
end

