class Notifier < ApplicationMailer
  default from: 'hitobito-glp@grunliberale.ch'

  def zip_code_changed person, email
    @person = person
    mail(to: email)
  end

  def mitglied_left person, email
    @person = person
    mail(to: email)
  end

  def mitglied_joined person, email
    @person = person
    mail(to: email, subject: "Achtung: Neues Mitglied.")
  end

  def mitglied_joined_monitoring person, submitted_role, email
    @person = person
    @category = submitted_role.gsub("_und_", " & ")
    case submitted_role
    when "Mitglied"
      @subject = "Achtung: Neues Mitglied"
      @welcome = "Ein neues Mitglied hat sich registriert."
    when "Sympathisant"
      @subject = "Achtung: Neue/r Sympathisant"
      @welcome = "Ein/e neue/r Sympathisant/in hat sich registriert."
    when "Medien_und_dritte"
      @subject = "Achtung: Neue News-Anmeldung"
      @welcome = "Es gibt eine neue Anmeldung für Partei-News."
    end

    mail(to: email, subject: @subject)
  end

  def welcome_mitglied person, locale
    @person = person
    @locale = locale
    I18n.locale = @locale
    mail(to: @person.email, from: t(".from"), subject: t(".subject"))
  end

  def welcome_sympathisant person, locale
    @person = person
    @locale = locale
    I18n.locale = @locale
    mail(to: @person.email, from: t(".from"), subject: t(".subject"))
  end

  def welcome_medien_und_dritte person, locale
    @person = person
    @locale = locale
    I18n.locale = @locale
    mail(to: @person.email, from: t(".from"), subject: t(".subject"))
  end
end
