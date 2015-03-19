require File.expand_path('../../test_helper', __FILE__)

module Stripe
  class AccountBankAccountTest < Test::Unit::TestCase
    ACCOUNT_BANK_ACCOUNT_URL = "/v1/accounts/acct_test_account/bank_accounts/ba_test_bank_account"

    def account
      @mock.expects(:get).once.returns(test_response(test_account))
      Stripe::Account.retrieve('acct_test_account')
    end

    should "account bank accounts should be listable" do
      a = account
      @mock.expects(:get).once.returns(test_response(test_bank_account_array(a.id)))
      bank_accounts = a.bank_accounts.all.data
      assert bank_accounts.kind_of? Array
      assert bank_accounts[0].kind_of? Stripe::BankAccount
    end

    should "account bank accounts should have the correct url" do
      a = account
      @mock.expects(:get).once.returns(test_response(test_bank_account(
        :id => 'ba_test_bank_account',
        :account => 'acct_test_account'
      )))
      bank_account = a.bank_accounts.retrieve('ba_test_bank_account')
      assert_equal ACCOUNT_BANK_ACCOUNT_URL, bank_account.url
    end

    should "account bank accounts should be updatable" do
      a = account
      @mock.expects(:get).once.returns(test_response(test_bank_account(
        :default_for_currency => false
      )))
      @mock.expects(:post).once.returns(test_response(test_bank_account(
        :default_for_currency => true
      )))
      bank_account = a.bank_accounts.retrieve('bank_account')
      bank_account.default_for_currency = true
      bank_account.save
      assert bank_account.default_for_currency
    end

    should "account bank accounts should be deletable" do
      a = account
      @mock.expects(:get).once.returns(test_response(test_bank_account))
      @mock.expects(:delete).once.returns(test_response(test_bank_account(:deleted => true)))
      bank_account = a.bank_accounts.retrieve('bank_account')
      bank_account.delete
      assert bank_account.deleted
    end
    
    should "account bank accounts should be creatable" do
      a = account
      @mock.expects(:post).once.returns(test_response(test_bank_account(:id => "test_bank_account")))
      bank_account = a.bank_accounts.create(:bank_account => "btok_5imXWk0s2aYz8E")
      assert_equal "test_bank_account", bank_account.id
    end
  end
end
