module my_addr::Message {
    use std::string::{String, Self};
    use std::signer;
    use aptos_framework::account;

    struct Message has key {
        my_message: String
    }

    public entry fun create_message(account: &signer, msg: String) acquires Message {
        let signer_address = signer::address_of(account);
        if (!exists<Message>(signer_address)) {
            let message = Message {
                my_message: msg
            };
            move_to(account, message);
        } else {
            let message = borrow_global_mut<Message>(signer_address);
            message.my_message = msg;
        }
    }

    #[test(admin = @0x123)]
    public entry fun test_flow(admin: signer) acquires Message {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin, string::utf8(b"This is my message"));
        create_message(&admin, string::utf8(b"I changed my message"));

        let message = borrow_global<Message>(signer::address_of(&admin));
        assert(message.my_message==string::utf8(b"I changed my message"), 10);
    }
}