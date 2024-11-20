module admin_addr::dice {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::randomness;
    use aptos_framework::timestamp;
    use aptos_framework::account;
    use aptos_std::table::{Self, Table};

    // Error codes
    const ENO_LOTTERY: u64 = 1;
    
    const MODULE_OWNER: address = @admin_addr;
    const LOTTERY_PRICE: u64 = 10000000;

    public entry fun initialize(deployer: &signer) {

    }

    public entry fun createLottery(admin: &signer, duration: u64) acquires GlobalTable {

    }

    #[randomness]
    public entry fun buyTicket(buyer: &signer, lotteryId: u64, guess: u8) acquires GlobalTable, SignerCapabilityStore {

    }
}