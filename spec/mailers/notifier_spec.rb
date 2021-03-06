# encoding: utf-8

#  Copyright (c) 2012-2019, GLP Schweiz. This file is part of
#  hitobito_glp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_glp.


require 'spec_helper'

describe Notifier do

  let(:jglp)   { false }

  context :mitglied_joined_monitoring do
    let(:role)   { roles(:mitglied) }
    let(:person) { role.person }

    subject { Notifier.mitglied_joined_monitoring(role.person, role.to_s, role.person.email, jglp) }

    it 'does not fail if preferred_language language is nil' do
      person.update(preferred_language: nil)
      expect(subject.subject).to eq 'Achtung: Neues Mitglied'
      expect(subject.body).to match %r{Ein neues Mitglied hat sich registriert}
      expect(subject.body).to match %r{Sprache:\s+}
    end

    it 'includes preferred_language language in email body' do
      person.update(preferred_language: :de)
      expect(subject.subject).to eq 'Achtung: Neues Mitglied'
      expect(subject.body).to match %r{Ein neues Mitglied hat sich registriert}
      expect(subject.body).to match %r{Sprache:\s+Deutsch}
    end
  end

  context :mitglied_joined do
    let(:role) { roles(:mitglied) }
    let(:person) { role.person }

    subject { Notifier.mitglied_joined(role.person, role.person.email, jglp) }

    it 'includes preferred_language language in email body' do
      person.update(preferred_language: :de)
      expect(subject.subject).to eq 'Achtung: Neues Mitglied.'
      expect(subject.body).to match %r{Ein neues Mitglied hat sich registriert}
      expect(subject.body).to match %r{Sprache:\s+Deutsch}
    end
  end

end
