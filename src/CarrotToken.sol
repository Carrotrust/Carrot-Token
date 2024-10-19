// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract CarrotToken is ERC20Burnable, Ownable, ERC20Pausable {
    error CarrotToken__CannotBurn();
    error CarrotToken__NotZeroAddress();
    error CarrotToken__MustBeMoreThanZero();

    constructor(uint256 initialSupply) ERC20("Carrot Token", "CT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }

    function burn(uint256 amount) public override whenNotPaused {
        if (amount <= 0) {
            revert CarrotToken__CannotBurn();
        }
        super.burn(amount);
    }

    function mint(address to, uint256 amount) public onlyOwner whenNotPaused {
        if (to == address(0)) {
            revert CarrotToken__NotZeroAddress();
        }
        if (amount <= 0) {
            revert CarrotToken__MustBeMoreThanZero();
        }
        _mint(to, amount);
    }

    function transfer(address to, uint256 amount) public override whenNotPaused returns (bool) {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 value) public override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function pause() public onlyOwner whenNotPaused {
        _pause();
    }

    function unpause() public onlyOwner whenPaused {
        _unpause();
    }

   

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, value);
    }
}
