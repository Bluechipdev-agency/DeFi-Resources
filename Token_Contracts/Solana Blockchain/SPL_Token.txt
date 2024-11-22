use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    pubkey::Pubkey,
    program_error::ProgramError,
    program_pack::{Pack, IsInitialized},
    sysvar::{rent::Rent, Sysvar},
};
use spl_token::{
    instruction::initialize_mint,
    state::{Mint},
};

entrypoint!(process_instruction);

/// Processes the instructions of the SPL token program.
pub fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    msg!("SPL Token Program Entry");

    // Parse accounts
    let account_info_iter = &mut accounts.iter();

    // Mint account (created externally)
    let mint_account = next_account_info(account_info_iter)?;
    
    // Account that pays for rent and transaction
    let rent_payer_account = next_account_info(account_info_iter)?;

    // System program (required for creating accounts)
    let system_program_account = next_account_info(account_info_iter)?;

    // Rent sysvar (required for rent calculations)
    let rent_sysvar_account = next_account_info(account_info_iter)?;

    // Parse the instruction data (can be expanded for more use cases)
    if instruction_data.len() == 0 {
        msg!("No instructions provided");
        return Err(ProgramError::InvalidInstructionData);
    }

    match instruction_data[0] {
        // Code for Initialize Mint
        0 => {
            msg!("Initialize Mint instruction");

            // Token mint parameters
            let decimals = instruction_data[1]; // Decimal places for token
            let mint_authority = Pubkey::new(&instruction_data[2..34]); // Mint authority address

            // Create Mint account using Solana runtime
            initialize_mint(
                &spl_token::id(),
                mint_account.key,
                &mint_authority,
                None,
                decimals,
            )?;
        }
        _ => {
            msg!("Unsupported instruction");
            return Err(ProgramError::InvalidInstructionData);
        }
    }

    Ok(())
}
