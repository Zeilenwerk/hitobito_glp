# encoding: utf-8

#  Copyright (c) 2012-2019, GLP Schweiz. This file is part of
#  hitobito_glp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_glp.


class Group::KantonKontakte < Group
  children Group::KantonKontakte

  class Adressverwaltung < Role
    self.permissions = [:group_and_below_full]
  end
  class Kontakt < Role
  end

  roles Adressverwaltung, Kontakt
end
