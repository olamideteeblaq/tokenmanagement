# Token Management Smart Contract - Comprehensive README

## Overview

This smart contract implements a fungible token (FT) standard compliant with SIP-010. It provides enhanced functionality for managing token transfers, including additional administrative controls like pausing transfers, blacklisting addresses, updating metadata, executing token airdrops, and transferring contract ownership. The contract is written in Clarity, designed to run on the Stacks blockchain.

---

## Features

1. **Fungible Token Standard (SIP-010):**
   - Fully implements the SIP-010 trait, ensuring compatibility with the Stacks ecosystem.

2. **Token Metadata:**
   - Includes `token-name`, `token-symbol`, `token-decimals`, and a configurable `token-uri` for metadata.

3. **Transfer Mechanisms:**
   - Supports token transfers with `transfer` and `transfer-from`.
   - Implements allowances for third-party spending via `approve`.

4. **Administrative Controls:**
   - **Pause Transfers:** Temporarily disable token transfers globally.
   - **Blacklist Addresses:** Restrict specific addresses from interacting with the token.
   - **Airdrop Tokens:** Bulk distribute tokens to multiple recipients in a single transaction.
   - **Update Metadata:** Dynamically modify the `token-uri` for updated token metadata.
   - **Ownership Transfer:** Enable the contract owner to transfer ownership.

5. **Read-Only Queries:**
   - Retrieve token details (name, symbol, decimals, URI).
   - Query balances, total supply, allowances, paused state, and blacklist status.

---

## Contract Constants and Variables

### Constants
- **`contract-owner`:** The owner of the contract, initialized as `tx-sender`.
- **`token-name`:** Name of the token, e.g., `"MyToken"`.
- **`token-symbol`:** Symbol of the token, e.g., `"MTK"`.
- **`token-decimals`:** Number of decimals, e.g., `6`.

### Variables
- **`token-uri`:** Optional metadata URI for the token.
- **`token-supply`:** Total supply of tokens in circulation.
- **`paused`:** Boolean flag indicating whether token transfers are paused.

---

## Error Codes

| Error Code | Description                              |
|------------|------------------------------------------|
| `u100`     | Owner-only operation.                   |
| `u101`     | Not authorized to perform the operation.|
| `u102`     | Insufficient token balance.             |
| `u103`     | Invalid recipient address.              |
| `u104`     | Token transfers are paused.             |
| `u105`     | Address is blacklisted.                 |

---

## Functions

### Read-Only Functions

- **`get-name`**: Returns the token name.
- **`get-symbol`**: Returns the token symbol.
- **`get-decimals`**: Returns the token decimal count.
- **`get-balance(owner)`**: Returns the balance of a specific address.
- **`get-total-supply`**: Returns the total token supply.
- **`get-token-uri`**: Returns the metadata URI of the token.
- **`get-allowance(owner, spender)`**: Returns the allowance granted by an owner to a spender.
- **`is-paused`**: Returns whether token transfers are paused.
- **`is-blacklisted(address)`**: Returns whether a specific address is blacklisted.

---

### Public Functions

#### Core Token Functions
1. **`transfer(amount, recipient)`**
   - Transfers tokens from the sender to the recipient.
   - Checks for paused state and blacklist restrictions.

2. **`transfer-from(amount, sender, recipient)`**
   - Allows a spender to transfer tokens from an owner’s balance.

3. **`approve(amount, spender)`**
   - Sets an allowance for a spender to use the owner’s tokens.

---

#### Administrative Functions
1. **`set-pause(pause)`**
   - Pauses or unpauses token transfers.
   - Only accessible by the contract owner.

2. **`set-blacklist(address, blacklist)`**
   - Adds or removes an address from the blacklist.
   - Only accessible by the contract owner.

3. **`update-token-uri(uri)`**
   - Updates the metadata URI for the token.
   - Only accessible by the contract owner.

4. **`airdrop(recipients, amounts)`**
   - Distributes tokens to multiple recipients in a single transaction.
   - Only accessible by the contract owner.

5. **`transfer-ownership(new-owner)`**
   - Transfers ownership of the contract to a new address.
   - Only accessible by the current contract owner.

6. **`mint(amount, recipient)`**
   - Mints new tokens and assigns them to a recipient.
   - Only accessible by the contract owner.

7. **`burn(amount)`**
   - Burns tokens from the sender’s balance, reducing the total supply.

---

## Deployment and Initialization

Upon deployment:
1. The `contract-owner` is set to the transaction sender (`tx-sender`).
2. The `token-uri` is initialized with a default metadata URI.
3. The `paused` state is set to `false`.

---

## Security Considerations

- **Ownership Privileges:** Only the owner can execute administrative functions. Ownership can be transferred securely.
- **Paused State:** Allows emergency suspension of transfers.
- **Blacklist:** Prevents malicious or unauthorized addresses from interacting with the token.
- **Allowance Checks:** Prevents unauthorized token usage with strict allowance validation.

---

## Example Usage

### Transfer Tokens
```clarity
(transfer u100 'SP3W...RECIPIENT)
```

### Pause Transfers
```clarity
(set-pause true)
```

### Blacklist an Address
```clarity
(set-blacklist 'SP3W...ADDRESS true)
```

### Airdrop Tokens
```clarity
(airdrop (list 'SP3W...A1 'SP3W...A2) (list u100 u200))
```

---

## Future Enhancements
- Add fee mechanisms for transfers.
- Implement staking or reward-based features.
- Integrate token burn rates for deflationary mechanisms.

This contract is robust, extensible, and designed for secure token management within the Stacks ecosystem.
