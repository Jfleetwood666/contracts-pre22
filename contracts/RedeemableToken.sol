pragma solidity ^0.4.23;

import "./modularERC20/ModularMintableToken.sol";

/** @title Redeemable Token 
Makes transfers to 0x0 alias to Burn
Implement Redemption Addresses
*/
contract RedeemableToken is ModularMintableToken {

    event RedemptionAddress(address indexed addr);

    function _transferAllArgs(address _from, address _to, uint256 _value) internal {
        if (_to == address(0)) {
            revert("_to address is 0x0");
        } else if (uint(_to) <= redemptionAddressCount) {
            // Transfers to redemption addresses becomes burn
            super._transferAllArgs(_from, _to, _value);
            _burnAllArgs(_to, _value);
        } else {
            super._transferAllArgs(_from, _to, _value);
        }
    }

    function _transferFromAllArgs(address _from, address _to, uint256 _value, address _sender) internal {
        if (_to == address(0)) {
            revert("_to address is 0x0");
        } else if (uint(_to) <= redemptionAddressCount) {
            // Transfers to redemption addresses becomes burn
            super._transferFromAllArgs(_from, _to, _value, _sender);
            _burnAllArgs(_to, _value);
        } else {
            super._transferFromAllArgs(_from, _to, _value, _sender);
        }
    }

    function incrementRedemptionAddressCount() external onlyOwner {
        emit RedemptionAddress(address(redemptionAddressCount));
        redemptionAddressCount += 1;
    }
}