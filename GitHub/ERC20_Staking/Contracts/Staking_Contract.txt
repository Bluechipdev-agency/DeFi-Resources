// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import ERC20 Interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Staking is Ownable {
    // Define ERC20 token interface
    IERC20 public stakingToken;

    // Struct to store user stake data
    struct Stake {
        uint256 amount;         // Amount of tokens staked
        uint256 timestamp;      // Timestamp when the tokens were staked
        uint256 rewardDebt;     // The reward debt, to prevent over-rewarding
    }

    // Mapping of user addresses to their staking data
    mapping(address => Stake) public stakes;

    // Staking reward rate (1% per year)
    uint256 public rewardRate = 100; // 100 = 1% per year (in basis points)

    // Lock time (e.g., 30 days)
    uint256 public lockPeriod = 30 days;

    // Event for staking action
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    
    // Constructor to set the staking token
    constructor(IERC20 _stakingToken) {
        stakingToken = _stakingToken;
    }

    // Function to stake tokens
    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        
        Stake storage userStake = stakes[msg.sender];
        
        // Update user's stake reward before new deposit
        if (userStake.amount > 0) {
            uint256 reward = calculateReward(msg.sender);
            userStake.rewardDebt += reward;
        }

        // Transfer tokens from user to contract
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        
        // Update the user's stake information
        userStake.amount += _amount;
        userStake.timestamp = block.timestamp;
        
        emit Staked(msg.sender, _amount);
    }

    // Function to unstake tokens and claim rewards
    function unstake(uint256 _amount) external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount >= _amount, "Insufficient staked amount");
        
        // Calculate the reward before unstaking
        uint256 reward = calculateReward(msg.sender);

        // Check if the lock period has passed
        require(block.timestamp >= userStake.timestamp + lockPeriod, "Tokens are still locked");

        // Deduct the amount from the user's stake
        userStake.amount -= _amount;
        
        // Transfer the staked tokens back to the user
        stakingToken.transfer(msg.sender, _amount);
        
        // Transfer the rewards to the user
        stakingToken.transfer(msg.sender, reward);
        
        // Emit the unstake event
        emit Unstaked(msg.sender, _amount, reward);
    }

    // Function to calculate the rewards based on the staking duration
    function calculateReward(address _user) public view returns (uint256) {
        Stake storage userStake = stakes[_user];
        uint256 stakingDuration = block.timestamp - userStake.timestamp;
        
        // Calculate the reward (1% annually, adjusted for the staking duration)
        uint256 reward = (userStake.amount * rewardRate * stakingDuration) / (365 days * 10000);
        return reward;
    }

    // Function to check the current stake balance
    function stakeBalance(address _user) external view returns (uint256) {
        return stakes[_user].amount;
    }

    // Function to check the total reward of a user
    function rewardBalance(address _user) external view returns (uint256) {
        return calculateReward(_user) + stakes[_user].rewardDebt;
    }

    // Function to change the reward rate (only owner can change)
    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }

    // Function to change the lock period (only owner can change)
    function setLockPeriod(uint256 _lockPeriod) external onlyOwner {
        lockPeriod = _lockPeriod;
    }
}
