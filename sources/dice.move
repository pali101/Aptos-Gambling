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
    const ENO_NOT_MODULE_OWNER: u64 = 2;
    
    const MODULE_OWNER: address = @admin_addr;
    const LOTTERY_PRICE: u64 = 10000000;

    struct SignerCapabilityStore has key {
        signer_cap: account::SignerCapability
    }

    public entry fun initialize(deployer: &signer) {
        assert!(signer::address_of(deployer) == MODULE_OWNER, ENO_NOT_MODULE_OWNER);
        let (_resource, signer_cap) = account::create_resource_account(deployer, vector::empty());
        let rsrc_acc_signer = account::create_signer_with_capability(&signer_cap);
        coin::register<AptosCoin>(&rsrc_acc_signer);

        move_to(deployer, SignerCapabilityStore{
            signer_cap,
        });
    }

    #[randomness]
    public entry fun buyTicket(buyer: &signer, guess: u8) acquires SignerCapabilityStore {
        let signer_cap_resource = borrow_global_mut<SignerCapabilityStore>(MODULE_OWNER);
        let rsrc_acc_signer = account::create_signer_with_capability(&signer_cap_resource.signer_cap);
        let rsrc_acc_address = signer::address_of(&rsrc_acc_signer);
        coin::transfer<AptosCoin>(buyer, rsrc_acc_address, initial_amount);

        // use randomness to determine if guess won or not
        let winner_guess = randomness::u64_range(0, 6) + 1;

        if (guess == winner_guess) {
            coin::transfer<AptosCoin>(&rsrc_acc_signer, buyer, 6 * LOTTERY_PRICE);
        }
    }
}