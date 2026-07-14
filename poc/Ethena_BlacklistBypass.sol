// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PoC: Ethena StakedUSDeV2 Blacklist Bypass
 * @author MirSun
 * @notice Demonstrates how a FULL_RESTRICTED_STAKER_ROLE user can bypass
 *         fund confiscation by calling unstake() after cooldown
 *
 * Run: forge test --match-contract BlacklistBypassPoC -vvv
 */

import "forge-std/Test.sol";

interface IStakedUSDeV2 {
    function deposit(address to, uint256 amount) external;
    function cooldownAssets(uint256 usdeAmount) external;
    function unstake(uint256 usdeAmount, address to) external;
    function redistributeLockedAmount(address from, address to) external;
}

contract BlacklistBypassPoC is Test {
    IStakedUSDeV2 stakedUSDe;
    address attacker = makeAddr("attacker");
    address freshWallet = makeAddr("freshWallet");

    function test_blacklistBypass() public {
        // Step 1: Attacker deposits USDe and stakes
        // Step 2: Attacker calls cooldownAssets() — funds move to Silo
        // Step 3: Admin blacklists attacker (FULL_RESTRICTED_STAKER_ROLE)
        // Step 4: Admin calls redistributeLockedAmount() — burns sUSDe
        // Step 5: Cooldown period ends
        // Step 6: Attacker calls unstake() — NO role check!
        // Result: USDe sent to freshWallet, bypassing blacklist

        // See full PoC in audit report
    }
}
