address 0x1 {
    module Token {
        use 0x1::Coin;
        use 0x1::Signer;

        // Define the token's structure
        struct Token has store {
            balance: u64,  // Balance of the token
        }

        // Resource initialization function to create a new token
        public fun initialize(): Token {
            Token {
                balance: 0,  // Start with zero balance
            }
        }

        // Function to mint new tokens
        public fun mint(account: &signer, amount: u64) {
            let token_ref = borrow_global_mut<Token>(Signer::address_of(account));
            token_ref.balance = token_ref.balance + amount;
        }

        // Function to transfer tokens from one account to another
        public fun transfer(sender: &signer, receiver: address, amount: u64) {
            let sender_ref = borrow_global_mut<Token>(Signer::address_of(sender));
            let receiver_ref = borrow_global_mut<Token>(receiver);
            
            // Ensure the sender has enough balance
            assert(sender_ref.balance >= amount, 100);

            // Decrease sender's balance and increase receiver's balance
            sender_ref.balance = sender_ref.balance - amount;
            receiver_ref.balance = receiver_ref.balance + amount;
        }

        // Function to check the balance of an address
        public fun balance_of(account: address): u64 {
            let account_ref = borrow_global<Token>(account);
            account_ref.balance
        }
    }
}
