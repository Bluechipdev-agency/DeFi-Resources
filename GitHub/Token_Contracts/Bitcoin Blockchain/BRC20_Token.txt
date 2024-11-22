{
  "p": "brc-20",                // Protocol identifier: This indicates it's a BRC-20 token.
  "op": "deploy",              // Operation: "deploy" for creating the token, "mint" for minting tokens, "transfer" for sending tokens.
  "tick": "MYTK",              // Ticker symbol: The short name of the token (max 4 characters).
  "max": "21000000",           // Maximum supply: Total number of tokens available for minting.
  "lim": "1000",               // Minting limit per user: Max number of tokens a single wallet can mint per transaction.
  "dec": "18"                  // Decimals: Number of decimal places (optional, default is 18).
}

{
  "p": "brc-20",
  "op": "deploy",
  "tick": "MYTK",
  "max": "21000000",
  "lim": "1000"
}

{
  "p": "brc-20",
  "op": "mint",
  "tick": "MYTK",
  "amt": "1000"
}

{
  "p": "brc-20",
  "op": "transfer",
  "tick": "MYTK",
  "amt": "500",
  "to": "bc1qrecipientaddress"
}


