// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Escrow{

    address payable buyer;
    address payable seller;
//just like of an array awaiting payement=0,awaiting delivery=1..
    enum State{AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETED}

    State currentState;

    modifier buyerOnly(){
                require(msg.sender==buyer);
                _;
    }

    modifier whichState(State expectedState){
                require(currentState==expectedState);
                _;
    }
    
    constructor(address payable _buyer, address payable _seller){
        buyer=_buyer;
        seller =_seller;
    }

    function confirmPayment() public  buyerOnly whichState(State.AWAITING_PAYMENT) {
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery()public payable whichState(State.AWAITING_DELIVERY) {
        seller.transfer(address(this).balance);
        currentState= State.COMPLETED;
    }

}