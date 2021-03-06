class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def received?
    true
  end

  def sent?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def validate?
    true
  end

  def decline_reason?
    true
  end

  def pay?
    true
  end

  def mark_as_paid?
    true
  end

  def send_to_partner?
    true
  end

  def follow_up?
    true
  end

  def update?
    record.user == user
  end

  def edit?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end
