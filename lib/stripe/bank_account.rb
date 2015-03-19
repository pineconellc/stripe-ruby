module Stripe
  class BankAccount < APIResource
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::Delete
    include Stripe::APIOperations::List

    def url
      if respond_to?(:account)
        "#{Account.url}/#{CGI.escape(account)}/bank_accounts/#{CGI.escape(id)}"
      elsif respond_to?(:recipient)
        "#{Recipient.url}/#{CGI.escape(recipient)}/active_account"
      end
    end
    
    def self.retrieve(id, opts=nil)
      raise NotImplementedError.new("Bank accounts cannot be retrieved without an account ID. Retrieve a bank account using account.bank_accounts.retrieve('bank_account_id')")
    end
  end
end
