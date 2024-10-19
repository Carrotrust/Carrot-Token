// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {CarrotToken} from "../src/CarrotToken.sol";

contract DeployCarrotToken is Script {
    uint256 public constant INITIAL_SUPPLY = 10000 ether;
    CarrotToken public ct;

    function run() external returns (CarrotToken) {
        vm.startBroadcast();
        ct = new CarrotToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ct;
    }
}
