module Stripe
  class BankAccount < APIResource
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::Delete
    include Stripe::APIOperations::List

    def url
      if @base_url.is_a?(String) && @base_url.match(Account.url)
        url = @base_url.dup
        url += "/bank_accounts" unless url.match("bank_accounts")
        url += "/#{CGI.escape(id)}" unless url.match(id)
        url
      else
        super
      end
    end
    
    def self.retrieve(id, opts=nil)
      raise NotImplementedError.new("Bank accounts cannot be retrieved without an account ID. Retrieve a bank account using account.bank_accounts.retrieve('bank_account_id')")
    end
  end
end
