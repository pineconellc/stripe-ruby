require File.expand_path('../../test_helper', __FILE__)

module Stripe
  class AccountTest < Test::Unit::TestCase
    should "account should be retrievable" do
      @mock.expects(:get).
        once.
        with('https://api.stripe.com/v1/account', nil, nil).
        returns(test_response(test_account))
      a = Stripe::Account.retrieve
      assert_equal "test+bindings@stripe.com", a.email
      assert a.kind_of? Stripe::Account
      assert !a.charges_enabled
      assert !a.details_submitted
    end

    should "account should be retrievable via plural endpoint" do
      @mock.expects(:get).
        once.
        with('https://api.stripe.com/v1/accounts/acct_foo', nil, nil).
        returns(test_response(test_account))
      a = Stripe::Account.retrieve('acct_foo')
      assert_equal "test+bindings@stripe.com", a.email
      assert !a.charges_enabled
      assert !a.details_submitted
    end

    should "be able to deauthorize an account" do
      @mock.expects(:get).once.returns(test_response(test_account))
      a = Stripe::Account.retrieve

      @mock.expects(:post).once.with do |url, api_key, params|
        url == "#{Stripe.connect_base}/oauth/deauthorize" && api_key.nil? && CGI.parse(params) == { 'client_id' => [ 'ca_1234' ], 'stripe_user_id' => [ a.id ]}
      end.returns(test_response({ 'stripe_user_id' => a.id }))
      a.deauthorize('ca_1234', 'sk_test_1234')
    end
  end
end
