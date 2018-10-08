require 'spec_helper'

describe ExternallySubmittedPeopleController do
  let!(:admin) { people(:admin) }
  let!(:role) { roles(:admin) }

  let!(:root_zugeordnete_group) { groups(:root_zugeordnete) }
  let!(:root_kontakte_group) { groups(:root_kontakte) }

  let!(:kanton) { groups(:bern) }
  let!(:kanton_zugeordnete_group) { groups(:bern_zugeordnete) }
  let!(:another_kanton_zugeordnete_group) { groups(:zurich_zugeordnete) }
  let!(:kanton_kontakte_group) { groups(:bern_kontakte) }
  let!(:another_kanton_kontakte_group) { groups(:zurich_kontakte) }

  def subject_with_args args={}
    post :create, externally_submitted_person: {zip_code: "9171",
                                                email: "sauron@evil.com",
                                                first_name: "Sauron",
                                                last_name: "The Abominable",
                                                preferred_language: "de",
                                                role: "mitglied"}.merge(args), format: :js
  end

  it "creates a person and saves his/her attributes." do
    expect{subject_with_args}.to change{Person.count}.by(1)
    expect(Person.last.email).to eq "sauron@evil.com"
    expect(Person.last.first_name).to eq "Sauron"
    expect(Person.last.last_name).to eq "The Abominable"
    expect(Person.last.zip_code).to eq "9171"
    expect(Person.last.preferred_language).to eq "de"
  end

  it "sends a notification email to the layer group." do
    expect{subject_with_args}.to change(ActionMailer::Base.deliveries, :count).by(1)
  end

  context "when submitted zip code DOES match existing layer groups' zip_codes" do
    context "it places him in respective subgroups" do

      it "when submitted role is a mitglied." do
        subject_with_args
        expect(Person.last.groups).to include kanton_zugeordnete_group, another_kanton_zugeordnete_group
      end

      it "when submitted role is a symphatisant." do
        subject_with_args({role: "sympathisant"})
        expect(Person.last.groups).to include kanton_zugeordnete_group, another_kanton_zugeordnete_group
      end

      it "when submitted role is a medien und dritte." do
        subject_with_args({role: "medien_und_dritte"})
        expect(Person.last.groups).to include kanton_kontakte_group, another_kanton_kontakte_group
      end

    end
  end

  context "when submitted zip code DOES NOT match any existing layer groups' zip_codes" do
    context "it places him in one of root groups equivalents" do

      it "when submitted role is a mitglied." do
        subject_with_args({zip_code: "1234"})
        expect(Person.last.groups).to include root_zugeordnete_group
      end

      it "when submitted role is a symphatisant." do
        subject_with_args({zip_code: "1234", role: "sympathisant"})
        expect(Person.last.groups).to include root_zugeordnete_group
      end

      it "when submitted role is a medien und dritte." do
        subject_with_args({zip_code: "1234", role: "medien_und_dritte"})
        expect(Person.last.groups).to include root_kontakte_group
      end

    end
  end

  context "fails gracefully" do

    it "when submitted email is a duplicate." do
      subject_with_args
      subject_with_args
      expect(response.body).to eq({error: "Ein Fehler ist aufgetreten."}.to_json)
    end

  end

end
