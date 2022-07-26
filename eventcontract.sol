// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address =>mapping (uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price ,uint ticketCount) external{
        require(date>block.timestamp,"you can create event for future dates");
        require(ticketCount>0,"there must be tickets greater than o.");

        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
        
    }

    function buyTicket(uint id, uint quantity) external payable{
        require(events[id].date!=0,"event doesn't exist.");
        require(events[id].date>block.timestamp,"event already occured.");
        Event storage _event = events[id];
        require(msg.value>=_event.price*quantity,"not enough money haha");
        require(_event.ticketRemain>=quantity,"not enough tickets hehe");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id] +=quantity;


    }

    function transferTicket(uint id, address to, uint quantity) external payable{
        require(events[id].date!=0,"event doesn't exist.");
        require(events[id].date>block.timestamp,"event already occured.");
        require(tickets[msg.sender][id]>=quantity,"you do not have enough tickets.");
        tickets[msg.sender][id] -=quantity;
        tickets[to][id] +=quantity;
    }

}