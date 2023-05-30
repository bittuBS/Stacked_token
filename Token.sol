// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingToken is ERC20 {
    using SafeMath for uint256;

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }
mapping(address=>uint) public bal;
    mapping(address => Stake) public stakes;
    uint256 public rewardRate = 100; 

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 amount);

    constructor()  ERC20("Staking Token", "STK") {
       

    }
    function mint(uint amount)public {
        _mint(msg.sender,amount);
    }
    
    function stake(uint256 amount) external{
        require(amount > 0, "Amount should be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
_transfer(msg.sender,address(this),amount);

       if (stakes[msg.sender].amount > 0) {
            uint256 reward = calculateReward();
            if (reward > 0) {
                _mint(msg.sender, reward);
                emit RewardPaid(msg.sender, reward);
            }
        }

                 stakes[msg.sender].amount = stakes[msg.sender].amount+(amount);

        stakes[msg.sender].startTime = block.timestamp;
        emit Staked(msg.sender,amount);
    }

    function unstake(uint amounts) external {
        require(stakes[msg.sender].amount > 0, "No stake found");
        uint256 reward = calculateReward();
      if (reward > 0) {
            _mint(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }

         stakes[msg.sender].amount = stakes[msg.sender].amount - amounts;
        
        _transfer(address(this),msg.sender,amounts);
        emit Unstaked(msg.sender, amounts);
    }

    function calculateReward() public returns(uint256) {
        uint256 stakingDuration = block.timestamp - stakes[msg.sender].startTime;
     uint256 reward =   stakes[msg.sender].amount* stakingDuration*rewardRate /3.154e7;
     stakes[msg.sender].startTime = block.timestamp;
        return reward;
                

                
                


    }
}
