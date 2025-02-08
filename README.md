# Decentralized Freelance Marketplace

A blockchain-based platform connecting clients and freelancers through smart contracts, providing secure payments, dispute resolution, and reputation management.

## Overview

The Decentralized Freelance Marketplace consists of four primary smart contracts that create a trustless environment for remote work:

1. Job Posting Contract
2. Escrow Contract
3. Dispute Resolution Contract
4. Reputation System Contract

## Core Features

### Job Posting Contract
- Creates and manages job listings with detailed requirements
- Handles freelancer applications and client selections
- Supports multiple job categories and skill tags
- Implements application filtering and shortlisting
- Manages milestone creation and tracking
- Stores job completion history

### Escrow Contract
- Secures client funds during project execution
- Supports milestone-based payments
- Handles automatic releases upon milestone completion
- Manages payment distributions
- Supports multiple payment tokens
- Implements emergency fund recovery

### Dispute Resolution Contract
- Manages conflict resolution between parties
- Implements a decentralized arbitration system
- Handles evidence submission and review
- Supports multiple resolution outcomes
- Manages arbitrator selection and voting
- Tracks dispute history and resolutions

### Reputation System Contract
- Records and manages user ratings and reviews
- Calculates reputation scores
- Prevents rating manipulation
- Implements weighted scoring based on transaction value
- Manages review verification
- Supports detailed feedback and responses

## Getting Started

### Prerequisites
- Node.js v16 or higher
- Hardhat development environment
- MetaMask or similar Web3 wallet
- OpenZeppelin Contracts library

### Installation
```bash
# Clone the repository
git clone https://github.com/your-org/decentralized-freelance-marketplace

# Install dependencies
cd decentralized-freelance-marketplace
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test
```

### Deployment
```bash
# Deploy to local network
npx hardhat run scripts/deploy.js --network localhost

# Deploy to testnet
npx hardhat run scripts/deploy.js --network goerli
```

## Smart Contract Architecture

### Job Posting Contract
```solidity
interface IJobPosting {
    function createJob(string calldata description, uint256 budget) external;
    function applyForJob(uint256 jobId) external;
    function selectFreelancer(uint256 jobId, address freelancer) external;
    function completeJob(uint256 jobId) external;
    function getJobDetails(uint256 jobId) external view returns (JobDetails memory);
}
```

### Escrow Contract
```solidity
interface IEscrow {
    function depositFunds(uint256 jobId) external payable;
    function releaseMilestonePayment(uint256 jobId, uint256 milestoneId) external;
    function refundClient(uint256 jobId) external;
    function getEscrowBalance(uint256 jobId) external view returns (uint256);
}
```

### Dispute Resolution Contract
```solidity
interface IDisputeResolution {
    function initiateDispute(uint256 jobId) external;
    function submitEvidence(uint256 disputeId, string calldata evidence) external;
    function voteOnDispute(uint256 disputeId, bool supportClient) external;
    function resolveDispute(uint256 disputeId) external;
}
```

### Reputation System Contract
```solidity
interface IReputationSystem {
    function submitRating(address user, uint8 rating, string calldata review) external;
    function calculateScore(address user) external view returns (uint256);
    function getUserReviews(address user) external view returns (Review[] memory);
}
```

## Security Features

- Role-based access control
- Payment security through escrow
- Anti-fraud mechanisms
- Dispute resolution safeguards
- Rating manipulation prevention
- Emergency pause functionality
- Multi-signature requirements for critical operations

## User Protection

### For Clients
- Secured funds through escrow
- Milestone-based payments
- Dispute resolution access
- Freelancer verification
- Review system access
- Work quality guarantees

### For Freelancers
- Guaranteed payment for completed work
- Protection against scope creep
- Fair dispute resolution
- Professional reputation building
- Client verification
- Clear project specifications

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Development Roadmap

### Phase 1: Core Platform
- Smart contract deployment
- Basic UI/UX implementation
- Payment system integration
- Initial security audits

### Phase 2: Enhanced Features
- Advanced reputation system
- Automated dispute resolution
- Multiple payment token support
- Enhanced search and filtering

### Phase 3: Platform Scaling
- Cross-chain integration
- Advanced analytics
- Mobile application
- API development

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Contact

For questions and support:
- Email: support@decentralizedfreelance.com
- Discord: [Join our community](https://discord.gg/decentralizedfreelance)
- Twitter: [@DecentralizedFL](https://twitter.com/DecentralizedFL)
