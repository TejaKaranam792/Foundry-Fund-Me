🌐 Foundry Fund Me — A Gas-Optimized Crowdfunding Smart Contract

A minimal yet production-grade crowdfunding contract built entirely with Foundry.
This project implements the classic Fund Me contract, enriched with modern tooling, script automation, and a clean testing pipeline.

It demonstrates:

🧩 Gas-efficient Solidity patterns

🧪 Full test suite (unit + integration)

🛠 Automated deployments & interactions

🔧 Price feed integration

🚀 Realistic E2E flows using Foundry scripts

If you're exploring Foundry, Chainlink feeds, or contract scripting, this repo is a perfect reference.

🚀 Features
✔ Gas-efficient funding logic

Minimum USD requirement enforced via Chainlink Aggregator.

Funders tracked in an array + mapping.

✔ Automated deployment scripts

Deterministic deployments with DeployFundMe.s.sol.

Grab "most recent deployment" on any chain.

✔ Interaction scripts

FundFundMe.s.sol → fund with one command

WithdrawFundMe.s.sol → owner withdrawal

✔ Fully tested

Includes tests for:

Funding

Withdrawal

Edge cases

Integration tests using real-world scripts

Using cheatcodes like vm.prank, vm.startBroadcast, and conditional broadcasting for test environments.

📁 Project Structure
Foundry-Fund-Me/
├── src/
│   └── FundMe.sol
├── script/
│   ├── DeployFundMe.s.sol
│   └── Interactions.s.sol
├── test/
│   ├── FundMeTest.t.sol
│   └── FundMeTestIntegration.t.sol
├── lib/
│   ├── chainlink-evm
│   ├── forge-std
│   └── foundry-devops
├── foundry.toml
└── README.md

⚙️ Prerequisites

Foundry installed

curl -L https://foundry.paradigm.xyz | bash
foundryup


Node (optional, for scripts that fetch RPC URLs)

🏗 Build & Test
🧪 Run all tests
forge test

🔍 Run with logs
forge test -vvv

🚧 Local build
forge build

🌍 Deployment
Deploy to any network:
forge script script/DeployFundMe.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY

Fund the contract:
forge script script/Interactions.s.sol:FundFundMe --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY

Withdraw as owner:
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY

🔗 Powered By

Foundry — blazing-fast Ethereum development toolkit

Chainlink — price feeds for reliable USD comparisons

Foundry-DevOps — get recent deployments per chain

Forge-Std — cheatcodes, console logs & helpers

📬 Author

Teja Karanam
→ GitHub: TejaKaranam792

→ LinkedIn: https://www.linkedin.com/in/tejakaranam

⭐ If this repo helped you, consider giving it a star!

It helps more developers discover solid Foundry examples.
