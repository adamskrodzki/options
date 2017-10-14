pragma solidity ^0.4.15;

import "./ERC20Interface.sol";

contract Swap {

    address _writer;
    address _striker;

    uint _collateralAmount;
    uint _strikeAmount;

    ERC20Interface collateralCoin;
    ERC20Interface strikeCoin;

    function Swap(
            address writer,
            address collateralCoinAddress,
            address striker,
            address strikeCoinAddress,
            uint strikeAmount,
            uint collateralAmount) {

        _writer = writer;
        _striker = striker;
        _collateralAmount = collateralAmount;
        _strikeAmount = strikeAmount;

        collateralCoin = ERC20Interface(collateralCoinAddress);
        strikeCoin = ERC20Interface(strikeCoinAddress);
    }

    function collateralize() {
        require(msg.sender == _writer);
        // take ownership of collateral
        require(collateralCoin.transferFrom(_writer, this, _collateralAmount));
    }

    function strike() {
        require(msg.sender == _striker);
        // send collateral to striker
        require(collateralCoin.transferFrom(this, _striker, _strikeAmount));
        // collect strike fee from striker
        require(strikeCoin.transferFrom(_striker, this, _strikeAmount));
        // selfdestruct();
    }

    function transfer(address to) {
        require(msg.sender == _striker);
        _striker = to;
    }
}