#![cfg_attr(not(feature = "std"), no_std)]

#[ink::contract]
mod psp22_token {
    use ink_prelude::string::String;
    use ink_storage::traits::{SpreadAllocate, SpreadLayout};

    // The PSP22 contract is responsible for defining the token structure and the core token logic.
    #[ink(storage)]
    #[derive(SpreadAllocate, SpreadLayout)]
    pub struct PSP22Token {
        total_supply: Balance,
        balances: ink_storage::Mapping<AccountId, Balance>,
        allowances: ink_storage::Mapping<(AccountId, AccountId), Balance>,
        name: String,
        symbol: String,
        decimals: u8,
    }

    // Implementation of the PSP22 contract.
    impl PSP22Token {
        /// Initializes the contract with the token's name, symbol, and decimals.
        #[ink(constructor)]
        pub fn new(name: String, symbol: String, decimals: u8, initial_supply: Balance) -> Self {
            let mut balances = ink_storage::Mapping::new();
            let caller = Self::env().caller();
            balances.insert(&caller, &initial_supply);

            Self {
                total_supply: initial_supply,
                balances,
                allowances: ink_storage::Mapping::new(),
                name,
                symbol,
                decimals,
            }
        }

        /// Returns the name of the token.
        #[ink(message)]
        pub fn name(&self) -> String {
            self.name.clone()
        }

        /// Returns the symbol of the token.
        #[ink(message)]
        pub fn symbol(&self) -> String {
            self.symbol.clone()
        }

        /// Returns the decimals of the token.
        #[ink(message)]
        pub fn decimals(&self) -> u8 {
            self.decimals
        }

        /// Returns the total supply of the token.
        #[ink(message)]
        pub fn total_supply(&self) -> Balance {
            self.total_supply
        }

        /// Returns the balance of a given account.
        #[ink(message)]
        pub fn balance_of(&self, account: AccountId) -> Balance {
            *self.balances.get(&account).unwrap_or(&0)
        }

        /// Transfers tokens from the caller to a recipient.
        #[ink(message)]
        pub fn transfer(&mut self, to: AccountId, value: Balance) -> bool {
            let from = self.env().caller();
            let from_balance = self.balance_of(from);
            if from_balance < value {
                return false;
            }

            self.balances.insert(&from, &(from_balance - value));
            let to_balance = self.balance_of(to);
            self.balances.insert(&to, &(to_balance + value));
            true
        }

        /// Approves a spender to transfer tokens from the caller's account.
        #[ink(message)]
        pub fn approve(&mut self, spender: AccountId, value: Balance) -> bool {
            let caller = self.env().caller();
            self.allowances.insert(&(caller, spender), &value);
            true
        }

        /// Returns the allowance of a spender for a specific owner.
        #[ink(message)]
        pub fn allowance(&self, owner: AccountId, spender: AccountId) -> Balance {
            *self.allowances.get(&(owner, spender)).unwrap_or(&0)
        }

        /// Transfers tokens from one account to another via allowance.
        #[ink(message)]
        pub fn transfer_from(
            &mut self,
            from: AccountId,
            to: AccountId,
            value: Balance,
        ) -> bool {
            let spender = self.env().caller();
            let allowance = self.allowance(from, spender);
            let from_balance = self.balance_of(from);
            if allowance < value || from_balance < value {
                return false;
            }

            self.balances.insert(&from, &(from_balance - value));
            let to_balance = self.balance_of(to);
            self.balances.insert(&to, &(to_balance + value));
            self.allowances.insert(&(from, spender), &(allowance - value));
            true
        }
    }
}
